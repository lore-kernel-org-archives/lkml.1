Return-Path: <linux-kernel-owner+w=401wt.eu-S1761312AbYJEQgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761312AbYJEQgw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761093AbYJEQfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:35:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35279 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758924AbYJEQfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:35:20 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 01/19] pcmcia: Fix wireless drivers
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:35:20 +0100
Message-ID: <20081005163504.3799.50459.stgit@localhost.localdomain>
In-Reply-To: <20081005163302.3799.61899.stgit@localhost.localdomain>
References: <20081005163302.3799.61899.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IRQ_TYPE_EXCLUSIVE has been deprecated for years but wireless seems not to
have caught up with reality.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/net/wireless/airo_cs.c     |    2 +-
 drivers/net/wireless/atmel_cs.c    |    2 +-
 drivers/net/wireless/netwave_cs.c  |    2 +-
 drivers/net/wireless/orinoco_cs.c  |    2 +-
 drivers/net/wireless/ray_cs.c      |    2 +-
 drivers/net/wireless/spectrum_cs.c |    2 +-
 drivers/net/wireless/wavelan_cs.c  |    2 +-
 drivers/net/wireless/wl3501_cs.c   |    2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/airo_cs.c b/drivers/net/wireless/airo_cs.c
index f123553..fd72e42 100644
--- a/drivers/net/wireless/airo_cs.c
+++ b/drivers/net/wireless/airo_cs.c
@@ -147,7 +147,7 @@ static int airo_probe(struct pcmcia_device *p_dev)
 	DEBUG(0, "airo_attach()\n");
 
 	/* Interrupt setup */
-	p_dev->irq.Attributes = IRQ_TYPE_EXCLUSIVE;
+	p_dev->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING;
 	p_dev->irq.IRQInfo1 = IRQ_LEVEL_ID;
 	p_dev->irq.Handler = NULL;
 	
diff --git a/drivers/net/wireless/atmel_cs.c b/drivers/net/wireless/atmel_cs.c
index 12617cd..d2388e8 100644
--- a/drivers/net/wireless/atmel_cs.c
+++ b/drivers/net/wireless/atmel_cs.c
@@ -158,7 +158,7 @@ static int atmel_probe(struct pcmcia_device *p_dev)
 	DEBUG(0, "atmel_attach()\n");
 
 	/* Interrupt setup */
-	p_dev->irq.Attributes = IRQ_TYPE_EXCLUSIVE;
+	p_dev->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING;
 	p_dev->irq.IRQInfo1 = IRQ_LEVEL_ID;
 	p_dev->irq.Handler = NULL;
 
diff --git a/drivers/net/wireless/netwave_cs.c b/drivers/net/wireless/netwave_cs.c
index f479c1a..25bae79 100644
--- a/drivers/net/wireless/netwave_cs.c
+++ b/drivers/net/wireless/netwave_cs.c
@@ -398,7 +398,7 @@ static int netwave_probe(struct pcmcia_device *link)
     link->io.IOAddrLines = 5;
     
     /* Interrupt setup */
-    link->irq.Attributes = IRQ_TYPE_EXCLUSIVE | IRQ_HANDLE_PRESENT;
+    link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING | IRQ_HANDLE_PRESENT;
     link->irq.IRQInfo1 = IRQ_LEVEL_ID;
     link->irq.Handler = &netwave_interrupt;
     
diff --git a/drivers/net/wireless/orinoco_cs.c b/drivers/net/wireless/orinoco_cs.c
index 1c216e0..f9bab5e 100644
--- a/drivers/net/wireless/orinoco_cs.c
+++ b/drivers/net/wireless/orinoco_cs.c
@@ -120,7 +120,7 @@ orinoco_cs_probe(struct pcmcia_device *link)
 	link->priv = dev;
 
 	/* Interrupt setup */
-	link->irq.Attributes = IRQ_TYPE_EXCLUSIVE | IRQ_HANDLE_PRESENT;
+	link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING | IRQ_HANDLE_PRESENT;
 	link->irq.IRQInfo1 = IRQ_LEVEL_ID;
 	link->irq.Handler = orinoco_interrupt;
 	link->irq.Instance = dev; 
diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 963960d..44da0d1 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -325,7 +325,7 @@ static int ray_probe(struct pcmcia_device *p_dev)
     p_dev->io.IOAddrLines = 5;
 
     /* Interrupt setup. For PCMCIA, driver takes what's given */
-    p_dev->irq.Attributes = IRQ_TYPE_EXCLUSIVE | IRQ_HANDLE_PRESENT;
+    p_dev->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING | IRQ_HANDLE_PRESENT;
     p_dev->irq.IRQInfo1 = IRQ_LEVEL_ID;
     p_dev->irq.Handler = &ray_interrupt;
 
diff --git a/drivers/net/wireless/spectrum_cs.c b/drivers/net/wireless/spectrum_cs.c
index 98df9bc..caf3e46 100644
--- a/drivers/net/wireless/spectrum_cs.c
+++ b/drivers/net/wireless/spectrum_cs.c
@@ -593,7 +593,7 @@ spectrum_cs_probe(struct pcmcia_device *link)
 	link->priv = dev;
 
 	/* Interrupt setup */
-	link->irq.Attributes = IRQ_TYPE_EXCLUSIVE | IRQ_HANDLE_PRESENT;
+	link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING | IRQ_HANDLE_PRESENT;
 	link->irq.IRQInfo1 = IRQ_LEVEL_ID;
 	link->irq.Handler = orinoco_interrupt;
 	link->irq.Instance = dev; 
diff --git a/drivers/net/wireless/wavelan_cs.c b/drivers/net/wireless/wavelan_cs.c
index 00a3559..b5de38a 100644
--- a/drivers/net/wireless/wavelan_cs.c
+++ b/drivers/net/wireless/wavelan_cs.c
@@ -4496,7 +4496,7 @@ wavelan_probe(struct pcmcia_device *p_dev)
   p_dev->io.IOAddrLines = 3;
 
   /* Interrupt setup */
-  p_dev->irq.Attributes = IRQ_TYPE_EXCLUSIVE | IRQ_HANDLE_PRESENT;
+  p_dev->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING | IRQ_HANDLE_PRESENT;
   p_dev->irq.IRQInfo1 = IRQ_LEVEL_ID;
   p_dev->irq.Handler = wavelan_interrupt;
 
diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
index 3771419..a546910 100644
--- a/drivers/net/wireless/wl3501_cs.c
+++ b/drivers/net/wireless/wl3501_cs.c
@@ -1917,7 +1917,7 @@ static int wl3501_probe(struct pcmcia_device *p_dev)
 	p_dev->io.IOAddrLines	= 5;
 
 	/* Interrupt setup */
-	p_dev->irq.Attributes	= IRQ_TYPE_EXCLUSIVE | IRQ_HANDLE_PRESENT;
+	p_dev->irq.Attributes	= IRQ_TYPE_DYNAMIC_SHARING | IRQ_HANDLE_PRESENT;
 	p_dev->irq.IRQInfo1	= IRQ_LEVEL_ID;
 	p_dev->irq.Handler = wl3501_interrupt;
 

