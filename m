Return-Path: <linux-kernel-owner+w=401wt.eu-S1757337AbZB0SFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbZB0SFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 13:05:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbZB0SFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 13:05:33 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1839 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbZB0SFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 13:05:32 -0500
From: Mark Brown <broonie@sirena.org.uk>
To: Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel@vger.kernel.org, Mark Brown <broonie@sirena.org.uk>
Date: Fri, 27 Feb 2009 18:05:20 +0000
Message-Id: <1235757920-20474-1-git-send-email-broonie@sirena.org.uk>
X-Mailer: git-send-email 1.5.6.3
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] checkpatch: Warn on empty commit log bodies
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try to help ensure that e-mailed patches have some commit log text in
the body of the e-mail by warning if we can't find any lines that look
like a header of some kind prior to the Signed-off-by.

Signed-off-by: Mark Brown <broonie@sirena.org.uk>
---
 scripts/checkpatch.pl |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 45eb0ae..d162421 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1072,6 +1072,7 @@ sub process {
 
 	our $clean = 1;
 	my $signoff = 0;
+	my $headers = 0;
 	my $is_patch = 0;
 
 	our @report = ();
@@ -1258,6 +1259,11 @@ sub process {
 
 		$cnt_lines++ if ($realcnt != 0);
 
+		# Check for a RFC822 style header
+		if ($line =~ /^([a-z0-9-]+:|From )/i) {
+			$headers++;
+		}
+
 #check the patch for a signoff:
 		if ($line =~ /^\s*signed-off-by:/i) {
 			# This is a signoff, if ugly, so do not double report.
@@ -1270,6 +1276,14 @@ sub process {
 				WARN("space required after Signed-off-by:\n" .
 					$herecurr);
 			}
+
+			# There should be at least 1 line of ordinary
+			# text for the body of the commit log prior to
+			# the signoff.
+			if ($linenr - $headers < 2) {
+				print $headers . $linenr . "\n";
+				WARN("no body for commit log");
+			}
 		}
 
 # Check for wrappage within a valid hunk of the file
-- 
1.5.6.3

