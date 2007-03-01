Return-Path: <linux-kernel-owner+w=401wt.eu-S965105AbXCAO3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965105AbXCAO3K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 09:29:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965115AbXCAO3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 09:29:10 -0500
Received: from mail.gmx.net ([213.165.64.20]:53343 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965104AbXCAO3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 09:29:06 -0500
Cc: akpm@linux-foundation.org, linux-dvb@linuxtv.org, domi.dumont@free.fr,
       Jiri Slaby <jirislaby@gmail.com>, bunk@stusta.de,
       linux-kernel@vger.kernel.org, Stephane Eranian <eranian@hpl.hp.com>,
       venkatesh.pallipadi@intel.com
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 01 Mar 2007 15:29:04 +0100
From: "Uwe Bugla" <uwe.bugla@gmx.de>
Message-ID: <20070301142904.29930@gmx.net>
MIME-Version: 1.0
Subject: patch 1 / 3: fix broken documentation for bt8xx cards
To: torvalds@linux-foundation.org
X-Authenticated: #8359428
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1+KaHI6zwiKkElb3jvsSxi7JjPaOdhTChUxar6P8Y
 V6He1gasPAuUGedl42Hs+6wxM= 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,
although this patch is fine and necessary it has been blocked and ignored for months by the following so-called "maintainers"
who are a tall order and a shame for the whole linux community:
a. Manuel Abraham <abraham.manu@gmail.com>
b. Mauro Carvalho Chehab <mchehab@infradead.org>
I vote for excluding Manuel Abraham from maintainership, as we all need communicatable, reliable and accurate maintainers, no mismatches!
This patch fixes the documentation for dvb-bt8xx cards, synchronizing it to the actual state of kernel development.
Please sign-off or ack this only in connection with the DST deselection patch (i. e. patch 2 / 3)
Written and
Signed-off-by: Uwe Bugla <uwe.bugla@gmx.de>

--- a/Documentation/dvb/bt8xx.txt
+++ b/Documentation/dvb/bt8xx.txt
@@ -9,9 +9,33 @@
 Please see Documentation/dvb/cards.txt => o Cards based on the Conexant Bt8xx PCI bridge:
 
 Compiling kernel please enable:
-a.)"Device drivers" => "Multimedia devices" => "Video For Linux" => "BT848 Video For Linux"
+a.)"Device drivers" => "Multimedia devices" => "Video For Linux" => "Enable Video for Linux API 1 (DEPRECATED)"
-b.)"Device drivers" => "Multimedia devices" => "Digital Video Broadcasting Devices"
- => "DVB for Linux" "DVB Core Support" "Bt8xx based PCI Cards"
+b.)"Device drivers" => "Multimedia devices" => "Video For Linux" => "Video Capture Adapters" => "BT848 Video For Linux"
+c.)"Device drivers" => "Multimedia devices" => "Digital Video Broadcasting Devices" => "DVB for Linux" "DVB Core Support" "Bt8xx based PCI Cards"
+
+Please use the following options with care as deselection of drivers which are in fact necessary
+may result in DVB devices that cannot be tuned due to lack of driver support:
+You can save RAM by deselecting every frontend or DST module that your DVB card does not need.
+
+First please remove the static dependency of DVB card drivers on all frontend modules for all possible card variants by enabling:
+d.) "Device drivers" => "Multimedia devices" => "Digital Video Broadcasting Devices"
+ => "DVB for Linux" "DVB Core Support" "Load and attach frontend modules as needed"
+
+If you know the frontend driver that your card needs please enable:
+e.)"Device drivers" => "Multimedia devices" => "Digital Video Broadcasting Devices"
+ => "DVB for Linux" "DVB Core Support" "Customise DVB Frontends" => "Customise the frontend modules to build"
+ Then please select your card-specific frontend module.
+
+Do you use one of the following cards?
+1. Twinhan DST (FTA and CI) family (DVB-S/C/T/ATSC)
+2. Pinnacle PCTV SAT CI
+3. Chaintech DST-1000
+4. DNTV Live !
+
+If not you can save additional RAM by enabling:
+f.)"Device drivers" => "Multimedia devices" => "Digital Video Broadcasting Devices" => "DVB for Linux" "DVB Core Support"
+ "Bt8xx based PCI Cards" => "Customise DST support" => "Customise DST modules to build"
+ Then please deselect "DST module" and "DST CA module"
 
 2) Loading Modules
 ==================
@@ -68,7 +92,7 @@
 	$ modprobe dvb-bt8xx
 
 For a full list of card ID's please see Documentation/video4linux/CARDLIST.bttv.
-In case of further problems send questions to the mailing list: www.linuxdvb.org.
+In case of further problems please subscribe and send questions to the mailing list: linux-dvb@linuxtv.org.
 
 Authors: Richard Walker,
 	 Jamie Honan,

P. S.: "There are two things that are infinite and endless: The human stupidity and the universe.
While I am sometimes doubting about the universe I am damn sure as far as the human stupidity is concerned."
ALBERT EINSTEIN

-- 
"Feel free" - 10 GB Mailbox, 100 FreeSMS/Monat ...
Jetzt GMX TopMail testen: www.gmx.net/de/go/mailfooter/topmail-out
