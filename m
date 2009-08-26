Return-Path: <linux-kernel-owner+w=401wt.eu-S1756524AbZHZCmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbZHZCmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 22:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbZHZCmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 22:42:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755531AbZHZCmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 22:42:07 -0400
Message-ID: <4A94A0E6.4020401@redhat.com>
Date: Tue, 25 Aug 2009 22:41:42 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Andrei Tanas <andrei@tanas.ca>
CC: "'NeilBrown'" <neilb@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: MD/RAID: what's wrong with sector 1953519935?
References: <004e01ca25e4$c11a54e0$434efea0$@ca>    <9cfb6af689a7010df166fdebb1ef516b.squirrel@neil.brown.name>    <4A948A82.4080901@redhat.com> <b585ed9f13649050bbc984869d081315.squirrel@neil.brown.name> <4A94905F.7050705@redhat.com> <005101ca25f4$09006830$1b013890$@ca>
In-Reply-To: <005101ca25f4$09006830$1b013890$@ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2009 10:22 PM, Andrei Tanas wrote:
>>>> One thing that can happen is when we have a hot spot (like the super
>>>> block) on high capacity drives is that the frequent write degrade
>> the
>>>> data in adjacent tracks.  Some drives have firmware that watches for
>>>> this and rewrites adjacent tracks, but it is also a good idea to
>> avoid
>>>> too frequent updates.
>>>
>>> Yet another detail to worry about.... :-(
>>
>> it never ends :-)
>>
>>>
>>>>
>>>> Didn't you have a tunable to decrease this update frequency?
>>>
>>> /sys/block/mdX/md/safe_mode_delay
>>> is a time in seconds (Default 0.200) between when the last write to
>>> the array completes and when the superblock is marked as clean.
>>> Depending on the actual rate of writes to the array, the superblock
>>> can be updated as much as twice in this time (once to mark dirty,
>>> once to mark clean).
>>>
>>> Increasing the number can decrease the update frequency of the
>> superblock,
>>> but the exact effect on update frequency is very load-dependant.
>>>
>>> Obviously a write-intent-bitmap, which is rarely more that a few
>>> sectors, can also see lots of updates, and it is harder to tune
>>> that (you have to set things up when you create the bitmap).
>>>
>>> NeilBrown
>>>
>>
>> We did see issues in practice with adjacent sectors with some drives,
>> so this
>> one is worth tuning down.
>>
>> I would suggest that Andrei might try to write and clear the IO error
>> at that
>> offset. You can use Mark Lord's hdparm to clear a specific sector or
>> just do the
>> math (carefully!) and dd over it. It the write succeeds (without
>> bumping your
>> remapped sectors count) this is a likely match to this problem,
>
> I've tried dd multiple times, it always succeeds, and the relocated sector
> count is currently 1 on this drive, even though this particular fault
> happened at least 3 times so far.
>

I would bump that count way up (say to 2) and see if you have an issue...

ric

