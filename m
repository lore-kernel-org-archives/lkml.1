Return-Path: <linux-kernel-owner+w=401wt.eu-S1762635AbZAHT1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762635AbZAHT1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 14:27:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761566AbZAHT1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 14:27:19 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:36041 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762269AbZAHT1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 14:27:17 -0500
Date: Thu, 8 Jan 2009 11:27:16 -0800
From: Ira Snyder <iws@ovro.caltech.edu>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       shemminger@vyatta.com, arnd@arndb.de, netdev@vger.kernel.org
Subject: Re: [PATCH RFC v5] net: add PCINet driver
Message-ID: <20090108192716.GA19863@ovro.caltech.edu>
Mail-Followup-To: David Miller <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
	shemminger@vyatta.com, arnd@arndb.de, netdev@vger.kernel.org
References: <20090107195052.GA24981@ovro.caltech.edu> <20090108.111610.132149837.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090108.111610.132149837.davem@davemloft.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Thu, 08 Jan 2009 11:27:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2009 at 11:16:10AM -0800, David Miller wrote:
> From: Ira Snyder <iws@ovro.caltech.edu>
> Date: Wed, 7 Jan 2009 11:50:52 -0800
> 
> > This adds support to Linux for a virtual ethernet interface which uses the
> > PCI bus as its transport mechanism. It creates a simple, familiar, and fast
> > method of communication for two devices connected by a PCI interface.
> 
> Well, it looks like much more than that to me.
> 
> What is this UART thing in here for?
> 
> I can only assume it's meant to be used as a console port between the
> x86 host and the powerpc nodes.
> 

Exactly right. I needed it to tell the U-Boot bootloader to tftp the
kernel and boot the board. These boards don't keep their PCI settings
(assigned by the BIOS at boot) over a soft or hard reset.

I couldn't think of a better way to get them started.

> You haven't even mentioned this UART aspect even indirectly in the
> commit message.
> 

Sorry, I'll add something about it.

> This just looks like yet another set of virtualization drivers
> to me.  You could have just have easily built this using your
> own PCI backplane framework, and using the virtio stuff on top.
> 
> And the virtio stuff has all kinds of snazzy optimizations that
> will likely improve your throughput, it has console drivers that
> distributions already probe for and attach appropriately, etc.
> 
> In short I really don't like this conceptually, it can be done
> so much better using facilities we already have that are
> heavily optimized and userland understands already.

I've had a really hard time understanding the virtio code. I haven't
been able to find much in the way of documentation for it. Can you point
me to some code that does anything vaguely similar to what you are
suggesting?

Arnd Bergmann said that there is a similar driver (for different
hardware) that uses virtio, but it is very slow, because it doesn't use
the DMA controller to transfer data. I need at very minimum 40MB/sec of
client -> host data transfer.

Thanks for the comments,
Ira

> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
