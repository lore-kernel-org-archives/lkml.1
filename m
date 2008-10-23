Return-Path: <linux-kernel-owner+w=401wt.eu-S1755754AbYJWLHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754AbYJWLHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 07:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbYJWLG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 07:06:56 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:50727 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbYJWLGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 07:06:54 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 4/9] checkpatch: structure member assignments are not complex
Date: Thu, 23 Oct 2008 12:06:34 +0100
Message-Id: <1224759999-21389-5-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.2.711.gf1ba4
In-Reply-To: <1224759999-21389-1-git-send-email-apw@shadowen.org>
References: <1224759999-21389-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure we do not trigger the complex macros checks on structure member
assignment, for example:

	#define foo .bar = 10

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index c28c20c..5551eb1 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2167,9 +2167,10 @@ sub process {
 				MODULE_PARAM_DESC|
 				DECLARE_PER_CPU|
 				DEFINE_PER_CPU|
-				__typeof__\(
+				__typeof__\(|
+				\.$Ident\s*=\s*
 			}x;
-			#print "REST<$rest>\n";
+			#print "REST<$rest> dstat<$dstat>\n";
 			if ($rest ne '') {
 				if ($rest !~ /while\s*\(/ &&
 				    $dstat !~ /$exceptions/)
-- 
1.6.0.2.711.gf1ba4

