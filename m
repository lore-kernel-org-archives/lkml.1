Return-Path: <linux-kernel-owner+w=401wt.eu-S1756149AbYJWQtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149AbYJWQtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 12:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363AbYJWQtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 12:49:20 -0400
Received: from relay1.sgi.com ([192.48.171.29]:36051 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753858AbYJWQtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 12:49:19 -0400
Message-ID: <4900AB49.9040404@sgi.com>
Date: Thu, 23 Oct 2008 09:50:17 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [bug #2] Re: [PATCH 00/35] cpumask: Replace cpumask_t with	struct
 cpumask
References: <20081023020826.051012000@polaris-admin.engr.sgi.com> <20081023125529.GA18327@elte.hu> <20081023142025.GA18804@elte.hu> <200810240201.15037.rusty@rustcorp.com.au> <20081023160610.GA8853@elte.hu> <4900A3C6.1080000@sgi.com> <20081023163508.GA15921@elte.hu>
In-Reply-To: <20081023163508.GA15921@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> Ingo Molnar wrote:
>>> * Rusty Russell <rusty@rustcorp.com.au> wrote:
>>>
>>>> On Friday 24 October 2008 01:20:25 Ingo Molnar wrote:
>>>>> Thomas has started a -tip cross-build test, and there's massive
>>>>> cross-build failures as well due to the cpumask changes:
>>>> Yes.  linux-next reported the same thing.  I've backed out various 
>>>> arch changes for this reason.
>>>>
>>>>> it seems to me that this commit is massively borked:
>>>>>
>>>>>   4a792c2: cpumask: make CONFIG_NR_CPUS always valid
>>>> Yep.  This is the big one I dropped.  There are a few others; Mike is 
>>>> just porting the changes across to your tree now.
>>> guys. I already spent hours integrating the "latest" of this stuff today 
>>> and established baseline quality for it on x86. I've dropped 4a792c2 and 
>>> pushed out a new tip/cpus4096-v2, please send append-only patches for 
>>> the rest of the changes.
>>>
>>> 	Ingo
>> Ok, no problem.  I was integrating in the changes you already made so 
>> they would not be dropped.  But I'll send "update" patches instead of 
>> "replacement" patches if you prefer.
> 
> how big are the deltas? You might send a single interdiff - it's 
> supposed to be all small, right?
> 
> 	Ingo

It's pretty trivial, mostly removing things.  The big problem is Rusty
based his on Linus' tree (and he's offline now), so I need to apply his
patches to that tree and then generate "diff" patches for your tree.

Btw, I'm still having trouble building a "baseline" config using the
cpus4096-v2 branch that actually boots.  (UP boots ok.)  Is this the
correct .git/config:

[core]
        repositoryformatversion = 0
        filemode = true
        bare = false
        logallrefupdates = true
[remote "linus"]
        url = git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
        fetch = +refs/heads/*:refs/remotes/linus/*
[remote "tip"]
        url = git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
        fetch = +refs/heads/*:refs/remotes/tip/*
[branch "tip-latest"]
        remote = tip
        merge = refs/heads/master
[branch "cpus4096-v2"]
        remote = tip
        merge = refs/heads/cpus4096-v2


It won't let me do a:

mkdir linux-2.6.tip
cd linux-2.6.tip
git-init-db
git-remote add linus git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
git-remote add tip git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
git-remote update

git-checkout -b cpus4096-v2 tip/cpus4096-v2
git checkout: updating paths is incompatible with switching branches/forcing
Did you intend to checkout 'tip/cpus4906-v2' which can not be resolved as commit?

or:

git-checkout tip/cpus4906-v2
error: pathspec 'tip/cpus4906-v2' did not match any file(s) known to git.
Did you forget to 'git add'?

Thanks,
Mike


