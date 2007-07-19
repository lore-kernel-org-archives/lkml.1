Return-Path: <linux-kernel-owner+w=401wt.eu-S1763530AbXGSGsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763530AbXGSGsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 02:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbXGSGsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 02:48:16 -0400
Received: from brick.kernel.dk ([80.160.20.94]:21285 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628AbXGSGsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 02:48:15 -0400
Date: Thu, 19 Jul 2007 08:47:55 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Giacomo Catenazzi <cate@cateee.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: regression: disk error loop (panic?) ide_do_rw_disk-bad:
Message-ID: <20070719064754.GX11657@kernel.dk>
References: <469D1D5E.8050609@cateee.net> <alpine.LFD.0.999.0707181313100.27353@woody.linux-foundation.org> <20070718202740.GN11657@kernel.dk> <200707190053.24578.bzolnier@gmail.com> <alpine.LFD.0.999.0707181618340.27353@woody.linux-foundation.org> <469F0770.2090309@cateee.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469F0770.2090309@cateee.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19 2007, Giacomo Catenazzi wrote:
> Linus Torvalds wrote:
> > 
> > On Thu, 19 Jul 2007, Bartlomiej Zolnierkiewicz wrote:
> >> Thanks for finding and fixing this.
> >>
> >> The latest patch (with additional cleanups) also looks good and should be
> >> safe enough (unchanged behavior for all non-pc requests) to merge it now.
> >>
> >> Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > 
> > Ok, Jens - mind signing off on the patch you sent out, and writing an 
> > explanatory message? Feel free to just crib from my explanation of my 
> > original patch, or whatever.
> > 
> > And it would be beautiful if people who saw the bad behaviour before 
> > reverting the ide.c changes were to go back to that broken state, and try 
> > the patch, and just verify that it acts like it should (ie you should see 
> > just a few error messages, and it shouldn't cause the IDE layer to go 
> > ballistic any more).
> 
> Ok, I tested a5fcaa210626a79465321e344c91a6a7dc3881fa , with
> the Jeans' patch with clean-up (Message-ID:
> <20070718201152.GL11657@kernel.dk>).
> 
> I don't see the error loop. but only 4 errors (2 for each hd, at hddtemp
> start)
> 
> Jul 19 08:22:19 catee kernel: hda: selected mode 0x45
> Jul 19 08:22:23 catee kernel: ide_do_rw_disk - bad command: dev hda:
> type=2, flags=104c8
> Jul 19 08:22:23 catee kernel:
> Jul 19 08:22:23 catee kernel: sector 14657019, nr/cnr 0/0
> Jul 19 08:22:23 catee kernel: bio c21a4780, biotail c21a4780, buffer
> 00000000, data 00000000, len 36
> Jul 19 08:22:23 catee kernel: cdb: 12 00 00 00 24 00 00 00 00 00 00 00
> 00 00 00 00
> Jul 19 08:22:23 catee kernel: ide_do_rw_disk - bad command: dev hdc:
> type=2, flags=104c8
> Jul 19 08:22:23 catee kernel:
> Jul 19 08:22:23 catee kernel: sector 34711027, nr/cnr 0/0
> Jul 19 08:22:23 catee kernel: bio c21a4740, biotail c21a4740, buffer
> 00000000, data 00000000, len 36
> Jul 19 08:22:23 catee kernel: cdb: 12 00 00 00 24 00 00 00 00 00 00 00
> 00 00 00 00
> Jul 19 08:22:23 catee kernel: ide_do_rw_disk - bad command: dev hdc:
> type=2, flags=104c8
> Jul 19 08:22:23 catee kernel:
> Jul 19 08:22:23 catee kernel: sector 7387152, nr/cnr 0/0
> Jul 19 08:22:23 catee kernel: bio c21a4900, biotail c21a4900, buffer
> 00000000, data 00000000, len 36
> Jul 19 08:22:23 catee kernel: cdb: 12 00 00 00 24 00 00 00 00 00 00 00
> 00 00 00 00
> Jul 19 08:22:23 catee kernel: ide_do_rw_disk - bad command: dev hda:
> type=2, flags=104c8
> Jul 19 08:22:23 catee kernel:
> Jul 19 08:22:23 catee kernel: sector 7387152, nr/cnr 0/0
> Jul 19 08:22:23 catee kernel: bio c21a4900, biotail c21a4900, buffer
> 00000000, data 00000000, len 36
> Jul 19 08:22:23 catee kernel: cdb: 12 00 00 00 24 00 00 00 00 00 00 00
> 00 00 00 00

Perfect, thanks a lot for testing!

Tested-By: Giacomo Catenazzi <cate@debian.org>

Linus, if you merge the patch I sent, can you just add this Tested-by?

-- 
Jens Axboe

