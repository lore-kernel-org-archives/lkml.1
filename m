Return-Path: <linux-kernel-owner+w=401wt.eu-S1763291AbXKIXe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763291AbXKIXe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:34:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbXKIXer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:34:47 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:57107 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbXKIXer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:34:47 -0500
Message-id: <133622706419279219.slaby@pripojeni.net>
Subject: [PATCH 1/7] Char: rocket, switch long delay to sleep
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Fri, 9 Nov 2007 18:34:47 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

rocket, switch long delay to sleep

Don't busy wait for whole 1s when registering some rocket modems. Sleep
instead since we are not in atomic.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit a9b06d9c7a580246dc328e96f31039d932bca47c
tree eb2e25299ebce29c89efa19c3014d41f742454c0
parent 5b07d82896b4d783e76f82dab6c4ba162545e414
author Jiri Slaby <jirislaby@gmail.com> Sat, 20 Oct 2007 11:51:04 +0200
committer Jiri Slaby <jirislaby@gmail.com> Fri, 09 Nov 2007 22:21:49 +0100

 drivers/char/rocket.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/rocket.c b/drivers/char/rocket.c
index d83419c..7a63f57 100644
--- a/drivers/char/rocket.c
+++ b/drivers/char/rocket.c
@@ -2191,10 +2191,10 @@ static __init int register_PCI(int i, struct pci_dev *dev)
 		num_chan = ports_per_aiop;
 		for (chan = 0; chan < num_chan; chan++)
 			sPCIModemReset(ctlp, chan, 1);
-		mdelay(500);
+		msleep(500);
 		for (chan = 0; chan < num_chan; chan++)
 			sPCIModemReset(ctlp, chan, 0);
-		mdelay(500);
+		msleep(500);
 		rmSpeakerReset(ctlp, rocketModel[i].model);
 	}
 	return (1);
@@ -2309,10 +2309,10 @@ static int __init init_ISA(int i)
 		total_num_chan = num_chan;
 		for (chan = 0; chan < num_chan; chan++)
 			sModemReset(ctlp, chan, 1);
-		mdelay(500);
+		msleep(500);
 		for (chan = 0; chan < num_chan; chan++)
 			sModemReset(ctlp, chan, 0);
-		mdelay(500);
+		msleep(500);
 		strcpy(rocketModel[i].modelString, "RocketModem ISA");
 	} else {
 		strcpy(rocketModel[i].modelString, "RocketPort ISA");
