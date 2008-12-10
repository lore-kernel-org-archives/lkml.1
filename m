Return-Path: <linux-kernel-owner+w=401wt.eu-S1755178AbYLJAb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbYLJAb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 19:31:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbYLJAbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 19:31:16 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:51302 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbYLJAbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 19:31:16 -0500
Message-ID: <ac3eb2510812091631j3b350ac6t9429e01171a96228@mail.gmail.com>
Date: Wed, 10 Dec 2008 01:31:13 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for December 9
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, adobriyan@gmail.com,
       Greg <greg@kroah.com>, NeilBrown <neilb@suse.de>
In-Reply-To: <20081209161511.15fe8cdb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081209185237.8bb715d7.sfr@canb.auug.org.au>
	 <20081209153418.4628723d.akpm@linux-foundation.org>
	 <ac3eb2510812091606k5615135fn87d35aaa16834ea8@mail.gmail.com>
	 <20081209161511.15fe8cdb.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 01:15, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 10 Dec 2008 01:06:47 +0100
> "Kay Sievers" <kay.sievers@vrfy.org> wrote:
>> On Wed, Dec 10, 2008 at 00:34, Andrew Morton <akpm@linux-foundation.org> wrote:
>> > On Tue, 9 Dec 2008 18:52:37 +1100
>> > Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> >
>> >> I have created today's linux-next tree at
>> >> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
>> >
>> > udevd is sitting there chewing up 100% of a CPU all the time.
>> >
>> > The machine is x86_64, running FC6.  It still happens with
>> > CONFIG_SELINUX=n.
>> >
>> > config:                 http://userweb.kernel.org/~akpm/config-akpm2.txt
>> > dmesg:                  http://userweb.kernel.org/~akpm/dmesg-akpm2.txt
>> > strace of udevd:        http://userweb.kernel.org/~akpm/strace.out.txt
>> >
>> > excerpt:
>> >
>> > close(9)                                = 0
>> > open("/proc/21707/stat", O_RDONLY)      = 9
>> > read(9, "21707 (hald-addon-stor) S 21033 "..., 255) = 240
>> > close(9)                                = 0
>> > open("/proc/22340/stat", O_RDONLY)      = 9
>> > read(9, "22340 (smartd) S 1 22339 22339 0"..., 255) = 245
>> > close(9)                                = 0
>>
>> Maybe an event loop, caused by something.
>>
>> Are you still able to run:
>>   udevmonitor --kernel
>> and see if we get events, maybe in a loop, from the kernel?
>
> akpm2:/home/akpm# udevmonitor --kernel
> unknown option

Ok, it was just -k that time. :)

> akpm2:/home/akpm# udevmonitor
> udevmonitor prints the received event from the kernel [UEVENT]
> and the event which udev sends out after rule processing [UDEV]
>
> UDEV  [1228867146.103334] add@/class/bdi/9:0
> UDEV  [1228867146.107566] remove@/block/md0
> UDEV  [1228867146.111969] remove@/class/bdi/9:0
> UEVENT[1228867146.119889] add@/block/md0
> UEVENT[1228867146.119964] add@/class/bdi/9:0
> UEVENT[1228867146.120162] remove@/class/bdi/9:0
> UEVENT[1228867146.120205] remove@/block/md0
> UDEV  [1228867146.122839] add@/block/md0
> UDEV  [1228867146.129125] add@/class/bdi/9:0
> UDEV  [1228867146.133459] remove@/block/md0
> UDEV  [1228867146.137813] remove@/class/bdi/9:0
> UEVENT[1228867146.145652] add@/block/md0

Weird loop, something is accessing /dev/md0, i guess, which creates
the kernel device, and the event, which accesses /dev/md0 again and it
goes crazy. Maybe caused by changes Neil did.

Do you use md devices on that box?

Thanks,
Kay
