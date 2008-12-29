Return-Path: <linux-kernel-owner+w=401wt.eu-S1756026AbYL2Nxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026AbYL2Nxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 08:53:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753951AbYL2Nv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 08:51:56 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:43001 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbYL2Nvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 08:51:51 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 09/13] kbuild: check for leaked CONFIG_ symbols to userspace
Date: Mon, 29 Dec 2008 14:53:19 +0100
Message-Id: <1230558803-7168-9-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20081229134402.GA7069@uranus.ravnborg.org>
References: <20081229134402.GA7069@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/headers_check.pl |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/scripts/headers_check.pl b/scripts/headers_check.pl
index 5bdd975..72924a7 100644
--- a/scripts/headers_check.pl
+++ b/scripts/headers_check.pl
@@ -16,7 +16,7 @@
 #
 # 2) It is checked that prototypes does not use "extern"
 #
-# 3) TODO: check for leaked CONFIG_ symbols
+# 3) Check for leaked CONFIG_ symbols
 
 use strict;
 
@@ -36,6 +36,7 @@ foreach my $file (@files) {
 		$lineno++;
 		check_include();
 		check_prototypes();
+		check_config();
 	}
 	close FH;
 }
@@ -64,3 +65,11 @@ sub check_prototypes
 		printf STDERR "$filename:$lineno: extern's make no sense in userspace\n";
 	}
 }
+
+sub check_config
+{
+	if ($line =~ m/[^a-zA-Z0-9_]+CONFIG_([a-zA-Z0-9]+)[^a-zA-Z0-9]/) {
+		printf STDERR "$filename:$lineno: leaks CONFIG_$1 to userspace where it is not valid\n";
+	}
+}
+
-- 
1.6.0.2.GIT

