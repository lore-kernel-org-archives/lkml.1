Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbZGFFVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbZGFFVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 01:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbZGFFVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 01:21:01 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:60360 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbZGFFVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 01:21:00 -0400
Date: Mon, 06 Jul 2009 14:20:58 +0900 (JST)
Message-Id: <20090706.142058.56800444.mitake@dcl.info.waseda.ac.jp>
To: fweisbec@gmail.com
Cc: mingo@elte.hu, acme@redhat.com, a.p.zijlstra@chello.nl,
       andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Adding information of counts processes acquired
 how many spinlocks to schedstat
From: mitake@dcl.info.waseda.ac.jp
In-Reply-To: <20090701154450.GC5097@nowhere>
References: <20090701110620.GB15958@elte.hu>
	<20090701.215304.864843820974206197.mitake@dcl.info.waseda.ac.jp>
	<20090701154450.GC5097@nowhere>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n665MVXx009392

From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH][RFC] Adding information of counts processes acquired how many spinlocks to schedstat
Date: Wed, 1 Jul 2009 17:44:51 +0200

> On Wed, Jul 01, 2009 at 09:53:04PM +0900, Hitoshi Mitake wrote:
> > From: Ingo Molnar <mingo@elte.hu>
> > Subject: Re: [PATCH][RFC] Adding information of counts processes acquired how many spinlocks to schedstat
> > Date: Wed, 1 Jul 2009 13:06:20 +0200
> > 
> > > 
> > > * Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:
> > > 
> > > > From: Ingo Molnar <mingo@elte.hu>
> > > > Subject: Re: [PATCH][RFC] Adding information of counts processes acquired how many spinlocks to schedstat
> > > > Date: Wed, 1 Jul 2009 11:07:49 +0200
> > > > 
> > > > > 
> > > > > * Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:
> > > > > 
> > > > > > From: Andi Kleen <andi@firstfloor.org>
> > > > > > Subject: Re: [PATCH][RFC] Adding information of counts processes acquired how many spinlocks to schedstat
> > > > > > Date: Wed, 01 Jul 2009 09:38:04 +0200
> > > > > > 
> > > > > > > Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> writes:
> > > > > > > 
> > > > > > > > Hi,
> > > > > > > >
> > > > > > > > I wrote a test patch which add information of counts processes acquired how many spinlocks to schedstat.
> > > > > > > > After applied this patch, /proc/<PID>/sched will change like this,
> > > > > > > 
> > > > > > > The problem is that spinlocks are very common and schedstats is 
> > > > > > > enabled commonly in production kernels. You would need to 
> > > > > > > demonstrate that such a change doesn't have significant 
> > > > > > > performance impact. For me it looks like it has.
> > > > > > 
> > > > > > I agree with your opinion about performance impact.
> > > > > > I thought this will make no problem,
> > > > > > because schedstat is categorized as "Kernel hacking" section.
> > > > > > But according to you, many production kernels enable it
> > > > > > so my patch will make widespread performance degradation.
> > > > > > I didn't know that, sorry.
> > > > > 
> > > > > His arguments are bogus: both lockstat and perfcounters are optional 
> > > > > (and default off), and the sw counter can be made near zero cost 
> > > > > even if both perfcounters and lockstat is enabled. Also, sw counters 
> > > > > are generally per CPU, etc. so not a performance issue.
> > > > > 
> > > > > The only (small) overhead will be when the lock-acquire sw counter 
> > > > > is actively enabled because you run 'perf stat -e lock-acquire' - 
> > > > > but that is expected and inherent in pretty much any kind of 
> > > > > instrumentation.
> > > > > 
> > > > > The feature you are working on has the chance to be a very useful 
> > > > > and popular piece of instrumentation. Being able to tell the lock 
> > > > > acquire stats on a per task, per workload, per CPU or system-wide 
> > > > > basis is a unique capability no other tool can offer right now.
> > > > > 
> > > > > Andi is often trolling perfcounters related (and other) threads, 
> > > > > please dont let yourself be deterred by that and feel free to ignore 
> > > > > him.
> > > > OK, at least it is truth that
> > > > counter in perfcounters makes only valid overhead.
> > > > 
> > > > And I have a question,
> > > > I tried to build perf, but I got a build error,
> > > > 
> > > > util/symbol.c: In function â€˜dso__load_symâ€™:
> > > > util/symbol.c:466: error: â€˜ELF_C_READ_MMAPâ€™ undeclared (first use in this function)
> > > > util/symbol.c:466: error: (Each undeclared identifier is reported only once
> > > > util/symbol.c:466: error: for each function it appears in.)
> > > > 
> > > > I used this libelf,
> > > > http://www.mr511.de/software/english.html
> > > > but constant ELF_C_READ_MMAP is not provided...
> > > > 
> > > > which "libelf" should I use?
> > > > It seems that there are some libelf implementations.
> > > 
> > > I use the elfutils-libelf* packages:
> > > 
> > >  elfutils-libelf-devel-static-0.141-1.fc10.i386
> > >  elfutils-0.141-1.fc10.i386
> > >  elfutils-libelf-0.141-1.fc10.i386
> > >  elfutils-libs-0.141-1.fc10.i386
> > >  elfutils-libelf-devel-0.141-1.fc10.i386
> > > 
> > > do they work fine or you?
> > 
> > I'm a Debian user, so I build this library from source
> > 
> > https://fedorahosted.org/releases/e/l/elfutils/elfutils-0.141.tar.bz2
> > 
> > And I succeed to build perf, thanks!
> 
> 
> You could also just
> 
> apt-get install libelf-dev
> 
> 
Thanks. I could install libelf with your way.

