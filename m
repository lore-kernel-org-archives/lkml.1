Return-Path: <linux-kernel-owner+w=401wt.eu-S1751920AbZEBBtC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbZEBBtC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 21:49:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750759AbZEBBsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 21:48:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:21295 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbZEBBsw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 21:48:52 -0400
MIME-Version: 1.0
In-Reply-To: <a55d774e0905011824k11e06f61ibc9937a2b26fd9e0@mail.gmail.com>
References: <1241097822.2516.3.camel@poy> <20090430222900.c13b63d5.akpm@linux-foundation.org> 
	<20090501061701.GB19234@kroah.com> <20090430234312.a63fa5cf.akpm@linux-foundation.org> 
	<20090501065527.GA19773@kroah.com> <a55d774e0905011824k11e06f61ibc9937a2b26fd9e0@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sat, 2 May 2009 03:48:36 +0200
Message-ID: <ac3eb2510905011848i51aef8e6wbe9506a13e67377d@mail.gmail.com>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
To: Brian Swetland <swetland@google.com>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 2, 2009 at 03:24, Brian Swetland <swetland@google.com> wrote:
> On Thu, Apr 30, 2009 at 11:55 PM, Greg KH <greg@kroah.com> wrote:
>> On Thu, Apr 30, 2009 at 11:43:12PM -0700, Andrew Morton wrote:
>>> On Thu, 30 Apr 2009 23:17:01 -0700 Greg KH <greg@kroah.com> wrote:
>>> > On Thu, Apr 30, 2009 at 10:29:00PM -0700, Andrew Morton wrote:
>>> >
>>> > Well, devfs "done right" with hopefully none of the vfs problems the
>>> > last devfs had. :)
>>>
>>> I think Adam Richter's devfs rewrite (which, iirc, was tmpfs-based)
>>> would have fixed up these things.  But it was never quite completed and
>>> came when minds were already made up.
>>>
>>> I don't understand why we need devfs2, really.  What problems are
>>> people having with teh existing design?
>>
>> Boot speed, boot speed, boot speed.
>>
>> Oh, and reduction in complexity in init scripts, and saving embedded
>> systems a lot of effort to implement a dynamic /dev properly (have you
>> _seen_ what Android does to keep from having to ship udev?  It's
>> horrible...)
>
> It's always struck me as odd that sysfs couldn't provide device node
> access, given that there's already an entity exposed for everything
> (or nearly everything).

You really want to be able to run grep-like stuff in sysfs, which
would do horrible things with device nodes. Also it does not support
extended attributes, not access control lists, ..., all stuff we need
for device nodes. You also want userspace to have control over device
nodes, and possibly mangle them, regardless what the kernel exports,
that's why it's a tmpfs and not part of sysfs.

> It seems weird to have to have an agent in
> userspace to create another hierarchy in addition to what the kernel
> already maintains.

Well, until just recently, there was no sane definition how device
nodes are names and layouted, every system did it differently, some
even tried to keep the totally useless devfs naming scheme alive. Now
that we managed to define a common default setup, which almost
everybody ships it, it makes it possible to add the few needed rules.

> I guess the really tricky bit is how to deal with
> permissions/ownership sanely.

Simple permissions would be possible without too much hassle, but uid
gid ownership, I can't see how the kernel could do that.

> I suspect there's no easy way to do
> something that "just works" for even the majority of userspace
> environments.

It will work just fine for root environments, what's missing without
userspace support is if you need to grant specific users access to
devices.

> Most of the ugly in the microudev thing in our init
> comes from having to do something about permissions.
>
> I would love to have a way for the kernel to do something like devfs
> (it'd let me kill some ugly userspace code on my side)....

How are permissions defined in your environment? What's the set of
permissions you need to apply?

Thanks,
Kay
