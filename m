Return-Path: <linux-kernel-owner+w=401wt.eu-S1030824AbXDVUHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030824AbXDVUHI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 16:07:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030869AbXDVUHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 16:07:08 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:53349 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030824AbXDVUHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 16:07:06 -0400
Date: Sun, 22 Apr 2007 22:08:39 +0200
From: DervishD <lkml@dervishd.net>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Juergen Beisert <juergen127@kreuzholzen.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Wrong free clusters count on FAT32
Message-ID: <20070422200839.GC12748@DervishD>
Mail-Followup-To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Andrew Morton <akpm@linux-foundation.org>,
	Juergen Beisert <juergen127@kreuzholzen.de>,
	linux-kernel@vger.kernel.org
References: <20070419085750.GA2833@DervishD> <200704191352.06456.juergen127@kreuzholzen.de> <20070419141942.GF8287@DervishD> <87d51xtkmp.fsf@duaron.myhome.or.jp> <20070421201841.85717088.akpm@linux-foundation.org> <87wt05vxu7.fsf@duaron.myhome.or.jp> <20070422112658.GB5786@DervishD> <87mz10tyi1.fsf@duaron.myhome.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87mz10tyi1.fsf@duaron.myhome.or.jp>
User-Agent: Mutt/1.4.2.2i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Ogawa :)

 * OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> dixit:
> DervishD <lkml@dervishd.net> writes:
> > The problem is that if a program writes a file onto the filesystem
> > without using statfs first to check for free space, the free_clusters
> > entry won't have the real value and the driver may report "disk full" (I
> > haven't read the code for the vfat driver, sorry, so I'm not sure about
> > this) when really there are plenty of clusters to write the new file.
> 
> No need to worry about it. If we ignored the ->free_clusters in
> FSINFO, the fat drivers counts the current free clusters by scaning
> FAT entries if needed.

    Cool! :)

> > Probably it's stupid to update the free clusters count at mount time
> > (sorry if so...) but it looks like a good idea to me. And of course, I
> > don't mean to update the value _on disk_, but the kernel's idea of free
> > clusters (so even FAT filesystems mounted R/O will report correct
> > values).
> 
> It would add the limitation to following simple usage,
> 
> 	# mount -t vfat /dev/sda1 /mnt
>         # cp -a * /mnt
>         # umount
> 
> if /dev/sda1 was the large and slow device, "mount" will need several
> minutes to counts free clusters. I think the user will be hard to
> accept the several minutes at "mount".


    I can carry some tests, but if Windows does that tasks lightning
fast, Linux surely does it faster ;) I don't think, anyway, that having
a huge USB disk is a common practice when using "modest" machines.

    If you want, I can perform a couple of tests. I have a 80GB disk
that I can connect using an USB adapter and my machine is AMD Athlon XP
1900+ with 1GB of RAM, which looks pretty slow nowadays O:)

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
