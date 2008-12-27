Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbYL0Hnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbYL0Hnr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 02:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbYL0Hni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 02:43:38 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:34042 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbYL0Hni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 02:43:38 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] headers_check.pl: disallow extern's
Date: Sat, 27 Dec 2008 02:43:36 -0500
Message-Id: <1230363816-24097-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since prototypes with "extern" refer to kernel functions, they make no
sense in userspace, so reject them automatically.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 scripts/headers_check.pl |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/scripts/headers_check.pl b/scripts/headers_check.pl
index 488a3b1..15b9bc6 100644
--- a/scripts/headers_check.pl
+++ b/scripts/headers_check.pl
@@ -33,6 +33,7 @@ foreach my $file (@files) {
 	while ($line = <FH>) {
 		$lineno++;
 		check_include();
+		check_prototypes();
 	}
 	close FH;
 }
@@ -54,3 +55,11 @@ sub check_include
 		}
 	}
 }
+
+sub check_prototypes
+{
+	if ($line =~ m/^\s*extern\b/) {
+		printf STDERR "$filename:$lineno: extern's make no sense in userspace\n";
+		$ret = 1;
+	}
+}
-- 
1.6.0.6

