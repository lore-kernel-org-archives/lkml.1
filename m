Return-Path: <linux-kernel-owner+w=401wt.eu-S1758910AbYBLPFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910AbYBLPFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 10:05:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756431AbYBLPEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 10:04:54 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:36529 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057AbYBLPEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 10:04:53 -0500
Date: Tue, 12 Feb 2008 16:04:52 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Chris Mason <chris.mason@oracle.com>
cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, btrfs-devel@oss.oracle.com
Subject: Re: BTRFS partition usage...
In-Reply-To: <200802120935.20437.chris.mason@oracle.com>
Message-ID: <Pine.LNX.4.64.0802121543240.21102@fbirervta.pbzchgretzou.qr>
References: <200802061200.14690.chris.mason@oracle.com>
 <200802120908.59602.chris.mason@oracle.com>
 <Pine.LNX.4.64.0802121518500.21102@fbirervta.pbzchgretzou.qr>
 <200802120935.20437.chris.mason@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
On Feb 12 2008 09:35, Chris Mason wrote:
>>
>> and slap the bootloader into "MBR", just like on x86.
>> Or I am missing something..
>
>It was a request from hpa, and he clearly had something in mind.  He kindly 
>offered to review the disk format for bootloaders and other lower level 
>issues but I asked him to wait until I firm it up a bit.
>
>From my point of view, 0 is a bad idea because it is very likely to conflict 
>with other things.  There are lots of things in the FS that need deep 
>thought,and the perfect system to fully use the first 64k of a 1TB filesystem 
>isn't quite at the top of my list right now ;)
>
>Regardless of offset, it is a good idea to mop up previous filesystems where 
>possible, and a very good idea to align things on some sector boundary.  Even 
>going 1MB in wouldn't be a horrible idea to align with erasure blocks on SSD.

I still don't like the idea of btrfs trying to be smarter than a user
who can partition up his system according to
	(a) his likes
	(b) system or hardware requirements or recommendations
to align the superblock to a specific location.

1MB alignment does not always mean 1MB alignment.
Sector 1 begins at 0x7e00 on x86.
And with the maximum CHS geometry (255/63), partitions begin
at 0x7e00+n*8225280 bytes, so the SB is unlikely to ever be on
a 1048576 boundary.
