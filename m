Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbYCaFxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbYCaFxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 01:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbYCaFxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 01:53:38 -0400
Received: from nelson.telenet-ops.be ([195.130.133.66]:34237 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbYCaFxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 01:53:37 -0400
Date: Mon, 31 Mar 2008 07:53:34 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: linux-ide@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Michael Schmitz <schmitz@debian.org>
Subject: Re: [PATCH 5/5] falconide/q40ide: add ->atapi_*put_bytes and
 ->ata_*put_data methods
In-Reply-To: <200803302134.42569.bzolnier@gmail.com>
Message-ID: <Pine.LNX.4.64.0803310750230.6871@anakin>
References: <200803301714.04527.bzolnier@gmail.com> <Pine.LNX.4.64.0803302012560.16372@anakin>
 <200803302134.42569.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Mar 2008, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 30 March 2008, Geert Uytterhoeven wrote:
> > On Sun, 30 Mar 2008, Bartlomiej Zolnierkiewicz wrote:
> > > * Add ->atapi_{in,out}put_bytes and ->ata_{in,out}put_data methods to
> > >   falconide and q40ide host drivers (->ata_* methods are implemented on
> > >   top of ->atapi_* methods so they also do byte-swapping now).
> > > 
> > > * Cleanup atapi_{in,out}put_bytes().
> > 
> > Thanks!
> > 
> > One remaining issue (for which the fix has never been submitted upstream so
> > far) with Atari and Q40 is that due to the byteswapped interface, the driveid
> > is also byteswapped, so it has to be unswapped again in ide_fix_driveid().
> 
> My patch causes unswapping for _all_ data coming from the device so I wonder
> whether the ide_fix_driveid() fix is still needed?

I'll give it a try on Aranym...

> [ I now recall some discussion that we shouldn't un-swap fs requests because
>   of how the things were done in the past fs itself is stored byte-swapped on
>   the disk - if this is the case I will recast the patch to pass rq to
>   ->ata_*put_data in ide_pio_sector() and check rq->cmd_type == REQ_TYPE_FS
>   in falconide/q40ide_*put_data() to decide whether to unswap data or not ]

Yes, the data on the disk is stored byte-swapped.
So it's only the drive ID and packet commands that should be swapped.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
