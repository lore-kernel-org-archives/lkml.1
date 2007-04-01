Return-Path: <linux-kernel-owner+w=401wt.eu-S964801AbXDATmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964801AbXDATmZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 15:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964804AbXDATmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 15:42:24 -0400
Received: from smtpout.mac.com ([17.250.248.184]:55758 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964801AbXDATmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 15:42:24 -0400
In-Reply-To: <Pine.LNX.4.61.0704012058060.16977@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr> <Pine.LNX.4.61.0704012006060.12316@yvahk01.tjqt.qr> <B118D361-9F40-456F-96B7-E61B16B98432@mac.com> <Pine.LNX.4.61.0704012040220.15102@yvahk01.tjqt.qr> <2E204ACD-E697-42C6-8F01-22C1B7B4A85B@mac.com> <Pine.LNX.4.61.0704012058060.16977@yvahk01.tjqt.qr>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: multipart/mixed; boundary=Apple-Mail-1--419165573
Message-Id: <D260104B-C775-474E-B246-6298CD175205@mac.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@osdl.org>
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: [PATCH]
Date: Sun, 1 Apr 2007 15:42:09 -0400
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail-1--419165573
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	delsp=yes;
	format=flowed

Add a CONFIG_I_KNOW_WHAT_THE_HELL_I_AM_DOING variable with a really  
strong
warning attached to it (and a shorter CONFIG_EXPERT variable for use in
Kconfig files where it's a PITA to type out the full name)

Signed-off-by: Kyle Moffett <mrmacman_g4@mac.com>

---

Since my mailer tends to mangle patches I've attached this one


--Apple-Mail-1--419165573
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	x-unix-mode=0644;
	name=config_expert.patch.txt
Content-Disposition: attachment;
	filename=config_expert.patch.txt

Index: linux-2.6.20.1/init/Kconfig
===================================================================
--- linux-2.6.20.1.orig/init/Kconfig
+++ linux-2.6.20.1/init/Kconfig
@@ -40,6 +40,35 @@
 	you say Y here, you will be offered the choice of using features or
 	drivers that are currently considered to be in the alpha-test phase.
 
+config I_KNOW_WHAT_THE_HELL_I_AM_DOING
+	bool "Prompt for config options which will break your computer"
+	---help---
+	  Some kernel developers sometimes need to tune kernel parameters
+	  outside of their normal limits.  Without complete knowledge of
+	  exactly what you are doing you are likely to corrupt the laws of
+	  physics and destroy the universe (well, not quite, but you'll
+	  certainly corrupt your data and crash your box).  If you really
+	  know what you're doing and accept that if it breaks you get to
+	  keep the pieces, then go ahead and enable this option.
+	  
+	  NOTICE:  Bug reports where this option is turned on in the kernel
+	  config will be: (not necessarily in this order)
+	    1)  Laughed at hysterically
+	    2)  Made much fun of
+	    3)  Ridiculed until we're red in the face
+	    4)  Ignored
+	  
+	  WARNING:  If you are building a kernel for a distribution, DO NOT
+	  TURN THIS OPTION ON!!!  Instead you should submit a patch which
+	  adds a new safe value to the list of possibilities for the config
+	  option you're interested in.  Otherwise your users might have a
+	  hard time getting kernel support on the LKML.
+
+config EXPERT
+	bool
+	depends on I_KNOW_WHAT_THE_HELL_I_AM_DOING
+	default y
+
 config BROKEN
 	bool
 

--Apple-Mail-1--419165573--
