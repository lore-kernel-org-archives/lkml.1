Return-Path: <linux-kernel-owner+w=401wt.eu-S1755706AbYANDvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706AbYANDvm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 22:51:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755961AbYANDvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 22:51:19 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:3531 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754725AbYANDvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 22:51:18 -0500
Date: Mon, 14 Jan 2008 04:51:16 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Sam Ravnborg <sam@ravnborg.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: [PATCH 3/3] use environment option
In-Reply-To: <20080106132601.GA3139@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0801140450580.17507@scrub.home>
References: <20071110204038.GA13140@uranus.ravnborg.org>
 <11947274093185-git-send-email-sam@ravnborg.org> <11947274091127-git-send-email-sam@ravnborg.org>
 <Pine.LNX.4.64.0711142116500.1818@scrub.home> <20071114220840.GB10920@uranus.ravnborg.org>
 <Pine.LNX.4.64.0711151616330.1817@scrub.home> <20080106132601.GA3139@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use the environment option to provide the ARCH symbol.
Remove the unused KERNELVERSION symbol.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

---
 init/Kconfig             |    4 ++++
 scripts/kconfig/symbol.c |   14 --------------
 2 files changed, 4 insertions(+), 14 deletions(-)

Index: linux-2.6/init/Kconfig
===================================================================
--- linux-2.6.orig/init/Kconfig
+++ linux-2.6/init/Kconfig
@@ -1,3 +1,7 @@
+config ARCH
+	string
+	option env="ARCH"
+
 config DEFCONFIG_LIST
 	string
 	depends on !UML
Index: linux-2.6/scripts/kconfig/symbol.c
===================================================================
--- linux-2.6.orig/scripts/kconfig/symbol.c
+++ linux-2.6/scripts/kconfig/symbol.c
@@ -56,20 +56,6 @@ void sym_init(void)
 
 	uname(&uts);
 
-	sym = sym_lookup("ARCH", 0);
-	sym->type = S_STRING;
-	sym->flags |= SYMBOL_AUTO;
-	p = getenv("ARCH");
-	if (p)
-		sym_add_default(sym, p);
-
-	sym = sym_lookup("KERNELVERSION", 0);
-	sym->type = S_STRING;
-	sym->flags |= SYMBOL_AUTO;
-	p = getenv("KERNELVERSION");
-	if (p)
-		sym_add_default(sym, p);
-
 	sym = sym_lookup("UNAME_RELEASE", 0);
 	sym->type = S_STRING;
 	sym->flags |= SYMBOL_AUTO;
