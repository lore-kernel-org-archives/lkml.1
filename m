Return-Path: <linux-kernel-owner+w=401wt.eu-S1755573AbXGGVj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbXGGVj0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 17:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbXGGVjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 17:39:19 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:7516 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbXGGVjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 17:39:18 -0400
Date: Sat, 7 Jul 2007 23:39:17 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Bodo Eggert <7eggert@gmx.de>
cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][Patch] Allow not mounting a root fs
In-Reply-To: <Pine.LNX.4.58.0707072255260.3562@be1.lrz>
Message-ID: <Pine.LNX.4.64.0707072335160.1536@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.58.0707060318160.26869@be1.lrz> <468DA42D.7050309@zytor.com>
 <Pine.LNX.4.64.0707072030230.1536@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.58.0707072255260.3562@be1.lrz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 7 2007 23:18, Bodo Eggert wrote:
>> >> BTW: Is it possible to mount a tmpfs on / before extracting the cpio?
>> >
>> >Not in the stock kernel.  There have been some patches floating around
>> >for that, I think.
>> 
>> What would it buy? rootfs is a tmpfs, is not it?
>
>As far as I understand, it is a ramfs aka. non-swappable tmpfs without any 
>limit and including a chance of DoSing the system.
>
>Since I'm toying with root-on-initcpio, I'm looking for things that might 
>make the task some easier.
>
>Currently I'm thinking about changing the root=initramfs to root=tmpfs and
>additionally mounting a tmpfs on / before unpacking the cpios. OTOH, this 
>seems to be a little bit messy. OTOH again, in _that_ boot code, nobody
>should complain :)

Come to speak of it, I think you can have it much easier by having the kernel
exporting the cpio image as a virtual file inside rootfs, so that you could
re-extract it inside a tmpfs. In other words:

mount -t tmpfs tmpfs /mnt;
cd /mnt;
cpio -diuv </initramfs.cpio;
#
# switch_root nukes rootfs, pivot_roots and execs some init
klibc_switch_root .; # or something like that

Of course this needs double the memory than directly mounting tmpfs as 
rootfs, but it's an idea too.


	Jan
-- 
