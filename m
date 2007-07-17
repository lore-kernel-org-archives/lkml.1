Return-Path: <linux-kernel-owner+w=401wt.eu-S933636AbXGQONh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933636AbXGQONh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763188AbXGQOIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:08:07 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:35935 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761262AbXGQOHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:07:52 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kernel@vger.kernel.org
Cc: Mike Frysinger <vapier@gentoo.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 25/33] kbuild: use POSIX BRE in headers install target
Date: Tue, 17 Jul 2007 16:08:54 +0200
Message-Id: <1184681344376-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11846813441741-git-send-email-sam@ravnborg.org>
References: 20070717140622.GA25846@uranus.ravnborg.org <11846813423231-git-send-email-sam@ravnborg.org> <11846813432423-git-send-email-sam@ravnborg.org> <1184681343138-git-send-email-sam@ravnborg.org> <11846813433593-git-send-email-sam@ravnborg.org> <11846813432300-git-send-email-sam@ravnborg.org> <11846813432072-git-send-email-sam@ravnborg.org> <11846813431389-git-send-email-sam@ravnborg.org> <1184681343412-git-send-email-sam@ravnborg.org> <11846813432249-git-send-email-sam@ravnborg.org> <1184681343297-git-send-email-sam@ravnborg.org> <11846813432231-git-send-email-sam@ravnborg.org> <1184681343423-git-send-email-sam@ravnborg.org> <11846813432234-git-send-email-sam@ravnborg.org> <11846813441521-git-send-email-sam@ravnborg.org> <11846813443387-git-send-email-sam@ravnborg.org> <1184681344594-git-send-email-sam@ravnborg.org> <11846813444176-git-send-email-sam@ravnborg.org> <11846813442297-git-send-email-sam@ravnborg.org> <11846813443187-git-send-email-sam@ravnborg.org> <11846813
 444171-git-send-email-sam@ravnborg.org> <1184681344985-git-send-email-sam@ravnborg.org> <11846813442810-git-send-email-sam@ravnborg.org> <118468134441-git-send-email-sam@ravnborg.org> <11846813441741-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>

The sed expression used at the moment in scripts/Makefile.headersinst
relies on the (handy) GNU extension where you can escape ERE's in an
otherwise BRE without using the GNU -r option.  The following patch
replaces this "\+" usage with a functionally equivalent POSIX BRE compliant
"\{1,\}".  Tested with `make headers_install` against blackfin/x86_64/i386
targets.

Stupid whiny OS X users and their crappy sed ;)

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/Makefile.headersinst |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/scripts/Makefile.headersinst b/scripts/Makefile.headersinst
index f98d772..53dae3e 100644
--- a/scripts/Makefile.headersinst
+++ b/scripts/Makefile.headersinst
@@ -11,13 +11,13 @@ UNIFDEF := scripts/unifdef -U__KERNEL__
 
 # Eliminate the contents of (and inclusions of) compiler.h
 HDRSED  := sed 	-e "s/ inline / __inline__ /g" \
-		-e "s/[[:space:]]__user[[:space:]]\+/ /g" \
-		-e "s/(__user[[:space:]]\+/ (/g" \
-		-e "s/[[:space:]]__force[[:space:]]\+/ /g" \
-		-e "s/(__force[[:space:]]\+/ (/g" \
-		-e "s/[[:space:]]__iomem[[:space:]]\+/ /g" \
-		-e "s/(__iomem[[:space:]]\+/ (/g" \
-		-e "s/[[:space:]]__attribute_const__[[:space:]]\+/\ /g" \
+		-e "s/[[:space:]]__user[[:space:]]\{1,\}/ /g" \
+		-e "s/(__user[[:space:]]\{1,\}/ (/g" \
+		-e "s/[[:space:]]__force[[:space:]]\{1,\}/ /g" \
+		-e "s/(__force[[:space:]]\{1,\}/ (/g" \
+		-e "s/[[:space:]]__iomem[[:space:]]\{1,\}/ /g" \
+		-e "s/(__iomem[[:space:]]\{1,\}/ (/g" \
+		-e "s/[[:space:]]__attribute_const__[[:space:]]\{1,\}/\ /g" \
 		-e "s/[[:space:]]__attribute_const__$$//" \
 		-e "/^\#include <linux\/compiler.h>/d"
 
-- 
1.5.0.6

