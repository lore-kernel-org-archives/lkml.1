Return-Path: <linux-kernel-owner+w=401wt.eu-S1757689AbZKXHej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689AbZKXHej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 02:34:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757533AbZKXHej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 02:34:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44100 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757522AbZKXHei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 02:34:38 -0500
Date: Tue, 24 Nov 2009 08:34:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>,
       Arjan van de Ven <arjan@infradead.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/5] perf kmem: Add more functions and show more
 statistics
Message-ID: <20091124073426.GA21991@elte.hu>
References: <4B0B6E44.6090106@cn.fujitsu.com>
 <84144f020911232315h7c8b7348u9ad97f585f54a014@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020911232315h7c8b7348u9ad97f585f54a014@mail.gmail.com>
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Hi Li,
> 
> On Tue, Nov 24, 2009 at 7:25 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> > Pekka, do you think we can remove kmemtrace now?
> 
> One more use case I forgot to mention: boot time tracing. Much of the 
> persistent kernel memory footprint comes from the boot process which 
> is why it's important to be able to trace memory allocations 
> immediately after kmem_cache_init() has run. Can we make "perf kmem" 
> do that? Eduard put most of his efforts into making that work for 
> kmemtrace.

Would be lovely if someone looked at perf from that angle (and extended 
it).

Another interesting area would be to allow a capture session without a 
process context running immediately. (i.e. pre-allocate all the buffers, 
use them, for a later 'perf save' to pick it up.)

The two are kind of the same thing conceptually: a boot time trace is a 
preallocated 'process context less' recording, to be picked up after 
bootup.

[ It also brings us 'stability/persistency of event logging' - i.e. a 
  capture session could be started and guaranteed by the kernel to be 
  underway, regardless of what user-space does. ]

Btw., Arjan is doing a _lot_ of boot time tracing for Moblin, and he 
indicated it in the past that starting a perf recording session from an 
initrd is a pretty practical substitute as well. (I've Cc:-ed Arjan.)

> On Tue, Nov 24, 2009 at 7:25 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>
> > With kmem trace events, low-level analyzing can be done using 
> > ftrace, and high-level analyzing can be done using perf-kmem.
> >
> > And chance is, more people may use and improve perf-kmem, and it 
> > will be well-maintained within the perf infrastructure. On the other 
> > hand, I guess few people use and contribute to kmemtrace-user.
> 
> Sure, I think "perf kmem" is the way forward. I'd love to hear 
> Eduard's comments on this before we remove the code from kernel. Do we 
> need to do that for 2.6.33 or can we postpone that for 2.6.34?

Certainly we can postpone it, as long as there's rough strategic 
consensus on the way forward. I'd hate to have two overlapping core 
kernel facilities and friction between the groups pursuing them and 
constant distraction from having two targets.

Such situations just rarely end with a good solution for the user - see 
security modules for a horror story ...

[ I dont think it will occur here, just wanted to mention it out of
  abundance of caution that 1.5 decades of kernel hacking experience 
  inflicts on me ;-) ]

	Ingo
