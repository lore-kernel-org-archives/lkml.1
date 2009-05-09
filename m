Return-Path: <linux-kernel-owner+w=401wt.eu-S1754924AbZEIJo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbZEIJo3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 05:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751139AbZEIJoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 05:44:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:57353 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbZEIJoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 05:44:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,320,1239001200"; 
   d="scan'208";a="140992228"
Date: Sat, 9 May 2009 17:43:16 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?utf-8?B?RnLDqWTDqXJpYw==?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, Matt Mackall <mpm@selenic.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [patch] tracing/mm: add page frame snapshot trace
Message-ID: <20090509094316.GA5520@localhost>
References: <20090508105320.316173813@intel.com> <20090508111031.020574236@intel.com> <20090508114742.GB17129@elte.hu> <20090508124433.GB15949@localhost> <20090509062758.GB21354@elte.hu> <20090509091325.GA7994@localhost> <20090509092431.GB13784@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090509092431.GB13784@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 09, 2009 at 05:24:31PM +0800, Ingo Molnar wrote:
> 
> * Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > Hi Ingo,
> > 
> > On Sat, May 09, 2009 at 02:27:58PM +0800, Ingo Molnar wrote:
> > > 
> > > * Wu Fengguang <fengguang.wu@intel.com> wrote:
> > > 
> > > > > So this should be done in cooperation with instrumentation 
> > > > > folks, while improving _all_ of Linux instrumentation in 
> > > > > general. Or, if you dont have the time/interest to work with us 
> > > > > on that, it should not be done at all. Not having the 
> > > > > resources/interest to do something properly is not a license to 
> > > > > introduce further instrumentation crap into Linux.
> > > > 
> > > > I'd be glad to work with you on the 'object collections' ftrace 
> > > > interfaces.  Maybe next month. For now my time have been allocated 
> > > > for the hwpoison work, sorry!
> > > 
> > > No problem - our offer still stands: we are glad to help out with 
> > > the instrumentation side bits. We'll even write all the patches for 
> > > you, just please help us out with making it maximally useful to 
> > > _you_ :-)
> > 
> > Thank you very much!
> > 
> > The good fact is, 2/3 of the code and experiences can be reused.
> > 
> > > Find below a first prototype patch written by Steve yesterday and 
> > > tidied up a bit by me today. It can also be tried on latest -tip:
> > > 
> > >   http://people.redhat.com/mingo/tip.git/README
> > > 
> > > This patch adds the first version of the 'object collections' 
> > > instrumentation facility under /debug/tracing/objects/mm/. It has a 
> > > single control so far, a 'number of pages to dump' trigger file:
> > > 
> > > To dump 1000 pages to the trace buffers, do:
> > > 
> > >   echo 1000 > /debug/tracing/objects/mm/pages/trigger
> > > 
> > > To dump all pages to the trace buffers, do:
> > > 
> > >   echo -1 > /debug/tracing/objects/mm/pages/trigger
> > 
> > That is not too intuitive, I'm afraid.
> 
> This was just a first-level approximation - and it matches the usual 
> "0xffffffff means infinite" idiom.

8^)

> How about changing it from 'trigger' to 'dump_range':

That's a better name!

>    echo "*" > /debug/tracing/objects/mm/pages/dump_range
> 
> being a shortcut for 'dump all'?

No I'm not complaining about -1. That's even better than "*",
because the latter can easily be expanded by shell ;)

> And:
> 
>    echo "1000 2000" > /debug/tracing/objects/mm/pages/dump_range
> 
> ?

Now it's much more intuitive!

> The '1000' is the offset where the dumping starts, and 2000 is the 
> size of the dump.

Ah the second parameter 2000 can easily be taken as "end"..

