Return-Path: <linux-kernel-owner+w=401wt.eu-S1755801AbYA0L6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801AbYA0L6p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 06:58:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbYA0L6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 06:58:38 -0500
Received: from yergi.telenet-ops.be ([195.130.132.36]:40900 "EHLO
	yergi.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbYA0L6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 06:58:37 -0500
Date: Sun, 27 Jan 2008 12:57:50 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: monstr@monstr.eu
cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: Re: [PATCH 17/52] [microblaze] checksum support
In-Reply-To: <4b7d90fc1b9bcb3c0b1b308c6460390f7bdf3824.1201107832.git.monstr@monstr.eu>
Message-ID: <Pine.LNX.4.64.0801271256300.6736@anakin>
References: <1201187014-3979-1-git-send-email-monstr@monstr.eu>
 <dbff6b883dbcb108db53e5093994c473946e1240.1201107832.git.monstr@monstr.eu>
 <ac0947adfe718fcb4c0dc5f6f7ab64f8155541fb.1201107832.git.monstr@monstr.eu>
 <873c2bf1f67696aa11014886470f6ba46f04e8d2.1201107832.git.monstr@monstr.eu>
 <516d173b1789ea533431e8f5ad05751c6a353c88.1201107832.git.monstr@monstr.eu>
 <068508828aac6298b4cc65b0cd7b2737a61c466c.1201107832.git.monstr@monstr.eu>
 <010fc233f82a8f7a591c9f8315ae03f9951139aa.1201107832.git.monstr@monstr.eu>
 <68faaf69ea03196d4a56a263707355e7e7eb5c6a.1201107832.git.monstr@monstr.eu>
 <4b7d90fc1b9bcb3c0b1b308c6460390f7bdf3824.1201107832.git.monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jan 2008, monstr@monstr.eu wrote:
> From: Michal Simek <monstr@monstr.eu>
> 
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> ---
>  arch/microblaze/lib/checksum.c    |  159 +++++++++++++++++++++++++++++++++++++
>  include/asm-microblaze/checksum.h |  101 +++++++++++++++++++++++
>  2 files changed, 260 insertions(+), 0 deletions(-)
>  create mode 100644 arch/microblaze/lib/checksum.c
>  create mode 100644 include/asm-microblaze/checksum.h
> 
> diff --git a/arch/microblaze/lib/checksum.c b/arch/microblaze/lib/checksum.c
> new file mode 100644
> index 0000000..21a6830
> --- /dev/null
> +++ b/arch/microblaze/lib/checksum.c
> @@ -0,0 +1,159 @@
> +/*
> + * INET		An implementation of the TCP/IP protocol suite for the LINUX
> + *		operating system.  INET is implemented using the  BSD Socket
> + *		interface as the means of communication with the user level.
> + *
> + *		IP/TCP/UDP checksumming routines
> + *
> + * Authors:	Jorge Cwik, <jorge@laser.satlink.net>
> + *		Arnt Gulbrandsen, <agulbra@nvg.unit.no>
> + *		Tom May, <ftom@netcom.com>
> + *		Andreas Schwab, <schwab@issan.informatik.uni-dortmund.de>
> + *		Lots of code moved from tcp.c and ip.c; see those files
> + *		for more names.
> + *
> + * 03/02/96	Jes Sorensen, Andreas Schwab, Roman Hodek:
> + *		Fixed some nasty bugs, causing some horrible crashes.
> + *		A: At some points, the sum (%0) was used as
> + *		length-counter instead of the length counter
> + *		(%1). Thanks to Roman Hodek for pointing this out.
> + *		B: GCC seems to mess up if one uses too many
> + *		data-registers to hold input values and one tries to
> + *		specify d0 and d1 as scratch registers. Letting gcc choose these
> + *      registers itself solves the problem.
> + *
> + *		This program is free software; you can redistribute it and/or
> + *		modify it under the terms of the GNU General Public License
> + *		as published by the Free Software Foundation; either version
> + *		2 of the License, or (at your option) any later version.
> + */
> +
> +/* Revised by Kenneth Albanowski for m68knommu. Basic problem: unaligned access
> + kills, so most of the assembly has to go. */

So basically this is a copy of arch/m68knommu/lib/checksum.c, with some
checkpatch.pl fixes but without the sparse fixes?
Furthermore, it's just plain C, so maybe we need a common one that can
be shared by multiple archs?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
