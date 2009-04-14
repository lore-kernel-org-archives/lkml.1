Return-Path: <linux-kernel-owner+w=401wt.eu-S1757507AbZDNSKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507AbZDNSKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755969AbZDNSJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:09:52 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:51472 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755620AbZDNSJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:09:51 -0400
Message-ID: <49E4D16C.7030809@msgid.tls.msk.ru>
Date: Tue, 14 Apr 2009 22:09:48 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Mark Lord <lkml@rtr.ca>, Anton Ertl <anton@mips.complang.tuwien.ac.at>,
       linux-kernel@vger.kernel.org
Subject: Re: Out-of-order writing by disk drives
References: <87r5zv72cl.fsf@basil.nowhere.org> <E1Ltla2-0000bS-5j@a4.complang.tuwien.ac.at> <20090414172406.GX14687@one.firstfloor.org> <49E4CA75.902@rtr.ca> <20090414175433.GY14687@one.firstfloor.org>
In-Reply-To: <20090414175433.GY14687@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
[]
> Where I see it as a problem is with virtualization; LVM seems to be the
> most sane way to manage file systems for lots of VMs and you likely
> want barriers there too.

Virtualisation is the best fit for partitionable raid1 arrays.
It is, in fact, what we have here -- I tested LVM but rejected
it because of this very issue - it does not support barriers.
And used partitions inside RAID1 arrays instead.  It is not
that easy as with lvm (requires some work with numbers instead
of names, but that's again not that problematic if you think
about /dev/disk/by-name/...), and does not support resizing,
but again, this is not really a very necessary feature here
(easy to copy data to a new, larger place).

And by the way, here, extlinux comes very very handy.  Inside
guests I don't use partitions but "whole disks", including
boot disk (/dev/vda for kvm).  ext3fs on it, and extlinux to
boot it (works flawlessly on a partition-less device)

/mjt
