Return-Path: <linux-kernel-owner+w=401wt.eu-S1753399AbZEBBYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbZEBBYh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 21:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbZEBBY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 21:24:29 -0400
Received: from smtp-out.google.com ([216.239.33.17]:58061 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbZEBBY2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 21:24:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=LLTPJqkN6GT9MQ5tqhpPOiGbEwu4S0XjPQWHuNztDriJa/A3HVHxibNBmPsGugiRO
	4W3HZIN7dTH5yDxpBT3Nw==
MIME-Version: 1.0
In-Reply-To: <20090501065527.GA19773@kroah.com>
References: <1241097822.2516.3.camel@poy>
	 <20090430222900.c13b63d5.akpm@linux-foundation.org>
	 <20090501061701.GB19234@kroah.com>
	 <20090430234312.a63fa5cf.akpm@linux-foundation.org>
	 <20090501065527.GA19773@kroah.com>
Date: Fri, 1 May 2009 18:24:23 -0700
Message-ID: <a55d774e0905011824k11e06f61ibc9937a2b26fd9e0@mail.gmail.com>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
From: Brian Swetland <swetland@google.com>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 11:55 PM, Greg KH <greg@kroah.com> wrote:
> On Thu, Apr 30, 2009 at 11:43:12PM -0700, Andrew Morton wrote:
>> On Thu, 30 Apr 2009 23:17:01 -0700 Greg KH <greg@kroah.com> wrote:
>> > On Thu, Apr 30, 2009 at 10:29:00PM -0700, Andrew Morton wrote:
>> >
>> > Well, devfs "done right" with hopefully none of the vfs problems the
>> > last devfs had. :)
>>
>> I think Adam Richter's devfs rewrite (which, iirc, was tmpfs-based)
>> would have fixed up these things.  But it was never quite completed and
>> came when minds were already made up.
>>
>> I don't understand why we need devfs2, really.  What problems are
>> people having with teh existing design?
>
> Boot speed, boot speed, boot speed.
>
> Oh, and reduction in complexity in init scripts, and saving embedded
> systems a lot of effort to implement a dynamic /dev properly (have you
> _seen_ what Android does to keep from having to ship udev?  It's
> horrible...)

It's always struck me as odd that sysfs couldn't provide device node
access, given that there's already an entity exposed for everything
(or nearly everything).  It seems weird to have to have an agent in
userspace to create another hierarchy in addition to what the kernel
already maintains.

I guess the really tricky bit is how to deal with
permissions/ownership sanely.  I suspect there's no easy way to do
something that "just works" for even the majority of userspace
environments.  Most of the ugly in the microudev thing in our init
comes from having to do something about permissions.

I would love to have a way for the kernel to do something like devfs
(it'd let me kill some ugly userspace code on my side)....

Brian
