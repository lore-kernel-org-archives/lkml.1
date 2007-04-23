Return-Path: <linux-kernel-owner+w=401wt.eu-S1161221AbXDWGRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161221AbXDWGRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 02:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161216AbXDWGRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 02:17:39 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:63271 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161221AbXDWGRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 02:17:38 -0400
Date: Mon, 23 Apr 2007 08:19:27 +0200
From: DervishD <lkml@dervishd.net>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Juergen Beisert <juergen127@kreuzholzen.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Wrong free clusters count on FAT32
Message-ID: <20070423061927.GA2428@DervishD>
Mail-Followup-To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Andrew Morton <akpm@linux-foundation.org>,
	Juergen Beisert <juergen127@kreuzholzen.de>,
	linux-kernel@vger.kernel.org
References: <20070419085750.GA2833@DervishD> <200704191352.06456.juergen127@kreuzholzen.de> <20070419141942.GF8287@DervishD> <87d51xtkmp.fsf@duaron.myhome.or.jp> <20070421201841.85717088.akpm@linux-foundation.org> <87wt05vxu7.fsf@duaron.myhome.or.jp> <20070422112658.GB5786@DervishD> <87mz10tyi1.fsf@duaron.myhome.or.jp> <20070422200839.GC12748@DervishD> <87ps5vq0yw.fsf@duaron.myhome.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ps5vq0yw.fsf@duaron.myhome.or.jp>
User-Agent: Mutt/1.4.2.2i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Ogawa :)

 * OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> dixit:
> DervishD <lkml@dervishd.net> writes:
> >> It would add the limitation to following simple usage,
> >> 
> >> 	# mount -t vfat /dev/sda1 /mnt
> >>         # cp -a * /mnt
> >>         # umount
> >> 
> >> if /dev/sda1 was the large and slow device, "mount" will need several
> >> minutes to counts free clusters. I think the user will be hard to
> >> accept the several minutes at "mount".
> >
> >     I can carry some tests, but if Windows does that tasks lightning
> > fast, Linux surely does it faster ;) I don't think, anyway, that having
> > a huge USB disk is a common practice when using "modest" machines.
> >
> >     If you want, I can perform a couple of tests. I have a 80GB disk
> > that I can connect using an USB adapter and my machine is AMD Athlon XP
> > 1900+ with 1GB of RAM, which looks pretty slow nowadays O:)
> 
> Yes, I think it's not common practice too. But I don't see why do you
> want to scanning at the mount.

    Just because I was thinking that, otherwise, the scanning would need
to be done at each statfs call, but I was wrong: once the scanning is
done and the count is right, it is written at free_clusters and used
afterwards.

    I thought the mount was the best point in time for doing this.

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
