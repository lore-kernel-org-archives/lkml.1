Return-Path: <linux-kernel-owner+w=401wt.eu-S1751910AbYCLJtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbYCLJtD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 05:49:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbYCLJsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 05:48:53 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:18859
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750765AbYCLJsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 05:48:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmABAOpD10d8qMER/2dsb2JhbAAIqUw
X-IronPort-AV: E=Sophos;i="4.25,487,1199631600"; 
   d="scan'208";a="236207719"
Subject: Re: [PATCH] UIO: Implement a UIO interface for the SMX Cryptengine
From: Ben Nizette <bn@niasdigital.com>
To: =?ISO-8859-1?Q?Hans-J=FCrgen?= Koch <hjk@linutronix.de>
Cc: gregkh@suse.de, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080311091525.2bd0c7ed@dilbert.local>
References: <1205211430.3817.15.camel@moss.renham>
	 <20080311091525.2bd0c7ed@dilbert.local>
Content-Type: text/plain; charset=UTF-8
Organization: Nias Digital
Date: Wed, 12 Mar 2008 20:54:20 +1100
Message-Id: <1205315660.4344.10.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-03-11 at 09:15 +0100, Hans-Jürgen Koch wrote:
> Am Tue, 11 Mar 2008 15:57:10 +1100
> schrieb Ben Nizette <bn@niasdigital.com>:
> > This driver is for proprietary hardware but we're always told to
> > submit the drivers anyway; here you are.  :-)
> 
> I've got no problems with that, but I'd like to know if that board can
> be bought somewhere (the niasdigital.com homepage doesn't mention it)
> and if and under which license the userspace part of the driver is
> available. The homepage says you're in favor of the GPL, so if it can
> be checked out or downloaded somewhere, please mention it, maybe in
> the Kconfig help text. If the userspace part is proprietary, please
> mention that, too.

The userspace part will be released under the GPL along with the
hardware itself, Q4 '08.  Have changed the Kconfig text to reflect this.

Of course this means for the next few months I will be the only direct
user of this driver, but I'm also submitting it in the hope that I can
convince others that it's a good thing to do.  I'm an active member of
AVRFreaks, an AVR32 support forum, and I spend far too much of my life
trying to convince people that polling the peripheral and
mmap'ing /dev/mem is not a good way to go.  Fingers crossed that this
driver at least serves to help educate until the SMX hardware is
released and it can serve it's main purpose :-)

<snip>
> > +static irqreturn_t smx_handler(int irq, struct uio_info *dev_info)
> > +{
> > +	void __iomem *csr = dev_info->mem[0].internal_addr + SMX_CSR;
> > +
> > +	u32 status = ioread32(csr);
> > +
> > +	/* Disable interrupt */
> > +	iowrite8(status & ~SMX_DRDY, csr);
> > +	return IRQ_HANDLED;
> > +}
> 
> You don't support shared interrupts. Is that intentional?
> 
On the hardware we have there is no possibility that the interrupt is
shared.  That said, it's little effort to allow the sharing and makes
the whole thing more future-proof, changed.

<snip>
> > +
> > +MODULE_LICENSE("GPL V2");
> 
> this needs to be "GPL v2" (lowercase 'v'), otherwise it won't build the
> module (at least on 2.6.25-rc5).
> 
Ah yep, thanks.

Thanks for the review, shall send a rejigged patch presently.

		--Ben.

