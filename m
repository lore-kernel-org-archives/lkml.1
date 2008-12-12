Return-Path: <linux-kernel-owner+w=401wt.eu-S1759843AbYLLSLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759843AbYLLSLT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 13:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759296AbYLLSKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 13:10:54 -0500
Received: from relay1.sgi.com ([192.48.179.29]:41755 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758964AbYLLSKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 13:10:53 -0500
Message-ID: <4942A92A.2010306@sgi.com>
Date: Fri, 12 Dec 2008 10:10:50 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] x86: fix assign_irq_vector boot up problem
References: <20081211112806.499831000@polaris-admin.engr.sgi.com> <20081211112806.740820000@polaris-admin.engr.sgi.com> <200812121857.55929.rusty@rustcorp.com.au> <20081212092041.GH25106@elte.hu>
In-Reply-To: <20081212092041.GH25106@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
>> On Thursday 11 December 2008 21:58:07 Mike Travis wrote:
>>> Impact: fix boot up problem.
>>>
>>> Fix a problem encountered with the Intel SATA-AHCI disk driver
>>> right at system startup.  Cpumask_intersects really needs to be
>>> a 3-way intersect, and since we need a cpumask_var_t later on,
>>> then just use it for the 3-way intersect as well.
>> This one looks fine.
>>
>> My plan was for Ingo to pull that for-ingo tree into his cpus4096 tree 
>> and take the x86 patches from there.  But he hasn't so maybe I should 
>> take this chance to fold that patch in?
> 
> i have no objections against the bits - just the sparseirq complication 
> came in. A lot of effort went into irq/sparseirq's io_apic.c changes and 
> cleanup.
> 
> So to do this cleanly, i merged those bits into cpus4096 and the 
> x86/reboot bits as well - now the plan would be for Mike to send a 
> (rebased) series against that base. I tried a plain merge and the 
> conflicts in io_apic.c were a horrendous 76 rejects due to the 
> irq/sparseirq interaction. Also, some of the commits subjects looked a 
> bit raw so this bit of the tree needs to be redone.
> 
> (Note that the existing cpumask-base+scheduler bits in cpus4096 are 
> golden already and we dont have to touch them in any way, it's just the 
> new x86 bits and new cpumask infrastructure bits that look odd or 
> clashy.)
> 
> 	Ingo

I have the merged result for io_apic and I believe it should also be
very clean in respect that it maintains the logic of of both patchsets
accurately. (About 6 hours to work through the complete file.)

What I'm confused about is how I'm to send this re-basing?  Do you only
want the patches in:

	.../pub/scm/linux/kernel/git/rusty/linux-2.6-for-ingo.git

And I've no clue how to cause a git tree to rebase.  What I can do is extract
them into quilt patches, reapply and fix conflicts, and then send them
(as quilt patches).  I'll do that today, and if you need a git tree to pull from,
then we'll figure out how to do that (with Rusty's help as again, I do not
have an external source to provide one.)

Also, you mention in separate mail:

    Please tidy up the commit logs of new cpumask bits and dont leave bits in 
    it like:

     e861b55: cpumask: Add CONFIG_CPUMASK_OFFSTACK
     65bda29: cpumask:clock_event_device-takes-cpumask-ptr
     07d73a8: cpumask:irq-functions-take-cpumask_t-ptr
     01fdd7d: cpumask:convert-few-difficult-cpumask_t-users
     9cc67bb: cpumask:centralize-common-maps

These patches went in via linux-next/rr, and are not part of the x86 patchset that
I'm working on.  I can only offer to help resolve the conflicts though again, I'm
not sure how I send them to you?  Would it be the commit from a "merge conflict
resolution" sent as a git-bundle?  [I've not done this yet so I'm really guessing.]

The tree for these changes are in:

	.../pub/scm/linux/kernel/git/rusty/linux-2.6-cpumask.git

and they include many, many non-x86 arch files, so sending them to you is not what
should be done, yes?

Rusty - can you fix these subject lines in your git tree?

Thanks!
Mike
