Return-Path: <linux-kernel-owner+w=401wt.eu-S1759512AbXGQNrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759512AbXGQNrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 09:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbXGQNrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 09:47:13 -0400
Received: from smtpq3.tilbu1.nb.home.nl ([213.51.146.202]:42639 "EHLO
	smtpq3.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbXGQNrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 09:47:13 -0400
Message-ID: <469CC81F.5020902@gmail.com>
Date: Tue, 17 Jul 2007 15:46:07 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Jesper Juhl <jesper.juhl@gmail.com>,
       Ray Lee <ray-lk@madrabbit.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
References: <200707111916.35036.jesper.juhl@gmail.com> <2c0942db0707112159v3ee2cd83i74759c7138e273f7@mail.gmail.com> <9a8748490707121324q3b3e6e65ye14ab8e7f089d999@mail.gmail.com> <4696C89E.4010002@goop.org> <9a8748490707121925w5fb22c0o61068f06d66d5845@mail.gmail.com> <4696FC43.3000201@goop.org> <46977C36.8010403@gmail.com> <20070714191737.GA11166@waste.org> <46994BE3.7010608@gmail.com> <20070716233849.GE11115@waste.org>
In-Reply-To: <20070716233849.GE11115@waste.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2007 01:38 AM, Matt Mackall wrote:

> On Sun, Jul 15, 2007 at 12:19:15AM +0200, Rene Herman wrote:

>> Quite. Ofcourse, saying "our stacks are 1 page" would be the by far
>> easiest solution to that. Personally, I've been running with 4K stacks
>> exclusively on a variety of machines for quite some time now, but I
>> can't say I'm all too adventurous with respect to filesystems
>> (especially) so I'm not sure how many problems remain with 4K stacks. I
>> did recently see Andrew Morton say that problems _do_ still exist. If
>> it's just XFS -- well, heck...
> 
> One long-standing problem is DM/LVM. That -may- be fixed now, but I
> suspect issues remain.

Three cases were reported again in this thread alone yes. Problems do seem 
to be nicely isolated to that specific issue...

>>> int growstack(int headroom, int func, void *data)
>>> {

[ ... ]

>>> }

>> This would also need something to tell func() where its current_thread_info 
>>  is now at.
> 
> That'd be handled in the usual way by switch_to_new_stack. That is,
> we'd store the location of the old stack at the top of the new stack
> and then literally change everything to point to the new stack.

I might not understand what you're saying but I don't believe that would do.
The current thread_info _itself_ (ie, the struct itself, not a pointer) is 
located at esp & ~(THREAD_SIZE - 1) meaning you'd either have to copy over 
the struct to the new stack, or forego that historic optimization (don't get 
me wrong, either may be okay).

>> Which might not be much of a problem. Can't think of much else 
>> either but it's the kind of thing you'd _like_ to be a problem just to have 
>> an excuse to shoot down an icky notion like that...
> 
> It's not any ickier than explicitly calling schedule().

Somewhat comparable in notion perhaps, but I disagree on the relative level 
of ickyness. Calling schedule() you do when you know you no longer have to 
hog te CPU and when you know it's safe to do so. Calling via growstack() 
looks to be a "ah, heck, let's err on the safe side since we don't have a 
bleedin' clue otherwise" sort of thing.

>> Would you intend this just as a "make this path work until we fix it 
>> properly" kind of thing?
> 
> Maybe.

If you know, _can_ MD/LVM (and/or XFS) in fact be sanely/timely fixed, or is 
this looking at something fundamental?

Rene.

