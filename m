Return-Path: <linux-kernel-owner+w=401wt.eu-S1760605AbYFLMIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760605AbYFLMIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 08:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760148AbYFLMHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 08:07:50 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4315 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760140AbYFLMHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 08:07:49 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 06/23] checkpatch: comment detection: ignore macro continuation when detecting associated comments
Date: Thu, 12 Jun 2008 13:05:45 +0100
Message-Id: <1213272362-19457-7-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.5.6.rc0.140.ga9675
In-Reply-To: <1213272362-19457-1-git-send-email-apw@shadowen.org>
References: <1213272362-19457-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When looking for an associated comment they may be suffixed by a macro
continuation.  Ignore this.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index fd597a4..94250d1 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -631,7 +631,7 @@ sub ctx_locate_comment {
 	my ($first_line, $end_line) = @_;
 
 	# Catch a comment on the end of the line itself.
-	my ($current_comment) = ($rawlines[$end_line - 1] =~ m@.*(/\*.*\*/)\s*$@);
+	my ($current_comment) = ($rawlines[$end_line - 1] =~ m@.*(/\*.*\*/)\s*(?:\\\s*)?$@);
 	return $current_comment if (defined $current_comment);
 
 	# Look through the context and try and figure out if there is a
-- 
1.5.6.rc0.140.ga9675

