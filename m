Return-Path: <linux-kernel-owner+w=401wt.eu-S1751792AbYLWOlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbYLWOlb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 09:41:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbYLWOlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 09:41:20 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:48365 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbYLWOlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 09:41:18 -0500
Date: Tue, 23 Dec 2008 15:42:47 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       sparclinux <sparclinux@vger.kernel.org>
Cc: mingo@elte.hu, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       kenchen@google.com, paulus@samba.org, tglx@linutronix.de, hpa@zytor.com,
       linux-next@vger.kernel.org
Subject: [PATCH] sparc64: fix unsigned long long warnings in drivers
Message-ID: <20081223144247.GA4920@uranus.ravnborg.org>
References: <20081222152247.b934ed5b.sfr@canb.auug.org.au> <b040c32a0812212249p45aba306tbb68a960b79cd0ee@mail.gmail.com> <20081222070426.GD29160@elte.hu> <20081222181932.5dd9514e.sfr@canb.auug.org.au> <20081222080341.GA18897@elte.hu> <20081222144319.1bfc0061.akpm@linux-foundation.org> <20081222230035.GB4074@uranus.ravnborg.org> <20081222151338.3b6ef997.akpm@linux-foundation.org> <20081223131746.GA7456@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081223131746.GA7456@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix warnings caused by the unsigned long long usage in sparc
specific drivers.

The drivers were considered sparc specific more or less from the
filename alone.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---

This turned out easier than expected.
There were a few generic related warnings that I did not touch.
I can split it up in smaller chunks if preferred.

	Sam

 drivers/block/sunvdc.c          |    8 ++++----
 drivers/char/hw_random/n2-drv.c |    2 +-
 drivers/net/sunvnet.c           |    8 ++++----
 drivers/sbus/char/display7seg.c |    2 +-
 sound/sparc/cs4231.c            |    2 +-
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
index 953c0b8..5861e33 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -153,7 +153,7 @@ static int vdc_send_attr(struct vio_driver_state *vio)
 	pkt.vdisk_block_size = port->vdisk_block_size;
 	pkt.max_xfer_size = port->max_xfer_size;
 
