Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173Ab0ASGvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab0ASGvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 01:51:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332Ab0ASGvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 01:51:52 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:40121 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668Ab0ASGvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 01:51:51 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: Steven Rostedt <srostedt@redhat.com>, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kconfig: dont hardcode path to lsmod
Date: Tue, 19 Jan 2010 01:52:00 -0500
Message-Id: <1263883920-17289-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lsmod utility has always been installed into /bin with the newer
module-init-tools package, so let lsmod be found via PATH instead of
hardcoding the old modutils /sbin path.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 scripts/kconfig/streamline_config.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
index 0d80082..e1dfc8c 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -238,7 +238,7 @@ foreach my $makefile (@makefiles) {
 my %modules;
 
 # see what modules are loaded on this system
-open(LIN,"/sbin/lsmod|") || die "Cant lsmod";
+open(LIN,"lsmod|") || die "Cant lsmod";
 while (<LIN>) {
 	next if (/^Module/);  # Skip the first line.
 	if (/^(\S+)/) {
-- 
1.6.6

