Return-Path: <linux-kernel-owner+w=401wt.eu-S1762596AbYBLQTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762596AbYBLQTJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 11:19:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756136AbYBLQSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 11:18:54 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:49894 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbYBLQSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 11:18:53 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: BTRFS partition usage...
Date: Tue, 12 Feb 2008 11:17:58 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, btrfs-devel@oss.oracle.com
References: <200802061200.14690.chris.mason@oracle.com> <200802120935.20437.chris.mason@oracle.com> <Pine.LNX.4.64.0802121543240.21102@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0802121543240.21102@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802121117.58519.chris.mason@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 February 2008, Jan Engelhardt wrote:
> On Feb 12 2008 09:35, Chris Mason wrote:
> >> and slap the bootloader into "MBR", just like on x86.
> >> Or I am missing something..
> >
> >It was a request from hpa, and he clearly had something in mind.  He
> > kindly offered to review the disk format for bootloaders and other lower
> > level issues but I asked him to wait until I firm it up a bit.
> >
> >From my point of view, 0 is a bad idea because it is very likely to
> > conflict with other things.  There are lots of things in the FS that need
> > deep thought,and the perfect system to fully use the first 64k of a 1TB
> > filesystem isn't quite at the top of my list right now ;)
> >
> >Regardless of offset, it is a good idea to mop up previous filesystems
> > where possible, and a very good idea to align things on some sector
> > boundary.  Even going 1MB in wouldn't be a horrible idea to align with
> > erasure blocks on SSD.
>
> I still don't like the idea of btrfs trying to be smarter than a user
> who can partition up his system according to
> 	(a) his likes
> 	(b) system or hardware requirements or recommendations
> to align the superblock to a specific location.

Will all the users in the world who think about super block location when they 
partition their disks please raise their hands?

The location of the super block needs to be very simple in order for mount and 
friends to find and detect it.  It needs a simple algorithm to try multiple 
locations in case a given copy of the super is corrupt.

Design in this case is a bunch of compromises around other users of the 
hardware, ease of programming, and the benefits in performance or usability 
from doing something complex.

>
> 1MB alignment does not always mean 1MB alignment.
> Sector 1 begins at 0x7e00 on x86.
> And with the maximum CHS geometry (255/63), partitions begin
> at 0x7e00+n*8225280 bytes, so the SB is unlikely to ever be on
> a 1048576 boundary.

IO is already aligned on sectors, sometimes we'll have a perfect erasure block 
alignment and sometimes not.  When the location of the super is my biggest 
bottleneck, I'll be a very happy boy.

-chris
