Return-Path: <linux-kernel-owner+w=401wt.eu-S1755705AbYGJJuC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705AbYGJJuC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 05:50:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbYGJJty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 05:49:54 -0400
Received: from orion2.pixelized.ch ([195.190.190.13]:39057 "EHLO
	orion.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbYGJJtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 05:49:53 -0400
Message-ID: <4875DB38.4000209@cateee.net>
Date: Thu, 10 Jul 2008 11:49:44 +0200
From: "Giacomo A. Catenazzi" <cate@cateee.net>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: bug in 2.6.26-rc9: sleeping function called from invalid context
 at kernel/rwsem:21
References: <4875C615.90102@cateee.net> <19f34abd0807100234n46e2229ej5077d8c91d08e9f6@mail.gmail.com>
In-Reply-To: <19f34abd0807100234n46e2229ej5077d8c91d08e9f6@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> On Thu, Jul 10, 2008 at 10:19 AM, Giacomo A. Catenazzi <cate@cateee.net> wrote:
>> Hello,
>>
>> yesterday at shutdown I had a crash. Unfortunately it seems
>> that there was one (or more) oops missing. The bug appeared
>> at unmounting partition at shutdown, so there are no logs
>> of the previous messages.
> 
> Thanks for the report.
> 
> It would be really useful to know which filesystems you are/were
> using, including virtual filesystems like sysfs. Maybe you are using
> ecryptfs or FUSE?
> 
> (It would also be interesting to see if you could run
> /etc/rc0.d/S40umountfs while the machine is up, to see if you can get
> the segfault but keep the machine usable enough to get the whole log.)

At home, my disks are only ext2.
sysfs, procfs and other system fs and /dev/* mount points are not
umounted in /etc/rc0.d/S40umountfs.

By a quick look (I'm not at home), it seems that on my home computer
only ext2 fs are umounted by /etc/rc0.d/S40umountfs.

As I said, the bug doesn't seems reproducible,
but I'll try harder later.

At subsequent boot, the unclean fs were: / /var and /usr,
Checking was done without error messages, so I think no busy
or opened files at time of crash.

Note: at the boot, one filesystem was checked (after 30+x),
I think it was /home. But I really think it is unrelated
(but it means that some of the other fs have a boot count > 30)

ciao
	cate
