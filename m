Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbZDOUJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbZDOUJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 16:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbZDOUI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 16:08:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51849 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186AbZDOUI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 16:08:58 -0400
Date: Wed, 15 Apr 2009 22:07:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
Message-ID: <20090415200724.GA12202@elte.hu>
References: <200904140159.n3E1x1K1014705@hera.kernel.org> <20090414020544.GA3738@elte.hu> <20090415054417.GA5272@elte.hu> <200904152014.11717.rusty@rustcorp.com.au> <alpine.LFD.2.00.0904150822020.4132@localhost.localdomain> <20090415162627.GA32254@elte.hu> <alpine.LFD.2.00.0904151013260.4132@localhost.localdomain> <49E62BD5.6090508@zytor.com> <alpine.LFD.2.00.0904151241490.4132@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904151241490.4132@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, 15 Apr 2009, H. Peter Anvin wrote:
> > 
> > "cleanup" is indeed the most common, as it is intended to signify a
> > trivial but nonzero code change.  Whether or not it's *correct* is
> > another matter.  "build fix" is valid and proper use: it tells that it
> > fixes a compilation error, which succinctly communicates both the
> > priority of the fix and how it needs to be validated.
> 
> Why would that be "proper use"?
> 
> Dammit, if the "build fix" is not obvious from the rest of the 
> commit message, there's something wrong.
> 
> And if it _is_ obvious, then the mechanical "Impact:" thing is 
> pointless.
> 
> In other words - in neither case does it actually help anything at 
> all. It's only distracting noise.

I often skip "Impact: build fix" - when it's obvious from the 
subject line or the first sentence of the commit - or if it can be 
made obvious by changing the subject line or by changing the first 
sentence of the commit.

I add it occasionally, when some other, higher priority principle 
makes the changing of the subject line undesired.

For example, yesterday i did this commit:

| commit 27b19565fe4ca5b0e9d2ae98ce4b81ca728bf445
| Author: Ingo Molnar <mingo@elte.hu>
| Date:   Tue Apr 14 11:03:12 2009 +0200
|
|     lockdep: warn about lockdep disabling after kernel taint, fix
|    
|     Impact: build fix for Sparc and s390
|    
|     Stephen Rothwell reported that the Sparc build broke:

I added that 'build fix' impact line for two reasons:

Firstly, because the subject line was inherited from the buggy 
commit and the new subject line got a ", fix" postfix. (This 
convention seems rather useful at times in shortlogs, see below.)

Secondly, i also added the impact line because i wanted to specify 
the architectures affected: Sparc and s390 - this fact was not 
obvious from the bug report context which i wanted to preserve to 
credit the bug reporter prominently (Stephen found the build error 
on Sparc only).

Another option would have been to use this primary subject line 
instead:

   fix build error on Sparc and s390

But IMHO that's a worse subject line. It's more important to keep 
the flow of the original change intact. The subject lines cluster up 
better in shortlogs or in git logs:

 $ gll include/linux/debug_locks.h 
 27b1956: lockdep: warn about lockdep disabling after kernel taint, fix
 9eeba61: lockdep: warn about lockdep disabling after kernel taint

The connection between the two commits is plain obvious, at a 
glance.

I could have concatenated the first subject line with the impact 
information:

 27b1956: lockdep: warn about lockdep disabling after kernel taint, fix build error on Sparc and s390

... but this is clearly over-long and dillutes the subject line with 
'effect' information.

	Ingo
