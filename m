Return-Path: <linux-kernel-owner+w=401wt.eu-S1756925AbZJ3AbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925AbZJ3AbB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 20:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756869AbZJ3Aa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 20:30:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56206 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753721AbZJ3Aaz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 20:30:55 -0400
Date: Fri, 30 Oct 2009 00:32:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH] ide: update Kconfig text to mark as deprecated
Message-ID: <20091030003232.6db3f8b8@lxorguk.ukuu.org.uk>
In-Reply-To: <51f3faa70910291719kecb5edcp3b8812981b69acb1@mail.gmail.com>
References: <4AE64FCC.4030102@gmail.com>
	<20091029.031344.102288703.davem@davemloft.net>
	<51f3faa70910291719kecb5edcp3b8812981b69acb1@mail.gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 1) Add a way for the ATA layer to create compat device
> >   nodes so that people can change over to use the ATA
> >   layer for their devices without any fstab et al. changes.
> >
> >   These compat device nodes do not have to be so featureful
> >   that they support hdparm or smartd or anything like that,
> >   but they need to work well enough to mount filesystems, and
> >   mount swap partitions, and interact with device management
> >   systems like udev as if they were real IDE devices.
> 
> I'm not really sure if this is worthwhile.. is having to update fstab
> really so onerous as to be worth the trouble? You'd presumably have to
> enable the creation of the compat device nodes somehow (enabling them
> by default seems like it would cause a lot of confusion), so it's not
> like you wouldn't need any config changes that way, either.

Not worth the pain or the code complexity. Almost no system today hard
codes the identifiers. For those that do you can use a udev rule to make
symlinks.

> > 2) The two or so remaining devices which have IDE support but
> >   don't have an ATA layer driver need porting.
> 
> Has anyone gone through and made a list of these? pmac seems like the
> most obvious one..

Pmac is probably the only one that matters. It basically needs an
alternate set of DMA sg drivers for the MAC DMA, the rest is very
"normal". The other is SGIIOC4 which I doubt anyone cares about.

There are a few other things that I think could do with addressing
particularly better IRQ unmasking for both polled PIO (embedded devices)
and interrupt driven PIO on relatively sane hardware would be helpful
particularly in the embedded world.

IDE will self correct in time anyway - new hardware doesn't work with it,
newer embedded devices are also moving away from compact flash, so it'll
die of its own accord.

As such while things like pmac support in libata will be nice I don't
think there is any need to go around obsoleting it or pressuring people
to move stacks.

Alan
