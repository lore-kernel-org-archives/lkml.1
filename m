Return-Path: <linux-kernel-owner+w=401wt.eu-S1763383AbXHFVsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763383AbXHFVsA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 17:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757090AbXHFVrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 17:47:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:59144 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756286AbXHFVrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 17:47:52 -0400
Subject: Re: [PATCH 2.6.22.y] ieee1394: revert "sbp2: enforce 32bit
	DMA	mapping"
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Olaf Hering <olh@suse.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Robert Hancock <hancockr@shaw.ca>, linuxppc-dev@ozlabs.org,
       stable@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070806135124.GA2900@suse.de>
References: <fa.Qn3Snqoik3hhnxcA6HqjGV0Yzck@ifi.uio.no>
	 <46B4B3DC.7020609@shaw.ca> <46B4B7C6.1040107@s5r6.in-berlin.de>
	 <1186272926.938.8.camel@localhost.localdomain>
	 <46B5824B.1000103@s5r6.in-berlin.de>
	 <1186351473.938.21.camel@localhost.localdomain>
	 <20070806135124.GA2900@suse.de>
Content-Type: text/plain
Date: Tue, 07 Aug 2007 07:47:28 +1000
Message-Id: <1186436848.938.75.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-06 at 15:51 +0200, Olaf Hering wrote:
> On Mon, Aug 06, Benjamin Herrenschmidt wrote:
> 
> > BTW. Any reason why you don't set the DMA mask in the ohci driver rather
> > than the sbp2 one ?
> 
> I used this patch, and the attached CD was found.
> What dma mask should be used in ohci_probe()?

Allright. So I see two problems here:

 - in the code that powerpc uses to generate the PCI tree based on the
open firmware device-tree (instead of probing the bus), we don't set the
dma mask to the default ffffffff.

 - our implementation of dma_supported() incorrectly tests against the
-previous- dma mask instead of the one we pass in as an argument.

I'll send a patch later today for you guys to test.

In addition, make sure that ieee1394 properly uses the parent PCI dev
and not some other intermediary struct device for the dma mask. Oh and,
don't do the set_dma_mask() in sbp2, it has nothing to do there. It
should be in the ohci1394 driver.

Cheers,
Ben.


