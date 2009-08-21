Return-Path: <linux-kernel-owner+w=401wt.eu-S933083AbZHUVqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083AbZHUVqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932981AbZHUVq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:46:27 -0400
Received: from adelie.canonical.com ([91.189.90.139]:59348 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932953AbZHUVqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:46:25 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 5/7] checkpatch: format strings should not have brackets in macros
Date: Fri, 21 Aug 2009 22:46:08 +0100
Message-Id: <1250891170-8599-6-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1250891170-8599-1-git-send-email-apw@canonical.com>
References: <1250891170-8599-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should not recommend braces for the following:

    #define pr_fmt(fmt)    "%s: " fmt, __func__

allow things with double quotes round them to avoid this check.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e3c6b49..57df906 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2288,7 +2288,8 @@ sub process {
 				DECLARE_PER_CPU|
 				DEFINE_PER_CPU|
 				__typeof__\(|
-				\.$Ident\s*=\s*
+				\.$Ident\s*=\s*|
+				^\"|\"$
 			}x;
 			#print "REST<$rest> dstat<$dstat>\n";
 			if ($rest ne '') {
-- 
1.6.3.3