-	viodbg(HS, "SEND ATTR xfer_mode[0x%x] blksz[%u] max_xfer[%lu]\n",
+	viodbg(HS, "SEND ATTR xfer_mode[0x%x] blksz[%u] max_xfer[%llu]\n",
 	       pkt.xfer_mode, pkt.vdisk_block_size, pkt.max_xfer_size);
 
 	return vio_ldc_send(&port->vio, &pkt, sizeof(pkt));
@@ -164,8 +164,8 @@ static int vdc_handle_attr(struct vio_driver_state *vio, void *arg)
 	struct vdc_port *port = to_vdc_port(vio);
 	struct vio_disk_attr_info *pkt = arg;
 
-	viodbg(HS, "GOT ATTR stype[0x%x] ops[%lx] disk_size[%lu] disk_type[%x] "
-	       "xfer_mode[0x%x] blksz[%u] max_xfer[%lu]\n",
+	viodbg(HS, "GOT ATTR stype[0x%x] ops[%llx] disk_size[%llu] disk_type[%x] "
+	       "xfer_mode[0x%x] blksz[%u] max_xfer[%llu]\n",
 	       pkt->tag.stype, pkt->operations,
 	       pkt->vdisk_size, pkt->vdisk_type,
 	       pkt->xfer_mode, pkt->vdisk_block_size,
@@ -753,7 +753,7 @@ static int __devinit vdc_port_probe(struct vio_dev *vdev,
 
 	err = -ENODEV;
 	if ((vdev->dev_no << PARTITION_SHIFT) & ~(u64)MINORMASK) {
-		printk(KERN_ERR PFX "Port id [%lu] too large.\n",
+		printk(KERN_ERR PFX "Port id [%llu] too large.\n",
 		       vdev->dev_no);
 		goto err_out_release_mdesc;
 	}
diff --git a/drivers/char/hw_random/n2-drv.c b/drivers/char/hw_random/n2-drv.c
index 8859aea..9b3e09c 100644
--- a/drivers/char/hw_random/n2-drv.c
+++ b/drivers/char/hw_random/n2-drv.c
@@ -482,7 +482,7 @@ static void n2rng_dump_test_buffer(struct n2rng *np)
 	int i;
 
 	for (i = 0; i < SELFTEST_BUFFER_WORDS; i++)
-		dev_err(&np->op->dev, "Test buffer slot %d [0x%016lx]\n",
+		dev_err(&np->op->dev, "Test buffer slot %d [0x%016llx]\n",
 			i, np->test_buffer[i]);
 }
 
diff --git a/drivers/net/sunvnet.c b/drivers/net/sunvnet.c
index a720065..c5335cf 100644
--- a/drivers/net/sunvnet.c
+++ b/drivers/net/sunvnet.c
@@ -336,7 +336,7 @@ static int vnet_walk_rx_one(struct vnet_port *port,
 	if (IS_ERR(desc))
 		return PTR_ERR(desc);
 
-	viodbg(DATA, "vio_walk_rx_one desc[%02x:%02x:%08x:%08x:%lx:%lx]\n",
+	viodbg(DATA, "vio_walk_rx_one desc[%02x:%02x:%08x:%08x:%llx:%llx]\n",
 	       desc->hdr.state, desc->hdr.ack,
 	       desc->size, desc->ncookies,
 	       desc->cookies[0].cookie_addr,
@@ -394,14 +394,14 @@ static int vnet_rx(struct vnet_port *port, void *msgbuf)
 	struct vio_dring_state *dr = &port->vio.drings[VIO_DRIVER_RX_RING];
 	struct vio_driver_state *vio = &port->vio;
 
-	viodbg(DATA, "vnet_rx stype_env[%04x] seq[%016lx] rcv_nxt[%016lx]\n",
+	viodbg(DATA, "vnet_rx stype_env[%04x] seq[%016llx] rcv_nxt[%016llx]\n",
 	       pkt->tag.stype_env, pkt->seq, dr->rcv_nxt);
 
 	if (unlikely(pkt->tag.stype_env != VIO_DRING_DATA))
 		return 0;
 	if (unlikely(pkt->seq != dr->rcv_nxt)) {
-		printk(KERN_ERR PFX "RX out of sequence seq[0x%lx] "
-		       "rcv_nxt[0x%lx]\n", pkt->seq, dr->rcv_nxt);
+		printk(KERN_ERR PFX "RX out of sequence seq[0x%llx] "
+		       "rcv_nxt[0x%llx]\n", pkt->seq, dr->rcv_nxt);
 		return 0;
 	}
 
diff --git a/drivers/sbus/char/display7seg.c b/drivers/sbus/char/display7seg.c
index 2550af4..1d46205 100644
--- a/drivers/sbus/char/display7seg.c
+++ b/drivers/sbus/char/display7seg.c
@@ -214,7 +214,7 @@ static int __devinit d7s_probe(struct of_device *op,
 
 	writeb(regs,  p->regs);
 
-	printk(KERN_INFO PFX "7-Segment Display%s at [%s:0x%lx] %s\n", 
+	printk(KERN_INFO PFX "7-Segment Display%s at [%s:0x%llx] %s\n", 
 	       op->node->full_name,
 	       (regs & D7S_FLIP) ? " (FLIPPED)" : "",
 	       op->resource[0].start,
diff --git a/sound/sparc/cs4231.c b/sound/sparc/cs4231.c
index d44bf98..41c3875 100644
--- a/sound/sparc/cs4231.c
+++ b/sound/sparc/cs4231.c
@@ -2057,7 +2057,7 @@ static int __devinit cs4231_ebus_probe(struct of_device *op, const struct of_dev
 	if (err)
 		return err;
 
-	sprintf(card->longname, "%s at 0x%lx, irq %d",
+	sprintf(card->longname, "%s at 0x%llx, irq %d",
 		card->shortname,
 		op->resource[0].start,
 		op->irqs[0]);
-- 
1.6.0.2.GIT

