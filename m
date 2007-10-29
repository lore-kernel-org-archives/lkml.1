Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbXJ2Xpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbXJ2Xpm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 19:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbXJ2XpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 19:45:20 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:56685 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752194AbXJ2XpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 19:45:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAJYNJkdMQWvU/2dsb2JhbACBWo5W
Date: Mon, 29 Oct 2007 19:35:15 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jeff Garzik <jeff@garzik.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, hch@infradead.org,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Peter Zijlstra <pzijlstr@redhat.com>,
       Philippe Elie <phil.el@wanadoo.fr>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "William L. Irwin" <wli@holomorphy.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Lameter <christoph@lameter.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [RFC] Create instrumentation directory (git repository)
Message-ID: <20071029233515.GA19413@Krystal>
References: <20071029215138.GA4233@Krystal> <20071029154741.cb093f55.rdunlap@xenotime.net> <4726649A.5020605@garzik.org> <20071029230409.GB16943@Krystal> <472667F3.3000505@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <472667F3.3000505@garzik.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:23:35 up 91 days, 23:42,  3 users,  load average: 0.48, 0.73, 0.73
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeff Garzik (jeff@garzik.org) wrote:
> Mathieu Desnoyers wrote:
> >* Jeff Garzik (jeff@garzik.org) wrote:
> >>Randy Dunlap wrote:
> >>>On Mon, 29 Oct 2007 17:51:38 -0400 Mathieu Desnoyers wrote:
> >>>
> >>>>Hi,
> >>>>
> >>>>Since we already have the Instrumentation menu in
> >>>>kernel/Kconfig.instrumentation and instrumentation code all over the
> >>>>kernel tree:
> >>>>
> >>>>arch/*/oprofile/*.c
> >>>>kernel/kprobes.c
> >>>>arch/*/kernel/kprobes.c
> >>>>kernel/marker.c
> >>>>kernel/profile.c
> >>>>kernel/lockdep.c
> >>>>vm/vmstat.c
> >>>>block/blktrace.c
> >>>>drivers/base/power/trace.c
> >>>>
> >>>>We could move them to
> >>>>
> >>>>instrumentation/
> >>>>arch/*/instrumentation/
> >>>>
> >>>>Therefore, we could also move the kprobes and marker samples under
> >>>>
> >>>>instrumentation/samples/
> >>>>
> >>>>Here is a link to a git repository containing the changes, based on
> >>>>2.6.24-rc1:
> >>>>
> >>>>git://ltt.polymtl.ca/linux-2.6-instrumentation.git 
> >>>>instrumentation-for-linus
> >>>>(the interesting range is : v2.6.24-rc1..instrumentation-for-linus)
> >>>>
> >>>>Through the gitweb interface:
> >>>>http://ltt.polymtl.ca/cgi-bin/gitweb.cgi?p=linux-2.6-instrumentation.git
> >>>>
> >>>>Feedback is appreciated. Sorry for the huge CC list, but the change
> >>>>involves many maintainers.
> >>>Two more added.  Jeff Garzik and Christoph H. sometimes have some 
> >>>comments
> >>>about this.
> >>>
> >>>It would be helpful if we could get comments on this in the next day
> >>>or two [instead of in 1-2 weeks].
> >>"instrumentation" is long, and painful to the fingers :)
> >>
> >
> >Quoting my post from last week:
> >
> >>My main concern is that 15 characters long directory name might be
> >>inelegant (however, it only beats Documentation by 2).
> >
> >And quoting the answer from Valdis.Kletnieks@vt.edu :
> >How so?  i n s esc.  4 keystrokes (and still 2 more than D<ESC> ;)
> >
> >
> >
> >Better suggestions are wery welcome. However, in modern shells,
> >auto-completion is cheap nowadays.
> 
> That is no excuse for extreme verbosity.  It makes ls(1) displays ugly, 
> it makes diffstat ugly, it causes long pathnames to be truncated in 
> various display-oriented programs.
> 
> Pick a shorter word like probes or profile or what... or better yet... 
> just leave most things in their current directories.
> 
> Shuffling files around just to put them into directories with extra-long 
> names is highly undesirable.
> 
> 

I'll keep the probes and profile directory name ideas in mind, thanks.

This patchset does more than moving things around : its purpose is to
gather various kernel files that have similar purpose (instrumentation)
into a single directory so that it becomes easier to work on these
without duplicating the effort.

I see no good reason to have so many different adhoc instrumentation
mechanisms for profiling (sched, vm, oprofile) and tracing (blktrace,
suspend/resume tracing) all over the place. Merging them in a single
directory seems like a good step towards a more generic
instrumentation/profiling/tracing infrastructure.

Back to "profile" and "probes" directory names, they might be short, but
they do not represent the whole markup-profiling-tracing trio,
"profile" lacks the tracing part and "probe" lacks the markup part.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