And sorry for my late response.
Because adding counting spin lock to perfcounters is more difficult
than I excepted...

When the process watched by perf tries to lock a spinlock
this will be the nest of spinlock,
because perfcounters subsystem also uses spinlock.

Is there any way to avoid the nest of lock?
I want any advice...

This is the temporal patch I wrote,

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 5e970c7..f65a473 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -102,6 +102,7 @@ enum perf_sw_ids {
 	PERF_COUNT_SW_CPU_MIGRATIONS		= 4,
 	PERF_COUNT_SW_PAGE_FAULTS_MIN		= 5,
 	PERF_COUNT_SW_PAGE_FAULTS_MAJ		= 6,
+	PERF_COUNT_SW_LOCK_ACQUIRES		= 7,
 
 	PERF_COUNT_SW_MAX,			/* non-ABI */
 };
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index d55a50d..0261f9f 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -3754,6 +3754,7 @@ static const struct pmu *sw_perf_counter_init(struct perf_counter *counter)
 	case PERF_COUNT_SW_PAGE_FAULTS_MAJ:
 	case PERF_COUNT_SW_CONTEXT_SWITCHES:
 	case PERF_COUNT_SW_CPU_MIGRATIONS:
+	case PERF_COUNT_SW_LOCK_ACQUIRES:
 		if (!counter->parent) {
 			atomic_inc(&perf_swcounter_enabled[event]);
 			counter->destroy = sw_perf_counter_destroy;
diff --git a/kernel/spinlock.c b/kernel/spinlock.c
index 7932653..394fc2d 100644
--- a/kernel/spinlock.c
+++ b/kernel/spinlock.c
@@ -20,6 +20,7 @@
 #include <linux/interrupt.h>
 #include <linux/debug_locks.h>
 #include <linux/module.h>
+#include <linux/perf_counter.h>
 
 int __lockfunc _spin_trylock(spinlock_t *lock)
 {
@@ -181,6 +182,9 @@ void __lockfunc _spin_lock(spinlock_t *lock)
 	preempt_disable();
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
+	perf_swcounter_event(PERF_COUNT_SW_LOCK_ACQUIRES,
+			     1, 1, NULL, 0);
+
 }
 
 EXPORT_SYMBOL(_spin_lock);
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 2e03524..87511c0 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -52,6 +52,7 @@ static struct perf_counter_attr default_attrs[] = {
   { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_CONTEXT_SWITCHES},
   { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_CPU_MIGRATIONS	},
   { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_PAGE_FAULTS	},
+  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_LOCK_ACQUIRES	},
 
   { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CPU_CYCLES	},
   { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_INSTRUCTIONS	},
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 4d042f1..0cd4985 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -38,6 +38,7 @@ static struct event_symbol event_symbols[] = {
   { CSW(PAGE_FAULTS_MAJ),	"major-faults",		""		},
   { CSW(CONTEXT_SWITCHES),	"context-switches",	"cs"		},
   { CSW(CPU_MIGRATIONS),	"cpu-migrations",	"migrations"	},
+  { CSW(LOCK_ACQUIRES),         "lock-acquires",	"lock"	},
 };
 
 #define __PERF_COUNTER_FIELD(config, name) \
@@ -66,6 +67,7 @@ static char *sw_event_names[] = {
 	"CPU-migrations",
 	"minor-faults",
 	"major-faults",
+	"lock-acquires",
 };
 
 #define MAX_ALIASES 8


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
