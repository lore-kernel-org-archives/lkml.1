Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751003Ab0BQPfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 10:35:22 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50962 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750738Ab0BQPfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 10:35:20 -0500
Date: Wed, 17 Feb 2010 15:34:02 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Alan Cox <alan@linux.intel.com>, jeff@garzik.org.com,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [RFC 3/4] libata: Remove excess command issue delays
Message-ID: <20100217153402.44346f11@lxorguk.ukuu.org.uk>
In-Reply-To: <4B7BF8DC.7080403@ru.mvista.com>
References: <20100217130847.16338.55586.stgit@localhost.localdomain>
	<20100217131145.16338.70473.stgit@localhost.localdomain>
	<4B7BF8DC.7080403@ru.mvista.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>    Wouldn't it make sense then to handle the "insane" hardware as an 
> exception, not vice versa?

It depends if you want to "fail safe". I'd personally just remove the
pause. We know from over ten years of drivers/ide that it's totally
unneccessary for almost any controller but I am submitting patches based
upon what Jeff seems ot want...

> > As a side effect it also means that those devices using PIO don't end up
> > generating ATA bus cycles in strange places which confuses some hardware.
> >   
> 
>    I thought that's mostly a problem with DMA commands...
> 
> > Saves us about 1mS on a dumb controller,
> 
>    1 ms per command?! Or per what?

per command. I've been using a plain and simple PCMCIA controller to make
the profiles nice and clear - the sff_pause does a read which crosses to
the device and back - that is slow. On some of the SFF style SATA
controllers its very fast so is presumably all cached as you'd expect.

Next time someone claims libata command issue is slower because of the
SCSI layer they should take a second look 8)

> > +	.sff_exec_command	= ata_sff_exec_command_nopost,
> > +	.sff_data_xfer	= 	winbond_data_xfer,
> > +	.cable_detect	= 	ata_cable_40wire,
> > +	.set_piomode	= 	winbond_set_piomode,
> >   
> 
>    What's up with the alignment here, why it's different from the rest 
> of drivers?
>
Just didn't fix up the formatting of that one when I was doing them all.

