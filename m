Return-Path: <linux-kernel-owner+w=401wt.eu-S1763602AbXESPOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763602AbXESPOf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 11:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759220AbXESPO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 11:14:28 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:54649 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759039AbXESPO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 11:14:28 -0400
Date: Sat, 19 May 2007 17:15:23 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>, Roman Zippel <zippel@linux-m68k.org>
Subject: RFC: kconfig select warnings bogus?
Message-ID: <20070519151523.GA26724@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We see a lot of these lately:
  GEN     /home/bor/build/linux-2.6.22/Makefile
scripts/kconfig/conf -s arch/i386/Kconfig
drivers/macintosh/Kconfig:116:warning: 'select' used by config symbol 'PMAC_APM_EMU' refers to undefined symbol 'SYS_SUPPORTS_APM_EMULATION'
drivers/net/Kconfig:2283:warning: 'select' used by config symbol 'UCC_GETH' refers to undefined symbol 'UCC_FAST'
drivers/input/keyboard/Kconfig:170:warning: 'select' used by config symbol 'KEYBOARD_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
drivers/input/mouse/Kconfig:182:warning: 'select' used by config symbol 'MOUSE_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'


Do this warning really add any value or should we just ignore them like this?

	Sam

diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index f14aeac..c0c84f2 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -200,11 +200,6 @@ void sym_check_prop(struct symbol *sym)
 				prop_warn(prop,
 				    "config symbol '%s' uses select, but is "
 				    "not boolean or tristate", sym->name);
-			else if (sym2->type == S_UNKNOWN)
-				prop_warn(prop,
-				    "'select' used by config symbol '%s' "
-				    "refers to undefined symbol '%s'",
-				    sym->name, sym2->name);
 			else if (sym2->type != S_BOOLEAN && sym2->type != S_TRISTATE)
 				prop_warn(prop,
 				    "'%s' has wrong type. 'select' only "
