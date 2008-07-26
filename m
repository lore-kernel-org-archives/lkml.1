Return-Path: <linux-kernel-owner+w=401wt.eu-S1756463AbYGZP2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463AbYGZP2n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 11:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbYGZP2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 11:28:34 -0400
Received: from monty.telenet-ops.be ([195.130.132.56]:45120 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbYGZP2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 11:28:33 -0400
Date: Sat, 26 Jul 2008 17:28:26 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Petr Stehlik <pstehlik@sophics.cz>
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       =?UTF-8?B?77+9?= <rene.scharfe@lsrfire.ath.cx>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH] msdos fs: remove unsettable atari option
In-Reply-To: <87od6jop4j.fsf@duaron.myhome.or.jp>
Message-ID: <Pine.LNX.4.64.0807261724400.16910@anakin>
References: <1211717062.5782.16.camel@ubuntu> <87ve12s849.fsf@duaron.myhome.or.jp>
 <20080601221035.GA9107@nineveh.local> <87zlq4rd30.fsf@duaron.myhome.or.jp>
 <Pine.LNX.4.64.0806020930170.7351@anakin> <4843D179.7070809@sophics.cz>
 <87od6jop4j.fsf@duaron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2008, OGAWA Hirofumi wrote:
> Petr Stehlik <pstehlik@sophics.cz> writes:
> > Geert Uytterhoeven wrote:
> >>>> Geert Uytterhoeven has a patch in his POSTPONED queue that is supposed
> >>>> to fix Atari FAT.  I can't speak to whether it works or why it's
> >>>> postponed, but it seems to compile.
> >>> I see. Although I don't know the patch, I'd like to add this part to
> >>> Geert's patch if possible. And when the patch can be posted, we can
> >>> re-add this part again.
> >>>
> >>> Geert, what do you think?
> >> 
> >> It's in POSTPONED state because nobody speaks up for/against it.
> >> Personally, I don't know how much it is (still) needed...
> >> But a few years ago somebody contacted me that he used it succesfully
> >> on PA-RISC and i386 ;-)
> >> 
> >> BTW, the patch is
> >> http://linux-m68k-cvs.ubb.ca/~geert/linux-m68k-patches-2.6/POSTPONED/134-atari-fat.diff
> >> 
> >> Atari people, I think now is the time to let it live or die...
> >
> > The patch looks good, how can I let it live?
> 
> Could you test whether it works well? If it works fine, I'll merge and
> clean it up. If it doesn't work, please fix it.

Petr, as there has been no further response anymore, it went into Linus' tree:

    commit 7557bc66be629d19a402e752673708bfbb8b5e86
    Author: Rene Scharfe <rene.scharfe@lsrfire.ath.cx>
    Date:   Fri Jul 25 01:46:45 2008 -0700

	msdos fs: remove unsettable atari option
	
	It has been impossible to set the option 'atari' of the MSDOS filesystem
	for several years.  Since nobody seems to have missed it, let's remove its
	remains.

I'm inclined to drop it, if nobody seems to really care...

> BTW,
> 
> +		if (sbi->fat_bits != 32 && total_clusters+2 > sbi->
> +			fat_length*SECTOR_SIZE*8/sbi->fat_bits)
> +			sbi->fat_bits = 12;
> 
> SECTOR_SIZE should be sb->s_blocksize? Or Atari doesn't support the
> sector size other than 512 bytes?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
