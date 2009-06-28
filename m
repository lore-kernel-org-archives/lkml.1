Return-Path: <linux-kernel-owner+w=401wt.eu-S1752262AbZF1BTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbZF1BTj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 21:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbZF1BT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 21:19:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:5030 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbZF1BT2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 21:19:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fkZJQuB5UlQXITgbBa7DvWStf7xyrkOu9dKVsu18IQvIOFR/FO6rH7RBkMJgZfmiaU
         4g2ES3Y8au5EZSyWdqCpp/dCZrLsnGhGTRs8LhaNGbgd7KzDEYYPGa9/gunvJ2fJVoa6
         isi97L4sUe5elGfaMv/BRdh9ctK8xSp5SoJAg=
MIME-Version: 1.0
In-Reply-To: <20090611202341.GA23590@elte.hu>
References: <20090611160329.GA3366@elte.hu>
	 <20090611161714.GA5008@infradead.org>
	 <alpine.LFD.2.01.0906110922080.3573@localhost.localdomain>
	 <20090611165226.GV8633@ZenIV.linux.org.uk>
	 <1244739378.6691.540.camel@laptop>
	 <20090611170015.GA3651@infradead.org>
	 <alpine.LFD.2.01.0906111005020.3573@localhost.localdomain>
	 <33307c790906111124m17e57332oc38c89fa70e39231@mail.gmail.com>
	 <alpine.LFD.2.01.0906111127520.3573@localhost.localdomain>
	 <20090611202341.GA23590@elte.hu>
Date: Sun, 28 Jun 2009 04:19:30 +0300
Message-ID: <94a0d4530906271819g4b4283aeq204f373236befaef@mail.gmail.com>
Subject: Re: [GIT PULL] Performance Counters for Linux
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Bligh <mbligh@google.com>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Al Viro <viro@zeniv.linux.org.uk>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 11:23 PM, Ingo Molnar<mingo@elte.hu> wrote:
>
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
> [...]
>> What the "keep it in the kernel sources" approach hopefully allows is
>>
>>  - taking advantage of new features in a timely manner.
>>
>>    NOT with some ABI breakage, but simply things like supporting a
>>    new CPU architecture or new counters. The thing that oprofile
>>    failed at so badly in my experience.
>>
>>  - Make it easier for developers, and _avoiding_ the horrible
>>    situation where you have two different groups that don't talk
>>    well to each other because one is a group of user-space
>>    weenies, and the other is a group of manly kernel people, and
>>    there is no common ground.
>
> Yes, very much agreed.
>
> Btw., here are a couple of other arguments why i find it useful to
> have the tools/perf/ in the kernel repo:
>
> 1) Super-fast and synchronized release cycles
>
> The kernel is one of the fastest moving packages in Linux - most
> user-space packages have (much!) longer release cycles than 3
> months.
>
> A tight release schedule forces a certain amount of release
> discipline on tooling as well - so i'm glad that the two will be
> coupled. It's so easy for a promising tool to degrade into
> tinkerware with odd release cycles with time - if it's part of the
> kernel then at least the release cycles wont be odd but at precise 3
> months.
>
> 2) Performance _matters_
>
> This is an argument pretty specific to perfcounters: Performance
> analysis tools under Linux suck pretty summarily. Yet, one of the
> major strengths of Linux is (or at least used to be) performance. So
> i find it very fitting that the kernel community takes performance
> analysis tooling into their own hand.
>
> 3) Strict quality control under a proven mode
>
> In the kernel repo i can be sure that:
>
>  - No one will even think of adding autofools to tools/perf/.
>
>  - No one will send us code with Hungarian notation and two spaces
>    tabulation.
>
>  - No one will put getopt.h into the code
>
>  - No one will rewrite it in some weird language
>
>   [ Or at least, even though such incidents might happen
>     occasionally, i can just sit back in my chair and watch the
>     resulting showdown on lkml, without having to worry about the
>     outcome ;-) ]
>
> I can point contributors to well-established kernel coding
> principles, without having to argue no end about them.
>
> All in one - the Linux kernel is a fire breathing monster engine
> when it comes to producing good software. Who says it that that this
> infrastructure and experience can only be used to produce kernel
> space code?
>
> 4) Code reuse
>
> We actually use code from the kernel: list.h primitives and
> rbtrees.c. We privatized them for now under
> tools/perf/util/rbtree.[ch] and tools/perf/util/list.h because
> there's some header and type pollution in them, but it would be nice
> to include them directly and share the facilities.
>
> 5) Reality check for kernel developers
>
> I think kernel hackers need a reality check too. It's easy to say
> that user-space sucks - but now there's a way and channel that
> frustration via direct action and make a real difference. I do hope
> that the extra superfluous mental energies visible in this thread
> can be used for good purposes too ;-)
>
> 6) It's a lot of fun
>
> I never thought i'd say that - but hacking properly structured
> user-space code in the kernel repo is serious fun. It's even
> relaxing at times: i can be reasonably sure that i wont crash the
> kernel.
>
> All in one, we did this because we found that it produces better
> code in practice and does it faster - and i dont think we should
> rigidly limit the kernel repo to kernel-space projects alone.

Here's another idea:
How about putting the tools in a different repo, but keeping the
communication in lkml. Then, if a change is required on kernel and
user-space, both patches are sent to lkml and rejected if the other
side is missing.

My guess is that kernel hackers are comfortable doing stuff on the
linux repo because the know all the processes; code-style, how to send
patches, git, etc. If they can just 'git clone' and type 'make' to
build the tools and send patches to lkml I guess they'll be equally
happy hacking there too.

Cheers.

-- 
Felipe Contreras
