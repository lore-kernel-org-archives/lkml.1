Return-Path: <linux-kernel-owner+w=401wt.eu-S935577AbYBHAlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935577AbYBHAlE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 19:41:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964891AbYBHAjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 19:39:35 -0500
Received: from ithilien.qualcomm.com ([129.46.51.59]:46329 "EHLO
	ithilien.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964881AbYBHAjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 19:39:33 -0500
Message-ID: <47ABA4A1.9030705@qualcomm.com>
Date: Thu, 07 Feb 2008 16:38:57 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] CPU isolation extensions
References: <47AA9807.7090402@qualcomm.com> <alpine.LFD.1.00.0802070903190.2883@woody.linux-foundation.org> <20080207195130.GA27482@elte.hu>
In-Reply-To: <20080207195130.GA27482@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Thanks for your reply.

> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>> On Wed, 6 Feb 2008, Max Krasnyansky wrote:
>>> Linus, please pull CPU isolation extensions from
>>>
>>> git://git.kernel.org/pub/scm/linux/kernel/git/maxk/cpuisol-2.6.git 
>>> for-linus
>> Have these been in -mm and widely discussed etc? I'd like to start 
>> more carefully, and (a) have that controversial last patch not merged 
>> initially and (b) make sure everybody is on the same page wrt this 
>> all..
> 
> no, they have not been under nearly enough testing and review - these 
> patches surfaced on lkml for the first time one week ago (!). 
Almost two weeks actually. Ok 1.8 :)

> I find the pull request totally premature, this stuff has not been discussed and 
> agreed on _at all_.
Ingo, I may have the wrong impression but my impression is that you ignored all the 
other emails and just read Linus' reply. I do not believe this accusation is valid.
I apologize if my impression is incorrect.
Since the patches _do not_ change/affect existing scheduler/cpuset functionality I did 
not know who to CC in the first email that I sent. Luckily Peter picked it up and CC'ed 
a bunch of folks, including Paul, Steven and You.
All of them replied and had questions/concerns. As I mentioned before I believe I addressed
all of them.
 
> None of the people who maintain and have interest in 
> this code and participated in the (short) one-week discussion were 
> Cc:-ed to the pull request.
Ok. I did not realize I'm supposed to do that. 
Since I got no replies to the second round of patches (take 2), which again was CC'ed to
the same people that Peter CC'ed. I assumed that people are ok with it. That's what discussion 
on the first take ended with.

> I think these patches also need a buy-in from Peter Zijlstra and Paul 
> Jackson (or really good reasoning while any objections from them should 
> be overriden) - all of whom deal with the code affected by these changes 
> on a daily basis and have an interest in CPU isolation features.
See above. 
Following issues were raised:
1. Peter and Steven initially thought that workqueue isolation is not needed.
2. Paul thought that it should be implemented on top of cpusets.
3. Peter thought that stopmachine change is not safe.
There were a couple of other minor misunderstandings (for example Peter thought 
that I'm completely disallowing IRQs on isolated CPUs, which is obviously not
the case). I clarified all of them.

#1 I explained in the original thread and then followed up with concrete code example
of why it is needed.
	http://marc.info/?l=linux-kernel&m=120217173001671&w=2
Got no replies so far. So I'm assuming folks are happy.

#2 I started a separate thread on that
	http://marc.info/?l=linux-kernel&m=120180692331461&w=2
The conclusion was, well let me just quote exactly what Paul had said:
----
> Paul Jackson wrote:
>> Max wrote:
>>> Looks like I failed to explain what I'm trying to achieve. So let me try again.
>> 
>> Well done.  I read through that, expecting to disagree or at least
>> to not understand at some point, and got all the way through nodding
>> my head in agreement.  Good.
>> 
>> Whether the earlier confusions were lack of clarity in the presentation,
>> or lack of competence in my brain ... well guess I don't want to ask that
>> question ;).
----

And #3 Peter did not agree with me but said that it's up to Linus or Andrew to decide
whether it's appropriate in mainline or not. I _clearly_ indicated that this part is
somewhat controversial and maybe dangerous, I'm _not_ trying to sneak something in. 
Andrew picked it up and I'm going to do some more investigation on whether it's really
not safe or is actually fine (about to send an email to Rusty).

> Generally i think that cpusets is actually the feature and API that 
> should be used (and extended) for CPU isolation - and we already 
> extended it recently in the direction of CPU isolation. Most enterprise 
> distros have cpusets enabled so it's in use. Also, cpusets has the 
> appeal of being commonly used in the "big honking boxes" arena, so 
> reusing the same concept for RT and virtualization stuff would be the 
> natural approach. It already ties in to the scheduler domains code 
> dynamically and is flexible and scalable. I resisted ad-hoc CPU 
> isolation patches in -rt for that reason. 
That's exactly what Paul proposed initially. I completely disagree with that but I did look 
at it in _detail_. 
Please take a look here for detailed explanation
	http://marc.info/?l=linux-kernel&m=120180692331461&w=2
This email getting to long and I did not want to inline everything.

> Also, i'd not mind some test-coverage in sched.git as well.
I believe it has _nothing_ to do with the "scheduler" but I do not mind it being in that tree.
Please read this email on why it has nothing to do with the scheduler
	http://marc.info/?l=linux-kernel&m=120210515323578&w=2
That's the email that convinced Paul.

To sum it up. It has been discussed with the right people. I do not believe that pull
request was premature. In fact I think we're making a bigger deal out of these simple
changes than it should be. At the end of the day those features are disabled by default
and do _not_ affect _anything_. But like I said I'll play by the rules. So ...

Next step for me is to address Andrew's comments, I'll resent the patches with those.
And to follow up with Andrew and Rusty on the stopmachine thing.

Thanks for your reply.
Max
