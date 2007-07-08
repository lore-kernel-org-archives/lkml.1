Return-Path: <linux-kernel-owner+w=401wt.eu-S1757162AbXGHUPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162AbXGHUPZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 16:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755455AbXGHUPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 16:15:12 -0400
Received: from [84.243.56.243] ([84.243.56.243]:51293 "EHLO aurora.bayour.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755206AbXGHUPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 16:15:10 -0400
From: Turbo Fredriksson <turbo@bayour.com>
To: linux-kernel@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>, Alasdair G Kergon <agk@redhat.com>
Subject: Re: Moving MD/LVM from PPC to x86
Organization: Bah!
References: <87wsxneqs0.fsf@pumba.bayour.com>
	<20070629215416.GA12786@agk.fab.redhat.com>
	<876455erlw.fsf@pumba.bayour.com>
	<18054.9063.45466.586046@notabene.brown>
X-PGP-Fingerprint: B7 92 93 0E 06 94 D6 22  98 1F 0B 5B FE 33 A1 0B
X-PGP-Key-ID: 0x788CD1A9
X-URL: http://www.bayour.com/
Date: Sun, 08 Jul 2007 22:15:03 +0200
In-Reply-To: <18054.9063.45466.586046@notabene.brown> (Neil Brown's message of
	"Sat, 30 Jun 2007 19:33:27 +1000")
Message-ID: <873azy4pq0.fsf@pumba.bayour.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Neil Brown <neilb@suse.de>:

> Version 0.90 MD superblocks (still the default) uses host-endian
> values so you cannot move between architectures directly.  However
> isn't too hard to make it work. 
> Firstly, use
>    mdadm --examine --metadata=0.swap /dev/DEVICE

----- s n i p -----
ppc:~# mdadm --examine --metadata=0.swap /dev/md0
mdadm: No super block found on /dev/md0 (Expected magic a92b4efc, got 00000000)
ppc:~# mdadm --examine --metadata=0.swap /dev/md1
mdadm: No super block found on /dev/md1 (Expected magic a92b4efc, got 00000000)
ppc:~# mdadm --examine --metadata=0.swap /dev/md2
mdadm: No super block found on /dev/md2 (Expected magic a92b4efc, got 00000000)
ppc:~# mdadm --examine --metadata=0.swap /dev/sda1
mdadm: No super block found on /dev/sda1 (Expected magic a92b4efc, got fc4e2ba9)
ppc:~# mdadm --examine --metadata=0.swap /dev/sda
mdadm: No super block found on /dev/sda (Expected magic a92b4efc, got 00000000)
ppc:~# mdadm --examine --metadata=0.swap /dev/sdb
mdadm: No super block found on /dev/sdb (Expected magic a92b4efc, got 00000000)
ppc:~# mdadm --examine --metadata=0.swap /dev/sdb1
mdadm: No super block found on /dev/sdb1 (Expected magic a92b4efc, got fc4e2ba9)
ppc:~# mdadm --examine --metadata=0.swap /dev/sdc
mdadm: No super block found on /dev/sdc (Expected magic a92b4efc, got 00000000)
ppc:~# mdadm --examine --metadata=0.swap /dev/sdc1
mdadm: No super block found on /dev/sdc1 (Expected magic a92b4efc, got fc4e2ba9)
ppc:~# cat /proc/mdstat | grep ^md
md2 : active raid1 sdb1[0]
md1 : active raid1 sdc1[0]
md0 : active raid1 sda1[0]
----- s n i p -----

Now what?

> to check that you have the right devices.
> Then
>
>   mdadm --assemble /dev/md0 --update=byteorder /dev/DEV0 /dev/DEV1  ....
>
> That should assemble the array and update the superblocks so that they
> are in the right byteorder and will assemble easily in future.

Is this safe, changing the byteorder on all the physical devices (that are
part of my MD's)?
Will it still work on the PPC?
