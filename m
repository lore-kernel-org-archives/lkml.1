Return-Path: <linux-kernel-owner+w=401wt.eu-S1759776AbZCTTZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759776AbZCTTZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 15:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753815AbZCTTZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 15:25:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52313 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689AbZCTTZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 15:25:39 -0400
Date: Fri, 20 Mar 2009 20:25:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Will Schmidt <will_schmidt@vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>
Subject: Re: [Announce] 2.6.29-rc8-rt2
Message-ID: <20090320192521.GH6224@elte.hu>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain> <alpine.LFD.2.00.0902231854360.3523@localhost.localdomain> <alpine.LFD.2.00.0902241849230.3523@localhost.localdomain> <alpine.LFD.2.00.0902241856480.9135@localhost.localdomain> <alpine.LFD.2.00.0903122013230.29264@localhost.localdomain> <alpine.LFD.2.00.0903200014320.29264@localhost.localdomain> <alpine.LFD.2.00.0903201832590.29264@localhost.localdomain> <1237576751.8951.146.camel@lexx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1237576751.8951.146.camel@lexx>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Will Schmidt <will_schmidt@vnet.ibm.com> wrote:

> On Fri, 2009-03-20 at 18:45 +0100, Thomas Gleixner wrote:
> > We are pleased to announce the next update to our new preempt-rt
> > series.
> >     
> >      - resurrected ARM and PowerPC support
> >      - tracing fixes for ARM (Uwe Kleine-Koenig)
> > 
> > The support for ARM/PowerPC has only been lightly tested. It might
> > crash and burn your system, make your hair curl, frigthen your cat and
> > give you sleepless nights. You have been warned !
> 
> During a build attempt on powerpc, I am seeing:
> 
> In file included from include/linux/mmzone.h:776,
>                  from include/linux/gfp.h:5,
>                  from include/linux/slab.h:13,
>                  from include/linux/percpu.h:6,
>                  from include/linux/rcupdate.h:40,
>                  from include/linux/rculist.h:11,
>                  from include/linux/dcache.h:7,
>                  from include/linux/fs.h:299,
>                  from init/do_mounts_rd.c:4:
> /root/linux-2.6.29-rc8/arch/powerpc/include/asm/mmzone.h:32: error:
> expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before
> ‘numa_cpumask_lookup_table’
> In file included from include/linux/topology.h:35,
>                  from include/linux/gfp.h:8,
>                  from include/linux/slab.h:13,
>                  from include/linux/percpu.h:6,
>                  from include/linux/rcupdate.h:40,
>                  from include/linux/rculist.h:11,
>                  from include/linux/dcache.h:7,
>                  from include/linux/fs.h:299,
>                  from init/do_mounts_rd.c:4:
> /root/linux-2.6.29-rc8/arch/powerpc/include/asm/topology.h: In function
> ‘node_to_cpumask’:
> /root/linux-2.6.29-rc8/arch/powerpc/include/asm/topology.h:22: error:
> ‘numa_cpumask_lookup_table’ undeclared (first use in this function)
> /root/linux-2.6.29-rc8/arch/powerpc/include/asm/topology.h:22: error:
> (Each undeclared identifier is reported only once
> /root/linux-2.6.29-rc8/arch/powerpc/include/asm/topology.h:22: error:
> for each function it appears in.)
> /root/linux-2.6.29-rc8/arch/powerpc/include/asm/topology.h: In function
> ‘node_to_first_cpu’:
> /root/linux-2.6.29-rc8/arch/powerpc/include/asm/topology.h:29: error:
> ‘numa_cpumask_lookup_table’ undeclared (first use in this function)
> make[1]: *** [init/do_mounts_rd.o] Error 1
> make[1]: *** Waiting for unfinished jobs....
> 
> 
> 
> I have locally fixed by adding an include just above the cpumask_t
> reference.  The include may belong elsewhere, but in case I got it
> right,.. :-)
> 
> Signed-Off-By:  Will Schmidt <will_schmidt@vnet.ibm.com>

you got it right :-) The full fix (the bug also affects sparc) is 
already queued up - see it below.

	Ingo

-------------->
>From 0c7e5b187fc599a40c1e6392926424d26cd0cf41 Mon Sep 17 00:00:00 2001
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 19 Mar 2009 22:03:22 +1100
Subject: [PATCH] numa, cpumask: move numa_node_id default implementation to topology.h, fix

Impact: build fix for powerpc and sparc

Today's linux-next build (powerpc allyesconfig) failed like this:

> In file included from include/linux/mmzone.h:776,
>                  from include/linux/gfp.h:5,
>                  from include/linux/kmod.h:23,
>                  from include/linux/module.h:14,
>                  from init/version.c:11:
> arch/powerpc/include/asm/mmzone.h:32: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'numa_cpumask_lookup_table'

Caused by commit 082edb7bf443eb8eda15b482d16ad9dd8137ad24 ("numa,
cpumask: move numa_node_id default implementation to topology.h") from
the cpus4096 tree which removed the include of linux/topology.h from
linux/mmzone.h.

Same for sparc64 defconfig.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-b: Rusty Russell <rusty@rustcorp.com.au>
Cc: ppc-dev <linuxppc-dev@ozlabs.org>
LKML-Reference: <20090319220322.3baa4613.sfr@canb.auug.org.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/powerpc/include/asm/mmzone.h |    1 +
 arch/sparc/include/asm/mmzone.h   |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/mmzone.h b/arch/powerpc/include/asm/mmzone.h
index 19f299b..35acac9 100644
--- a/arch/powerpc/include/asm/mmzone.h
+++ b/arch/powerpc/include/asm/mmzone.h
@@ -8,6 +8,7 @@
 #define _ASM_MMZONE_H_
 #ifdef __KERNEL__
 
+#include <linux/cpumask.h>
 
 /*
  * generic non-linear memory support:
diff --git a/arch/sparc/include/asm/mmzone.h b/arch/sparc/include/asm/mmzone.h
index ebf5986..e8c6487 100644
--- a/arch/sparc/include/asm/mmzone.h
+++ b/arch/sparc/include/asm/mmzone.h
@@ -3,6 +3,8 @@
 
 #ifdef CONFIG_NEED_MULTIPLE_NODES
 
+#include <linux/cpumask.h>
+
 extern struct pglist_data *node_data[];
 
 #define NODE_DATA(nid)		(node_data[nid])
