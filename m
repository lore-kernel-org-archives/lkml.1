Return-Path: <linux-kernel-owner+w=401wt.eu-S1758370AbYHCQ5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370AbYHCQ5P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 12:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756682AbYHCQ47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 12:56:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42591 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756590AbYHCQ46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 12:56:58 -0400
Date: Sun, 3 Aug 2008 17:39:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: Re: Kernel Summit request for Discussion of future of ATA (libata)
 and IDE
Message-ID: <20080803173941.314edf33@lxorguk.ukuu.org.uk>
In-Reply-To: <1217779055.4179.10.camel@localhost.localdomain>
References: <1217779055.4179.10.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 03 Aug 2008 10:57:35 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> Right at the moment, we have two separate subsystems for running IDE
> type devices:  driver/ide and drivers/ata.  The claim I've seen is that
> drivers/ata can do everything drivers/ide can do plus it does sata.  I
> also note that no major distribution seems to enable anything in
> drivers/ide anymore, so given this is it time to deprecate drivers/ide?
> 
> A counter argument to the above is that not all drivers (particularly
> the older ones where hw is scarce) are converted to drivers/ata, so

That statement would be false. In fact for old and obscure hw the libata
coverage is probably better, not that this in fact is the slighest bit
relevant to the real world!

The current situation is something like this

- For PC class hardware libata covers everything in old IDE and a lot
more.
- For the older Mac hardware libata does not have pre PCI Macintosh
support although it is in progress
- For certain embedded PPC boards there are some things to sort out with
IRQ routing on non standards sane configurations using pata_ali in
particular.

There is a trend in new hardware to interfaces that simply won't fit old
IDE so that process of libata only drivers is likely to continue.

> drivers/ide seems to be needed for some legacy systems (in which case it
> can be deprecated but not removed).  I've also noted that some embedded
> distributions seem to be using drivers/ide, but I'm not really sure
> whether this is inertia or some overriding need.

Actually what a material number of embedded systems need is a single
dumb-as-a-rock CF only PIO driver which doesn't suck in large chunks of
midlayer code. I'm just not sure that trend will continue as CF is giving
way to other smaller media.

> The proposal is to discuss the future of these two subsystems and arrive
> at a consensus what's happening to each going forwards.

Won't be at KS and I suspect that is true of most of the folks hacking on
both sets so the right place for discussion would be the net. Right now
the PPC bits need fixing, and the lack of libata Macio support for the
moment makes the debate premature.

Alan
