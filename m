Return-Path: <linux-kernel-owner+w=401wt.eu-S1754488AbZFECMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbZFECMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 22:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbZFECMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 22:12:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60724 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbZFECMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 22:12:07 -0400
Date: Thu, 4 Jun 2009 22:12:01 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, sam@ravnborg.org,
       Amerigo Wang <amwang@redhat.com>, linux-kbuild@vger.kernel.org
Message-Id: <20090605021419.7905.89870.sendpatchset@localhost.localdomain>
Subject: [Patch] kbuild: fix headers_check.pl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


'extern' checking information is not clear, refine it.
Plus, fix a comment.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>

----
diff --git a/scripts/headers_check.pl b/scripts/headers_check.pl
index 56f90a4..3923888 100644
--- a/scripts/headers_check.pl
+++ b/scripts/headers_check.pl
@@ -2,7 +2,7 @@
 #
 # headers_check.pl execute a number of trivial consistency checks
 #
-# Usage: headers_check.pl dir [files...]
+# Usage: headers_check.pl dir arch [files...]
 # dir:   dir to look for included files
 # arch:  architecture
 # files: list of files to check
@@ -37,7 +37,7 @@ foreach my $file (@files) {
 		&check_include();
 		&check_asm_types();
 		&check_sizetypes();
-		&check_prototypes();
+		&check_declarations();
 		# Dropped for now. Too much noise &check_config();
 	}
 	close FH;
@@ -61,10 +61,14 @@ sub check_include
 	}
 }
 
-sub check_prototypes
+sub check_declarations
 {
-	if ($line =~ m/^\s*extern\b/) {
-		printf STDERR "$filename:$lineno: extern's make no sense in userspace\n";
+	if ($line =~m/^\s*extern\b/) {
+		if ($line =~ m/^\s*extern\b.*\(.*\)/) {
+			printf STDERR "$filename:$lineno: extern's make no sense in userspace\n";
+		} else {
+			printf STDERR "$filename:$lineno: exporting global variable to userspace is suspicious\n";
+		}
 	}
 }
 
