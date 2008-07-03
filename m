Return-Path: <linux-kernel-owner+w=401wt.eu-S1754449AbYGCSaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbYGCSaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 14:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753433AbYGCSaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 14:30:01 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:41871 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbYGCSaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 14:30:00 -0400
Message-ID: <486D1A96.7060603@fr.ibm.com>
Date: Thu, 03 Jul 2008 20:29:42 +0200
From: Daniel Lezcano <dlezcano@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Thery <benjamin.thery@bull.net>
Subject: Re: [PATCH 06/11] sysfs: Implement sysfs tagged directory support.
References: <20080618170729.808539948@theryb.frec.bull.fr>	<20080618170731.002784342@theryb.frec.bull.fr>	<485F04E1.70204@gmail.com> <m1y74svtff.fsf@frodo.ebiederm.org>	<486706C9.9040303@gmail.com> <m18wwmsqdv.fsf@frodo.ebiederm.org>	<4869D314.5030403@gmail.com> <m1ej6enep7.fsf@frodo.ebiederm.org>	<486A0751.9080602@gmail.com> <m1wsk5hjm0.fsf@frodo.ebiederm.org>	<486AF4FA.8020805@gmail.com> <m1ej6d9c2r.fsf@frodo.ebiederm.org>	<486B060C.7030607@gmail.com> <m14p78s02q.fsf@frodo.ebiederm.org>	<486C4515.1070007@gmail.com> <m1hcb7o8lv.fsf@frodo.ebiederm.org>	<486CB051.5000507@fr.ibm.com> <m14p77m9uy.fsf@frodo.ebiederm.org> <486CF71F.5090405@gmail.com>
In-Reply-To: <486CF71F.5090405@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
> Eric W. Biederman wrote:
>> Daniel Lezcano <dlezcano@fr.ibm.com> writes:
>>
>>> The kobject events are sent through a netlink message which is not currently per
>>> network namespace. Shouldn't be useful to have a way to retrieve from the
>>> kobject the network namespace or the uevent socket associated with it ? IMHO
>>> having idr in the kobject + netns pointer associated may help to handle the
>>> sysfs isolation and makes the uevent per namespace trivial, no ?
>> Grumble.  I have been conveniently been forgetting about that socket.
>> Similarly we have the user mode helpers to deal with.
>>
>> For this conversation there is a simple answer.  All of that is in the
>> kobject layer, and works even when you compile sysfs out of your kernel.
>> Therefore it is a separate problem.  And sysfs idr tags have nothing
>> to do with it.
>>
>> It is most definitely something we need to come back to.  I bet there
>> are some interesting interactions when you have multiple network devices
>> with the same name generating events.
> 
> Related delta: I've been thinking that uevents should be part of sysfs
> not kobject as that's what the userland is gonna associate the event
> with.  Would that solve the problem you're thinking about?

uevents can work with the network namespaces being compiled in and the 
sysfs compiled out. AFAICS, uevents will be unable to handle multiple 
network namespaces if it is tied with sysfs, no ?
