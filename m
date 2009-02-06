Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbZBFNWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbZBFNWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 08:22:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbZBFNWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 08:22:23 -0500
Received: from mail.atlantis.sk ([80.94.52.35]:46018 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141AbZBFNWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 08:22:23 -0500
From: Ondrej Zary <linux@rainbow-software.org>
Subject: 3c509 resume from hibernation broken somewhere between 2.6.25 and 2.6.28
Date: Fri, 6 Feb 2009 14:22:13 +0100
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1312
To: netdev@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200902061422.14746.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
last year, I posted a patch which fixed hibernation on 3c509 cards. That was 
back in 2.6.24. It worked fine in 2.6.25. But then I stopped using 
hibernation (as it did not work with my new IT8212 RAID controller).

Now I fixed it and noticed that 3c509 does not wake up properly anymore (in 
2.6.28) - neither in PnP nor in ISA modes. ifconfig down/up makes the card 
work again in PnP mode. However, in ISA mode, ifconfig up ends with "No such 
device" error.

Comparing the 3c509 driver between 2.6.25 and 2.6.28, there's only some 
statistics-related change. So the cause of the problem must be somewhere 
else.

This patch makes the resume work in PnP mode, but it's still not enough for 
ISA mode.

--- linux-2.6.28-orig/drivers/net/3c509.c	2009-01-02 17:19:07.000000000 +0100
+++ linux/drivers/net/3c509.c	2009-02-05 22:36:20.000000000 +0100
@@ -1477,6 +1477,7 @@
 	spin_lock_irqsave(&lp->lock, flags);
 
 	outw(PowerUp, ioaddr + EL3_CMD);
+	EL3WINDOW(0);
 	el3_up(dev);
 
 	if (netif_running(dev))

-- 
Ondrej Zary
