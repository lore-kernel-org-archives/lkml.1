Return-Path: <linux-kernel-owner+w=401wt.eu-S1755790AbZJFBBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790AbZJFBBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 21:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755686AbZJFBBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 21:01:04 -0400
Received: from mail-ew0-f217.google.com ([209.85.219.217]:40347 "EHLO
	mail-ew0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497AbZJFBBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 21:01:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=b+mDTthHR1NV24ObFIvaXXuHJZoDu3mjXxGOSqPCdLQZ2lDoH9zosjfIZ97EhWwK54
         cWimRlIemeUsiMMYJ+dQZmULlYBX+P1BuesXzdRjAwlpnz8fZoBMdkMAvnDPV4eCGQuL
         tK3REzYV6TBH8F18JaaQuGWT5hXAbUwA9bwRs=
Message-ID: <4ACA96B9.7000909@gmail.com>
Date: Mon, 05 Oct 2009 18:00:41 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jason Baron <jbaron@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: system gets stuck in a lock during boot
References: <4A922F82.9080000@cn.fujitsu.com> <4A9251EB.8040805@gmail.com>	 <dd18b0c30908241219mdb76311t9334929f34f2c4c3@mail.gmail.com>	 <20090825085919.GB14003@elte.hu> <4A94803A.5060408@gmail.com>	 <20090826073351.GE23435@elte.hu> <4A9549E5.5020002@gmail.com>	 <dd18b0c30909071449q6834e847yb0f27ec971c9564a@mail.gmail.com>	 <20091002211211.GA2633@redhat.com> <20091004174113.GB24418@elte.hu> <dd18b0c30910041710y15e1da1k348c0decc05f326f@mail.gmail.com>
In-Reply-To: <dd18b0c30910041710y15e1da1k348c0decc05f326f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Mattock wrote:
> On Sun, Oct 4, 2009 at 10:41 AM, Ingo Molnar<mingo@elte.hu>  wrote:
>    
>> * Jason Baron<jbaron@redhat.com>  wrote:
>>
>>      
>>> On Mon, Sep 07, 2009 at 02:49:44PM -0700, Justin Mattock wrote:
>>>        
>>>>>> * Justin P. Mattock<justinmattock@gmail.com>    wrote:
>>>>>>
>>>>>>
>>>>>>              
>>>>>>> Ingo Molnar wrote:
>>>>>>>
>>>>>>>                
>>>>>>>> * Justin Mattock<justinmattock@gmail.com>     wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>                  
>>>>>>>>> O.K. I feel better, deleted
>>>>>>>>> my system, and threw in a minimal built system
>>>>>>>>> with only the bare essentials to boot.
>>>>>>>>> (just to make sure things are correct).
>>>>>>>>>
>>>>>>>>> unfortunately after building rc6 I'm still hitting
>>>>>>>>> this. really am not sure why this is happening.
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>                    
>>>>>>>> Could you please double-check the bisection result by doing this:
>>>>>>>>
>>>>>>>>    git revert af6af30c0f
>>>>>>>>
>>>>>>>> on the latest kernel and seeing whether that fixes the lockup?
>>>>>>>>
>>>>>>>> Bisections are very efficient and hence very sensitive as well to
>>>>>>>> minimal errors. Just one small mistake near the end of a bisection
>>>>>>>> can blame the wrong commit.
>>>>>>>>
>>>>>>>> So the best way to double-check such 100%-triggerable crashes is to
>>>>>>>> do the revert. I tried the revert and it can be done fine here.
>>>>>>>>
>>>>>>>> [ _If_ that does not fix the bug then to save time you can
>>>>>>>>      'backtrack' the bisection, instead of re-doing it completely.
>>>>>>>>      I.e. you have your bisection log, re-check the final steps going
>>>>>>>>      backwards. Once you find a discrepancy (i.e. a 'bad' point that
>>>>>>>>      is 'good' or the other way around), redo the bisection log
>>>>>>>>      commands up to that point and continue it up to the end. ]
>>>>>>>>
>>>>>>>>         Ingo
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>                  
>>>>>>> shoot, I did not see your post here. when looking at my bisect
>>>>>>> log, I guess after a git bisect reset it clears?
>>>>>>>
>>>>>>> Anyways after git bisect had finished I looked manually at the
>>>>>>> commits that it had generated the one which I had sent in a post
>>>>>>> previously, and this one:
>>>>>>>
>>>>>>>   9424edc2da097c8589fcc24a72552d33e54be161
>>>>>>>
>>>>>>>                
>>>>>> (this commit has no effect on your kernel image, at all.)
>>>>>>
>>>>>>
>>>>>>              
>>>>> yep. but it was worth a try.
>>>>>            
>>>>>>> at the time looking at the commit, I see this to be more of the
>>>>>>> cause because of it being related to elf as so forth, but as soon
>>>>>>> as I reverted this on rc6 made no difference.(the previous commit
>>>>>>> fixes this for me, on a regular tar.ball as well as in git.
>>>>>>>
>>>>>>> I think at this point since this system is a fresh from scratch
>>>>>>> build, I think something might be wrong that I'm doing (all the
>>>>>>> CFLAGS, and such are in a previous post).
>>>>>>>
>>>>>>> At the moment I don't have a problem applying a patch to the
>>>>>>> kernel for this. especially since I'm the only one that seems to
>>>>>>> be hitting this, then if more and more reports of this happen then
>>>>>>> we can go from there.
>>>>>>>
>>>>>>>                
>>>>>> What would be nice is to verify your bisection end result, i.e. do
>>>>>> what i suggested:
>>>>>>
>>>>>>
>>>>>>              
>>>>> yeah I've done this on both kernels three to be exact, and all boot after
>>>>> reverting
>>>>> Fix perf-tracepoint OOPS.
>>>>>
>>>>> As for my system, I'm still convinced that I might be doing something wrong
>>>>> over here.
>>>>>
>>>>>            
>>>>>>>> Could you please double-check the bisection result by doing this:
>>>>>>>>
>>>>>>>>    git revert af6af30c0f
>>>>>>>>
>>>>>>>> on the latest kernel and seeing whether that fixes the lockup?
>>>>>>>>
>>>>>>>>                  
>>>>>> if this doesnt fix it on latest -git then this commit is not the
>>>>>> cause of the lockup.
>>>>>>
>>>>>>         Ingo
>>>>>>
>>>>>>
>>>>>>              
>>>>> This commit(Fix perf-tracepoint OOPS.)does fix my stuckage, but I'm left, as
>>>>> well as others asking
>>>>> the question of why.
>>>>> In any case I still think I'm setting something wrong with either gcc, or
>>>>> something
>>>>> that might be causing this from userland.
>>>>>
>>>>> Justin P. Mattock
>>>>>
>>>>>            
>>>> O.k. here something awkward about this issue I was
>>>> experiencing. at the moment I have two imac's
>>>> here the descriptions:
>>>>
>>>> imac A) the one with the problem
>>>>
>>>> OS: built from the clfs book
>>>> x86_64 multilib with only lib64
>>>>
>>>> built everything with these flags:
>>>> CFLAGS="-m64 -mtune=core2 -march=core2
>>>> -mfpmath=both -O2 -pipe -fomit-frame-pointer
>>>> -fstack-protection"
>>>> CXXFLAGS="${CFLAGS}" MAKEOPTS="{-j3}"
>>>> while compiling everything with
>>>> gcc version: 4.5.0 20090730
>>>>
>>>>
>>>> imac B) the one that works
>>>>
>>>> OS: clfs(just built a few days ago)
>>>> x86_64 pure64 bit build
>>>> (lib with a symlink to lib64)
>>>> CFLAGS="-m64 -mtune=core2 -march=core2
>>>>   -O2 -pipe -fomit-frame-pointer"
>>>> CXXFLAGS="${CFLAGS}" MAKEOPTS="{-j3}"
>>>> gcc version: 4.4.1 (GCC for Cross-LFS 4.4.1.20090722)
>>>>
>>>> The only things I can think of is either I hit something
>>>> because of gcc, something goes wrong with the libraries,
>>>> or there something happening with either the option
>>>> of mfpmath=both or stackprotection.
>>>>
>>>> At this point since the kernel seems to be running fine,
>>>> is to just trash the system that has this issue and just leave
>>>> it at, I was hitting some weird anomaly.
>>>>
>>>>          
>>> hi Justin,
>>>
>>> I've been playing around with gcc '4.5' as well and hit a panic that
>>> looks very similar to what you've seen with stock 2.6.31 - I haven't
>>> seen it anywhere else. Anyways, it seems to be some sort of alignment
>>> issue with the 'struct ftrace_event_call'. I'm not sure yet if this is a
>>> compiler or kernel issue. But the following kernel patch fixes the issue
>>> for me. It would be interesting to verify if the patch also resolves the
>>> issue for you.
>>>        
>> Would be nice to know precisely what kind of problem is being hit here -
>> we'd like to fix either the kernel or GCC - depending on where the bug
>> lies.
>>
>>         Ingo
>>
>>      
>
> So I wasn't going crazy....
> Anyways that system(clfs)
> I still have, I can go ahead and
> put it back on the machine and see if I hit this
> again(keep in mind, just got back from a 7hr drive,
> so it might be tomorrow).
>
>    
o.k. I put back on that system, and
hit the error. I add your patch to 2.6.31-rc6,
and the latest git(a few days old).
I still am hitting this, but with your patch
I'm able to see the beginning of this panic:
(Ill write it manually)

[   2.523966] kernel panic - not syncing: No init found. try passing 
init= option
to the kernel
[   2.524394] Pid: 1, comm: swapper Not tainted 2.6.31-rc6 #6
[   2.524633] Call Trace:
[   2.524875] [<ffffffff813a5b72>] panic+0x75/0x120
[   2.525119] [<ffffffff8100910f>] init_post+0xef/0xf5
[   2.525357] [<ffffffff815f6cf0>] kernel_init+0x198/0x1a3
[   2.525600] [<ffffffff8102410a>] child_rip+0xa/0x20
[   2.525842] [<ffffffff815f6b58>] ? kernel_init+0x0/0x1a3
[   2.526084] [>ffffffff810224100>] ? child_rip+0x0/0x20

Seems I only hit this with using gcc 4.5.0 and compiling
sysvinit with SELinux support to load the policy at boot.
(here's the patch I used
http://readlist.com/lists/tycho.nsa.gov/selinux/3/15451.html).

Sound's like gcc is doing something(correct me if I'm
wrong) because the other systems I have are using the same
packages except for and older version of gcc.
maybe  I should update sysvinit with a better patch to load the policy.

Justin P. Mattock
