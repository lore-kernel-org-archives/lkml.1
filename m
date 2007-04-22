Return-Path: <linux-kernel-owner+w=401wt.eu-S1030405AbXDVLzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030405AbXDVLzN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 07:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030480AbXDVLzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 07:55:13 -0400
Received: from mail.parknet.jp ([210.171.160.80]:3936 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030405AbXDVLzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 07:55:11 -0400
X-AuthUser: hirofumi@parknet.jp
To: DervishD <lkml@dervishd.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Juergen Beisert <juergen127@kreuzholzen.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Wrong free clusters count on FAT32
References: <20070419085750.GA2833@DervishD>
	<200704191352.06456.juergen127@kreuzholzen.de>
	<20070419141942.GF8287@DervishD> <87d51xtkmp.fsf@duaron.myhome.or.jp>
	<20070421201841.85717088.akpm@linux-foundation.org>
	<87wt05vxu7.fsf@duaron.myhome.or.jp> <20070422112658.GB5786@DervishD>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Sun, 22 Apr 2007 20:55:02 +0900
In-Reply-To: <20070422112658.GB5786@DervishD> (DervishD's message of "Sun\, 22 Apr 2007 13\:26\:58 +0200")
Message-ID: <87mz10tyi1.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.98 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

DervishD <lkml@dervishd.net> writes:

>     The problem is that if a program writes a file onto the filesystem
> without using statfs first to check for free space, the free_clusters
> entry won't have the real value and the driver may report "disk full" (I
> haven't read the code for the vfat driver, sorry, so I'm not sure about
> this) when really there are plenty of clusters to write the new file.

No need to worry about it. If we ignored the ->free_clusters in
FSINFO, the fat drivers counts the current free clusters by scaning
FAT entries if needed.

>     Probably it's stupid to update the free clusters count at mount time
> (sorry if so...) but it looks like a good idea to me. And of course, I
> don't mean to update the value _on disk_, but the kernel's idea of free
> clusters (so even FAT filesystems mounted R/O will report correct
> values).

It would add the limitation to following simple usage,

	# mount -t vfat /dev/sda1 /mnt
        # cp -a * /mnt
        # umount

if /dev/sda1 was the large and slow device, "mount" will need several
minutes to counts free clusters. I think the user will be hard to
accept the several minutes at "mount".

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
