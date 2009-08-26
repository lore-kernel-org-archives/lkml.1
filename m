Return-Path: <linux-kernel-owner+w=401wt.eu-S932460AbZHZAVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460AbZHZAVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 20:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932375AbZHZAVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 20:21:30 -0400
Received: from mail-pz0-f194.google.com ([209.85.222.194]:54475 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932366AbZHZAV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 20:21:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VjoyeZDAJ4hG0eAf2ToWCJJwUJm0rjRRKb0uHSKT6D5sm2CZdZriyzS60fbV/j/f5/
         sYv49429T2J9YVIwXvOM0pGI06B5CFned1Ww0Qo/y9aaFBjyh6ETn8NxDuo/pMI4XlK9
         ADwtU/oostvAM3SQTCZ/aKKmE5cmeG2zoU1dE=
Message-ID: <4A94803A.5060408@gmail.com>
Date: Tue, 25 Aug 2009 17:22:18 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009031304)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: system gets stuck in a lock during boot
References: <alpine.DEB.2.00.0908181926410.28398@gandalf.stny.rr.com> <4A8B4607.6090303@gmail.com> <4A8B5113.20102@cn.fujitsu.com> <4A8FA2BD.4030707@gmail.com> <4A91FDED.9050801@cn.fujitsu.com> <1251093523.7538.118.camel@twins> <4A922F82.9080000@cn.fujitsu.com> <1251096925.7538.121.camel@twins> <4A9251EB.8040805@gmail.com> <dd18b0c30908241219mdb76311t9334929f34f2c4c3@mail.gmail.com> <20090825085919.GB14003@elte.hu>
In-Reply-To: <20090825085919.GB14003@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Justin Mattock<justinmattock@gmail.com>  wrote:
>
>    
>> O.K. I feel better, deleted
>> my system, and threw in a minimal built system
>> with only the bare essentials to boot.
>> (just to make sure things are correct).
>>
>> unfortunately after building rc6 I'm still hitting
>> this. really am not sure why this is happening.
>>      
>
> Could you please double-check the bisection result by doing this:
>
>   git revert af6af30c0f
>
> on the latest kernel and seeing whether that fixes the lockup?
>
> Bisections are very efficient and hence very sensitive as well to
> minimal errors. Just one small mistake near the end of a bisection
> can blame the wrong commit.
>
> So the best way to double-check such 100%-triggerable crashes is to
> do the revert. I tried the revert and it can be done fine here.
>
> [ _If_ that does not fix the bug then to save time you can
>     'backtrack' the bisection, instead of re-doing it completely.
>     I.e. you have your bisection log, re-check the final steps going
>     backwards. Once you find a discrepancy (i.e. a 'bad' point that
>     is 'good' or the other way around), redo the bisection log
>     commands up to that point and continue it up to the end. ]
>
> 	Ingo
>
>    
shoot, I did not see your post here.
when looking at my bisect log, I guess after a
git bisect reset it clears?

Anyways after git bisect had finished
I looked manually at the commits that it
had generated
the one which I had sent in a post previously, and
this one:
  9424edc2da097c8589fcc24a72552d33e54be161

at the time looking at the commit, I see this to be
more of the cause because of  it being related to elf as so forth,
but as soon as I reverted this on rc6
made no difference.(the previous commit fixes this for
me, on a regular tar.ball as well as in git.

I think at this point since this system is a fresh from scratch
build,  I think something might be wrong that I'm doing
(all the CFLAGS, and such are in a previous post).

At the moment I don't have a problem applying a patch
to the kernel for this. especially since I'm the only one that seems
to be hitting this, then if more and more reports of this happen
then we can go from there.

Justin P. Mattock

