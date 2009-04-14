Return-Path: <linux-kernel-owner+w=401wt.eu-S1757048AbZDNRV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048AbZDNRV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbZDNRVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:21:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34547 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbZDNRVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:21:19 -0400
Date: Tue, 14 Apr 2009 19:24:06 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Anton Ertl <anton@mips.complang.tuwien.ac.at>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Out-of-order writing by disk drives
Message-ID: <20090414172406.GX14687@one.firstfloor.org>
References: <87r5zv72cl.fsf@basil.nowhere.org> <E1Ltla2-0000bS-5j@a4.complang.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Ltla2-0000bS-5j@a4.complang.tuwien.ac.at>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 06:33:50PM +0200, Anton Ertl wrote:
> Andi Kleen wrote:
> > 
> > "Anton Ertl" <anton@mips.complang.tuwien.ac.at> writes:
> > >
> > > /dev/md2        /home           ext3    defaults,barrier=1      1	2
> > 
> > Just make sure /dev/md2 is a RAID1, MD RAID0/5/10 don't support barriers.
> 
> Thank you.  I added the following to the README:
> 
> |Note that, as of this writing (2009-04), not all Linux devices support
> |barriers, in particular md devices only support them in RAID 1 mode;
> |the kernel will reportedly warn about the lack of barriers if you try
> |to use ext3 with barriers on a device that does not support barriers
> |(look in, e.g., dmesg).

A full listing of what devices do and don't support barriers would
be likely very long. You would actually need to list down to hard disks.

A common problem is barriers over LVM. Since 2.6.29 they work
with a single device (and if the underlying device supports it) with 
dm linear, but not in any other LVM setup.

So it might be better to just generally recommend to check
dmesg.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
