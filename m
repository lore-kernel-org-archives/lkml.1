Return-Path: <linux-kernel-owner+w=401wt.eu-S1752556AbZDSXzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbZDSXzW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 19:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbZDSXzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 19:55:06 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33112 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbZDSXzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 19:55:05 -0400
Message-ID: <49EBB9D0.6060307@garzik.org>
Date: Sun, 19 Apr 2009 19:54:56 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/14] convert voyager over to the x86 quirks model
References: <1239724300-16371-1-git-send-email-James.Bottomley@HansenPartnership.com> <20090414165722.GD2089@elte.hu> <20090414180832.GA25692@elte.hu> <49E79B1E.9090405@garzik.org> <20090419233518.GA765@elte.hu>
In-Reply-To: <20090419233518.GA765@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeff Garzik <jeff@garzik.org> wrote:
> 
>> Ingo Molnar wrote:
>>> * Ingo Molnar <mingo@elte.hu> wrote:
>>>
>>>> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
>>>>
>>>>>  39 files changed, 554 insertions(+), 726 deletions(-)
>>>> That diffstat is not against current mainline, is it? Would you mind 
>>>> to send a proper diffstat with the revert included as well? That will 
>>>> give us a complete picture.
>>> ok, i did the calculations, and the effect of adding back x86/Voyager 
>>> is roughly:
>>>
>>>    48 files changed, 5226 insertions(+), 142 deletions(-)
>>>
>>> That's quite a lot, and lets put this into perspective.
>>>
>>> You are talking about moving ~5000 lines of legacy code back into  
>>> arch/x86/, for a total of *four* Voyager/Linux systems, which are  
>>> using _ancient_ 486/P5 era CPUs.
>>>
>>> Two of these systems are in your house, two are somewhere unknown:  
>>> their owners certainly never sent bugreports against recent mainline  
>>> kernels (Voyager didnt even _build_ for a couple of straight kernel  
>>> releases), and i suspect those boxes are probably decommissioned  
>>> already.
>>>
>>> A single core on my run-of-the-mill x86 laptop has more computing  
>>> power than all Voyager/Linux systems on the planet, combined. And you 
>>> now want to add back support to the mainline arch/x86 code, which we 
>>> are trying hard to keep running on millions of x86 Linux systems?
>>>
>>> You still have not given proper justification for doing that ...
>>>
>>> Sorry to be the one to say 'no', but the reasons you gave so far were 
>>> not very convincing to me.
>>>  Anyway, you seem to be willing to maintain this code it out of tree.  
>>> If someone owns such an ancient Voyager box and wants to test a new  
>>> kernel then your tree is a good starting point for doing that. There's 
>>> really no pressing need to have this in mainline.
>> That argument is more than a little unfair, Ingo.  Voyager support 
>> used to be in mainline.
> 
> The last time it built fine upstream was v2.6.26.0. After that:
> 
>   v2.6.27.0:   Voyager was broken - it did not even build.
>   v2.6.28.0:   Voyager was broken - it did not even build.
>   v2.6.29-rc5: Voyager was broken - it did not even build.
> 
> ... which was the point when we yanked it from the x86 devel tree.

Or IOW you waited less than a year (based on 2.6.26 release date).  That 
is quite impatient.  Getting feedback from dinosaur code is inevitably slow.

You did not even give user(s) the courtesy of putting a notice for many 
months in Documentation/feature-removal-schedule.txt after marking is 
CONFIG_BROKEN, either.


> ... at which time (after i Cc:-ed James Bottomley on the yanking) he 
> sent us the fix which we pulled - so v2.6.29 finally built. (But 
> even up to v2.6.27 Voyager was a rocky road - with regressions and 
> late fixes.)
> 
> Anyway, that long window of breakage has really proven the most 
> important fact: that no user really cares about x86/Voyager anymore.

Yet we can point to patches posted on LKML to remedy this.


>> It got yanked, and now you are adding all sorts of barriers for 
>> its re-inclusion?
> 
> It got yanked due to multiple releases with problems related to the 
> Voyager code - in the final ~3 development cycles it did not even 
> build.

Again -- under a year, and no mention in feature-removal-schedule.


> Regarding the new x86/Voyager submission: architecture or core 
> kernel level code always has a higher barrier of entry than driver 
> code for a number of good reasons:

No, my point is that it is blatantly unfair to remove code, then reset 
standards for inclusion far, far higher than at which it left the tree.

As long as James wants to maintain it, I don't see why we cannot settle 
for "it works and mostly isn't in Ingo's way"


> So i'm saying 'no' here, and i am NAK-ing its inclusion based on 
> past patterns of breakage and based on the utter irrelevance of a 
> ~133 Mhz Pentium based system for which only two existing instances 
> are known that have booted any recent kernel. If the code is 
> absolutely trouble-free out of tree, for an equivalent amount of 
> time (3 kernel releases or so), and gathers users/testers/etc., then 
> we might add it, after a thorough technical review. Not sooner than 
> that really. Meanwhile if James does not want to maintain it out of 
> tree he can ask Linus to overrule our NAK, but i'd like to ask him 
> to quote this NAK paragraph from me in his mail to Linus.

Sets a great pattern for pushing away enthusiasts, IMO.

We should not be zealous about yanking code from the tree.

	Jeff


