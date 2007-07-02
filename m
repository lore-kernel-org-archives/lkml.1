Return-Path: <linux-kernel-owner+w=401wt.eu-S1756249AbXGBQgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbXGBQgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 12:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbXGBQgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 12:36:31 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:52676 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772AbXGBQga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 12:36:30 -0400
Message-ID: <4689298B.2000407@dgreaves.com>
Date: Mon, 02 Jul 2007 17:36:27 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070618)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Tejun Heo <htejun@gmail.com>, David Chinner <dgc@sgi.com>,
       David Robinson <zxvdr.au@gmail.com>,
       LVM general discussion and development 
	<linux-lvm@redhat.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com, linux-pm <linux-pm@lists.osdl.org>,
       LinuxRaid <linux-raid@vger.kernel.org>
Subject: Re: [linux-lvm] 2.6.22-rc5 XFS fails after hibernate/resume
References: <46744065.6060605@dgreaves.com> <200707021608.56616.rjw@sisk.pl> <46890C7A.5040008@dgreaves.com> <200707021712.50323.rjw@sisk.pl>
In-Reply-To: <200707021712.50323.rjw@sisk.pl>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Monday, 2 July 2007 16:32, David Greaves wrote:
>> Rafael J. Wysocki wrote:
>>> On Monday, 2 July 2007 12:56, Tejun Heo wrote:
>>>> David Greaves wrote:
>>>>>> Tejun Heo wrote:
>>>>>>> It's really weird tho.  The PHY RDY status changed events are coming
>>>>>>> from the device which is NOT used while resuming
>>>>> There is an obvious problem there though Tejun (the errors even when sda
>>>>> isn't involved in the OS boot) - can I start another thread about that
>>>>> issue/bug later? I need to reshuffle partitions so I'd rather get the
>>>>> hibernate working first and then go back to it if that's OK?
>>>> Yeah, sure.  The problem is that we don't know whether or how those two
>>>> are related.  It would be great if there's a way to verify memory image
>>>> read from hibernation is intact.  Rafael, any ideas?
>>> Well, s2disk has an option to compute an MD5 checksum of the image during
>>> the hibernation and verify it while reading the image.
>> (Assuming you mean the mainline version)
>>
>> Sounds like a good think to try next...
>> Couldn't see anything on this in ../Documentation/power/*
>> How do I enable it?
> 
> Add 'compute checksum = y' to the s2disk's configuration file.

Ah, right - that's uswsusp isn't it? Which isn't what I'm having problems with 
AFAIK?

My suspend procedure is:

xfs_freeze -f /scratch
sync
echo platform > /sys/power/disk
echo disk > /sys/power/state
xfs_freeze -u /scratch

Which should work (actually it should work without the sync/xfs_freeze too).

So to debug the problem I'd like to minimally extend this process rather than 
replace it with another approach.

I take it there isn't an 'echo y > /sys/power/do_image_checksum'?

David


