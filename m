Return-Path: <linux-kernel-owner+w=401wt.eu-S1751106AbZHZOmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751106AbZHZOmB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 10:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750980AbZHZOmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 10:42:00 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:58784 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbZHZOl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 10:41:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=RNaukTXr8r4a2Ys8AJajEehxlpra/tdv5HgsHVo0W3rkW9NPoTfES5zl0j7fiEy1+R
         2ws3gUPSlvtm5BjgcdjyiVRZBwRXiZwmwZAVCGnrREmBQPcjtwark2Ca6I6GeKolzLb8
         Vfy4Vs0oEBbITzy67RdrhqcU7e2Eo0ibnri6I=
Message-ID: <4A9549E5.5020002@gmail.com>
Date: Wed, 26 Aug 2009 07:42:45 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009031304)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: system gets stuck in a lock during boot
References: <4A8B5113.20102@cn.fujitsu.com> <4A8FA2BD.4030707@gmail.com> <4A91FDED.9050801@cn.fujitsu.com> <1251093523.7538.118.camel@twins> <4A922F82.9080000@cn.fujitsu.com> <1251096925.7538.121.camel@twins> <4A9251EB.8040805@gmail.com> <dd18b0c30908241219mdb76311t9334929f34f2c4c3@mail.gmail.com> <20090825085919.GB14003@elte.hu> <4A94803A.5060408@gmail.com> <20090826073351.GE23435@elte.hu>
In-Reply-To: <20090826073351.GE23435@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Justin P. Mattock<justinmattock@gmail.com>  wrote:
>
>    
>> Ingo Molnar wrote:
>>      
>>> * Justin Mattock<justinmattock@gmail.com>   wrote:
>>>
>>>
>>>        
>>>> O.K. I feel better, deleted
>>>> my system, and threw in a minimal built system
>>>> with only the bare essentials to boot.
>>>> (just to make sure things are correct).
>>>>
>>>> unfortunately after building rc6 I'm still hitting
>>>> this. really am not sure why this is happening.
>>>>
>>>>          
>>> Could you please double-check the bisection result by doing this:
>>>
>>>    git revert af6af30c0f
>>>
>>> on the latest kernel and seeing whether that fixes the lockup?
>>>
>>> Bisections are very efficient and hence very sensitive as well to
>>> minimal errors. Just one small mistake near the end of a bisection
>>> can blame the wrong commit.
>>>
>>> So the best way to double-check such 100%-triggerable crashes is to
>>> do the revert. I tried the revert and it can be done fine here.
>>>
>>> [ _If_ that does not fix the bug then to save time you can
>>>      'backtrack' the bisection, instead of re-doing it completely.
>>>      I.e. you have your bisection log, re-check the final steps going
>>>      backwards. Once you find a discrepancy (i.e. a 'bad' point that
>>>      is 'good' or the other way around), redo the bisection log
>>>      commands up to that point and continue it up to the end. ]
>>>
>>> 	Ingo
>>>
>>>
>>>        
>> shoot, I did not see your post here. when looking at my bisect
>> log, I guess after a git bisect reset it clears?
>>
>> Anyways after git bisect had finished I looked manually at the
>> commits that it had generated the one which I had sent in a post
>> previously, and this one:
>>
>>   9424edc2da097c8589fcc24a72552d33e54be161
>>      
>
> (this commit has no effect on your kernel image, at all.)
>
>    
yep. but it was worth a try.
>> at the time looking at the commit, I see this to be more of the
>> cause because of it being related to elf as so forth, but as soon
>> as I reverted this on rc6 made no difference.(the previous commit
>> fixes this for me, on a regular tar.ball as well as in git.
>>
>> I think at this point since this system is a fresh from scratch
>> build, I think something might be wrong that I'm doing (all the
>> CFLAGS, and such are in a previous post).
>>
>> At the moment I don't have a problem applying a patch to the
>> kernel for this. especially since I'm the only one that seems to
>> be hitting this, then if more and more reports of this happen then
>> we can go from there.
>>      
>
> What would be nice is to verify your bisection end result, i.e. do
> what i suggested:
>
>    
yeah I've done this on both kernels three to be exact, and all boot 
after reverting
Fix perf-tracepoint OOPS.

As for my system, I'm still convinced that I might be doing something 
wrong over here.

>>> Could you please double-check the bisection result by doing this:
>>>
>>>    git revert af6af30c0f
>>>
>>> on the latest kernel and seeing whether that fixes the lockup?
>>>        
>
> if this doesnt fix it on latest -git then this commit is not the
> cause of the lockup.
>
> 	Ingo
>
>    
This commit(Fix perf-tracepoint OOPS.)does fix my stuckage, but I'm 
left, as well as others asking
the question of why.
In any case I still think I'm setting something wrong with either gcc, 
or something
that might be causing this from userland.

Justin P. Mattock
