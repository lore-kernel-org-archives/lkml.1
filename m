Return-Path: <linux-kernel-owner+w=401wt.eu-S1750967AbZBNJPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750967AbZBNJPW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 04:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750832AbZBNJPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 04:15:04 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43146 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbZBNJPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 04:15:01 -0500
Date: Sat, 14 Feb 2009 10:32:13 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Mat <jackdachef@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, agk@redhat.com,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: [PATCH] Implement barrier support for single device DM devices
Message-ID: <20090214093213.GC26292@one.firstfloor.org>
References: <e85b9d30809110712y700a9d8exb5828487984d6a59@mail.gmail.com> <e85b9d30809110713m542fc884sc17374f7fb2c7493@mail.gmail.com> <20080911174657.GN7714@one.firstfloor.org> <e85b9d30902131526v5f710583ub58d578339dd0a90@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e85b9d30902131526v5f710583ub58d578339dd0a90@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 14, 2009 at 12:26:05AM +0100, Mat wrote:
> Hi Andi,
> 
> any news on this patch ?

It's in mainline as of 2.6.29-rc4.

> from what I saw it isn't included in mainline yet, if it is already
> please point to the kernel-config option where to enable it

It's always enabled for simple DM remapped devices given that its conditions
(only single underlying device etc.) are true.

> heavy flush, write operations; especially on amd64/X64:
> http://forums.gentoo.org/viewtopic-t-482731.html
> 
> I'm not sure if it's possible but I believe it could also be related
> to filesystems switching to synchronous writes (non-barrier
> write-mode) when the underlying partition is a LUKS-partition and

Note that my patch doesn't enable barriers for LUKS/dm_crypt, that would
be another patch which is not currently submtted.

> therefore
> decreasing performance (I'm not a kernel-hacker so I don't know if
> there's a possible correlation here)

You can find out by testing it without LUKS, but enabling/disabling
barriers on a file system and see how much difference it makes.
That would be better than speculating.

> 
> some factors I noticed having an impact on that are:

How did you determine that? Did you run some repeatable benchmark
that gave different numbers? 

> - the i/o scheduler hardly makes a change
> - elder boxes with PCI (non-PCIe) can be "fixed" with some latency-tweaks:
>   setpci -v -d *:* latency_timer=b0

You realize that the PCI latency has nothing to do with IO scheduler
delays? It's very unlikely that there is a correlation there.
Please double check these results.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
