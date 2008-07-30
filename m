Return-Path: <linux-kernel-owner+w=401wt.eu-S1763191AbYGaAZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763191AbYGaAZA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762025AbYGaAW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:22:59 -0400
Received: from ns.suse.de ([195.135.220.2]:39573 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763267AbYGaAW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:22:57 -0400
Date: Wed, 30 Jul 2008 16:59:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Steven Toth <stoth@hauppauge.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch 50/62] DVB: cx23885: SRAM changes for the 885 and 887
	silicon parts
Message-ID: <20080730235943.GX12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dvb-cx23885-sram-changes-for-the-885-and-887-silicon-parts.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Steven Toth <stoth@hauppauge.com>

(cherry picked from commit 7e994302ed3fc6d209ce247ad5b6d9c2499bf7c2)

DVB: cx23885: SRAM changes for the 885 and 887 silicon parts

In a previous patch I merged both memory maps into a single struct,
believing that they could be combined. We've since found problems
with streaming multiple channels on the 885. I'm restoring the
multiple memory map structs - in line with the windows driver.

Signed-off-by: Steven Toth <stoth@hauppauge.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/cx23885/cx23885-core.c |  116 ++++++++++++++++++++++++++++-
 1 file changed, 114 insertions(+), 2 deletions(-)

--- a/drivers/media/video/cx23885/cx23885-core.c
+++ b/drivers/media/video/cx23885/cx23885-core.c
@@ -76,7 +76,7 @@ LIST_HEAD(cx23885_devlist);
  * 0x00010ea0 0x00010xxx Free
  */
 
-static struct sram_channel cx23887_sram_channels[] = {
+static struct sram_channel cx23885_sram_channels[] = {
 	[SRAM_CH01] = {
 		.name		= "VID A",
 		.cmds_start	= 0x10000,
@@ -187,6 +187,117 @@ static struct sram_channel cx23887_sram_
 	},
 };
 
+static struct sram_channel cx23887_sram_channels[] = {
+	[SRAM_CH01] = {
+		.name		= "VID A",
+		.cmds_start	= 0x10000,
+		.ctrl_start	= 0x105b0,
+		.cdt		= 0x107b0,
+		.fifo_start	= 0x40,
+		.fifo_size	= 0x2800,
+		.ptr1_reg	= DMA1_PTR1,
+		.ptr2_reg	= DMA1_PTR2,
+		.cnt1_reg	= DMA1_CNT1,
+		.cnt2_reg	= DMA1_CNT2,
+	},
+	[SRAM_CH02] = {
+		.name		= "ch2",
+		.cmds_start	= 0x0,
+		.ctrl_start	= 0x0,
+		.cdt		= 0x0,
+		.fifo_start	= 0x0,
+		.fifo_size	= 0x0,
+		.ptr1_reg	= DMA2_PTR1,
+		.ptr2_reg	= DMA2_PTR2,
+		.cnt1_reg	= DMA2_CNT1,
+		.cnt2_reg	= DMA2_CNT2,
+	},
+	[SRAM_CH03] = {
+		.name		= "TS1 B",
+		.cmds_start	= 0x100A0,
+		.ctrl_start	= 0x10630,
+		.cdt		= 0x10870,
+		.fifo_start	= 0x5000,
+		.fifo_size	= 0x1000,
+		.ptr1_reg	= DMA3_PTR1,
+		.ptr2_reg	= DMA3_PTR2,
+		.cnt1_reg	= DMA3_CNT1,
+		.cnt2_reg	= DMA3_CNT2,
+	},
+	[SRAM_CH04] = {
+		.name		= "ch4",
+		.cmds_start	= 0x0,
+		.ctrl_start	= 0x0,
+		.cdt		= 0x0,
+		.fifo_start	= 0x0,
+		.fifo_size	= 0x0,
+		.ptr1_reg	= DMA4_PTR1,
+		.ptr2_reg	= DMA4_PTR2,
+		.cnt1_reg	= DMA4_CNT1,
+		.cnt2_reg	= DMA4_CNT2,
+	},
+	[SRAM_CH05] = {
+		.name		= "ch5",
+		.cmds_start	= 0x0,
+		.ctrl_start	= 0x0,
+		.cdt		= 0x0,
+		.fifo_start	= 0x0,
+		.fifo_size	= 0x0,
+		.ptr1_reg	= DMA5_PTR1,
+		.ptr2_reg	= DMA5_PTR2,
+		.cnt1_reg	= DMA5_CNT1,
+		.cnt2_reg	= DMA5_CNT2,
+	},
+	[SRAM_CH06] = {
+		.name		= "TS2 C",
+		.cmds_start	= 0x10140,
+		.ctrl_start	= 0x10670,
+		.cdt		= 0x108d0,
+		.fifo_start	= 0x6000,
+		.fifo_size	= 0x1000,
+		.ptr1_reg	= DMA5_PTR1,
+		.ptr2_reg	= DMA5_PTR2,
+		.cnt1_reg	= DMA5_CNT1,
+		.cnt2_reg	= DMA5_CNT2,
+	},
+	[SRAM_CH07] = {
+		.name		= "ch7",
+		.cmds_start	= 0x0,
+		.ctrl_start	= 0x0,
+		.cdt		= 0x0,
+		.fifo_start	= 0x0,
+		.fifo_size	= 0x0,
+		.ptr1_reg	= DMA6_PTR1,
+		.ptr2_reg	= DMA6_PTR2,
+		.cnt1_reg	= DMA6_CNT1,
+		.cnt2_reg	= DMA6_CNT2,
+	},
+	[SRAM_CH08] = {
+		.name		= "ch8",
+		.cmds_start	= 0x0,
+		.ctrl_start	= 0x0,
+		.cdt		= 0x0,
+		.fifo_start	= 0x0,
+		.fifo_size	= 0x0,
+		.ptr1_reg	= DMA7_PTR1,
+		.ptr2_reg	= DMA7_PTR2,
+		.cnt1_reg	= DMA7_CNT1,
+		.cnt2_reg	= DMA7_CNT2,
+	},
+	[SRAM_CH09] = {
+		.name		= "ch9",
+		.cmds_start	= 0x0,
+		.ctrl_start	= 0x0,
+		.cdt		= 0x0,
+		.fifo_start	= 0x0,
+		.fifo_size	= 0x0,
+		.ptr1_reg	= DMA8_PTR1,
+		.ptr2_reg	= DMA8_PTR2,
+		.cnt1_reg	= DMA8_CNT1,
+		.cnt2_reg	= DMA8_CNT2,
+	},
+};
+
 static int cx23885_risc_decode(u32 risc)
 {
 	static char *instr[16] = {
@@ -626,7 +737,6 @@ static int cx23885_dev_setup(struct cx23
 	atomic_inc(&dev->refcount);
 
 	dev->nr = cx23885_devcount++;
-	dev->sram_channels = cx23887_sram_channels;
 	sprintf(dev->name, "cx23885[%d]", dev->nr);
 
 	mutex_lock(&devlist);
@@ -638,11 +748,13 @@ static int cx23885_dev_setup(struct cx23
 		dev->bridge = CX23885_BRIDGE_887;
 		/* Apply a sensible clock frequency for the PCIe bridge */
 		dev->clk_freq = 25000000;
+		dev->sram_channels = cx23887_sram_channels;
 	} else
 	if(dev->pci->device == 0x8852) {
 		dev->bridge = CX23885_BRIDGE_885;
 		/* Apply a sensible clock frequency for the PCIe bridge */
 		dev->clk_freq = 28000000;
+		dev->sram_channels = cx23885_sram_channels;
 	} else
 		BUG();
 

-- 
