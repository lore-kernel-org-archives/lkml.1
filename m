Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbYL2NwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbYL2NwG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 08:52:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbYL2Nvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 08:51:50 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:43002 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbYL2Nvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 08:51:49 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Mike Frysinger <vapier@gentoo.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 08/13] headers_check.pl: disallow extern's
Date: Mon, 29 Dec 2008 14:53:18 +0100
Message-Id: <1230558803-7168-8-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20081229134402.GA7069@uranus.ravnborg.org>
References: <20081229134402.GA7069@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>

Since prototypes with "extern" refer to kernel functions, they make no
sense in userspace, so reject them automatically.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
[sam: made it into a warning]
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/headers_check.pl |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/scripts/headers_check.pl b/scripts/headers_check.pl
index 488a3b1..5bdd975 100644
--- a/scripts/headers_check.pl
+++ b/scripts/headers_check.pl
@@ -14,7 +14,9 @@
 #    Only include files located in asm* and linux* are checked.
 #    The rest are assumed to be system include files.
 #
-# 2) TODO: check for leaked CONFIG_ symbols
+# 2) It is checked that prototypes does not use "extern"
+#
+# 3) TODO: check for leaked CONFIG_ symbols
 
 use strict;
 
@@ -33,6 +35,7 @@ foreach my $file (@files) {
 	while ($line = <FH>) {
 		$lineno++;
 		check_include();
+		check_prototypes();
 	}
 	close FH;
 }
@@ -54,3 +57,10 @@ sub check_include
 		}
 	}
 }
+
+sub check_prototypes
+{
+	if ($line =~ m/^\s*extern\b/) {
+		printf STDERR "$filename:$lineno: extern's make no sense in userspace\n";
+	}
+}
-- 
1.6.0.2.GIT

