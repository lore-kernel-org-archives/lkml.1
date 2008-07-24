Return-Path: <linux-kernel-owner+w=401wt.eu-S1754538AbYGXUcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbYGXUcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 16:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbYGXUcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 16:32:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33981 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751552AbYGXUcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 16:32:08 -0400
Date: Thu, 24 Jul 2008 21:14:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: jeff@garzik.org, greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH PROPOSAL] libata/pci: Move D3 hack handling from libata
 into PCI
Message-ID: <20080724211426.26bb15fe@lxorguk.ukuu.org.uk>
In-Reply-To: <200807241311.24384.jbarnes@virtuousgeek.org>
References: <20080724171838.591f6a31@lxorguk.ukuu.org.uk>
	<200807241311.24384.jbarnes@virtuousgeek.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2008 13:11:24 -0700
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Thursday, July 24, 2008 9:18 am Alan Cox wrote:
> > Libata has some hacks to deal with certain controllers going silly in D3
> > state. The right way to handle this is to keep a PCI device flag for such
> > devices. That can then be generalised for no ATA devices with power
> > problems.
> >
> > Signed-off-by: Alan Cox <alan@redhat.com>
> 
> Looks pretty reasonable to me; do you want me to take the drivers/ata bits 
> along with the PCI stuff?
> 
> Btw, what happens to these devices in D3hot?  Do they behave like they're in 
> D3cold or something and require a reset?  Or do they otherwise kill the bus 
> somehow?

They lose some of their configuration bits in a manner we can't restore.
The end effect of that is that if we disable/re-enable them they can't be
put back into proper DMA mode.

Windows it seems doesn't do this to these devices and the BIOS re-inits
the legacy ATA controllers during boot up which makes suspend/resume work.

Alan
