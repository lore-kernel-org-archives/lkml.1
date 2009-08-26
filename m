Return-Path: <linux-kernel-owner+w=401wt.eu-S1757215AbZHZHeD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215AbZHZHeD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 03:34:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757202AbZHZHeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 03:34:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60488 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757201AbZHZHeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 03:34:01 -0400
Date: Wed, 26 Aug 2009 09:33:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: system gets stuck in a lock during boot
Message-ID: <20090826073351.GE23435@elte.hu>
References: <4A8B5113.20102@cn.fujitsu.com> <4A8FA2BD.4030707@gmail.com> <4A91FDED.9050801@cn.fujitsu.com> <1251093523.7538.118.camel@twins> <4A922F82.9080000@cn.fujitsu.com> <1251096925.7538.121.camel@twins> <4A9251EB.8040805@gmail.com> <dd18b0c30908241219mdb76311t9334929f34f2c4c3@mail.gmail.com> <20090825085919.GB14003@elte.hu> <4A94803A.5060408@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A94803A.5060408@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Justin P. Mattock <justinmattock@gmail.com> wrote:

> Ingo Molnar wrote:
>> * Justin Mattock<justinmattock@gmail.com>  wrote:
>>
>>    
>>> O.K. I feel better, deleted
>>> my system, and threw in a minimal built system
>>> with only the bare essentials to boot.
>>> (just to make sure things are correct).
>>>
>>> unfortunately after building rc6 I'm still hitting
>>> this. really am not sure why this is happening.
>>>      
>>
>> Could you please double-check the bisection result by doing this:
>>
>>   git revert af6af30c0f
>>
>> on the latest kernel and seeing whether that fixes the lockup?
>>
>> Bisections are very efficient and hence very sensitive as well to
>> minimal errors. Just one small mistake near the end of a bisection
>> can blame the wrong commit.
>>
>> So the best way to double-check such 100%-triggerable crashes is to
>> do the revert. I tried the revert and it can be done fine here.
>>
>> [ _If_ that does not fix the bug then to save time you can
>>     'backtrack' the bisection, instead of re-doing it completely.
>>     I.e. you have your bisection log, re-check the final steps going
>>     backwards. Once you find a discrepancy (i.e. a 'bad' point that
>>     is 'good' or the other way around), redo the bisection log
>>     commands up to that point and continue it up to the end. ]
>>
>> 	Ingo
>>
>>    
> shoot, I did not see your post here. when looking at my bisect 
> log, I guess after a git bisect reset it clears?
>
> Anyways after git bisect had finished I looked manually at the 
> commits that it had generated the one which I had sent in a post 
> previously, and this one:
>
>  9424edc2da097c8589fcc24a72552d33e54be161

(this commit has no effect on your kernel image, at all.)

> at the time looking at the commit, I see this to be more of the 
> cause because of it being related to elf as so forth, but as soon 
> as I reverted this on rc6 made no difference.(the previous commit 
> fixes this for me, on a regular tar.ball as well as in git.
>
> I think at this point since this system is a fresh from scratch 
> build, I think something might be wrong that I'm doing (all the 
> CFLAGS, and such are in a previous post).
>
> At the moment I don't have a problem applying a patch to the 
> kernel for this. especially since I'm the only one that seems to 
> be hitting this, then if more and more reports of this happen then 
> we can go from there.

What would be nice is to verify your bisection end result, i.e. do 
what i suggested:

>> Could you please double-check the bisection result by doing this:
>>
>>   git revert af6af30c0f
>>
>> on the latest kernel and seeing whether that fixes the lockup?

if this doesnt fix it on latest -git then this commit is not the 
cause of the lockup.

	Ingo
