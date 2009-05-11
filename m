Return-Path: <linux-kernel-owner+w=401wt.eu-S1759457AbZEKWJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759457AbZEKWJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 18:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755548AbZEKWJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 18:09:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43178 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755471AbZEKWJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 18:09:16 -0400
Date: Tue, 12 May 2009 00:08:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: fengguang.wu@intel.com, fweisbec@gmail.com, rostedt@goodmis.org,
       a.p.zijlstra@chello.nl, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com,
       andi@firstfloor.org, mpm@selenic.com, adobriyan@gmail.com,
       linux-mm@kvack.org
Subject: Re: [PATCH 4/8] proc: export more page flags in /proc/kpageflags
Message-ID: <20090511220834.GA26614@elte.hu>
References: <20090508105320.316173813@intel.com> <20090508111031.020574236@intel.com> <20090508114742.GB17129@elte.hu> <20090508132452.bafa287a.akpm@linux-foundation.org> <20090509104409.GB16138@elte.hu> <20090509222612.887b96e3.akpm@linux-foundation.org> <20090511114554.GC4748@elte.hu> <20090511113157.b2c56e70.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090511113157.b2c56e70.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 11 May 2009 13:45:54 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > Yes, we could place pagemap's two auxiliary files into debugfs but 
> > > it would be rather stupid to split the feature's control files 
> > > across two pseudo filesystems, one of which may not even exist.  
> > > Plus pagemap is not a kernel debugging feature.
> > 
> > That's not what i'm suggesting though.
> > 
> > What i'm suggesting is that there's a zillion ways to enumerate 
> > and index various kernel objects, doing that in /proc is 
> > fundamentally wrong. And there's no need to create a per PID/TID 
> > directory structure in /debug either, to be able to list and 
> > access objects by their PID.
> 
> The problem with procfs was that it was growing a lot of random 
> non-process-related stuff.  We never deprecated procfs - we 
> decided that it should be retained for its original purpose and 
> that non-process-realted things shouldn't go in there.
> 
> The /proc/<pid>/pagemap file clearly _is_ process-related, and 
> /proc/<pid> is the natural and correct place for it to live.
> 
> Yes, sure, there are any number of ways in which that data could 
> be presented to userspace in other locations and via other means.  
> But there would need to be an extraordinarily good reason for 
> violating the existing paradigm/expectation/etc.

It has also been clearly demonstrated in this thread that people 
want more enumeration than just the the process dimension. 

_Especially_ for an object like pages. Often most of the memory in a 
Linux system is _not mapped to any process_. It is in the page 
cache. Still, /proc enumeration does not capture it. Why? Because 
IMO it has been done at the wrong layer, at the wrong abstraction 
level.

Yes, /proc is for process enumeration (as the name tells us 
already), but it is not really suitable as a general object 
enumerator for kernel debugging or kernel instrumentation purposes. 

By putting kernel instrumentation into /proc, we limit all _future_ 
enumeration greatly. Instead of adding just another iterator 
(walker), we now have to move the whole thing across into another 
domain (which is being resisted, and /proc is an ABI anyway).

It's all doable, but a lot harder if it's not being relized why it's 
important to do it.

	Ingo
