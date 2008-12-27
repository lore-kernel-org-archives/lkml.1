Return-Path: <linux-kernel-owner+w=401wt.eu-S1754302AbYL0Swx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbYL0Swx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 13:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049AbYL0Swp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 13:52:45 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:58691 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbYL0Swo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 13:52:44 -0500
Date: Sat, 27 Dec 2008 19:54:15 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] headers_check.pl: disallow extern's
Message-ID: <20081227185415.GA10361@uranus.ravnborg.org>
References: <1230363816-24097-1-git-send-email-vapier@gentoo.org> <20081227184355.GA9264@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081227184355.GA9264@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> 
> And we need to get these fixed before we apply this patch.
> Otherwise we will break every allyesconfig/allmodconfig builds

I turned them into warnings for now.
And when I was there I fixed the TODO:

>From 2bbc376f97c4a75fbbb603b34f73db235a8cd2c1 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sat, 27 Dec 2008 19:52:20 +0100
Subject: [PATCH] kbuild: check for leaked CONFIG_ symbols to userspace

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

