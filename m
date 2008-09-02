Return-Path: <linux-kernel-owner+w=401wt.eu-S1754023AbYIBR1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbYIBR1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 13:27:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYIBRZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 13:25:24 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:36149 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbYIBRZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 13:25:22 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 1/7] checkpatch: case/default checks should only check changed lines
Date: Tue,  2 Sep 2008 18:25:08 +0100
Message-Id: <1220376314-15180-2-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.rc1.258.g80295
In-Reply-To: <1220376314-15180-1-git-send-email-apw@shadowen.org>
References: <1220376314-15180-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should only be checking changes lines for the trailing statement
check on case/default statements.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 66bcedc..457f874 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1363,14 +1363,6 @@ sub process {
 				ERROR("switch and case should be at the same indent\n$hereline$err");
 			}
 		}
-		if ($line =~ /^.\s*(?:case\s*.*|default\s*):/g &&
-		    $line !~ /\G(?:
-			(?:\s*{)?(?:\s*$;*)(?:\s*\\)?\s*$|
-			\s*return\s+
-		    )/xg)
-		{
-			ERROR("trailing statements should be on next line\n" . $herecurr);
-		}
 
 # if/while/etc brace do not go on next line, unless defining a do while loop,
 # or if that brace on the next line is for something else
@@ -1986,6 +1978,15 @@ sub process {
 				ERROR("trailing statements should be on next line\n" . $herecurr);
 			}
 		}
+# case and default should not have general statements after them
+		if ($line =~ /^.\s*(?:case\s*.*|default\s*):/g &&
+		    $line !~ /\G(?:
+			(?:\s*{)?(?:\s*$;*)(?:\s*\\)?\s*$|
+			\s*return\s+
+		    )/xg)
+		{
+			ERROR("trailing statements should be on next line\n" . $herecurr);
+		}
 
 		# Check for }<nl>else {, these must be at the same
 		# indent level to be relevant to each other.
-- 
1.6.0.rc1.258.g80295

