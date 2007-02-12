Return-Path: <linux-kernel-owner+w=401wt.eu-S964884AbXBLQhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964884AbXBLQhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 11:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964959AbXBLQhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 11:37:19 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60874 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S964884AbXBLQhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:37:18 -0500
Date: Mon, 12 Feb 2007 16:51:05 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Florian Schmidt <mista.tapas@gmx.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20 "IRQ handler type mismatch for IRQ 4"
Message-ID: <20070212165105.2d97ccce@localhost.localdomain>
In-Reply-To: <200702121434.38403.mista.tapas@gmx.net>
References: <200702102140.55155.mista.tapas@gmx.net>
	<20070212131838.04a2abcc@localhost.localdomain>
	<200702121434.38403.mista.tapas@gmx.net>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > This is all scary and generally not needed spew but handy for debug.
> >
> > Looks like a PCMCIA layer bug. It should be respecting IRQ assignment
> > (not just allocation) by other resource configuration layers.
> 
> Ah thanks for taking a look. I was slowly getting the impression from older 
> lkml posts, that this isn't really what stopped my wifi from functioning. It 
> seems there are other reasons and i just stumbled across this harmless 
> message in dmesg.. Thanks for clearing it up :)

The problem is we don't know what the PNP layer does about the routing
here. It could be breaking the wifi but it's only a possible cause. It
still shouldn't be using IRQ 4 after pnp had it.

I'm also a little suprised to see both pnp and ACPI triggering. I thought
it wasn't permitted to use both at once but that really wants asking of
an ACPI guru like Len.

Does it work if you compile out PNP bios support ?
