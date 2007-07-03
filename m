Return-Path: <linux-kernel-owner+w=401wt.eu-S1758972AbXGCTXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758972AbXGCTXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 15:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755805AbXGCTXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 15:23:00 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40742 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755507AbXGCTW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 15:22:59 -0400
Date: Tue, 3 Jul 2007 12:21:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: Don't miss the ARM-scsi fix.
Message-Id: <20070703122145.447c7d2c.akpm@linux-foundation.org>
In-Reply-To: <200707031503.56561.rob@landley.net>
References: <200707031503.56561.rob@landley.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2007 15:03:56 -0400
Rob Landley <rob@landley.net> wrote:

> Just making sure this fix winds up in 2.6.23:

2.6.22?

> http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=4454/1
> 
> It fixes a regression that occurred between 2.6.20 and 2.6.20-rc1.  Without 
> it, qemu-system-arm can't use emulated SCSI drives.  It wasn't in -rc7, and 
> the attached patch Works For Me (tm).

Should have cc'ed Russell?
 
> Signed-off-by: Rob Landley <rob@landley.net>
> 
> Rob
> -- 
> "One of my most productive days was throwing away 1000 lines of code."
>   - Ken Thompson.
> 
> 
> [linux-armfix.patch  text/x-diff (1.1KB)]
> ARM Versatile PCI config reads of one byte width have the lowest two<br />
> bits of the address cleared and result in reading from a wrong place<br />

html gunk in changelog

> in the config space.  This change is to use word size accesses like it is done for halfword reads.
> 
> Byte reads are used for retrieving the IRQ number of a PCI device and the problem was not exposed until 2.6.20 because the value read was discarded in drivers/pci/setup-irq.c (recently fixed).
> 
> Signed-off-by: Andrzej Zaborowski  &lt;(address hidden)&gt;<br />
> Acked-by: Paul Brook  &lt;(address hidden)&gt;

more
 
> Note 2 submitted by Russell King on 02 Jul 2007 12:39:41 (UTC)
> Moved to applied
> Applied to git-curr.
> 
> diff --git a/arch/arm/mach-versatile/pci.c b/arch/arm/mach-versatile/pci.c
> index ba58223..ca82901 100644
> --- a/arch/arm/mach-versatile/pci.c
> +++ b/arch/arm/mach-versatile/pci.c
> @@ -117,7 +117,10 @@ static int versatile_read_config(struct pci_bus *bus, unsigned int devfn, int wh
>  	} else {
>  		switch (size) {
>  		case 1:
> -			v = __raw_readb(addr);
> +			v = __raw_readl(addr);
> +			if (where & 2) v >>= 16;
> +			if (where & 1) v >>= 8;

Someone's enter key broke?

> + 			v &= 0xff;
>  			break;
>  
>  		case 2:
> 
