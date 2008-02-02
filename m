Return-Path: <linux-kernel-owner+w=401wt.eu-S1761530AbYBBQN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761530AbYBBQN4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 11:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750791AbYBBQNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 11:13:49 -0500
Received: from mailfe14.tele2.it ([212.247.155.173]:56790 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750768AbYBBQNs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 11:13:48 -0500
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Feb 2008 11:13:48 EST
X-Cloudmark-Score: 0.000000 []
Message-ID: <47A488A4.8040107@gmail.com>
Date: Sat, 02 Feb 2008 16:13:40 +0100
From: Massimo Maiurana <maiurana@gmail.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20060909)
MIME-Version: 1.0
To: sam@ravnborg.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] kconfig: fix target update-po-config in Makefile
X-Enigmail-Version: 0.94.4.0
OpenPGP: id=7044D601
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to recent changes in arch/cris, "make update-po-config" fails
because it can't include arch/cris/arch as it is a symlink generated
at build time.
Patch below fixes this by creating, and then removing at the end, a
symlink to arch/cris/arch-v10 (should it point to arch-v32? arch-v10
contains more help messages).

Signed-off-by: Massimo Maiurana <maiurana@gmail.com>

---
diff -Nru linux/scripts/kconfig/Makefile linux.new/scripts/kconfig/Makefile
--- linux/scripts/kconfig/Makefile	2008-01-25 13:05:12.000000000 +0100
+++ linux.new/scripts/kconfig/Makefile	2008-02-02 15:40:48.000000000 +0100
@@ -35,13 +35,14 @@
 	    --output $(obj)/config.pot
 	$(Q)sed -i s/CHARSET/UTF-8/ $(obj)/config.pot
 	$(Q)ln -fs Kconfig.i386 arch/um/Kconfig.arch
+	$(Q)ln -fs arch-v10 arch/cris/arch
 	(for i in `ls arch/`;                            \
 	do                                               \
 	    $(obj)/kxgettext arch/$$i/Kconfig;           \
 	done ) >> $(obj)/config.pot
 	msguniq --sort-by-file --to-code=UTF-8 $(obj)/config.pot \
 	    --output $(obj)/linux.pot
-	$(Q)rm -f arch/um/Kconfig.arch
+	$(Q)rm -f arch/um/Kconfig.arch arch/cris/arch
 	$(Q)rm -f $(obj)/config.pot

 PHONY += randconfig allyesconfig allnoconfig allmodconfig defconfig


-- 
       Massimo Maiurana         massimo<at>ragusa.linux.it
       http://massimo.solira.org       GPG keyID #7044D601

Articolo 11 - L'Italia ripudia la guerra come strumento di offesa
alla libertà degli altri popoli e come mezzo di risoluzione delle
controversie internazionali....

