Return-Path: <linux-kernel-owner+w=401wt.eu-S1760252AbZAUJhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760252AbZAUJhR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 04:37:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756947AbZAUJgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 04:36:50 -0500
Received: from mail.gmx.net ([213.165.64.20]:39315 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756506AbZAUJgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 04:36:48 -0500
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX19h9t1oMIph/nSFNIZMFrfhgmPrXjzSilkuSfAwYa
	nKUscHN6xZGUAb
Date: Wed, 21 Jan 2009 10:36:44 +0100
From: Eric Sesterhenn <snakebyte@gmx.de>
To: Pavel Machek <pavel@suse.cz>
Cc: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-btrfs@vger.kernel.org
Subject: Re: Warning and BUG with btrfs and corrupted image
Message-ID: <20090121093644.GA2466@alice>
References: <20090113142147.GE16333@alice> <1231857643.29164.28.camel@think.oraclecorp.com> <20090113144307.GF16333@alice> <20090118174035.GG1944@ucw.cz> <20090120063150.GC5854@alice> <20090120101119.GB10158@disturbed> <20090120101503.GC17377@alice> <20090120125944.GC10158@disturbed> <20090120173455.GC21339@alice> <20090120221808.GA2320@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090120221808.GA2320@elf.ucw.cz>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.28-rc9-00057-g8960223 (x86_64)
X-Uptime: 10:32:25 up  1:31,  5 users,  load average: 2.63, 2.71, 2.73
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek (pavel@suse.cz) wrote:
> On Tue 2009-01-20 18:34:55, Eric Sesterhenn wrote:
> > * Dave Chinner (david@fromorbit.com) wrote:
> > > On Tue, Jan 20, 2009 at 11:15:03AM +0100, Eric Sesterhenn wrote:
> > > > * Dave Chinner (david@fromorbit.com) wrote:
> > > > > On Tue, Jan 20, 2009 at 07:31:50AM +0100, Eric Sesterhenn wrote:
> > > > > > * Pavel Machek (pavel@suse.cz) wrote:
> > > > > > > Does ext2/3 and vfat survive that kind of attacks? Those are 'in
> > > > > > > production' and should survive it...
> > > > > > 
> > > > > > I regularly (once or twice a week) test 100 corrupted images of 
> > > > > > vfat, udf, msdos, swap, iso9660, ext2, ext3, ext4, minix, bfs, befs,
> > > > > > hfs, hfs+, qnx4, affs and cramfs on each of my two test machines.
> > > > > 
> > > > > Any reason you are not testing XFS in that set?
> > > > 
> > > > So far the responses from xfs folks have been disappointing, if you are
> > > > interested in bugreports i can send you some.
> > > 
> > > Sure I am.  It would be good if you could start testing XFS along
> > > with all the other filesystems and report anything you find.
> > 
> > Ok, i wont report stuff with only xfs-internal backtraces from
> > xfs_error_report() or are they interesting to you?
> > 
> > This occurs during mount, box is dead afterwards
> > Image can be found here :
> > http://www.cccmz.de/~snakebyte/xfs.11.img.bz2
> > I see this every ~10 images, which makes further testing hard :)
> 
> BTW have you considered trying to run fsck.* on such images? I had lot
> of fun with e2fsck/e3fsck/fsck.vfat.

Not yet, but if one assumes the people writing the userspace code are
the same writing the kernel code, and probably make the same errors in
both versions this might be interesting.

For userspace a more advanced approach than random bit flipping is
possible with tools like bunny (http://code.google.com/p/bunny-the-fuzzer/)
Bunny instrumentates the code, and then tries to change the input file
based on the feedback it gets from the instrumentation. I fired up
an instance testing ext2, lets see if it finishes until evening :-)

Maybe someone is brave enough to test this approach with user mode
linux... :)

Greetings, Eric
