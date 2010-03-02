Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163Ab0CBKBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 05:01:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45112 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934Ab0CBKBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 05:01:50 -0500
Date: Tue, 2 Mar 2010 11:01:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: Re: [PATCH 00/15] oprofile fixes and updates for v2.6.34
Message-ID: <20100302100137.GA31186@elte.hu>
References: <1267205407-6523-1-git-send-email-robert.richter@amd.com>
 <20100227090331.GA22839@elte.hu>
 <20100301143946.GE13205@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100301143946.GE13205@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> On 27.02.10 10:03:31, Ingo Molnar wrote:
> > Hm, the perf_event.c bits conflict quite heavily with pending changes in 
> > tip:perf/core.
> > 
> > So to not hold up the oprofile changes for v2.6.34 i've pulled the core 
> > oprofile changes for v2.6.34 into tip:oprofile (up to cfc9c0b, if that is fine 
> > with you), and mind reworking the last 3 patches against perf/core?
> 
> Ingo & Peter,
> 
> I have a rebased version containing also a merge from:
> 
>  tip/oprofile -> tip/perf/core
> 
> Please pull again from:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core

Pulled, thanks Robert!

> > On a related note, wrt. your ongoing work for perf IBS support. The following 
> > patch by Peter:
> > 
> >   f22f54f: perf_events, x86: Split PMU definitions into separate files
> 
> Yes, the patches went also upstream on Friday. Will update my current patch 
> stack now. Maybe it would have been better to first integrate all pending 
> patches before doing that split.  Conflict resolution is a pain for moving 
> code. But anyway, it is supposed to go upstream and I will rebase my 
> patches.

The way to do it is to not keep that many pending patches in the first place. 
There are always 'pending patches' - if we waited for them to drain then we 
could never do cleanups.

Peter, Arnaldo, Frederic and all the other perf developers sync their patches 
with perf/core very frequently and push these bits to me. This has various 
advantages:

 - breakages are discovered quickly and can be mitigated before more harm is 
   done.

 - patch review is a lot more gradual (and a lot less taxing) as well. 

 - other people can get interested and jump in and help you out.

 - design mistakes/disagreements can also be hashed out before too much work 
   is invested into a particular direction.

 - as a maintainer i can see progress and can see problem areas. This makes it
   much easier to judge and plan a new topic's upstream integration schedule.
   It's not tucked away in some tree, with a large stream of patches showing
   up at once.

i.e. it's all variations of the 'release early, release often' Linux mantra.

So if you have a significant amount of pending patches then you are doing 
something wrong. Please consider adapting your workflow and please get any 
pending pieces to us in small, reviewable pieces.

That's especially true of large, intrusive features: for example the IBS bits 
could be moved into perf/core gradually, in a series of clean steps, even if 
they are not functional yet.

Thanks,

	Ingo
