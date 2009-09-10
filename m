Return-Path: <linux-kernel-owner+w=401wt.eu-S1755653AbZIJNDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbZIJNDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 09:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755634AbZIJNDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 09:03:23 -0400
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4041 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbZIJNDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 09:03:23 -0400
Message-ID: <2f08a48107b19501ffa2c1570483544f.squirrel@webmail.xs4all.nl>
In-Reply-To: <20090908225858.04d56dce.akpm@linux-foundation.org>
References: <alpine.LSU.2.00.0905090957490.27646@fbirervta.pbzchgretzou.qr>
    <Pine.LNX.4.64.0908141315310.1670@venus.araneidae.co.uk>
    <20090908225858.04d56dce.akpm@linux-foundation.org>
Date: Thu, 10 Sep 2009 15:02:53 +0200
Subject: Re: [PATCH] Re: /proc/uptime idle counter remains at 0
From: "Johan van Baarlen" <vanbaajf@xs4all.nl>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Michael Abbott" <michael@araneidae.co.uk>,
       "Jan Engelhardt" <jengelh@medozas.de>,
       "Martin Schwidefsky" <schwidefsky@de.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Johan van Baarlen" <jf@vanbaarlen.demon.nl>
User-Agent: SquirrelMail/1.4.18
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

with this patch the idle-time in /proc/uptime makes a lot more sense - but
it runs about a factor of 4 too fast (I'm thinking this is not coincidence
- I've got 4 cpu's in this box, and simply adding 4 idle timers means you
are going 4 times too fast).

Can we just add idletime /= (i+1) after the foreachcpu loop, or am I
thinking too easy?


Regards,
Johan



> On Fri, 14 Aug 2009 13:18:08 +0100 (BST) Michael Abbott
> <michael@araneidae.co.uk> wrote:
>
>> Reviving this:
>>
>> On Sat, 9 May 2009, Jan Engelhardt wrote:
>> > starting from v2.6.28-4930-g79741dd lasting thru at least v2.6.29.1,
>> > the second field of /proc/uptime always shows 0.00. This happens for
>> > both the typical i386 (my case) and on an ARM (according to Michael,
>> > cc'ed).
>> >
>> > >From the commit log of 79741dd:
>> >
>> > 	"""The cpu time spent by the idle process actually doing
>> > 	something is currently accounted as idle time. This is plain
>> > 	wrong, the architectures that support VIRT_CPU_ACCOUNTING=y
>> > 	can do better: distinguish between the time spent doing
>> > 	nothing and the time spent by idle doing work. The first is
>> > 	accounted with account_idle_time and the second with
>> > 	account_system_time."""
>> >
>> > Citing Michael from our irc conversation:
>> >
>> > 	"""the writer[committer] [says] that [the] idle process time
>> > 	isn't really idle time ... but that's all that /proc/uptime
>> > 	looks at. I guess fs/proc/uptime.c needs to catch up."""
>> >
>> > So, were the updates to uptime.c missed, or do we now live on with
>> > /proc/uptime constantly having 0?
>>
>> My previous patch seems to have run into the sand.  It every so nearly
>> got
>> pulled into mainstream as far as I can tell, but didn't seem to make it;
>> no idea what happened.
>>
>> So here we go again:
>>
>
> Imagine my surprise to find a version of this patch lurking in Martin's
> tree since June 22.  It's a regression fix!
>
> Johan, does this patch help with the regression you reported in
> http://bugzilla.kernel.org/show_bug.cgi?id=14131

