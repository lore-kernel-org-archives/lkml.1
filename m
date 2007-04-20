Return-Path: <linux-kernel-owner+w=401wt.eu-S1754362AbXDTCB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbXDTCB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 22:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754363AbXDTCB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 22:01:26 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:24813 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358AbXDTCBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 22:01:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:user-agent:cc:references:in-reply-to:mime-version:content-disposition:date:content-type:content-transfer-encoding:message-id;
        b=dpXtzijC6OwN0yNCoarhtPvWfdT/fLCNoNFtexKYpryo4BETZwDzJ4IADRXlvAP3TQ3r82VBoxnEHCCsZFQemWjKPrWJUZQEspSlobNRTDLCE2yu6HF0kp82lYA0i/AC4EJS8SeMwZWhbCtT143l+V6wQryGe/mTHwVdRaAW47Q=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Con Kolivas <kernel@kolivas.org>
Subject: Re: Renice X for cpu schedulers
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20070417062621.GL2986@holomorphy.com> <200704191416.14374.gene.heskett@gmail.com> <200704200847.30516.kernel@kolivas.org>
In-Reply-To: <200704200847.30516.kernel@kolivas.org>
MIME-Version: 1.0
Content-Disposition: inline
Date: Thu, 19 Apr 2007 22:01:21 -0400
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200704192201.21610.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 April 2007, Con Kolivas wrote:
>On Friday 20 April 2007 04:16, Gene Heskett wrote:
>> On Thursday 19 April 2007, Con Kolivas wrote:
>>
>> [and I snipped a good overview]
>>
>> >So yes go ahead and think up great ideas for other ways of metering out
>> > cpu bandwidth for different purposes, but for X, given the absurd
>> > simplicity of renicing, why keep fighting it? Again I reiterate that
>> > most users of SD have not found the need to renice X anyway except if
>> > they stick to old habits of make -j4 on uniprocessor and the like, and I
>> > expect that those on CFS and Nicksched would also have similar
>> > experiences.
>>
>> FWIW folks, I have never touched x's niceness, its running at the default
>> -1 for all of my so-called 'tests', and I have another set to be rebooted
>> to right now.  And yes, my kernel makeit script uses -j4 by default, and
>> has used -j8 just for effects, which weren't all that different from what
>> I expected in 'abusing' a UP system that way.  The system DID remain
>> usable, not snappy, but usable.
>
>Gene, you're agreeing with me. You've shown that you're very happy with a
> fair distribution of cpu and leaving X at nice 0.

I was quite happy till Ingo's first patch came out, and it was even better, 
but I over-wrote it, and we're still figuring out just exactly what the magic 
twanger was that made it all click for me.  OTOH, I don't think that patch 
passed muster with Mike G., either.  We have obviously different workloads, 
and critical points in them.

>> Having tried re-nicing X a while back, and having the rest of the system
>> suffer in quite obvious ways for even 1 + or - from its default felt
>> pretty bad from this users perspective.
>>
>> It is my considered opinion (yeah I know, I'm just a leaf in the hurricane
>> of this list) that if X has to be re-niced from the 1 point advantage its
>> had for ages, then something is basicly wrong with the overall scheduling,
>> cpu or i/o, or both in combination.  FWIW I'm using cfq for i/o.
>
>It's those who want X to have an unfair advantage that want it to do
>something "special". Your agreement that it works fine at nice 0 shows you
>don't want it to have an unfair advantage. Others who want it to have an
>unfair advantage _can_ renice it if they desire. But if the cpu scheduler
>gives X an unfair advantage within the kernel by default then you have _no_
>choice. If you leave the choice up to userspace (renice or not) then both
>parties get their way. If you put it into the kernel only one party wins and
>there is no way for the Genes (and Cons) of this world to get it back.
>
>Your opinion is as valuable as eveyone else's Gene. It is hard to get people
>to speak on as frightening a playground as the linux kernel mailing list so
>please do.

In the FWIW category, htop has always told me that x is running at -1, not 
zero.  Now, I have NDI where this is actually set at, so I'd have to ask 
stupid questions here if I did wanna play with it.  Which I really don't, the 
last time I tried to -5 x, kde got a whole lot LESS responsive.  But heck, 
2.6.2 was freshly minted then too and I've long since forgot how I went about 
that unless I used htop to change it, the most likely scenario that I can 
picture at this late date. 

As for speaking my mind, yes, and I've been slapped down a few times, as much 
because I do a lot of bitching and microscopic amounts of patch submission. 
The only patch I ever submitted was for something in the floppy driver, way 
back in the middle of 2.2 days, rejected because I didn't know how to use the 
tools correctly.  I didn't, so it was a shrug and my feelings weren't hurt.

Some see that as an unbalanced set of books and I'm aware of it.  OTOH, I 
think I do a pretty good job of playing the canary here, and that should be 
worth something if for no other reason than I can turn into a burr under 
somebodies saddle when things go all aglay.  But I figure if its happening to 
me, then if I don't fuss, and that gotcha gets into a distro kernel, there 
are gonna be a hell of a lot more folks than me trying to grab the 
microphone.

BTW, I'm glad you are feeling well enough to get into this again.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
There cannot be a crisis next week.  My schedule is already full.
		-- Henry Kissinger
