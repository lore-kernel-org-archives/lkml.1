Return-Path: <linux-kernel-owner+w=401wt.eu-S1751002AbZHRVVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751002AbZHRVVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 17:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbZHRVVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 17:21:49 -0400
Received: from brick.kernel.dk ([93.163.65.50]:49524 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbZHRVVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 17:21:48 -0400
Date: Tue, 18 Aug 2009 23:21:49 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-btrfs@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Why does stat() return invalid st_dev field for btrfs ??
Message-ID: <20090818212149.GS12579@kernel.dk>
References: <4A89C1DA.6040601@rtr.ca> <ac3eb2510908171729k2e53914fu6ffe49483310aeba@mail.gmail.com> <4A8A0B76.1030800@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8A0B76.1030800@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 17 2009, Mark Lord wrote:
> Kay Sievers wrote:
>> On Mon, Aug 17, 2009 at 22:47, Mark Lord<lkml@rtr.ca> wrote:
>>> Chris / list,
>>>
>>> stat(2) seems to return invalid major/minor device info
>>> for btrfs filesystems.
>>>
>>> Why?  Is this a bug?
>>
>> This is not invalid and not a bug. It's a superblock without a device,
>> and expected behavior.
>>
>> There is no one-to-one relation from a btrfs mountpoint to a device,
>> it's a tree, and therefore therefore there can not be a single
>> major/minor.
> ..
>
> Sure there is for the most common case.
> When there is only a single device, stat() should return that device.
> When there are several, it should do something different.

I actually think it's quite sane, since then you get the same behaviour
on multi vs single disk file systems. The last thing you want is to have
different behaviour when you later add a disk, for instance.

-- 
Jens Axboe

