Return-Path: <linux-kernel-owner+w=401wt.eu-S1762011AbZATQvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762011AbZATQvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 11:51:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758102AbZATQvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 11:51:40 -0500
Received: from mail.gmx.net ([213.165.64.20]:52896 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758174AbZATQvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 11:51:39 -0500
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX1/4aDxC1434yFSHIEZv999AplOs1Xw79Fi7SguISn
	2W7XV+0TAMVUrl
Date: Tue, 20 Jan 2009 17:51:31 +0100
From: Eric Sesterhenn <snakebyte@gmx.de>
To: Chris Mason <chris.mason@oracle.com>
Cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org,
       linux-btrfs@vger.kernel.org
Subject: Re: Warning and BUG with btrfs and corrupted image
Message-ID: <20090120165131.GB21339@alice>
References: <20090113142147.GE16333@alice> <1231857643.29164.28.camel@think.oraclecorp.com> <20090113144307.GF16333@alice> <20090118174035.GG1944@ucw.cz> <20090120063150.GC5854@alice> <1232457065.15042.2.camel@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1232457065.15042.2.camel@think.oraclecorp.com>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.28-rc9-00057-g8960223 (x86_64)
X-Uptime: 17:48:39 up 10:46,  6 users,  load average: 0.42, 0.56, 1.00
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Chris Mason (chris.mason@oracle.com) wrote:
> On Tue, 2009-01-20 at 07:31 +0100, Eric Sesterhenn wrote:
> > Hi,
> > 
> > * Pavel Machek (pavel@suse.cz) wrote:
> >  
> > > Does ext2/3 and vfat survive that kind of attacks? Those are 'in
> > > production' and should survive it...
> > 
> > I regularly (once or twice a week) test 100 corrupted images of 
> > vfat, udf, msdos, swap, iso9660, ext2, ext3, ext4, minix, bfs, befs,
> > hfs, hfs+, qnx4, affs and cramfs on each of my two test machines.
> > 
> > They are all pretty stable, one remaining thing on my list i didnt have
> > time to look into was an issue with fat (msdos) triggering a bug in
> > buffer.c the other is a warning with ext4 in jbd2/checkpoint.c:166
> > 
> > If there is a filesystem you are interested in thats not on the list
> > or that you want me to test a bit more, just let me know
> > 
> 
> squashfs is in the kernel now, that would be good to see as well.  I
> didn't realize you were doing such extensive tests, thanks for doing
> them.

I already tested squashfs. One issue is basically a problem with
the zlib-api for which i just posted a patch here
http://marc.info/?t=123212807300003&r=1&w=2

The other is an overwritten redzone (also reported in this thread
http://marc.info/?l=linux-fsdevel&m=123212794425497&w=2)
Looks like a length parameter is passed to squashfs_read_data
which is bigger than ((msblk->block_size >> msblk->devblksize_log2) +
1), so the kcalloced buffer gets overwritten later. Maybe you want to
take a look at this issue. Those are the only two problems i have
seen so far with ~8000 tested squashfs images.

Greetings, Eric
