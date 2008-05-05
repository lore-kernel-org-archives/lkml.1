Return-Path: <linux-kernel-owner+w=401wt.eu-S1760260AbYEEXRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760260AbYEEXRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 19:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbYEEXRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 19:17:08 -0400
Received: from mail.lang.hm ([64.81.33.126]:52541 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387AbYEEXRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 19:17:06 -0400
Date: Mon, 5 May 2008 16:19:13 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: Arjan van de Ven <arjan@infradead.org>
cc: "Randy.Dunlap" <rdunlap@xenotime.net>, Ingo Molnar <mingo@elte.hu>,
       Adrian Bunk <bunk@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Alexander Viro <viro@ftp.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [rfc] the kernel workflow & trivial "global -> static" patches
 (was: Re: [2.6 patch] make sched_feat_{names,open} static)
In-Reply-To: <20080505145132.58df7e70@infradead.org>
Message-ID: <alpine.DEB.1.10.0805051615080.14481@asgard>
References: <20080505182942.GA17139@cs181133002.pp.htv.fi> <20080505201906.GA900@elte.hu> <Pine.LNX.4.64.0805051327530.27703@shark.he.net> <20080505145132.58df7e70@infradead.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2008, Arjan van de Ven wrote:

> On Mon, 5 May 2008 13:40:53 -0700 (PDT)
> "Randy.Dunlap" <rdunlap@xenotime.net> wrote:
>
>> On Mon, 5 May 2008, Ingo Molnar wrote:
>>
>>> And unlike other kernel developers, my opinion is not that we
>>> should eliminate this disruption by not doing these trivial patches
>>> _at all_. My opinion is that we should make it easier for
>>> maintainers to _avoid introducing_ these problems.
>>>
>>> I.e. we need to fight the root of this problem (the steady
>>> introduction of needlessly global symbols), not its symptoms (the
>>> needlessly global symbols themselves).
>>
>> in some automated ways...
>>
>> We have Documentation/SubmitChecklist that we hope that patch
>> submitters will use, but we have little evidence that they (we) do
>> use it, and we have some evidence that they (we) do NOT use it.
>> (but this isn't automated)
>>
>> I see being related to DaveM's "Slow down, please" thread.
>> We have developers hurriedly writing new code but not paying enough
>> attention to code that they have already written.
>> (not directed at anyone in particular)
>>
>> E.g., you do maybe 200 randconfig builds per day.  I only do
>> 20 - 50, but we both find too many problems (IMHO).
>>
>>> Let me raise some thoughts about what we could do to achieve these
>>> goals.
>>
>> Good discussion material.
>>
>
>
> can we do a "make patchcheck" kernel build target that would
> * run checkpatch on teh patch
> * build the kernel without the patch (in various .configs, probably
> allyesconfig / allmodconfig is enough, but we can figure this out
> later)
> * apply the patch
> * build the kernel in the same configs
> * build a kernel for install that has the 'standard debug options' on
>  (lockdep, slabpoison etc)
> then we can
> * compare if new gcc warnings got introduced
> * compare if major stack usage got introduced
> * compare if namespace_check and some of the others introduce new issues
> * compare if new sparse warnings got introduced
> and maybe even run a bloat-o-meter to show code growth/shrinkage
> [insert other useful checks here]
>
> if all of that is just one command away, I bet quite a few people would
> use it
> (and the more useful it gets the more people will use it)
>
> yes you can do the same thing by hand.
> but yes it's many steps that are cumbersome if not automated... so few
> people will do it.
>
> If it's all in one step...
>

keep listing the checks you want to have done. I'll bet that if you can 
automate it enough you will have people setting up farms to do the 
compiles (or, ideally, package it with a seti-at-home type of thing and 
many people will donate spare cycles to grinding away at it)

how much value is lost if this is run on larger chunks? during the merge 
window the number of patches will exceed anyone's capability to check each 
one individually (not to mention it being a little late), but I think 
there would still be value in checking larger groups of patches.

David Lang
