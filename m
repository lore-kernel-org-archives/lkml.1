Return-Path: <linux-kernel-owner+w=401wt.eu-S1753141AbXDOQ7F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbXDOQ7F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 12:59:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbXDOQ7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 12:59:05 -0400
Received: from wx-out-0506.google.com ([66.249.82.230]:57076 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbXDOQ7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 12:59:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=VD4FKTHoe8cs/hxwdN1nZXSOxLIXOQCaG9UOjAgTPB9LH1kQsRD/g03D2SIiEY7KJQJU/0Ly+eDRCewotubFmRNzDcAkMDqh6Xhmg6WVu9t7he7+8j3B3L7RUFleoY8AWbrZtzQheRJvICLEq2nssDR0TnTkKegbNmaHOPsQFh4=
Organization: Organization? Not detectable
To: Con Kolivas <kernel@kolivas.org>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Date: Sun, 15 Apr 2007 12:58:48 -0400
User-Agent: KMail/1.9.6
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "hui Bill Huey" <billh@gnuppy.monkey.org>,
       "Ingo Molnar" <mingo@elte.hu>, "ck list" <ck@vds.kolivas.org>,
       "Peter Williams" <pwil3058@bigpond.net.au>,
       linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Nick Piggin" <npiggin@suse.de>, "Mike Galbraith" <efault@gmx.de>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
References: <20070413202100.GA9957@elte.hu> <200704151116.20530.gene.heskett@verizon.net> <200704160243.01395.kernel@kolivas.org>
In-Reply-To: <200704160243.01395.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704151258.48857.gene.heskett@verizon.net>
From: Gene Heskett <gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 April 2007, Con Kolivas wrote:
>On Monday 16 April 2007 01:16, Gene Heskett wrote:
>> On Sunday 15 April 2007, Pekka Enberg wrote:
>> >On 4/15/07, hui Bill Huey <billh@gnuppy.monkey.org> wrote:
>> >> The perception here is that there is that there is this expectation
>> >> that sections of the Linux kernel are intentionally "churn squated" to
>> >> prevent any other ideas from creeping in other than of the owner of
>> >> that subsytem
>> >
>> >Strangely enough, my perception is that Ingo is simply trying to
>> >address the issues Mike's testing discovered in RDSL and SD. It's not
>> >surprising Ingo made it a separate patch set as Con has repeatedly
>> >stated that the "problems" are in fact by design and won't be fixed.
>>
>> I won't get into the middle of this just yet, not having decided which dog
>> I should bet on yet.  I've been running 2.6.21-rc6 + Con's 0.40 patch for
>> about 24 hours, its been generally usable, but gzip still causes lots of 5
>> to 10+ second lags when its running.  I'm coming to the conclusion that
>> gzip simply doesn't play well with others...
>
>Actually Gene I think you're being bitten here by something I/O bound since
>the cpu usage never tops out. If that's the case and gzip is dumping
>truckloads of writes then you're suffering something that irks me even more
>than the scheduler in linux, and that's how much writes hurt just about
>everything else. Try your testcase with bzip2 instead (since that won't be
>i/o bound), or drop your dirty ratio to as low as possible which helps a
>little bit (5% is the minimum)
>
>echo 5 > /proc/sys/vm/dirty_ratio
>
>and finally try the braindead noop i/o scheduler as well.
>
>echo noop > /sys/block/sda/queue/scheduler
>
>(replace sda with your drive obviously).
>
>I'd wager a big one that's what causes your gzip pain. If it wasn't for the
>fact that I've decided to all but give up ever trying to provide code for
>mainline again, trying my best to make writes hurt less on linux would be my
>next big thing [tm].

Chuckle, possibly but then I'm not anything even remotely close to an expert 
here Con, just reporting what I get.  And I just rebooted to 2.6.21-rc6 + 
sched-mike-5.patch for grins and giggles, or frowns and profanity as the case 
may call for.

>Oh and for the others watching, (points to vm hackers) I found a bug when
>playing with the dirty ratio code. If you modify it to allow it drop below
> 5% but still above the minimum in the vm code, stalls happen somewhere in
> the vm where nothing much happens for sometimes 20 or 30 seconds worst case
> scenario. I had to drop a patch in 2.6.19 that allowed the dirty ratio to
> be set ultra low because these stalls were gross.

I think I'd need a bit of tutoring on how to do that.  I recall that one other 
time, several weeks back, I thought I would try one of those famous echo this 
>/proc/that ideas that went by on this list, but even though I was root, 
apparently /proc was read-only AFAIWC.

>> Amazing to me, the cpu its using stays generally below 80%, and often
>> below 60%, even while the kmail composer has a full sentence in its buffer
>> that it still hasn't shown me when I switch to the htop screen to check,
>> and back to the kmail screen to see if its updated yet.  The screen switch
>> doesn't seem to lag so I don't think renicing x would be helpfull.  Those
>> are the obvious lags, and I'll build & reboot to the CFS patch at some
>> point this morning (whats left of it that is :).  And report in due time
>> of course

And now I wonder if I applied the right patch.  This one feels good ATM, but I 
don't think its the CFS thingy.  No, I'm sure of it now, none of the patches 
I've saved say a thing about CFS.  Backtrack up the list time I guess, ignore 
me for the nonce.


-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Microsoft: Re-inventing square wheels

   -- From a Slashdot.org post
