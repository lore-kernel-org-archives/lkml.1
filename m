Return-Path: <linux-kernel-owner+w=401wt.eu-S1752093AbYCOJwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbYCOJwp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 05:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbYCOJwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 05:52:35 -0400
Received: from mango.safe-mail.net ([213.8.192.71]:38094 "EHLO
	mango.safe-mail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbYCOJwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 05:52:34 -0400
X-Greylist: delayed 3897 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Mar 2008 05:52:34 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
	s=N1-0105; d=Safe-mail.net;
	b=RoAWGZxdhPsMVfYnd9wouu6WIxvku7ulDS9Iex/SpM4IwLBLHBCNGnGCaLIc9Nha
	B3cj77bhu+KrBEZRa443mFhbzfbF7kCdz6c3viAfSGuZDTtMYGUHD+wDhpOrsPg0
	h/4PLFV4Ec12JgYA/TeJT/hO6g7IOx/EcEyQgdWiOwo=;
Subject: vmlinuz resume=/dev/md0 borks swap ( unlike /dev/sda1 )
Date: Sat, 15 Mar 2008 04:47:27 -0400
From: "Antryg Revok" <antrygrevok@Safe-mail.net>
To: linux-kernel@vger.kernel.org
X-SMType: Regular
X-SMRef: N1N-U8gRtCsRlA
Message-Id: <N1N-U8gRtCsRlA@Safe-mail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-SMSignature: SBKeZIIobJDV/12JAJEJo7A76UFiMcYLplbfyJiQQKDXTiPvIlkVEGwg7r9vhksx
	Ro6/CDnvfeHP260mITyXv/txySX+sURRZ7l9hVTnDBa5nC4boyOZnS/EPPAHsn77
	UumQ0V+laj4IKtorlNDLc3jT9n5F6ZfWe4X4c+q/qIs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not subscribed
( tried that once, and couldn't use that e-mail account again, due to swamping )
so please cc me to replies, if you feel I might help further. . .

circumstance:
openSUSE 10.3 x86_64 ( on an X2 ), 4GB RAM, 4GB swap ( some apps do go bonkers, sometimes ) on /dev/md0 ( raid-1 /dev/sda1 /dev/sdb1 )


/boot/grub/menu.lst

# Modified by YaST2. Last modification on Fri Mar 14 17:02:28 EDT 2008
default 0
timeout 8
gfxmenu (hd0,2)/boot/message
##YaST - activate

###Don't change this comment - YaST2 identifier: Original name: linux###
title openSUSE 10.3 - 2.6.22.17-0.1
    root (hd0,2)
#kernel /boot/vmlinuz-2.6.22.17-0.1-default root=/dev/md2 vga=0x375 dma resume=/dev/md0 splash=verbose showopts
    kernel /boot/vmlinuz-2.6.22.17-0.1-default root=/dev/md2 vga=0x375 dma splash=verbose showopts
    initrd /boot/initrd-2.6.22.17-0.1-default

###Don't change this comment - YaST2 identifier: Original name: failsafe###
title Failsafe -- openSUSE 10.3 - 2.6.22.17-0.1
    root (hd0,2)
    kernel /boot/vmlinuz-2.6.22.17-0.1-default root=/dev/md2 vga=ask showopts ide=nodma apm=off acpi=off noresume edd=off  3
    initrd /boot/initrd-2.6.22.17-0.1-default


I couldn't get swap to activate on /dev/md0
when the "resume=..." bit was in there, and
I couldn't get mdadm to stop /dev/md0
( btw, the manpage for mdadm is wrong, at least in syntax, on opensuse 10.3 )
it complained that the thing was still in use, but nothing in /etc/fstab was identified as being on it
( I'd commented-out the swap line, to minimize complexity ), and I couldn't find anything else that seemed to be using it.

lsof | grep md0
md0_raid1 2283 root cwd DIR 9,2 4096 2 /
md0_raid1 2283 root rtd DIR 9,2 4096 2 /
md0_raid1 2283 root txt unknown /proc/2283/exe

Then removing that "resume=..." from grub's menu.lst bit fixed swap.
/dev/md0 /could/ be activated as swap, then, and /dev/md0 behaved as a normal raid device, being stoppable & runnable.

I *need* this machine to be redundant-everything, very-very-reliable, because it's going to someone who can't geek, and they need it to work.
( which is the reason I'm not permitting MS-Windows anywhere near the metal )

Presumeably the resume stuff wasn't /intended/ to require a non-raid-1 partition if it is to co-exist with swap, 
I think it was an oversight, 
but maybe it's impossible?

My current "solution" is to rip all suspend/hibernate system/sw from this machine, to prevent any problems with the system "assuming" that the resume-data exists.

Please get the fixers to perceive the problem, if youse can, & thanks in advance, eh?

  : )
