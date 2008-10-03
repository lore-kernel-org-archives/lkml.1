Return-Path: <linux-kernel-owner+w=401wt.eu-S1754989AbYJCP1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbYJCP1Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 11:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbYJCP0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 11:26:05 -0400
Received: from tallyho.bytemark.co.uk ([80.68.81.166]:57477 "EHLO
	tallyho.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbYJCP0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 11:26:00 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 04/13] checkpatch: macros which define structure members are not complex
Date: Fri,  3 Oct 2008 16:25:45 +0100
Message-Id: <1223047554-31111-5-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.1.451.gc8d31
In-Reply-To: <1223047554-31111-1-git-send-email-apw@shadowen.org>
References: <1223047554-31111-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We often see macros which define structure members, these are not
complex and necessarily do not have braces or brackets.  For example:

    #define _PLIST_HEAD_INIT(head)                      \
        .prio_list = LIST_HEAD_INIT((head).prio_list),  \
        .node_list = LIST_HEAD_INIT((head).node_list)

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 19690a2..6eceda7 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2155,6 +2155,7 @@ sub process {
 				if ($dstat ne '' &&
 				    $dstat !~ /^(?:$Ident|-?$Constant)$/ &&
 				    $dstat !~ /$exceptions/ &&
+				    $dstat !~ /^\.$Ident\s*=/ &&
 				    $dstat =~ /$Operators/)
 				{
 					ERROR("Macros with complex values should be enclosed in parenthesis\n" . "$here\n$ctx\n");
-- 
1.6.0.1.451.gc8d31

