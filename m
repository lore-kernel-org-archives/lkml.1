Return-Path: <linux-kernel-owner+w=401wt.eu-S1758746AbZBDT4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746AbZBDT4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 14:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbZBDT4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 14:56:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:32790 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410AbZBDT4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 14:56:42 -0500
Date: Wed, 4 Feb 2009 20:56:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       randy.dunlap@oracle.com, linux-kernel@vger.kernel.org, x86@kernel.org,
       Andrea Righi <righi.andrea@gmail.com>
Subject: Re: mmotm 2009-02-02-17-12 uploaded (x86/nopmd etc.)
Message-ID: <20090204195612.GE22608@elte.hu>
References: <200902030112.n131CNiq010549@imap1.linux-foundation.org> <498893C8.6080506@oracle.com> <20090203191804.GA24698@elte.hu> <20090203121706.423d5cab.akpm@linux-foundation.org> <20090203212538.GB20527@elte.hu> <4988C73F.2070707@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4988C73F.2070707@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>> the include file spaghetti is ... interesting there, and it's historic.
>>
>> I could blame it on highmem, PAE or paravirt - but i'll only blame it 
>> on paravirt for now because those developers are still around! ;-)
>>   
>
> Hey, don't forget unification, if we're pointing fingers ;)

Unification only moved stupidly separate crap closer to each other, making 
them all stink much more intensely. I consider that a feature! :)

>> Jeremy, any ideas how to reduce the historic dependency mess in that 
>> area? I think we should go on three routes at once:
>>
>>  - agressive splitup and separation of type definitions from method
>>    declaration (+ inline definitions). The spinlock_types.h / 
>> spinlock.h    splitup was really nice in solving such dependency 
>> problems.
>>   
>
> That already exists to some extent, though I don't think it's being used 
> to maximum advantage (pgtable-[23]level.h vs pgtable-[23]level-defs.h).  
> For consistency we'd have pgtable-4level(-defs).h headers too, and 
> top-level pgtable.h/pgtable-defs.h headers.  But its not clear to me that 
> would even be enough...

>>  - uninlining of methods: instead of macro-ing them - wherever 
>> possible.    It's really hard to mess up type + externs headers - while 
>> headers with    inlines and macros mixed in get painful quickly.
>>   
>
> Yes.  I went through a period of fairly aggressive inline->macro  
> conversion, and in many cases the remaining macros are there to #include  
> hell.
>
>>  - removal of spurious pile of dozens of #include lines in header files.
>
> Yeah, it would be useful to make sure that each header only #includes  
> the bare minimum headers to satisfy its own definitions - but of course  
> that's going to provoke a long series of #include whack-a-mole patches.

If you worry about the fallout, that's not a problem really. I'd expect most 
of the fixlets to go into .c files that used insufficient list of includes 
and relied on some previously existing spaghetti side-effect.

I even volunteer to whack them all myself, if you provide a large series of 
base patches that:

 1) happen to build and boot on any one of your favorite configs

 2) produce a squeaky clean .h file layout and dependency structure.

Doing a ping-pong with you of breakage+fixlet cycles wont scale too well, 
even with the very fast -tip turnaround. We could easily end up having to do 
dozens of followup fixes.

But it should be _really_ radical and the end result should be _really_ 
clean, to make the effort _really_ worth it :-)

	Ingo
