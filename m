Return-Path: <linux-kernel-owner+w=401wt.eu-S965104AbXCAOau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965104AbXCAOau (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 09:30:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965094AbXCAOau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 09:30:50 -0500
Received: from mail.gmx.net ([213.165.64.20]:45740 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965104AbXCAOat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 09:30:49 -0500
Cc: akpm@linux-foundation.org, linux-dvb@linuxtv.org, domi.dumont@free.fr,
       Jiri Slaby <jirislaby@gmail.com>, bunk@stusta.de,
       linux-kernel@vger.kernel.org, Stephane Eranian <eranian@hpl.hp.com>,
       venkatesh.pallipadi@intel.com
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 01 Mar 2007 15:30:48 +0100
From: "Uwe Bugla" <uwe.bugla@gmx.de>
Message-ID: <20070301143048.29950@gmx.net>
MIME-Version: 1.0
Subject: patch 2 / 3: deselect dst and dst-ca modules if they aren't needed
To: torvalds@linux-foundation.org
X-Authenticated: #8359428
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1+eo3pDV7Kew2kfBDmd9B1RXVQ5G3TS4omi9aZPGN
 mJxmwn43cyHZ/u4Puc6u0WvMg= 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,
although this patch is fine and necessary it has been blocked and ignored for months by the following so-called "maintainers"
who are a tall order, a shame and a mismatch for the whole linux community:
a. Manuel Abraham <abraham.manu@gmail.com>
b. Mauro Carvalho Chehab <mchehab@infradead.org>
I vote for excluding Manuel Abraham from maintainership as we all need communicatable, accurate and reliable maintainers, no mismatches!
within the current kernel concept you are forced to compile the TwinHan dst and dst-ca modules as a regular case which is absolute nonsense.
With this patch you optimize RAM usage for all bt8xx DVB-S abd DVB-T cards with the following known exceptions:
1. Pinnacle PCTV Sat with CI extension
2. TwinHan DST and clones
3. TwinHan DST with CA slot
4. Chaintech DST-1000
5. DNTV Live !

Please sign-off or ack this only in connection with the bt8xx documentation fix (i. e. patch 1 / 3).
Written, tested with a Pinnacle PCTV Sat without CI extension and:
Signed-off-by: Uwe Bugla <uwe.bugla@gmx.de>

--- a/drivers/media/dvb/bt8xx/Makefile
+++ b/drivers/media/dvb/bt8xx/Makefile
@@ -1,3 +1,5 @@
-obj-$(CONFIG_DVB_BT8XX) += bt878.o dvb-bt8xx.o dst.o dst_ca.o
+obj-$(CONFIG_DVB_BT8XX) += bt878.o dvb-bt8xx.o
+obj-$(CONFIG_DVB_DST) += dst.o
+obj-$(CONFIG_DVB_DST_CA) += dst_ca.o
 
 EXTRA_CFLAGS = -Idrivers/media/dvb/dvb-core/ -Idrivers/media/video/bt8xx -Idrivers/media/dvb/frontends
--- a/drivers/media/dvb/bt8xx/Kconfig
+++ b/drivers/media/dvb/bt8xx/Kconfig
@@ -9,6 +9,8 @@
 	select DVB_LGDT330X if !DVB_FE_CUSTOMISE
 	select DVB_TUNER_LGH06XF if !DVB_FE_CUSTOMISE
 	select DVB_ZL10353 if !DVB_FE_CUSTOMISE
+	select DVB_DST if !DVB_DST_CUSTOMISE
+	select DVB_DST_CA if !DVB_DST_CUSTOMISE
 	select FW_LOADER
 	help
 	  Support for PCI cards based on the Bt8xx PCI bridge. Examples are
@@ -21,3 +23,36 @@
 	  an external software decoder to watch TV on your computer.
 
 	  Say Y if you own such a device and want to use it.
+
+menu "Customise DST support"
+	depends on DVB_BT8XX
+
+config DVB_DST_CUSTOMISE
+	bool "Customise DST modules to build"
+	default N
+	help
+	  This allows the user to deselect DST drivers for TwinHan and clone cards or cards with
+	  CA slot. Use this option with care as deselecting drivers which are in fact necessary
+	  will result in DVB devices which cannot be tuned due to lack of driver support.
+
+	  Please note: To deselect these drivers you MUST say Y to DVB_CORE_ATTACH above.
+
+	  If unsure say N.
+
+config DVB_DST
+	tristate "DST module"
+	depends on DVB_BT8XX
+	default m if DVB_DST_CUSTOMISE
+	help
+	  A DVB-S tuner module. Say Y when your card is a TwinHan or clone.
+	  Also say Y if your card needs the DST_CA module.
+
+config DVB_DST_CA
+	tristate "DST CA module"
+	depends on DVB_BT8XX
+	default m if DVB_DST_CUSTOMISE
+	help
+	  A DVB-S tuner module. Say Y when your card has a conditional access slot.
+	  Examples are: TwinHan DST with CA slot, Pinnacle PCTV Sat CI, Chaintech DST-1000, DNTV Live !
+
+endmenu

P. S.: "There are two things that are infinite and endless: The human stupidity and the universe.
While I am sometimes doubting about the universe I am damn sure as far as the human stupidity is concerned."
ALBERT EINSTEIN

-- 
"Feel free" - 5 GB Mailbox, 50 FreeSMS/Monat ...
Jetzt GMX ProMail testen: www.gmx.net/de/go/mailfooter/promail-out
