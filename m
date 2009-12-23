Return-Path: <linux-kernel-owner+w=401wt.eu-S1753612AbZLWGv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbZLWGv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 01:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbZLWGvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 01:51:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48823 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266AbZLWGvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 01:51:53 -0500
Date: Wed, 23 Dec 2009 07:51:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andi Kleen <andi@firstfloor.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [GIT PULL] AlacrityVM guest drivers for 2.6.33
Message-ID: <20091223065129.GA19600@elte.hu>
References: <4B1D4F29.8020309@gmail.com>
 <87637zdy9g.fsf@basil.nowhere.org>
 <4B30E654.40702@codemonkey.ws>
 <200912221701.56840.bzolnier@gmail.com>
 <4B30F214.80206@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B30F214.80206@codemonkey.ws>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Anthony Liguori <anthony@codemonkey.ws> wrote:

> On 12/22/2009 10:01 AM, Bartlomiej Zolnierkiewicz wrote:
> >>new e1000 driver is more superior in architecture and do the required
> >>work to make the new e1000 driver a full replacement for the old one.
> >Right, like everyone actually does things this way..
> >
> >I wonder why do we have OSS, old Firewire and IDE stacks still around then?
> 
> And it's always a source of pain, isn't it.

Even putting aside the fact that such overlap sucks and is a pain to users 
(and that 98% of driver and subsystem version transitions are done completely 
seemlessly to users - the examples that were cited were the odd ones out of 
150K commits in the past 4 years, 149K+ of which are seemless), the comparison 
does not even apply really.

e1000, OSS, old Firewire and IDE are hardware stacks, where hardware is a not 
fully understood externality, with its inevitable set of compatibility voes. 
There's often situations where one piece of hardware still works better with 
the old driver, for some odd (or not so odd) reason.

Also, note that the 'new' hw drivers are generally intended and are maintained 
as clear replacements for the old ones, and do so with minimal ABI changes - 
or preferably with no ABI changes at all. Most driver developers just switch 
from old to new and the old bits are left around and are phased out. We phased 
out old OSS recently.

That is a very different situation from the AlacrityVM patches, which:

 - Are a pure software concept and any compatibility mismatch is
   self-inflicted. The patches are in fact breaking the ABI to KVM 
   intentionally (for better or worse).

 - Gregory claims that the AlacricityVM patches are not a replacement for KVM.
   I.e. there's no intention to phase out any 'old stuff' and it splits the 
   pool of driver developers.

i.e. it has all the makings of a stupid, avoidable, permanent fork. The thing 
is, if AlacricityVM is better, and KVM developers are not willing to fix their 
stuff, replace KVM with it.

It's a bit as if someone found a performance problem with sys_open() and came 
up with sys_open_v2() and claimed that he wants to work with the VFS 
developers while not really doing so but advances sys_open_v2() all the time. 

Do we allow sys_open_v2() upstream, in the name of openness and diversity, 
letting some apps use that syscall while other apps still use sys_open()? Or 
do we say "enough is enough of this stupidity, come up with some strong 
reasons to replace sys_open, and if so, replace the thing and be done with the 
pain!".

Overlap and forking can still be done in special circumstances, when a project 
splits and a hostile fork is inevitable due to prolongued and irreconcilable 
differences between the parties and if there's no strong technical advantage 
on either side. I havent seen evidence of this yet though: Gregory claims that 
he wants to 'work with the community' and the KVM guys seem to agree violently 
that performance can be improved - and are doing so (and are asking Gregory to 
take part in that effort).

The main difference is that Gregory claims that improved performance is not 
possible within the existing KVM framework, while the KVM developers disagree. 
The good news is that this is a hard, testable fact.

I think we should try _much_ harder before giving up and forking the ABI of a 
healthy project and intentionally inflicting pain on our users.

And, at minimum, such kinds of things _have to_ be pointed out in pull 
requests, because it's like utterly important. In fact i couldnt list any more 
important thing to point out in a pull request.

	Ingo
