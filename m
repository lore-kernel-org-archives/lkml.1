Return-Path: <linux-kernel-owner+w=401wt.eu-S1761878AbXKIE6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761878AbXKIE6D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 23:58:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758987AbXKIE5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 23:57:51 -0500
Received: from havoc.gtf.org ([69.61.125.42]:46664 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762821AbXKIE5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 23:57:50 -0500
Date: Thu, 8 Nov 2007 23:57:48 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Mark Lord <liml@rtr.ca>
Cc: Riki Oktarianto <rkoktarianto@gmail.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-ide@vger.kernel.org
Subject: Re: [PATCH] Add quirk to set AHCI mode on ICH boards
Message-ID: <20071109045748.GD25581@havoc.gtf.org>
References: <20071109020235.GA2031@ceren> <20071109023129.GA25581@havoc.gtf.org> <4733D421.7000505@rtr.ca> <20071109034622.GB25581@havoc.gtf.org> <4733E5A6.30808@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4733E5A6.30808@rtr.ca>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2007 at 11:44:22PM -0500, Mark Lord wrote:
> Jeff Garzik wrote:
> >On Thu, Nov 08, 2007 at 10:29:37PM -0500, Mark Lord wrote:
> >>And I might even privately patch my own kernels to map the ACHI BAR
> >>in the cases where the BIOS didn't...
> >
> >The inability to do this in the general case is the main reason why
> >AHCI was not unconditionally enabled, even in IDE mode, when it was
> >originally added...  :/
> ..
> 
> Yeah, that one's always puzzled me.
> It's just software,  so why don't we do it?  In the PCI layer, that is?

Ah, but it's not just software:  when trying to find bus address
space for the BAR, we don't know if we are stomping on magic hardware
resources the BIOS has conveniently failed to tell us about.

So while in all likelihood you will have no problem finding a
suitable bus address to use, as a generalized rule it is a far more
difficult proposition.

Mind you, I would /love/ to be proven wrong here.  In additional to AHCI
BAR, modern ata_piix includes SATA PHY registers that we could make use
of, but cannot...

	Jeff


