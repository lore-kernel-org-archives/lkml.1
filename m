Return-Path: <linux-kernel-owner+w=401wt.eu-S1754837AbYE3WeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbYE3WeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 18:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbYE3WeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 18:34:03 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:53251 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbYE3WeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 18:34:01 -0400
Message-ID: <48408191.6030104@keyaccess.nl>
Date: Sat, 31 May 2008 00:37:05 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Takashi Iwai <tiwai@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       ALSA devel <alsa-devel@alsa-project.org>
Subject: [PATCH] ISA: set 24-bit dma_mask for ISA devices.
References: <4823AAF2.7070102@keyaccess.nl> <482B38D6.5030804@keyaccess.nl> <48406E8D.8050408@keyaccess.nl> <200805301543.42208.bjorn.helgaas@hp.com> <48407B99.4080209@keyaccess.nl>
In-Reply-To: <48407B99.4080209@keyaccess.nl>
Content-Type: multipart/mixed;
 boundary="------------050209050208090004020909"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050209050208090004020909
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 31-05-08 00:11, Rene Herman wrote:

[ PNP: set the pnp_card dma_mask for use by ISAPnP cards. ]

> Thanks. I'll assume Andrew picks it up from the CC...

And here's the ISA one...

Rene.

--------------050209050208090004020909
Content-Type: text/plain;
 name="0001-ISA-set-24-bit-dma_mask-for-ISA-devices.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-ISA-set-24-bit-dma_mask-for-ISA-devices.patch"

>From 35f30388ad8536860719b3b44ea1f232b95ba42b Mon Sep 17 00:00:00 2001
From: Rene Herman <rene.herman@gmail.com>
Date: Sat, 31 May 2008 00:31:40 +0200
Subject: [PATCH] ISA: set 24-bit dma_mask for ISA devices.

Set the ISA device dma_mask in preparation for using the actual device
with the DMA API.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
---
 drivers/base/isa.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/base/isa.c b/drivers/base/isa.c
index d222239..efd5775 100644
--- a/drivers/base/isa.c
+++ b/drivers/base/isa.c
@@ -7,6 +7,7 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/dma-mapping.h>
 #include <linux/isa.h>
 
 static struct device isa_bus = {
@@ -141,6 +142,9 @@ int isa_register_driver(struct isa_driver *isa_driver, unsigned int ndev)
 		isa_dev->dev.release		= isa_dev_release;
 		isa_dev->id			= id;
 
+		isa_dev->dev.coherent_dma_mask = DMA_24BIT_MASK;
+		isa_dev->dev.dma_mask = &isa_dev->dev.coherent_dma_mask;
+
 		error = device_register(&isa_dev->dev);
 		if (error) {
 			put_device(&isa_dev->dev);
-- 
1.5.2.2


--------------050209050208090004020909--
