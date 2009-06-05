Return-Path: <linux-kernel-owner+w=401wt.eu-S1756606AbZFEXte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbZFEXte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 19:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756194AbZFEXmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 19:42:01 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:36411 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295AbZFEXlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 19:41:11 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Amerigo Wang <amwang@redhat.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 18/39] kbuild/headers_check: refine extern check
Date: Sat,  6 Jun 2009 01:42:36 +0200
Message-Id: <1244245377-17441-18-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.3.rc3.40.g75b44
In-Reply-To: <20090605233720.GA13588@uranus.ravnborg.org>
References: <20090605233720.GA13588@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amerigo Wang <amwang@redhat.com>

'extern' checking information is not clear, refine it.
Plus, fix a comment.

Signed-off-by: WANG Cong <amwang@redhat.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/headers_check.pl |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

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
 
-- 
1.6.3.rc3.40.g75b44

