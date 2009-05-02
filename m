Return-Path: <linux-kernel-owner+w=401wt.eu-S1752667AbZEBCCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbZEBCCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 22:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbZEBCCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 22:02:45 -0400
Received: from smtp-out.google.com ([216.239.45.13]:12940 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbZEBCCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 22:02:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=UVR+8FrbnW01CXpIZoR66toPLBcm8Ogw/aOUu1nFBudSsFqQ5zSYoAGxadG0EQ7Sg
	VD9Yp/NXkV1mHk5aqXcrw==
MIME-Version: 1.0
In-Reply-To: <ac3eb2510905011848i51aef8e6wbe9506a13e67377d@mail.gmail.com>
References: <1241097822.2516.3.camel@poy>
	 <20090430222900.c13b63d5.akpm@linux-foundation.org>
	 <20090501061701.GB19234@kroah.com>
	 <20090430234312.a63fa5cf.akpm@linux-foundation.org>
	 <20090501065527.GA19773@kroah.com>
	 <a55d774e0905011824k11e06f61ibc9937a2b26fd9e0@mail.gmail.com>
	 <ac3eb2510905011848i51aef8e6wbe9506a13e67377d@mail.gmail.com>
Date: Fri, 1 May 2009 19:02:41 -0700
Message-ID: <a55d774e0905011902y1827322ascd7d2eb42570d1dc@mail.gmail.com>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
From: Brian Swetland <swetland@google.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 1, 2009 at 6:48 PM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Sat, May 2, 2009 at 03:24, Brian Swetland <swetland@google.com> wrote:
>> It's always struck me as odd that sysfs couldn't provide device node
>> access, given that there's already an entity exposed for everything
>> (or nearly everything).
>
> You really want to be able to run grep-like stuff in sysfs, which
> would do horrible things with device nodes. Also it does not support
> extended attributes, not access control lists, ..., all stuff we need
> for device nodes. You also want userspace to have control over device
> nodes, and possibly mangle them, regardless what the kernel exports,
> that's why it's a tmpfs and not part of sysfs.

That makes sense.

>> It seems weird to have to have an agent in
>> userspace to create another hierarchy in addition to what the kernel
>> already maintains.
>
> Well, until just recently, there was no sane definition how device
> nodes are names and layouted, every system did it differently, some
> even tried to keep the totally useless devfs naming scheme alive. Now
> that we managed to define a common default setup, which almost
> everybody ships it, it makes it possible to add the few needed rules.

That's good news -- I wasn't sure if there was still variety in layout
policies that required somehow supporting multiple different ones.

>> I guess the really tricky bit is how to deal with
>> permissions/ownership sanely.
>
> Simple permissions would be possible without too much hassle, but uid
> gid ownership, I can't see how the kernel could do that.

Yeah, I don't see any easy solution there.  Which means we end up
having to have some userspace agent responsible for arranging
permissions as devices are published.

>> I suspect there's no easy way to do
>> something that "just works" for even the majority of userspace
>> environments.
>
> It will work just fine for root environments, what's missing without
> userspace support is if you need to grant specific users access to
> devices.
>
>> Most of the ugly in the microudev thing in our init
>> comes from having to do something about permissions.
>>
>> I would love to have a way for the kernel to do something like devfs
>> (it'd let me kill some ugly userspace code on my side)....
>
> How are permissions defined in your environment? What's the set of
> permissions you need to apply?

In our world we use groups to provide access to specific classes of
hardware resources (audio, video, display, dsp, etc) and processes
that have the appropriate permissions are arranged to run with
necessary additional groups for the hardware they need to access.
Very little of the system ever runs as root -- most runs as a per-app
or per-service untrusted user with permissions granted via group
membership.

Brian
