Return-Path: <linux-kernel-owner+w=401wt.eu-S1753239Ab0AHCGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab0AHCGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 21:06:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884Ab0AHCGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 21:06:15 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:59823 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab0AHCGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 21:06:15 -0500
Date: Fri, 8 Jan 2010 02:06:14 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Joe Perches <joe@perches.com>
cc: H Hartley Sweeten <hartleys@visionengravers.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       davem@davemloft.net
Subject: Re: [PATCH] drivers/net/defxx.c: use %pMF to show MAC address
In-Reply-To: <1262914750.10429.88.camel@Joe-Laptop.home>
Message-ID: <alpine.LFD.2.00.1001080143250.13474@eddie.linux-mips.org>
References: <201001071624.20139.hartleys@visionengravers.com> <1262914750.10429.88.camel@Joe-Laptop.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jan 2010, Joe Perches wrote:

> On Thu, 2010-01-07 at 16:24 -0700, H Hartley Sweeten wrote:
> > Use the %pMF kernel extension to display the MAC address.
> > The address will still be displayed in the FDDI Canonical format.
> 
> > diff --git a/drivers/net/defxx.c b/drivers/net/defxx.c
> > index 6a6ea03..e4eac4b 100644
> > --- a/drivers/net/defxx.c
> > +++ b/drivers/net/defxx.c
> > @@ -1052,12 +1052,9 @@ static int __devinit dfx_driver_init(struct net_device *dev,
> >  		board_name = "DEFEA";
> >  	if (dfx_bus_pci)
> >  		board_name = "DEFPA";
> > -	pr_info("%s: %s at %saddr = 0x%llx, IRQ = %d, "
> > -		"Hardware addr = %02X-%02X-%02X-%02X-%02X-%02X\n",
> > +	pr_info("%s: %s at %saddr = 0x%llx, IRQ = %d, Hardware addr = %pMF\n",
> >  		print_name, board_name, dfx_use_mmio ? "" : "I/O ",
> 
> I believe the output will _now_ be in the canonical form.
> Before it wasn't bit reversed.  Now it should be.

 Output was correct -- why would you assume otherwise?  The bit order in 
the MLA (My Long Address) register as retrieved from the MAC chip by 
board's firmware has nothing to do with the wire order and is already in 
the canonical form (the same applies to CAM entries and frame headers) -- 
the board designers were sane people.

 With the two patches in place the output produced is now broken. :(

  Maciej
