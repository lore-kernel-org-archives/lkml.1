Return-Path: <linux-kernel-owner+w=401wt.eu-S932154AbXGTHDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154AbXGTHDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 03:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757325AbXGTHDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 03:03:24 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:54071 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbXGTHDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 03:03:23 -0400
Date: Fri, 20 Jul 2007 09:03:22 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Willy Tarreau <w@1wt.eu>
cc: Al Boldi <a1426z@gawab.com>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFH] Partion table recovery
In-Reply-To: <20070720053526.GG943@1wt.eu>
Message-ID: <Pine.LNX.4.64.0707200858030.31013@fbirervta.pbzchgretzou.qr>
References: <200707200813.03553.a1426z@gawab.com> <20070720053526.GG943@1wt.eu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 20 2007 07:35, Willy Tarreau wrote:
>On Fri, Jul 20, 2007 at 08:13:03AM +0300, Al Boldi wrote:
>> As always, a good friend of mine managed to scratch my partion table by 
>> cat'ing /dev/full into /dev/sda.  I was able to push him out of the way, but 
>> at least the first 100MB are gone.  I can probably live without the first 
>> partion, but there are many partitions after that, which I hope should 
>> easily be recoverable.

Go use GPT, it's got a backup copy of the ptable at then end of the disk ;-)

>> 
>> I tried parted, but it's not working out for me.  Does anybody know of a 
>> simple partition recovery tool, that would just scan the disk for lost 
>> partions?
>
>The best one is simply "fdisk", because you can manually enter your
>cylinders numbers. You have to find by hand the beginning of each partition,
>and for this, you have to remember what filesystems you used and see how to
>identify them (using a magic). Then with an hex editor, you scan the disk to
>find such entries and note the possible sectors on a paper. Then comes fdisk.
>You create the part, exit and try to mount it. If it fails, fdisk again and
>try other values.

Pretty easy:
"XFSB" (offset +0),
"ReIsErFs2" (offset +0x10034),
"SWAPSPACE2" (offset +0xff6),
"FAT32" (offset +0x52h, maybe harder) / "mkdofs" (+0x3)
ext2/3 is TOUGH. (sequence 0x53ef at +0x438 - quite ambiguous!)

>
>I've saved many disks that way, it may sound harder than it really is. It
>should not take you more than half an hour to get the first part. Knowing
>your approximate partitions size will help too.

>
>Good luck!
>Willy
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>

	Jan
-- 
