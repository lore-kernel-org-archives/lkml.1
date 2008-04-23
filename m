Return-Path: <linux-kernel-owner+w=401wt.eu-S1756441AbYDWWjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441AbYDWWjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 18:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbYDWWiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 18:38:51 -0400
Received: from mailfe08.tele2.it ([212.247.154.237]:59788 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751203AbYDWWiu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 18:38:50 -0400
X-Greylist: delayed 3602 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Apr 2008 18:38:50 EDT
X-Cloudmark-Score: 0.000000 []
Message-ID: <480FAC63.6060109@gmail.com>
Date: Wed, 23 Apr 2008 23:38:43 +0200
From: Massimo Maiurana <maiurana@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: sam@ravnborg.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] kconfig: fix broken target update-po-config
X-Enigmail-Version: 0.95.6
OpenPGP: id=7044D601
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the latest kernel "make update-po-config" fails because it tries
to open arch/Kconfig/Kconfig, since the ls command doesn't
distinguish between files and directories.

trivial patch below.

Signed-off-by: Massimo Maiurana <maiurana@gmail.com>

---
diff -u linux/scripts/kconfig/Makefile linux.new/scripts/kconfig/Makefile
--- linux/scripts/kconfig/Makefile      2008-04-17 12:51:55.000000000 +0200
+++ linux.new/scripts/kconfig/Makefile  2008-04-23 18:32:13.000000000 +0200
@@ -36,7 +36,7 @@
             --output $(obj)/config.pot
         $(Q)sed -i s/CHARSET/UTF-8/ $(obj)/config.pot
         $(Q)ln -fs Kconfig.i386 arch/um/Kconfig.arch
-       $(Q)(for i in `ls arch/`;                        \
+       $(Q)(for i in `find ./arch -maxdepth 1 -mindepth 1 -type d | cut -c 8-`; \
             do                                           \
                 echo "  GEN $$i";                        \
                 $(obj)/kxgettext arch/$$i/Kconfig        \



-- 
        Massimo Maiurana         massimo<at>ragusa.linux.it
        http://massimo.solira.org       GPG keyID #7044D601

Articolo 11 - L'Italia ripudia la guerra come strumento di offesa
alla libertà degli altri popoli e come mezzo di risoluzione delle
controversie internazionali....



