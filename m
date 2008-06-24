Return-Path: <linux-kernel-owner+w=401wt.eu-S1757526AbYFXV5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526AbYFXV5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 17:57:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755608AbYFXV4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 17:56:32 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:38995 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756559AbYFXV4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 17:56:09 -0400
Date: Wed, 25 Jun 2008 00:54:08 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       rmk@arm.linux.org.uk, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [0/5] move hd.c to drivers/block/
Message-ID: <20080624215407.GB18252@cs181140183.pp.htv.fi>
References: <20080609222155.GA1987@cs181133002.pp.htv.fi> <200806101956.15711.bzolnier@gmail.com> <20080622101752.GG27069@cs181133002.pp.htv.fi> <200806221521.33506.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200806221521.33506.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2008 at 03:21:33PM +0200, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 22 June 2008, Adrian Bunk wrote:
> > On Tue, Jun 10, 2008 at 07:56:15PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > > On Tuesday 10 June 2008, Adrian Bunk wrote:
> > > > This patch limits BLK_DEV_HD_ONLY to the ARM platforms offering 
> > > > IRQ_HARDDISK, fixing the following compile error on others:
> > > > 
> > > > <--  snip  -->
> > > > 
> > > > ...
> > > >   CC      drivers/ide/legacy/hd.o
> > > > ...
> > > > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ide/legacy/hd.c: In function 'hd_times_out':
> > > > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ide/legacy/hd.c:542: error: 'IRQ_HARDDISK' undeclared (first use in this function)
> > > > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ide/legacy/hd.c:542: error: (Each undeclared identifier is reported only once
> > > > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ide/legacy/hd.c:542: error: for each function it appears in.)
> > > > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ide/legacy/hd.c: In function 'do_hd_request':
> > > > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ide/legacy/hd.c:661: error: 'IRQ_HARDDISK' undeclared (first use in this function)
> > > > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ide/legacy/hd.c: In function 'hd_init':
> > > > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ide/legacy/hd.c:765: error: 'IRQ_HARDDISK' undeclared (first use in this function)
> > > > make[3]: *** [drivers/ide/legacy/hd.o] Error 1
> > > > 
> > > > <--  snip  -->
> > > > 
> > > > Reported-by: Adrian Bunk <bunk@kernel.org>
> > > > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > > 
> > > applied, thanks
> > > 
> > > BTW Could you look into converting your "remove BLK_DEV_HD_ONLY" patch
> > > into "move old hd driver to drivers/block/" one because the old hd driver
> > > still has some uses (as noticed by Alan)?
> > 
> > drivers/ide/Makefile says:
> >   # old hd driver must be last
> > 
> > Is this still true?
> 
> Yep.
> 
> > If yes then moving the driver to drivers/block/ requires switching to 
> > late_initcall() since drivers/block/ is linked before drivers/ide/ .
> 
> Care to cook a patch?

Comes as part of this patchset.

This was only compile tested, and I'd really appreciate if anyone 
(Alan?) could test whether it still works.

> Thanks,
> Bart

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

