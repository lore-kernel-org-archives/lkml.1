Return-Path: <linux-kernel-owner+w=401wt.eu-S934813AbYBBVIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934813AbYBBVIq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 16:08:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762404AbYBBVIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 16:08:36 -0500
Received: from ns.gsystems.sk ([62.176.172.50]:41449 "EHLO www.gsystems.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759704AbYBBVIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 16:08:35 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] [RFC] 3c509: convert to isa_driver and pnp_driver v2
Date: Sat, 2 Feb 2008 22:08:34 +0100
User-Agent: KMail/1.9.7
Cc: netdev@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200801312012.43447.linux@rainbow-software.org> <200802021925.36552.linux@rainbow-software.org> <47A4D791.3050700@garzik.org>
In-Reply-To: <47A4D791.3050700@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802022208.36219.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 February 2008 21:50:25 Jeff Garzik wrote:
> Ondrej Zary wrote:
> > Hello,
> > this is second version of the patch. Autoloading using udev works fine
> > with PnP card. Hibernation now works both in PnP and ISA modes. The I/O
> > address used for non-pnp ISA card detection is now not released as it's
> > needed to wake up the card.
> >
> > Manual irq and transceiver settings aren't implemented yet. Operation
> > with multiple cards is not tested - I'll try 3 cards in both PnP and ISA
> > modes. There is some code that is the same in each of the 4 probe
> > functions (isa, pnp, eisa and mca), which should be probably separated
> > into a function.
> >
> > I have no EISA or MCA machine so I hope that I didn't break them.
>
> Looks pretty good at first glance...
>
> I'll throw it in my queue.  Want to add a signed-off-by:  ?
>
> 	Jeff

I think that the ISA resume will not work with more than 1 card. I'll fix that 
first and test with 3 cards. So the next version can include signed-off-by.

I also wonder about the old el3_cleanup_module() function - it called 
el3_common_remove for all cards. With isa_driver and pnp_driver, it oopsed - 
I think that's because the remove() functions were called by driver core on 
isa_unregister_driver (and pnp_unregister_driver) - but what about MCA and 
EISA?

-- 
Ondrej Zary
