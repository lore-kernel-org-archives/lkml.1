Return-Path: <linux-kernel-owner+w=401wt.eu-S1762863AbYBLOgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762863AbYBLOgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 09:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761344AbYBLOgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 09:36:08 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:47108 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761402AbYBLOgG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 09:36:06 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: BTRFS partition usage...
Date: Tue, 12 Feb 2008 09:35:20 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, btrfs-devel@oss.oracle.com
References: <200802061200.14690.chris.mason@oracle.com> <200802120908.59602.chris.mason@oracle.com> <Pine.LNX.4.64.0802121518500.21102@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0802121518500.21102@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200802120935.20437.chris.mason@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 February 2008, Jan Engelhardt wrote:
> On Feb 12 2008 09:08, Chris Mason wrote:
> >> >So, if Btrfs starts zeroing at 1k, will that be acceptable for you?
> >>
> >> Something looks wrong here. Why would btrfs need to zero at all?
> >> Superblock at 0, and done. Just like xfs.
> >> (Yes, I had xfs on sparc before, so it's not like you NEED the
> >> whitespace at the start of a partition.)
> >
> >I've had requests to move the super down to 64k to make room for
> > bootloaders, which may not matter for sparc, but I don't really plan on
> > different locations for different arches.
>
> In x86, there is even more space for a bootloader (some 28k or so)
> even if your partition table is as closely packed as possible,
> from 0 to 7e00 IIRC.
>
> For sparc you could have something like
>
> 			startlba	endlba	type
> 	sda1		0		2	1 Boot
> 	sda2		2		58	3 Whole disk
> 	sda3		58		90000	83 Linux
>
> and slap the bootloader into "MBR", just like on x86.
> Or I am missing something..

It was a request from hpa, and he clearly had something in mind.  He kindly 
offered to review the disk format for bootloaders and other lower level 
issues but I asked him to wait until I firm it up a bit.

>From my point of view, 0 is a bad idea because it is very likely to conflict 
with other things.  There are lots of things in the FS that need deep 
thought,and the perfect system to fully use the first 64k of a 1TB filesystem 
isn't quite at the top of my list right now ;)

Regardless of offset, it is a good idea to mop up previous filesystems where 
possible, and a very good idea to align things on some sector boundary.  Even 
going 1MB in wouldn't be a horrible idea to align with erasure blocks on SSD.

-chris
