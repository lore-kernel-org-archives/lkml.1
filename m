Return-Path: <linux-kernel-owner+w=401wt.eu-S1758171AbZAMCdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171AbZAMCdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 21:33:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754789AbZAMCdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 21:33:06 -0500
Received: from ozlabs.org ([203.10.76.45]:43739 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754114AbZAMCdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 21:33:04 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ira Snyder <iws@ovro.caltech.edu>
Subject: Re: [PATCH RFC v5] net: add PCINet driver
Date: Tue, 13 Jan 2009 13:02:52 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, shemminger@vyatta.com, arnd@arndb.de,
       netdev@vger.kernel.org
References: <20090107195052.GA24981@ovro.caltech.edu> <20090108192716.GA19863@ovro.caltech.edu> <20090108215127.GA28935@ovro.caltech.edu>
In-Reply-To: <20090108215127.GA28935@ovro.caltech.edu>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200901131302.52754.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 January 2009 08:21:27 Ira Snyder wrote:
> Rusty, since you wrote the virtio code, can you point me at the things I
> would need to implement to use virtio over the PCI bus.
> 
> The guests (PowerPC computers running Linux) are PCI cards in the host
> system (an Intel Pentium3-M system). The guest computers can access all
> of the host's memory. The guests provide a 1MB (movable) window into
> their memory.
> 
> The PowerPC computers also have a DMA controller, which I've used to get
> better throughput from my driver. I have a way to create interrupts to
> both the host and guest systems.
> 
> I've read your paper titled: "virtio: Towards a De-Facto Standard For
> Virtual I/O Devices"
> 
> If I read that correctly, then I should implement all of the functions
> in struct virtqueue_ops appropriately, and the existing virtio drivers
> should just work. The only concern I have there is how to make guest ->
> host transfer use the DMA controller. I've done all programming of it
> from the guest kernel, using the Linux DMAEngine API.

Hi Ira,

   Interesting system: the guest being able to access the host's memory but not (fully) vice-versa makes this a little different from the current implementations where that was assumed.  virtio assumes that the guest will publish buffers and someone else (ie. the host) will access them.

   > Are there any other implementations other than virtio_ring?

   There were some earlier implementations, but they were trivial.  And not particularly helpful in your case.

In summary, yes, it should work quite nicely, but rather than publishing the buffers to the host, the host will need to tell the guest where it wants them transferred (possibly using that 1M window, and a notification mechanism).  That will be the complex part I think.

Cheers,
Rusty.
