Return-Path: <linux-kernel-owner+w=401wt.eu-S1758867AbXHMWz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758867AbXHMWz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 18:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765432AbXHMWyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 18:54:36 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:49765 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765160AbXHMWye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 18:54:34 -0400
Date: Mon, 13 Aug 2007 15:54:34 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: Mel Gorman <mel@skynet.ie>, Lee.Schermerhorn@hp.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] Embed zone_id information within the zonelist->zones
 pointer
In-Reply-To: <20070813234322.GJ3406@bingen.suse.de>
Message-ID: <Pine.LNX.4.64.0708131553050.30626@schroedinger.engr.sgi.com>
References: <200708102013.49170.ak@suse.de> <Pine.LNX.4.64.0708101201240.17549@schroedinger.engr.sgi.com>
 <200708110304.55433.ak@suse.de> <Pine.LNX.4.64.0708131423050.28026@schroedinger.engr.sgi.com>
 <20070813225020.GE3406@bingen.suse.de> <Pine.LNX.4.64.0708131457190.28445@schroedinger.engr.sgi.com>
 <20070813225841.GG3406@bingen.suse.de> <Pine.LNX.4.64.0708131506030.28502@schroedinger.engr.sgi.com>
 <20070813230801.GH3406@bingen.suse.de> <Pine.LNX.4.64.0708131536340.29946@schroedinger.engr.sgi.com>
 <20070813234322.GJ3406@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2007, Andi Kleen wrote:

> On Mon, Aug 13, 2007 at 03:38:10PM -0700, Christoph Lameter wrote:
> > I just did a grep for GFP_DMA and I still see a large list of GFP_DMA 
> > kmallocs???
> 
> I converted all of those that applied to x86.

Converted to what?

drivers/scsi/sr_ioctl.c:	buffer = kmalloc(32, GFP_KERNEL | SR_GFP_DMA(cd));
drivers/scsi/sr_ioctl.c:	buffer = kmalloc(32, GFP_KERNEL | SR_GFP_DMA(cd));
drivers/scsi/sr_ioctl.c:	char *buffer = kmalloc(32, GFP_KERNEL | SR_GFP_DMA(cd));
drivers/scsi/sr_ioctl.c:	raw_sector = kmalloc(2048, GFP_KERNEL | SR_GFP_DMA(cd));
drivers/scsi/sr.c:	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
drivers/scsi/sr.c:	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
drivers/scsi/ch.c:	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
drivers/scsi/ch.c:		buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);

^^^ looks generic to mme.

drivers/net/tokenring/3c359.c:	xl_priv->xl_tx_ring = kmalloc((sizeof(struct xl_tx_desc) * XL_TX_RING_SIZE) + 7, GFP_DMA | GFP_KERNEL) ; 
drivers/net/tokenring/3c359.c:	xl_priv->xl_rx_ring = kmalloc((sizeof(struct xl_rx_desc) * XL_RX_RING_SIZE) +7, GFP_DMA | GFP_KERNEL) ; 

Tokenring not supported on x86?

drivers/net/znet.c:	if (!(znet->rx_start = kmalloc (DMA_BUF_SIZE, GFP_KERNEL | GFP_DMA)))
drivers/net/znet.c:	if (!(znet->tx_start = kmalloc (DMA_BUF_SIZE, GFP_KERNEL | GFP_DMA)))
drivers/net/lance.c:			rx_buff = kmalloc(PKT_BUF_SZ, GFP_DMA | gfp);
drivers/net/wan/cosa.c:	cosa->bouncebuf = kmalloc(COSA_MTU, GFP_KERNEL|GFP_DMA);
drivers/net/wan/cosa.c:	if ((chan->rxdata = kmalloc(COSA_MTU, GFP_DMA|GFP_KERNEL)) == NULL) {
drivers/net/wan/cosa.c:	if ((kbuf = kmalloc(count, GFP_KERNEL|GFP_DMA)) == NULL) {

None of the above are supported on x86?
