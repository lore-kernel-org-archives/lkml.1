Return-Path: <linux-kernel-owner+w=401wt.eu-S932379AbXGNAw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379AbXGNAw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 20:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759347AbXGNAws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 20:52:48 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:62261 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759264AbXGNAwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 20:52:47 -0400
Date: Fri, 13 Jul 2007 20:52:27 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Forward port of latest RT patch (2.6.21.5-rt20) to 2.6.22 available
In-reply-to: <46981855.8040904@bigpond.net.au>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Ingo Molnar <mingo@elte.hu>, Gregory Haskins <ghaskins@novell.com>,
       jim.houston@ccur.com, joe.korty@ccur.com, rostedt@goodmis.org,
       tglx@linutronix.de, dwalker@mvista.com, David Bahi <DBahi@novell.com>,
       Moiz Kohari <MKohari@novell.com>, Sven Dietrich <SDietrich@novell.com>,
       dsaxena@plexity.net, williams@redhat.com, abogani@texware.it,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Message-id: <200707132052.27563.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <4695E5BB0200005A0002763E@mcclure.wal.novell.com>
 <200707130443.11356.gene.heskett@gmail.com> <46981855.8040904@bigpond.net.au>
User-Agent: KMail/1.9.7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 July 2007, Peter Williams wrote:
>Gene Heskett wrote:
>> On Friday 13 July 2007, Peter Williams wrote:
>>> Ingo Molnar wrote:
>>>> * Gregory Haskins <ghaskins@novell.com> wrote:
>>>>> On Thu, 2007-07-12 at 14:07 +0200, Ingo Molnar wrote:
>>>>>> * Gregory Haskins <ghaskins@novell.com> wrote:
>>>>>>> Hi Ingo, Thomas, and the greater linux-rt community,
>>>>>>>
>>>>>>> 	I just wanted to let you guys know that our team has a port of
>>>>>>> the 21.5-rt20 patch for the 2.6.22 kernel available. [...]
>>>>>>
>>>>>> great! We had the upstream -rt port to .22 in the works too, it was
>>>>>> just held up by the hpet breakage - which Thomas managed to fix
>>>>>> earlier today. I've released the 2.6.22.1-rt1 patch to the usual
>>>>>> place:
>>>>>>
>>>>>>     http://redhat.com/~mingo/realtime-preempt/
>>>>>
>>>>> Thats awesome, Ingo!  Thanks!  Could you publish a broken out version
>>>>> as well?  We found it extremely valuable to be able to bisect this
>>>>> beast while working on the 21-22 port.
>>>>
>>>> we are working on something in this area :) Stay tuned ...
>>>
>>> I've just been reviewing these patches and have spotted an error in the
>>> file mm/slob.c at lines 500-501 whereby a non existent variable "c" is
>>> referenced.  The attached patch is a proposed fix to the problem.
>>
>> Could this explain why 2.6.22.1-rt1 seems to use a lot of swap?  I've been
>> as high as 570 megs into swap, currently at 286megs after doing a
>> swapoff --a;swapon -a about 8 hours ago.
>
>No.  This problem would have caused the build to fail if slob was
>configured.
>
>Peter

Which, now that I've gone back and looked only has SLAB as the choice in the 
make xconfig.  It did that switch rather silently as I had been using SLUB 
all the way through the 2.6.22-rcN series just to exersize the new option.

In any event, both rt2 and rt3 seem to have that under total control now.  No 
swap is being indicated by htop, and kmail is up to 122 megs.  Uptime with 
rt3 is 8.5 hours now & so far everything is running rather nicely.  Except of 
course for tvtime.  I fwd'd the logs from that to the v4l list, but haven't 
been graced with a reply as yet.

Thanks Peter.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
There are three ways to get something done:
	(1) Do it yourself.
	(2) Hire someone to do it for you.
	(3) Forbid your kids to do it.
