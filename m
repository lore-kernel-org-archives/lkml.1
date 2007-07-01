Return-Path: <linux-kernel-owner+w=401wt.eu-S1756352AbXGAHRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbXGAHRV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 03:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbXGAHRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 03:17:14 -0400
Received: from smtp04.mtu.ru ([62.5.255.51]:49826 "EHLO smtp04.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867AbXGAHRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 03:17:13 -0400
X-Greylist: delayed 535 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Jul 2007 03:17:13 EDT
From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
To: Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org,
       michal.k.k.piotrowski@gmail.com
Date: Sun, 01 Jul 2007 11:08:16 +0400
References: <A6D19A13FE030A409EC4362C172E091F016F51AF@eseldmw101.eemea.ericsson.se> <200706301847.33834.arvidjaar@mail.ru> <200707010113.25853.arvidjaar@mail.ru> <200706302130.49440.bjorn.helgaas@hp.com>
User-Agent: KNode/0.10.5
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <20070701070816.BB294782035@smtp04.mtu.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:

[...]
> 
> I suspect that things will mostly work if you load the drivers in
> the (smsc-ircc2, wlags49_h1_cs) order.

yes

> Then smsc-ircc2 has a chance 
> to reserve the resources before yenta and wlags49 get involved.  But
> of course, we can't rely on that workaround.
> 

yes :)

> I think there's lots of work needed here -- make PNP reserve resources,
> add smarter PNP quirk infrastructure so we can do things at _SRS-time,
> add real Portege BIOS workaround, etc.  Way more than we can do for
> 2.6.22.
> 

yes :)

> What do you think we need to get 2.6.22 out?  I was thinking of a
> stop-gap patch like the one below. 

I agree. I was about to suggest the same the very first time I have seen
this issue.

> I'm between trips and can't 
> really test it.  In my one quick boot, it did find the IR device,
> but irdadump didn't seem to do anything.
> 

I confirm that loading smsc-icc2 with nopnp (with your other two patches
applied) works, finds SIR/FIR and irdadump shows data flowing. 

-andrey

> 
> 
> [patch] smsc-ircc2: bypass PNP detection until we get the quirks worked
> [out
> 
> Don't use PNP detection by default yet.  We have some PNP and BIOS issues
> to work out first.
> 
> Sample problem on a Toshiba Portege 4000: the SMCf010 device is handed off
> disabled.  We assign I/O ports originally assigned to the SMCf010 to a
> PCMCIA device instead.  We enable the SMCf010, configuring it to use
> disjoint ports, but _SRS doesn't work correctly, so the device doesn't
> work.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> 
> Index: w/drivers/net/irda/smsc-ircc2.c
> ===================================================================
> --- w.orig/drivers/net/irda/smsc-ircc2.c      2007-06-30 21:00:06.000000000
> -0600
> +++ w/drivers/net/irda/smsc-ircc2.c   2007-06-30 21:00:08.000000000 -0600
> @@ -79,7 +79,7 @@
>  MODULE_DESCRIPTION("SMC IrCC SIR/FIR controller driver");
>  MODULE_LICENSE("GPL");
>  
> -static int smsc_nopnp;
> +static int smsc_nopnp = 1;
>  module_param_named(nopnp, smsc_nopnp, bool, 0);
>  MODULE_PARM_DESC(nopnp, "Do not use PNP to detect controller settings");


