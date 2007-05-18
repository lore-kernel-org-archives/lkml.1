Return-Path: <linux-kernel-owner+w=401wt.eu-S1761344AbXERPIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761344AbXERPIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 11:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756035AbXERPIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 11:08:13 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39450 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755903AbXERPIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 11:08:12 -0400
Date: Fri, 18 May 2007 16:12:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Robert Hancock <hancockr@shaw.ca>, Zoltan Boszormenyi <zboszor@dunaweb.hu>,
       Peer Chen <pchen@nvidia.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/ata: Add the SW NCQ support to sata_nv for
 MCP51/MCP55/MCP61
Message-ID: <20070518161228.7e89b6dc@the-village.bc.nu>
In-Reply-To: <464DB97B.8030204@garzik.org>
References: <fa.iernIz8Xcuvw0SBwi4A99Ju0g2o@ifi.uio.no>
	<464D0855.20703@shaw.ca>
	<20070518133456.5f1392e9@the-village.bc.nu>
	<464DB97B.8030204@garzik.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2007 10:34:35 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Alan Cox wrote:
> >> That shouldn't be a problem, libata default DMA mask is 32 bits (which 
> >> isn't overridden with this controller) and so the block layer will 
> >> bounce any data being read/written above that point with IOMMU or 
> >> swiotlb. The comment is a bit unnecessarily scary.
> > 
> > Adding a BUG_ON for this would be wise. Its trivial to check and a BUG
> > rather than corruption if this assumption ever changes would be far
> > preferable
> 
> The default DMA mask -everywhere- is 32 bits.
> 
> A lot of code will break if this assumption ever changes, not just libata.

Little lesson from history..

Over ten years ago someone (Eric Youngdale I guess) stuck a panic check
for DMA over 16MBytes in the AHA 1542 ISA SCSI driver. Last year it
triggered. The panic probably saved someone from corruption and meant the
bug could be fixed.

Alan
