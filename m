Return-Path: <linux-kernel-owner+w=401wt.eu-S1756723AbZDNRtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbZDNRtD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:49:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbZDNRsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:48:53 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:54468 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152AbZDNRsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:48:52 -0400
Message-ID: <49E4CC82.4050607@msgid.tls.msk.ru>
Date: Tue, 14 Apr 2009 21:48:50 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Andi Kleen <andi@firstfloor.org>,
       Anton Ertl <anton@mips.complang.tuwien.ac.at>,
       linux-kernel@vger.kernel.org
Subject: Re: Out-of-order writing by disk drives
References: <87r5zv72cl.fsf@basil.nowhere.org> <E1Ltla2-0000bS-5j@a4.complang.tuwien.ac.at> <20090414172406.GX14687@one.firstfloor.org> <49E4CA75.902@rtr.ca>
In-Reply-To: <49E4CA75.902@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Andi Kleen wrote:
[]
>> A common problem is barriers over LVM. Since 2.6.29 they work
>> with a single device (and if the underlying device supports it) with 
>> dm linear, but not in any other LVM setup.
> 
> Does anyone else here find this rather peculiar?
> 
> The folks who actually care about barriers the most
> (apart from kernel developers) are probably enterprise users.
> 
> And who is most likely to be using RAID and LVM,
> where barriers generally don't work at all ?

And esp. RAID10.

(Not being an "enterprise" user really, but I do still use
several hard drives and databases).

For this very reason, I stopped using both RAID10 and LVM.

For now, I've several large RAID1 volumes with GPT partitions
inside them, and use that for various databases etc.  With
XFS mostly.  It also does not have constant alignment problems
what LVM has(*) (I can align GPT properly, even when the tools
to do so (parted-derivates) are very bad quality still, crashing
left and right).  Yes it's not that easy to use as LVM, but it
is MUCH faster because of all the reasons stated.

(*) another LVM's issue which is hidden behind scenes for
most users, and is especially serious on raid5 or raid6 --
this is misaligned blocks.  The good thing about this is
that raid[56] are not usually being used for write-intensive
applications like databases.

/mjt
