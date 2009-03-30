Return-Path: <linux-kernel-owner+w=401wt.eu-S1751285AbZC3LjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285AbZC3LjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 07:39:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbZC3Lix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 07:38:53 -0400
Received: from ozlabs.org ([203.10.76.45]:47035 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734AbZC3Liu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 07:38:50 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] cpumask cleanups
Date: Mon, 30 Mar 2009 22:08:38 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Mike Travis <travis@sgi.com>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-mips@linux-mips.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
       Trond.Myklebust@netapp.com, Russell King <rmk@arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903302208.38802.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0d34fb8e93ceba7b6dad0062dbb4a0813bacd75b:             
  Linus Torvalds (1):                                                                    
        Merge branch 'bzip2-lzma-for-linus' of git://git.kernel.org/.../x86/linux-2.6-tip

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-cpumask.git master

Russell King (1):
      oprofile: Thou shalt not call __exit functions from __init functions

Rusty Russell (10):
      cpumask: remove dangerous CPU_MASK_ALL_PTR, &CPU_MASK_ALL
      cpumask: fix seq_bitmap_*() functions.                   
      cpumask: remove node_to_first_cpu                        
      cpumask: use set_cpu_active in init/main.c               
      cpumask: use mm_cpumask() wrapper: kernel/fork.c         
      cpumask: remove references to struct irqaction's mask field.
      cpumask: use new cpumask_ functions in core code.           
      cpumask: convert rcutorture.c                               
      cpumask: remove cpumask_t from core                         
      cpumask: remove the now-obsoleted pcibus_to_cpumask(): generic

 arch/cris/arch-v10/kernel/time.c           |    1 -
 arch/cris/arch-v32/kernel/smp.c            |    1 -
 arch/cris/arch-v32/kernel/time.c           |    1 -
 arch/frv/kernel/irq-mb93091.c              |    4 ----
 arch/frv/kernel/irq-mb93093.c              |    1 -   
 arch/frv/kernel/irq-mb93493.c              |    2 --  
 arch/frv/kernel/time.c                     |    1 -   
 arch/h8300/kernel/timer/itu.c              |    1 -   
 arch/h8300/kernel/timer/timer16.c          |    1 -   
 arch/h8300/kernel/timer/timer8.c           |    1 -   
 arch/h8300/kernel/timer/tpu.c              |    1 -   
 arch/ia64/include/asm/topology.h           |    5 -----
 arch/m32r/kernel/time.c                    |    1 -    
 arch/mips/cobalt/irq.c                     |    1 -    
 arch/mips/emma/markeins/irq.c              |    1 -    
 arch/mips/include/asm/mach-ip27/topology.h |    1 -    
 arch/mips/jazz/irq.c                       |    1 -    
 arch/mips/kernel/cevt-bcm1480.c            |    1 -    
 arch/mips/kernel/cevt-sb1250.c             |    1 -    
 arch/mips/kernel/i8253.c                   |    2 --   
 arch/mips/kernel/i8259.c                   |    1 -    
 arch/mips/lasat/interrupt.c                |    1 -    
 arch/mips/lemote/lm2e/irq.c                |    1 -    
 arch/mips/sgi-ip27/ip27-nmi.c              |    2 +-   
 arch/mips/sgi-ip32/ip32-irq.c              |    2 --   
 arch/mips/sni/rm200.c                      |    3 ++-  
 arch/mips/vr41xx/common/irq.c              |    1 -    
 arch/mn10300/kernel/time.c                 |    1 -    
 arch/powerpc/include/asm/topology.h        |    5 -----
 arch/powerpc/platforms/85xx/mpc85xx_cds.c  |    1 -    
 arch/powerpc/platforms/8xx/m8xx_setup.c    |    1 -    
 arch/powerpc/platforms/chrp/setup.c        |    1 -    
 arch/powerpc/platforms/powermac/pic.c      |    2 --   
 arch/powerpc/platforms/powermac/smp.c      |    1 -    
 arch/powerpc/sysdev/cpm1.c                 |    1 -    
 arch/sh/include/asm/topology.h             |    1 -    
 arch/sh/kernel/time_64.c                   |    1 -    
 arch/sh/kernel/timers/timer-cmt.c          |    1 -    
 arch/sh/kernel/timers/timer-mtu2.c         |    1 -    
 arch/sh/kernel/timers/timer-tmu.c          |    1 -    
 arch/sparc/include/asm/topology_64.h       |    5 -----
 arch/sparc/kernel/irq_32.c                 |    2 --   
 arch/sparc/kernel/sun4d_irq.c              |    1 -    
 arch/x86/include/asm/topology.h            |   12 ------------
 arch/x86/kernel/irqinit_32.c               |    2 --          
 arch/x86/kernel/irqinit_64.c               |    1 -           
 arch/x86/kernel/mfgpt_32.c                 |    1 -
 arch/x86/kernel/setup.c                    |    1 -
 arch/x86/kernel/time_64.c                  |    2 --
 arch/x86/kernel/vmiclock_32.c              |    1 -
 drivers/base/cpu.c                         |    2 +-
 drivers/oprofile/buffer_sync.c             |    2 +-
 fs/seq_file.c                              |    2 +-
 include/asm-generic/topology.h             |   10 ----------
 include/linux/cpuset.h                     |    4 ++--
 include/linux/seq_file.h                   |    9 +++++----
 init/main.c                                |    5 ++---
 kernel/cpu.c                               |    6 +++---
 kernel/fork.c                              |    2 +-
 kernel/kmod.c                              |    2 +-
 kernel/kthread.c                           |    4 ++--
 kernel/rcutorture.c                        |   25 +++++++++++++++++--------
 kernel/sched_cpupri.h                      |    2 +-
 kernel/stop_machine.c                      |    2 +-
 kernel/workqueue.c                         |    6 +++---
 mm/allocpercpu.c                           |    2 +-
 mm/pdflush.c                               |    2 +-
 mm/vmstat.c                                |    2 +-
 net/sunrpc/svc.c                           |    2 +-
 69 files changed, 48 insertions(+), 129 deletions(-)

commit 1a2142afa5646ad5af44bbe1febaa5e0b7e71156
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 30 22:05:10 2009 -0600

    cpumask: remove dangerous CPU_MASK_ALL_PTR, &CPU_MASK_ALL
    
    Impact: cleanup
    
    (Thanks to Al Viro for reminding me of this, via Ingo)
    
    CPU_MASK_ALL is the (deprecated) "all bits set" cpumask, defined as so:
    
    	#define CPU_MASK_ALL (cpumask_t) { { ... } }
    
    Taking the address of such a temporary is questionable at best,
    unfortunately 321a8e9d (cpumask: add CPU_MASK_ALL_PTR macro) added
    CPU_MASK_ALL_PTR:
    
    	#define CPU_MASK_ALL_PTR (&CPU_MASK_ALL)
    
    Which formalizes this practice.  One day gcc could bite us over this
    usage (though we seem to have gotten away with it so far).
    
    So replace everywhere which used &CPU_MASK_ALL or CPU_MASK_ALL_PTR
    with the modern "cpu_all_mask" (a real const struct cpumask *).
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Acked-by: Ingo Molnar <mingo@elte.hu>
    Reported-by: Al Viro <viro@zeniv.linux.org.uk>
    Cc: Mike Travis <travis@sgi.com>

 init/main.c      |    2 +-
 kernel/kmod.c    |    2 +-
 kernel/kthread.c |    4 ++--
 mm/pdflush.c     |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

commit af76aba00fdcfb21535c9f9872245d14097a4561
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 30 22:05:11 2009 -0600

    cpumask: fix seq_bitmap_*() functions.
    
    1) seq_bitmap_list() should take a const.
    2) All the seq_bitmap should use cpumask_bits().
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 fs/seq_file.c            |    2 +-
 include/linux/seq_file.h |    9 +++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

commit 0451fb2ebc4f65c265bb51d71a2fc986ebf20218
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 30 22:05:11 2009 -0600

    cpumask: remove node_to_first_cpu
    
    Everyone defines it, and only one person uses it
    (arch/mips/sgi-ip27/ip27-nmi.c).  So just open code it there.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Cc: linux-mips@linux-mips.org

 arch/ia64/include/asm/topology.h           |    5 -----
 arch/mips/include/asm/mach-ip27/topology.h |    1 -
 arch/mips/sgi-ip27/ip27-nmi.c              |    2 +-
 arch/powerpc/include/asm/topology.h        |    5 -----
 arch/sh/include/asm/topology.h             |    1 -
 arch/sparc/include/asm/topology_64.h       |    5 -----
 arch/x86/include/asm/topology.h            |   12 ------------
 include/asm-generic/topology.h             |    3 ---
 8 files changed, 1 insertions(+), 33 deletions(-)

commit 2b17fa506c418e9fb02bbbc7f426d2bbb5b247a6
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 30 22:05:12 2009 -0600

    cpumask: use set_cpu_active in init/main.c
    
    cpu_active_map is deprecated in favor of cpu_active_mask, which is
    const for safety: we use accessors now (set_cpu_active) is we really
    want to make a change.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 init/main.c  |    3 +--
 kernel/cpu.c |    6 +++---
 2 files changed, 4 insertions(+), 5 deletions(-)

commit 9489424454c93f4d225d7af47978f8c7e84bf4d4
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 30 22:05:12 2009 -0600

    cpumask: use mm_cpumask() wrapper: kernel/fork.c
    
    Impact: futureproof
    
    Makes code futureproof against the impending change to mm->cpu_vm_mask.
    
    It's also a chance to use the new cpumask_ ops which take a pointer.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 kernel/fork.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

commit 1a8a51004a18b627ea81444201f7867875212f46
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 30 22:05:13 2009 -0600

    cpumask: remove references to struct irqaction's mask field.
    
    Impact: cleanup
    
    It's unused, since about 1995.  So remove all initialization of it in
    preparation for actually removing the field.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Acked-by: Thomas Gleixner <tglx@linutronix.de>

 arch/cris/arch-v10/kernel/time.c          |    1 -
 arch/cris/arch-v32/kernel/smp.c           |    1 -
 arch/cris/arch-v32/kernel/time.c          |    1 -
 arch/frv/kernel/irq-mb93091.c             |    4 ----
 arch/frv/kernel/irq-mb93093.c             |    1 -
 arch/frv/kernel/irq-mb93493.c             |    2 --
 arch/frv/kernel/time.c                    |    1 -
 arch/h8300/kernel/timer/itu.c             |    1 -
 arch/h8300/kernel/timer/timer16.c         |    1 -
 arch/h8300/kernel/timer/timer8.c          |    1 -
 arch/h8300/kernel/timer/tpu.c             |    1 -
 arch/m32r/kernel/time.c                   |    1 -
 arch/mips/cobalt/irq.c                    |    1 -
 arch/mips/emma/markeins/irq.c             |    1 -
 arch/mips/jazz/irq.c                      |    1 -
 arch/mips/kernel/cevt-bcm1480.c           |    1 -
 arch/mips/kernel/cevt-sb1250.c            |    1 -
 arch/mips/kernel/i8253.c                  |    2 --
 arch/mips/kernel/i8259.c                  |    1 -
 arch/mips/lasat/interrupt.c               |    1 -
 arch/mips/lemote/lm2e/irq.c               |    1 -
 arch/mips/sgi-ip32/ip32-irq.c             |    2 --
 arch/mips/sni/rm200.c                     |    3 ++-
 arch/mips/vr41xx/common/irq.c             |    1 -
 arch/mn10300/kernel/time.c                |    1 -
 arch/powerpc/platforms/85xx/mpc85xx_cds.c |    1 -
 arch/powerpc/platforms/8xx/m8xx_setup.c   |    1 -
 arch/powerpc/platforms/chrp/setup.c       |    1 -
 arch/powerpc/platforms/powermac/pic.c     |    2 --
 arch/powerpc/platforms/powermac/smp.c     |    1 -
 arch/powerpc/sysdev/cpm1.c                |    1 -
 arch/sh/kernel/time_64.c                  |    1 -
 arch/sh/kernel/timers/timer-cmt.c         |    1 -
 arch/sh/kernel/timers/timer-mtu2.c        |    1 -
 arch/sh/kernel/timers/timer-tmu.c         |    1 -
 arch/sparc/kernel/irq_32.c                |    2 --
 arch/sparc/kernel/sun4d_irq.c             |    1 -
 arch/x86/kernel/irqinit_32.c              |    2 --
 arch/x86/kernel/irqinit_64.c              |    1 -
 arch/x86/kernel/mfgpt_32.c                |    1 -
 arch/x86/kernel/setup.c                   |    1 -
 arch/x86/kernel/time_64.c                 |    2 --
 arch/x86/kernel/vmiclock_32.c             |    1 -
 43 files changed, 2 insertions(+), 53 deletions(-)

commit aa85ea5b89c36c51200d795dd788139bd9b8cf50
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 30 22:05:15 2009 -0600

    cpumask: use new cpumask_ functions in core code.
    
    Impact: cleanup
    
    Time to clean up remaining laggards using the old cpu_ functions.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Cc: Greg Kroah-Hartman <gregkh@suse.de>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Trond.Myklebust@netapp.com

 drivers/base/cpu.c     |    2 +-
 include/linux/cpuset.h |    4 ++--
 kernel/workqueue.c     |    6 +++---
 mm/allocpercpu.c       |    2 +-
 mm/vmstat.c            |    2 +-
 net/sunrpc/svc.c       |    2 +-
 6 files changed, 9 insertions(+), 9 deletions(-)

commit 73d0a4b107d58908305f272bfae9bd17f74a2c81
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 30 22:05:16 2009 -0600

    cpumask: convert rcutorture.c
    
    We're getting rid of cpumasks on the stack.
    
    Simply change tmp_mask to a global, and allocate it in
    rcu_torture_init().
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Acked-by: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
    Cc: Josh Triplett <josh@freedesktop.org>

 kernel/rcutorture.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

commit 612a726faf8486fa48b34fa37115ce1e7421d383
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 30 22:05:16 2009 -0600

    cpumask: remove cpumask_t from core
    
    Impact: cleanup
    
    struct cpumask is nicer, and we use it to make where we've made code
    safe for CONFIG_CPUMASK_OFFSTACK=y.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 kernel/sched_cpupri.h |    2 +-
 kernel/stop_machine.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

commit 97c12f85ac5e4ac2faee6cada014ac6205105b19
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 30 22:05:17 2009 -0600

    cpumask: remove the now-obsoleted pcibus_to_cpumask(): generic
    
    Impact: reduce stack usage for large NR_CPUS
    
    cpumask_of_pcibus() is the new version.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 include/asm-generic/topology.h |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

commit bb75efddeaca89f8a67fd82cdcbaaf436cf17ca9
Author: Russell King <rmk@arm.linux.org.uk>
Date:   Sun Mar 29 17:12:22 2009 +0100

    oprofile: Thou shalt not call __exit functions from __init functions
    
    Impact: fix ref to discarded function
    
    `buffer_sync_cleanup' referenced in section `.init.text' of arch/arm/oprofile/built-in.o: defined in discarded section `.exit.text' of arch/arm/oprofile/built-in.o
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 drivers/oprofile/buffer_sync.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/cris/arch-v10/kernel/time.c b/arch/cris/arch-v10/kernel/time.c
index c685ba4..2b73c7a 100644
--- a/arch/cris/arch-v10/kernel/time.c
+++ b/arch/cris/arch-v10/kernel/time.c
@@ -261,7 +261,6 @@ timer_interrupt(int irq, void *dev_id)
 static struct irqaction irq2  = {
 	.handler = timer_interrupt,
 	.flags = IRQF_SHARED | IRQF_DISABLED,
-	.mask = CPU_MASK_NONE,
 	.name = "timer",
 };
 
diff --git a/arch/cris/arch-v32/kernel/smp.c b/arch/cris/arch-v32/kernel/smp.c
index 9dac173..f59a973 100644
--- a/arch/cris/arch-v32/kernel/smp.c
+++ b/arch/cris/arch-v32/kernel/smp.c
@@ -65,7 +65,6 @@ static int send_ipi(int vector, int wait, cpumask_t cpu_mask);
 static struct irqaction irq_ipi  = {
 	.handler = crisv32_ipi_interrupt,
 	.flags = IRQF_DISABLED,
-	.mask = CPU_MASK_NONE,
 	.name = "ipi",
 };
 
diff --git a/arch/cris/arch-v32/kernel/time.c b/arch/cris/arch-v32/kernel/time.c
index 3a13dd6..65633d0 100644
--- a/arch/cris/arch-v32/kernel/time.c
+++ b/arch/cris/arch-v32/kernel/time.c
@@ -267,7 +267,6 @@ timer_interrupt(int irq, void *dev_id)
 static struct irqaction irq_timer = {
 	.handler = timer_interrupt,
 	.flags = IRQF_SHARED | IRQF_DISABLED,
-	.mask = CPU_MASK_NONE,
 	.name = "timer"
 };
 
diff --git a/arch/frv/kernel/irq-mb93091.c b/arch/frv/kernel/irq-mb93091.c
index 9e38f99..4dd9ada 100644
--- a/arch/frv/kernel/irq-mb93091.c
+++ b/arch/frv/kernel/irq-mb93091.c
@@ -109,28 +109,24 @@ static struct irqaction fpga_irq[4]  = {
 	[0] = {
 		.handler	= fpga_interrupt,
 		.flags		= IRQF_DISABLED | IRQF_SHARED,
-		.mask		= CPU_MASK_NONE,
 		.name		= "fpga.0",
 		.dev_id		= (void *) 0x0028UL,
 	},
 	[1] = {
 		.handler	= fpga_interrupt,
 		.flags		= IRQF_DISABLED | IRQF_SHARED,
-		.mask		= CPU_MASK_NONE,
 		.name		= "fpga.1",
 		.dev_id		= (void *) 0x0050UL,
 	},
 	[2] = {
 		.handler	= fpga_interrupt,
 		.flags		= IRQF_DISABLED | IRQF_SHARED,
-		.mask		= CPU_MASK_NONE,
 		.name		= "fpga.2",
 		.dev_id		= (void *) 0x1c00UL,
 	},
 	[3] = {
 		.handler	= fpga_interrupt,
 		.flags		= IRQF_DISABLED | IRQF_SHARED,
-		.mask		= CPU_MASK_NONE,
 		.name		= "fpga.3",
 		.dev_id		= (void *) 0x6386UL,
 	}
diff --git a/arch/frv/kernel/irq-mb93093.c b/arch/frv/kernel/irq-mb93093.c
index 3c2752c..e452090 100644
--- a/arch/frv/kernel/irq-mb93093.c
+++ b/arch/frv/kernel/irq-mb93093.c
@@ -108,7 +108,6 @@ static struct irqaction fpga_irq[1]  = {
 	[0] = {
 		.handler	= fpga_interrupt,
 		.flags		= IRQF_DISABLED,
-		.mask		= CPU_MASK_NONE,
 		.name		= "fpga.0",
 		.dev_id		= (void *) 0x0700UL,
 	}
diff --git a/arch/frv/kernel/irq-mb93493.c b/arch/frv/kernel/irq-mb93493.c
index 7754c73..ba55ecd 100644
--- a/arch/frv/kernel/irq-mb93493.c
+++ b/arch/frv/kernel/irq-mb93493.c
@@ -120,14 +120,12 @@ static struct irqaction mb93493_irq[2]  = {
 	[0] = {
 		.handler	= mb93493_interrupt,
 		.flags		= IRQF_DISABLED | IRQF_SHARED,
-		.mask		= CPU_MASK_NONE,
 		.name		= "mb93493.0",
 		.dev_id		= (void *) __addr_MB93493_IQSR(0),
 	},
 	[1] = {
 		.handler	= mb93493_interrupt,
 		.flags		= IRQF_DISABLED | IRQF_SHARED,
-		.mask		= CPU_MASK_NONE,
 		.name		= "mb93493.1",
 		.dev_id		= (void *) __addr_MB93493_IQSR(1),
 	}
diff --git a/arch/frv/kernel/time.c b/arch/frv/kernel/time.c
index 69f6a4e..fb0ce75 100644
--- a/arch/frv/kernel/time.c
+++ b/arch/frv/kernel/time.c
@@ -45,7 +45,6 @@ static irqreturn_t timer_interrupt(int irq, void *dummy);
 static struct irqaction timer_irq  = {
 	.handler = timer_interrupt,
 	.flags = IRQF_DISABLED,
-	.mask = CPU_MASK_NONE,
 	.name = "timer",
 };
 
diff --git a/arch/h8300/kernel/timer/itu.c b/arch/h8300/kernel/timer/itu.c
index d1c9265..4883ba7 100644
--- a/arch/h8300/kernel/timer/itu.c
+++ b/arch/h8300/kernel/timer/itu.c
@@ -60,7 +60,6 @@ static struct irqaction itu_irq = {
 	.name		= "itu",
 	.handler	= timer_interrupt,
 	.flags		= IRQF_DISABLED | IRQF_TIMER,
-	.mask		= CPU_MASK_NONE,
 };
 
 static const int __initdata divide_rate[] = {1, 2, 4, 8};
diff --git a/arch/h8300/kernel/timer/timer16.c b/arch/h8300/kernel/timer/timer16.c
index e14271b..042dbb5 100644
--- a/arch/h8300/kernel/timer/timer16.c
+++ b/arch/h8300/kernel/timer/timer16.c
@@ -55,7 +55,6 @@ static struct irqaction timer16_irq = {
 	.name		= "timer-16",
 	.handler	= timer_interrupt,
 	.flags		= IRQF_DISABLED | IRQF_TIMER,
-	.mask		= CPU_MASK_NONE,
 };
 
 static const int __initdata divide_rate[] = {1, 2, 4, 8};
diff --git a/arch/h8300/kernel/timer/timer8.c b/arch/h8300/kernel/timer/timer8.c
index 0556d7c..38be0ca 100644
--- a/arch/h8300/kernel/timer/timer8.c
+++ b/arch/h8300/kernel/timer/timer8.c
@@ -75,7 +75,6 @@ static struct irqaction timer8_irq = {
 	.name		= "timer-8",
 	.handler	= timer_interrupt,
 	.flags		= IRQF_DISABLED | IRQF_TIMER,
-	.mask		= CPU_MASK_NONE,
 };
 
 static const int __initdata divide_rate[] = {8, 64, 8192};
diff --git a/arch/h8300/kernel/timer/tpu.c b/arch/h8300/kernel/timer/tpu.c
index df7f453..ad383ca 100644
--- a/arch/h8300/kernel/timer/tpu.c
+++ b/arch/h8300/kernel/timer/tpu.c
@@ -65,7 +65,6 @@ static struct irqaction tpu_irq = {
 	.name		= "tpu",
 	.handler	= timer_interrupt,
 	.flags		= IRQF_DISABLED | IRQF_TIMER,
-	.mask		= CPU_MASK_NONE,
 };
 
 const static int __initdata divide_rate[] = {
diff --git a/arch/ia64/include/asm/topology.h b/arch/ia64/include/asm/topology.h
index 3193f44..f260dcf 100644
--- a/arch/ia64/include/asm/topology.h
+++ b/arch/ia64/include/asm/topology.h
@@ -44,11 +44,6 @@
 #define parent_node(nid) (nid)
 
 /*
- * Returns the number of the first CPU on Node 'node'.
- */
-#define node_to_first_cpu(node) (cpumask_first(cpumask_of_node(node)))
-
-/*
  * Determines the node for a given pci bus
  */
 #define pcibus_to_node(bus) PCI_CONTROLLER(bus)->node
diff --git a/arch/m32r/kernel/time.c b/arch/m32r/kernel/time.c
index 6ea0177..cada3ba 100644
--- a/arch/m32r/kernel/time.c
+++ b/arch/m32r/kernel/time.c
@@ -230,7 +230,6 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 static struct irqaction irq0 = {
 	.handler = timer_interrupt,
 	.flags = IRQF_DISABLED,
-	.mask = CPU_MASK_NONE,
 	.name = "MFT2",
 };
 
diff --git a/arch/mips/cobalt/irq.c b/arch/mips/cobalt/irq.c
index ac4fb91..cb9bf82 100644
--- a/arch/mips/cobalt/irq.c
+++ b/arch/mips/cobalt/irq.c
@@ -47,7 +47,6 @@ asmlinkage void plat_irq_dispatch(void)
 
 static struct irqaction cascade = {
 	.handler	= no_action,
-	.mask		= CPU_MASK_NONE,
 	.name		= "cascade",
 };
 
diff --git a/arch/mips/emma/markeins/irq.c b/arch/mips/emma/markeins/irq.c
index c2583ec..ff4e529 100644
--- a/arch/mips/emma/markeins/irq.c
+++ b/arch/mips/emma/markeins/irq.c
@@ -194,7 +194,6 @@ void emma2rh_gpio_irq_init(void)
 static struct irqaction irq_cascade = {
 	   .handler = no_action,
 	   .flags = 0,
-	   .mask = CPU_MASK_NONE,
 	   .name = "cascade",
 	   .dev_id = NULL,
 	   .next = NULL,
diff --git a/arch/mips/include/asm/mach-ip27/topology.h b/arch/mips/include/asm/mach-ip27/topology.h
index 55d4815..0754723 100644
--- a/arch/mips/include/asm/mach-ip27/topology.h
+++ b/arch/mips/include/asm/mach-ip27/topology.h
@@ -26,7 +26,6 @@ extern struct cpuinfo_ip27 sn_cpu_info[NR_CPUS];
 #define parent_node(node)	(node)
 #define node_to_cpumask(node)	(hub_data(node)->h_cpus)
 #define cpumask_of_node(node)	(&hub_data(node)->h_cpus)
-#define node_to_first_cpu(node)	(cpumask_first(cpumask_of_node(node)))
 struct pci_bus;
 extern int pcibus_to_node(struct pci_bus *);
 
diff --git a/arch/mips/jazz/irq.c b/arch/mips/jazz/irq.c
index 03965cb..d9b6a5b 100644
--- a/arch/mips/jazz/irq.c
+++ b/arch/mips/jazz/irq.c
@@ -134,7 +134,6 @@ static irqreturn_t r4030_timer_interrupt(int irq, void *dev_id)
 static struct irqaction r4030_timer_irqaction = {
 	.handler	= r4030_timer_interrupt,
 	.flags		= IRQF_DISABLED,
-	.mask		= CPU_MASK_CPU0,
 	.name		= "R4030 timer",
 };
 
diff --git a/arch/mips/kernel/cevt-bcm1480.c b/arch/mips/kernel/cevt-bcm1480.c
index b820661..a5182a2 100644
--- a/arch/mips/kernel/cevt-bcm1480.c
+++ b/arch/mips/kernel/cevt-bcm1480.c
@@ -144,7 +144,6 @@ void __cpuinit sb1480_clockevent_init(void)
 
 	action->handler	= sibyte_counter_handler;
 	action->flags	= IRQF_DISABLED | IRQF_PERCPU;
-	action->mask	= cpumask_of_cpu(cpu);
 	action->name	= name;
 	action->dev_id	= cd;
 
diff --git a/arch/mips/kernel/cevt-sb1250.c b/arch/mips/kernel/cevt-sb1250.c
index a2eebaa..340f53e 100644
--- a/arch/mips/kernel/cevt-sb1250.c
+++ b/arch/mips/kernel/cevt-sb1250.c
@@ -143,7 +143,6 @@ void __cpuinit sb1250_clockevent_init(void)
 
 	action->handler	= sibyte_counter_handler;
 	action->flags	= IRQF_DISABLED | IRQF_PERCPU;
-	action->mask	= cpumask_of_cpu(cpu);
 	action->name	= name;
 	action->dev_id	= cd;
 
diff --git a/arch/mips/kernel/i8253.c b/arch/mips/kernel/i8253.c
index f4d1878..689719e 100644
--- a/arch/mips/kernel/i8253.c
+++ b/arch/mips/kernel/i8253.c
@@ -98,7 +98,6 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 static struct irqaction irq0  = {
 	.handler = timer_interrupt,
 	.flags = IRQF_DISABLED | IRQF_NOBALANCING,
-	.mask = CPU_MASK_NONE,
 	.name = "timer"
 };
 
@@ -121,7 +120,6 @@ void __init setup_pit_timer(void)
 	cd->min_delta_ns = clockevent_delta2ns(0xF, cd);
 	clockevents_register_device(cd);
 
-	irq0.mask = cpumask_of_cpu(cpu);
 	setup_irq(0, &irq0);
 }
 
diff --git a/arch/mips/kernel/i8259.c b/arch/mips/kernel/i8259.c
index 413bd1d..01c0885 100644
--- a/arch/mips/kernel/i8259.c
+++ b/arch/mips/kernel/i8259.c
@@ -306,7 +306,6 @@ static void init_8259A(int auto_eoi)
  */
 static struct irqaction irq2 = {
 	.handler = no_action,
-	.mask = CPU_MASK_NONE,
 	.name = "cascade",
 };
 
diff --git a/arch/mips/lasat/interrupt.c b/arch/mips/lasat/interrupt.c
index d1ac7a2..1353fb1 100644
--- a/arch/mips/lasat/interrupt.c
+++ b/arch/mips/lasat/interrupt.c
@@ -104,7 +104,6 @@ asmlinkage void plat_irq_dispatch(void)
 
 static struct irqaction cascade = {
 	.handler	= no_action,
-	.mask		= CPU_MASK_NONE,
 	.name		= "cascade",
 };
 
diff --git a/arch/mips/lemote/lm2e/irq.c b/arch/mips/lemote/lm2e/irq.c
index 3e0b7be..1d0a09f 100644
--- a/arch/mips/lemote/lm2e/irq.c
+++ b/arch/mips/lemote/lm2e/irq.c
@@ -92,7 +92,6 @@ asmlinkage void plat_irq_dispatch(void)
 
 static struct irqaction cascade_irqaction = {
 	.handler = no_action,
-	.mask = CPU_MASK_NONE,
 	.name = "cascade",
 };
 
diff --git a/arch/mips/sgi-ip27/ip27-nmi.c b/arch/mips/sgi-ip27/ip27-nmi.c
index 64459e7..b174a51 100644
--- a/arch/mips/sgi-ip27/ip27-nmi.c
+++ b/arch/mips/sgi-ip27/ip27-nmi.c
@@ -219,7 +219,7 @@ cont_nmi_dump(void)
 		if (i == 1000) {
 			for_each_online_node(node)
 				if (NODEPDA(node)->dump_count == 0) {
-					cpu = node_to_first_cpu(node);
+					cpu = cpumask_first(cpumask_of_node(node));
 					for (n=0; n < CNODE_NUM_CPUS(node); cpu++, n++) {
 						CPUMASK_SETB(nmied_cpus, cpu);
 						/*
diff --git a/arch/mips/sgi-ip32/ip32-irq.c b/arch/mips/sgi-ip32/ip32-irq.c
index 0d6b666..9cb28cd 100644
--- a/arch/mips/sgi-ip32/ip32-irq.c
+++ b/arch/mips/sgi-ip32/ip32-irq.c
@@ -115,14 +115,12 @@ extern irqreturn_t crime_cpuerr_intr(int irq, void *dev_id);
 struct irqaction memerr_irq = {
 	.handler = crime_memerr_intr,
 	.flags = IRQF_DISABLED,
-	.mask = CPU_MASK_NONE,
 	.name = "CRIME memory error",
 };
 
 struct irqaction cpuerr_irq = {
 	.handler = crime_cpuerr_intr,
 	.flags = IRQF_DISABLED,
-	.mask = CPU_MASK_NONE,
 	.name = "CRIME CPU error",
 };
 
diff --git a/arch/mips/sni/rm200.c b/arch/mips/sni/rm200.c
index 5310aa7..a695a08 100644
--- a/arch/mips/sni/rm200.c
+++ b/arch/mips/sni/rm200.c
@@ -359,7 +359,8 @@ void sni_rm200_init_8259A(void)
  * IRQ2 is cascade interrupt to second interrupt controller
  */
 static struct irqaction sni_rm200_irq2 = {
-	no_action, 0, CPU_MASK_NONE, "cascade", NULL, NULL
+	.handler = no_action,
+	.name = "cascade",
 };
 
 static struct resource sni_rm200_pic1_resource = {
diff --git a/arch/mips/vr41xx/common/irq.c b/arch/mips/vr41xx/common/irq.c
index 92dd1a0..9cc3891 100644
--- a/arch/mips/vr41xx/common/irq.c
+++ b/arch/mips/vr41xx/common/irq.c
@@ -32,7 +32,6 @@ static irq_cascade_t irq_cascade[NR_IRQS] __cacheline_aligned;
 
 static struct irqaction cascade_irqaction = {
 	.handler	= no_action,
-	.mask		= CPU_MASK_NONE,
 	.name		= "cascade",
 };
 
diff --git a/arch/mn10300/kernel/time.c b/arch/mn10300/kernel/time.c
index e460658..395caf0 100644
--- a/arch/mn10300/kernel/time.c
+++ b/arch/mn10300/kernel/time.c
@@ -37,7 +37,6 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id);
 static struct irqaction timer_irq = {
 	.handler	= timer_interrupt,
 	.flags		= IRQF_DISABLED | IRQF_SHARED | IRQF_TIMER,
-	.mask		= CPU_MASK_NONE,
 	.name		= "timer",
 };
 
diff --git a/arch/powerpc/include/asm/topology.h b/arch/powerpc/include/asm/topology.h
index 3752585..054a16d 100644
--- a/arch/powerpc/include/asm/topology.h
+++ b/arch/powerpc/include/asm/topology.h
@@ -24,11 +24,6 @@ static inline cpumask_t node_to_cpumask(int node)
 
 #define cpumask_of_node(node) (&numa_cpumask_lookup_table[node])
 
-static inline int node_to_first_cpu(int node)
-{
-	return cpumask_first(cpumask_of_node(node));
-}
-
 int of_node_to_nid(struct device_node *device);
 
 struct pci_bus;
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_cds.c b/arch/powerpc/platforms/85xx/mpc85xx_cds.c
index aeb6a5b..02fe215 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_cds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_cds.c
@@ -179,7 +179,6 @@ static irqreturn_t mpc85xx_8259_cascade_action(int irq, void *dev_id)
 static struct irqaction mpc85xxcds_8259_irqaction = {
 	.handler = mpc85xx_8259_cascade_action,
 	.flags = IRQF_SHARED,
-	.mask = CPU_MASK_NONE,
 	.name = "8259 cascade",
 };
 #endif /* PPC_I8259 */
diff --git a/arch/powerpc/platforms/8xx/m8xx_setup.c b/arch/powerpc/platforms/8xx/m8xx_setup.c
index 0d9f75c..385acfc 100644
--- a/arch/powerpc/platforms/8xx/m8xx_setup.c
+++ b/arch/powerpc/platforms/8xx/m8xx_setup.c
@@ -44,7 +44,6 @@ static irqreturn_t timebase_interrupt(int irq, void *dev)
 
 static struct irqaction tbint_irqaction = {
 	.handler = timebase_interrupt,
-	.mask = CPU_MASK_NONE,
 	.name = "tbint",
 };
 
diff --git a/arch/powerpc/platforms/chrp/setup.c b/arch/powerpc/platforms/chrp/setup.c
index 272d79a..cd4ad9a 100644
--- a/arch/powerpc/platforms/chrp/setup.c
+++ b/arch/powerpc/platforms/chrp/setup.c
@@ -472,7 +472,6 @@ static void __init chrp_find_openpic(void)
 #if defined(CONFIG_VT) && defined(CONFIG_INPUT_ADBHID) && defined(CONFIG_XMON)
 static struct irqaction xmon_irqaction = {
 	.handler = xmon_irq,
-	.mask = CPU_MASK_NONE,
 	.name = "XMON break",
 };
 #endif
diff --git a/arch/powerpc/platforms/powermac/pic.c b/arch/powerpc/platforms/powermac/pic.c
index 6d149ae..7039d8f 100644
--- a/arch/powerpc/platforms/powermac/pic.c
+++ b/arch/powerpc/platforms/powermac/pic.c
@@ -266,7 +266,6 @@ static unsigned int pmac_pic_get_irq(void)
 static struct irqaction xmon_action = {
 	.handler	= xmon_irq,
 	.flags		= 0,
-	.mask		= CPU_MASK_NONE,
 	.name		= "NMI - XMON"
 };
 #endif
@@ -274,7 +273,6 @@ static struct irqaction xmon_action = {
 static struct irqaction gatwick_cascade_action = {
 	.handler	= gatwick_action,
 	.flags		= IRQF_DISABLED,
-	.mask		= CPU_MASK_NONE,
 	.name		= "cascade",
 };
 
diff --git a/arch/powerpc/platforms/powermac/smp.c b/arch/powerpc/platforms/powermac/smp.c
index bd8817b..cf1dbe7 100644
--- a/arch/powerpc/platforms/powermac/smp.c
+++ b/arch/powerpc/platforms/powermac/smp.c
@@ -385,7 +385,6 @@ static void __init psurge_dual_sync_tb(int cpu_nr)
 static struct irqaction psurge_irqaction = {
 	.handler = psurge_primary_intr,
 	.flags = IRQF_DISABLED,
-	.mask = CPU_MASK_NONE,
 	.name = "primary IPI",
 };
 
diff --git a/arch/powerpc/sysdev/cpm1.c b/arch/powerpc/sysdev/cpm1.c
index 490473c..82424cd 100644
--- a/arch/powerpc/sysdev/cpm1.c
+++ b/arch/powerpc/sysdev/cpm1.c
@@ -119,7 +119,6 @@ static irqreturn_t cpm_error_interrupt(int irq, void *dev)
 
 static struct irqaction cpm_error_irqaction = {
 	.handler = cpm_error_interrupt,
-	.mask = CPU_MASK_NONE,
 	.name = "error",
 };
 
diff --git a/arch/sh/include/asm/topology.h b/arch/sh/include/asm/topology.h
index 066f0fb..a3f2395 100644
--- a/arch/sh/include/asm/topology.h
+++ b/arch/sh/include/asm/topology.h
@@ -33,7 +33,6 @@
 
 #define node_to_cpumask(node)	((void)node, cpu_online_map)
 #define cpumask_of_node(node)	((void)node, cpu_online_mask)
-#define node_to_first_cpu(node)	((void)(node),0)
 
 #define pcibus_to_node(bus)	((void)(bus), -1)
 #define pcibus_to_cpumask(bus)	(pcibus_to_node(bus) == -1 ? \
diff --git a/arch/sh/kernel/time_64.c b/arch/sh/kernel/time_64.c
index 59d2a03..988c77c 100644
--- a/arch/sh/kernel/time_64.c
+++ b/arch/sh/kernel/time_64.c
@@ -284,7 +284,6 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 static struct irqaction irq0  = {
 	.handler = timer_interrupt,
 	.flags = IRQF_DISABLED,
-	.mask = CPU_MASK_NONE,
 	.name = "timer",
 };
 
diff --git a/arch/sh/kernel/timers/timer-cmt.c b/arch/sh/kernel/timers/timer-cmt.c
index c127293..9aa3486 100644
--- a/arch/sh/kernel/timers/timer-cmt.c
+++ b/arch/sh/kernel/timers/timer-cmt.c
@@ -109,7 +109,6 @@ static struct irqaction cmt_irq = {
 	.name		= "timer",
 	.handler	= cmt_timer_interrupt,
 	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
-	.mask		= CPU_MASK_NONE,
 };
 
 static void cmt_clk_init(struct clk *clk)
diff --git a/arch/sh/kernel/timers/timer-mtu2.c b/arch/sh/kernel/timers/timer-mtu2.c
index 9a77ae8..9b0ef01 100644
--- a/arch/sh/kernel/timers/timer-mtu2.c
+++ b/arch/sh/kernel/timers/timer-mtu2.c
@@ -115,7 +115,6 @@ static struct irqaction mtu2_irq = {
 	.name		= "timer",
 	.handler	= mtu2_timer_interrupt,
 	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
-	.mask		= CPU_MASK_NONE,
 };
 
 static unsigned int divisors[] = { 1, 4, 16, 64, 1, 1, 256 };
diff --git a/arch/sh/kernel/timers/timer-tmu.c b/arch/sh/kernel/timers/timer-tmu.c
index 10b5a6f..c5d3396 100644
--- a/arch/sh/kernel/timers/timer-tmu.c
+++ b/arch/sh/kernel/timers/timer-tmu.c
@@ -162,7 +162,6 @@ static struct irqaction tmu0_irq = {
 	.name		= "periodic/oneshot timer",
 	.handler	= tmu_timer_interrupt,
 	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
-	.mask		= CPU_MASK_NONE,
 };
 
 static void __init tmu_clk_init(struct clk *clk)
diff --git a/arch/sparc/include/asm/topology_64.h b/arch/sparc/include/asm/topology_64.h
index 5bc0b8f..2770f64 100644
--- a/arch/sparc/include/asm/topology_64.h
+++ b/arch/sparc/include/asm/topology_64.h
@@ -28,11 +28,6 @@ static inline cpumask_t node_to_cpumask(int node)
 #define node_to_cpumask_ptr_next(v, node)	\
 			   v = &(numa_cpumask_lookup_table[node])
 
-static inline int node_to_first_cpu(int node)
-{
-	return cpumask_first(cpumask_of_node(node));
-}
-
 struct pci_bus;
 #ifdef CONFIG_PCI
 extern int pcibus_to_node(struct pci_bus *pbus);
diff --git a/arch/sparc/kernel/irq_32.c b/arch/sparc/kernel/irq_32.c
index 44dd5ee..ad800b8 100644
--- a/arch/sparc/kernel/irq_32.c
+++ b/arch/sparc/kernel/irq_32.c
@@ -439,7 +439,6 @@ static int request_fast_irq(unsigned int irq,
 	flush_cache_all();
 
 	action->flags = irqflags;
-	cpus_clear(action->mask);
 	action->name = devname;
 	action->dev_id = NULL;
 	action->next = NULL;
@@ -574,7 +573,6 @@ int request_irq(unsigned int irq,
 
 	action->handler = handler;
 	action->flags = irqflags;
-	cpus_clear(action->mask);
 	action->name = devname;
 	action->next = NULL;
 	action->dev_id = dev_id;
diff --git a/arch/sparc/kernel/sun4d_irq.c b/arch/sparc/kernel/sun4d_irq.c
index 3369fef..ab036a7 100644
--- a/arch/sparc/kernel/sun4d_irq.c
+++ b/arch/sparc/kernel/sun4d_irq.c
@@ -326,7 +326,6 @@ int sun4d_request_irq(unsigned int irq,
 
 	action->handler = handler;
 	action->flags = irqflags;
-	cpus_clear(action->mask);
 	action->name = devname;
 	action->next = NULL;
 	action->dev_id = dev_id;
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 77cfb2c..744299c 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -217,10 +217,6 @@ static inline cpumask_t node_to_cpumask(int node)
 {
 	return cpu_online_map;
 }
-static inline int node_to_first_cpu(int node)
-{
-	return first_cpu(cpu_online_map);
-}
 
 static inline void setup_node_to_cpumask_map(void) { }
 
@@ -237,14 +233,6 @@ static inline void setup_node_to_cpumask_map(void) { }
 
 #include <asm-generic/topology.h>
 
-#ifdef CONFIG_NUMA
-/* Returns the number of the first CPU on Node 'node'. */
-static inline int node_to_first_cpu(int node)
-{
-	return cpumask_first(cpumask_of_node(node));
-}
-#endif
-
 extern cpumask_t cpu_coregroup_map(int cpu);
 extern const struct cpumask *cpu_coregroup_mask(int cpu);
 
diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
index 50b8c3a..458c554 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -50,7 +50,6 @@ static irqreturn_t math_error_irq(int cpl, void *dev_id)
  */
 static struct irqaction fpu_irq = {
 	.handler = math_error_irq,
-	.mask = CPU_MASK_NONE,
 	.name = "fpu",
 };
 
@@ -83,7 +82,6 @@ void __init init_ISA_irqs(void)
  */
 static struct irqaction irq2 = {
 	.handler = no_action,
-	.mask = CPU_MASK_NONE,
 	.name = "cascade",
 };
 
diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index da481a1..76abe43 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -45,7 +45,6 @@
 
 static struct irqaction irq2 = {
 	.handler = no_action,
-	.mask = CPU_MASK_NONE,
 	.name = "cascade",
 };
 DEFINE_PER_CPU(vector_irq_t, vector_irq) = {
diff --git a/arch/x86/kernel/mfgpt_32.c b/arch/x86/kernel/mfgpt_32.c
index 8815f3c..846510b 100644
--- a/arch/x86/kernel/mfgpt_32.c
+++ b/arch/x86/kernel/mfgpt_32.c
@@ -348,7 +348,6 @@ static irqreturn_t mfgpt_tick(int irq, void *dev_id)
 static struct irqaction mfgptirq  = {
 	.handler = mfgpt_tick,
 	.flags = IRQF_DISABLED | IRQF_NOBALANCING,
-	.mask = CPU_MASK_NONE,
 	.name = "mfgpt-timer"
 };
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index b746deb..900dad7 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1027,7 +1027,6 @@ void __init x86_quirk_trap_init(void)
 static struct irqaction irq0  = {
 	.handler = timer_interrupt,
 	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL | IRQF_TIMER,
-	.mask = CPU_MASK_NONE,
 	.name = "timer"
 };
 
diff --git a/arch/x86/kernel/time_64.c b/arch/x86/kernel/time_64.c
index 241ec39..5ba343e 100644
--- a/arch/x86/kernel/time_64.c
+++ b/arch/x86/kernel/time_64.c
@@ -116,7 +116,6 @@ unsigned long __init calibrate_cpu(void)
 static struct irqaction irq0 = {
 	.handler	= timer_interrupt,
 	.flags		= IRQF_DISABLED | IRQF_IRQPOLL | IRQF_NOBALANCING | IRQF_TIMER,
-	.mask		= CPU_MASK_NONE,
 	.name		= "timer"
 };
 
@@ -125,7 +124,6 @@ void __init hpet_time_init(void)
 	if (!hpet_enable())
 		setup_pit_timer();
 
-	irq0.mask = cpumask_of_cpu(0);
 	setup_irq(0, &irq0);
 }
 
diff --git a/arch/x86/kernel/vmiclock_32.c b/arch/x86/kernel/vmiclock_32.c
index 33a788d..d303369 100644
--- a/arch/x86/kernel/vmiclock_32.c
+++ b/arch/x86/kernel/vmiclock_32.c
@@ -202,7 +202,6 @@ static struct irqaction vmi_clock_action  = {
 	.name 		= "vmi-timer",
 	.handler 	= vmi_timer_interrupt,
 	.flags 		= IRQF_DISABLED | IRQF_NOBALANCING | IRQF_TIMER,
-	.mask 		= CPU_MASK_ALL,
 };
 
 static void __devinit vmi_time_init_clockevent(void)
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 5b257a5..e62a4cc 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -119,7 +119,7 @@ static ssize_t print_cpus_map(char *buf, const struct cpumask *map)
 #define	print_cpus_func(type) \
 static ssize_t print_cpus_##type(struct sysdev_class *class, char *buf)	\
 {									\
-	return print_cpus_map(buf, &cpu_##type##_map);			\
+	return print_cpus_map(buf, cpu_##type##_mask);			\
 }									\
 static struct sysdev_class_attribute attr_##type##_map = 		\
 	_SYSDEV_CLASS_ATTR(type, 0444, print_cpus_##type, NULL)
diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index c3ea5fa..2c9aa49 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -574,7 +574,7 @@ int __init buffer_sync_init(void)
 		return 0;
 }
 
-void __exit buffer_sync_cleanup(void)
+void buffer_sync_cleanup(void)
 {
 	free_cpumask_var(marked_cpus);
 }
diff --git a/fs/seq_file.c b/fs/seq_file.c
index a1a4cfe..7f40f30 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -513,7 +513,7 @@ int seq_bitmap(struct seq_file *m, const unsigned long *bits,
 }
 EXPORT_SYMBOL(seq_bitmap);
 
-int seq_bitmap_list(struct seq_file *m, unsigned long *bits,
+int seq_bitmap_list(struct seq_file *m, const unsigned long *bits,
 		unsigned int nr_bits)
 {
 	if (m->count < m->size) {
diff --git a/include/asm-generic/topology.h b/include/asm-generic/topology.h
index 0e9e2bc..88bada2 100644
--- a/include/asm-generic/topology.h
+++ b/include/asm-generic/topology.h
@@ -43,20 +43,10 @@
 #ifndef cpumask_of_node
 #define cpumask_of_node(node)	((void)node, cpu_online_mask)
 #endif
-#ifndef node_to_first_cpu
-#define node_to_first_cpu(node)	((void)(node),0)
-#endif
 #ifndef pcibus_to_node
 #define pcibus_to_node(bus)	((void)(bus), -1)
 #endif
 
-#ifndef pcibus_to_cpumask
-#define pcibus_to_cpumask(bus)	(pcibus_to_node(bus) == -1 ? \
-					CPU_MASK_ALL : \
-					node_to_cpumask(pcibus_to_node(bus)) \
-				)
-#endif
-
 #ifndef cpumask_of_pcibus
 #define cpumask_of_pcibus(bus)	(pcibus_to_node(bus) == -1 ?		\
 				 cpu_all_mask :				\
diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 90c6074..2e0d796 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -90,12 +90,12 @@ static inline void cpuset_init_smp(void) {}
 static inline void cpuset_cpus_allowed(struct task_struct *p,
 				       struct cpumask *mask)
 {
-	*mask = cpu_possible_map;
+	cpumask_copy(mask, cpu_possible_mask);
 }
 static inline void cpuset_cpus_allowed_locked(struct task_struct *p,
 					      struct cpumask *mask)
 {
-	*mask = cpu_possible_map;
+	cpumask_copy(mask, cpu_possible_mask);
 }
 
 static inline nodemask_t cpuset_mems_allowed(struct task_struct *p)
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index f616f31..004f3b3 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -55,7 +55,7 @@ int seq_bitmap(struct seq_file *m, const unsigned long *bits,
 				   unsigned int nr_bits);
 static inline int seq_cpumask(struct seq_file *m, const struct cpumask *mask)
 {
-	return seq_bitmap(m, mask->bits, nr_cpu_ids);
+	return seq_bitmap(m, cpumask_bits(mask), nr_cpu_ids);
 }
 
 static inline int seq_nodemask(struct seq_file *m, nodemask_t *mask)
@@ -63,12 +63,13 @@ static inline int seq_nodemask(struct seq_file *m, nodemask_t *mask)
 	return seq_bitmap(m, mask->bits, MAX_NUMNODES);
 }
 
-int seq_bitmap_list(struct seq_file *m, unsigned long *bits,
+int seq_bitmap_list(struct seq_file *m, const unsigned long *bits,
 		unsigned int nr_bits);
 
-static inline int seq_cpumask_list(struct seq_file *m, cpumask_t *mask)
+static inline int seq_cpumask_list(struct seq_file *m,
+				   const struct cpumask *mask)
 {
-	return seq_bitmap_list(m, mask->bits, NR_CPUS);
+	return seq_bitmap_list(m, cpumask_bits(mask), nr_cpu_ids);
 }
 
 static inline int seq_nodemask_list(struct seq_file *m, nodemask_t *mask)
diff --git a/init/main.c b/init/main.c
index 6bf83af..d6b388f 100644
--- a/init/main.c
+++ b/init/main.c
@@ -407,8 +407,7 @@ static void __init smp_init(void)
 	 * Set up the current CPU as possible to migrate to.
 	 * The other ones will be done by cpu_up/cpu_down()
 	 */
-	cpu = smp_processor_id();
-	cpu_set(cpu, cpu_active_map);
+	set_cpu_active(smp_processor_id(), true);
 
 	/* FIXME: This should be done in userspace --RR */
 	for_each_present_cpu(cpu) {
@@ -842,7 +841,7 @@ static int __init kernel_init(void * unused)
 	/*
 	 * init can run on any cpu.
 	 */
-	set_cpus_allowed_ptr(current, CPU_MASK_ALL_PTR);
+	set_cpus_allowed_ptr(current, cpu_all_mask);
 	/*
 	 * Tell the world that we're going to be the grim
 	 * reaper of innocent orphaned children.
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 79e40f0..395b697 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -281,7 +281,7 @@ int __ref cpu_down(unsigned int cpu)
 		goto out;
 	}
 
-	cpu_clear(cpu, cpu_active_map);
+	set_cpu_active(cpu, false);
 
 	/*
 	 * Make sure the all cpus did the reschedule and are not
@@ -296,7 +296,7 @@ int __ref cpu_down(unsigned int cpu)
 	err = _cpu_down(cpu, 0);
 
 	if (cpu_online(cpu))
-		cpu_set(cpu, cpu_active_map);
+		set_cpu_active(cpu, true);
 
 out:
 	cpu_maps_update_done();
@@ -333,7 +333,7 @@ static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
 		goto out_notify;
 	BUG_ON(!cpu_online(cpu));
 
-	cpu_set(cpu, cpu_active_map);
+	set_cpu_active(cpu, true);
 
 	/* Now call notifier in preparation. */
 	raw_notifier_call_chain(&cpu_chain, CPU_ONLINE | mod, hcpu);
diff --git a/kernel/fork.c b/kernel/fork.c
index 6715ebc..47c1584 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -284,7 +284,7 @@ static int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 	mm->free_area_cache = oldmm->mmap_base;
 	mm->cached_hole_size = ~0UL;
 	mm->map_count = 0;
-	cpus_clear(mm->cpu_vm_mask);
+	cpumask_clear(mm_cpumask(mm));
 	mm->mm_rb = RB_ROOT;
 	rb_link = &mm->mm_rb.rb_node;
 	rb_parent = NULL;
diff --git a/kernel/kmod.c b/kernel/kmod.c
index a27a5f6..f0c8f54 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -167,7 +167,7 @@ static int ____call_usermodehelper(void *data)
 	}
 
 	/* We can run anywhere, unlike our parent keventd(). */
-	set_cpus_allowed_ptr(current, CPU_MASK_ALL_PTR);
+	set_cpus_allowed_ptr(current, cpu_all_mask);
 
 	/*
 	 * Our parent is keventd, which runs with elevated scheduling priority.
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 4fbc456..84bbadd 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -110,7 +110,7 @@ static void create_kthread(struct kthread_create_info *create)
 		 */
 		sched_setscheduler(create->result, SCHED_NORMAL, &param);
 		set_user_nice(create->result, KTHREAD_NICE_LEVEL);
-		set_cpus_allowed_ptr(create->result, CPU_MASK_ALL_PTR);
+		set_cpus_allowed_ptr(create->result, cpu_all_mask);
 	}
 	complete(&create->done);
 }
@@ -240,7 +240,7 @@ int kthreadd(void *unused)
 	set_task_comm(tsk, "kthreadd");
 	ignore_signals(tsk);
 	set_user_nice(tsk, KTHREAD_NICE_LEVEL);
-	set_cpus_allowed_ptr(tsk, CPU_MASK_ALL_PTR);
+	set_cpus_allowed_ptr(tsk, cpu_all_mask);
 
 	current->flags |= PF_NOFREEZE | PF_FREEZER_NOSIG;
 
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 7c4142a..9b4a975 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -126,6 +126,7 @@ static atomic_t n_rcu_torture_mberror;
 static atomic_t n_rcu_torture_error;
 static long n_rcu_torture_timers = 0;
 static struct list_head rcu_torture_removed;
+static cpumask_var_t shuffle_tmp_mask;
 
 static int stutter_pause_test = 0;
 
@@ -889,10 +890,9 @@ static int rcu_idle_cpu;	/* Force all torture tasks off this CPU */
  */
 static void rcu_torture_shuffle_tasks(void)
 {
-	cpumask_t tmp_mask;
 	int i;
 
-	cpus_setall(tmp_mask);
+	cpumask_setall(shuffle_tmp_mask);
 	get_online_cpus();
 
 	/* No point in shuffling if there is only one online CPU (ex: UP) */
@@ -902,29 +902,29 @@ static void rcu_torture_shuffle_tasks(void)
 	}
 
 	if (rcu_idle_cpu != -1)
-		cpu_clear(rcu_idle_cpu, tmp_mask);
+		cpumask_clear_cpu(rcu_idle_cpu, shuffle_tmp_mask);
 
-	set_cpus_allowed_ptr(current, &tmp_mask);
+	set_cpus_allowed_ptr(current, shuffle_tmp_mask);
 
 	if (reader_tasks) {
 		for (i = 0; i < nrealreaders; i++)
 			if (reader_tasks[i])
 				set_cpus_allowed_ptr(reader_tasks[i],
-						     &tmp_mask);
+						     shuffle_tmp_mask);
 	}
 
 	if (fakewriter_tasks) {
 		for (i = 0; i < nfakewriters; i++)
 			if (fakewriter_tasks[i])
 				set_cpus_allowed_ptr(fakewriter_tasks[i],
-						     &tmp_mask);
+						     shuffle_tmp_mask);
 	}
 
 	if (writer_task)
-		set_cpus_allowed_ptr(writer_task, &tmp_mask);
+		set_cpus_allowed_ptr(writer_task, shuffle_tmp_mask);
 
 	if (stats_task)
-		set_cpus_allowed_ptr(stats_task, &tmp_mask);
+		set_cpus_allowed_ptr(stats_task, shuffle_tmp_mask);
 
 	if (rcu_idle_cpu == -1)
 		rcu_idle_cpu = num_online_cpus() - 1;
@@ -1012,6 +1012,7 @@ rcu_torture_cleanup(void)
 	if (shuffler_task) {
 		VERBOSE_PRINTK_STRING("Stopping rcu_torture_shuffle task");
 		kthread_stop(shuffler_task);
+		free_cpumask_var(shuffle_tmp_mask);
 	}
 	shuffler_task = NULL;
 
@@ -1190,10 +1191,18 @@ rcu_torture_init(void)
 	}
 	if (test_no_idle_hz) {
 		rcu_idle_cpu = num_online_cpus() - 1;
+
+		if (!alloc_cpumask_var(&shuffle_tmp_mask, GFP_KERNEL)) {
+			firsterr = -ENOMEM;
+			VERBOSE_PRINTK_ERRSTRING("Failed to alloc mask");
+			goto unwind;
+		}
+
 		/* Create the shuffler thread */
 		shuffler_task = kthread_run(rcu_torture_shuffle, NULL,
 					  "rcu_torture_shuffle");
 		if (IS_ERR(shuffler_task)) {
+			free_cpumask_var(shuffle_tmp_mask);
 			firsterr = PTR_ERR(shuffler_task);
 			VERBOSE_PRINTK_ERRSTRING("Failed to create shuffler");
 			shuffler_task = NULL;
diff --git a/kernel/sched_cpupri.h b/kernel/sched_cpupri.h
index 642a94e..9a7e859 100644
--- a/kernel/sched_cpupri.h
+++ b/kernel/sched_cpupri.h
@@ -25,7 +25,7 @@ struct cpupri {
 
 #ifdef CONFIG_SMP
 int  cpupri_find(struct cpupri *cp,
-		 struct task_struct *p, cpumask_t *lowest_mask);
+		 struct task_struct *p, struct cpumask *lowest_mask);
 void cpupri_set(struct cpupri *cp, int cpu, int pri);
 int cpupri_init(struct cpupri *cp, bool bootmem);
 void cpupri_cleanup(struct cpupri *cp);
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 74541ca..912823e 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -44,7 +44,7 @@ static DEFINE_MUTEX(setup_lock);
 static int refcount;
 static struct workqueue_struct *stop_machine_wq;
 static struct stop_machine_data active, idle;
-static const cpumask_t *active_cpus;
+static const struct cpumask *active_cpus;
 static void *stop_machine_work;
 
 static void set_state(enum stopmachine_state newstate)
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 1f0c509..9aedd9f 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -416,7 +416,7 @@ void flush_workqueue(struct workqueue_struct *wq)
 	might_sleep();
 	lock_map_acquire(&wq->lockdep_map);
 	lock_map_release(&wq->lockdep_map);
-	for_each_cpu_mask_nr(cpu, *cpu_map)
+	for_each_cpu(cpu, cpu_map)
 		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
@@ -547,7 +547,7 @@ static void wait_on_work(struct work_struct *work)
 	wq = cwq->wq;
 	cpu_map = wq_cpu_map(wq);
 
-	for_each_cpu_mask_nr(cpu, *cpu_map)
+	for_each_cpu(cpu, cpu_map)
 		wait_on_cpu_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
 }
 
@@ -911,7 +911,7 @@ void destroy_workqueue(struct workqueue_struct *wq)
 	list_del(&wq->list);
 	spin_unlock(&workqueue_lock);
 
-	for_each_cpu_mask_nr(cpu, *cpu_map)
+	for_each_cpu(cpu, cpu_map)
 		cleanup_workqueue_thread(per_cpu_ptr(wq->cpu_wq, cpu));
  	cpu_maps_update_done();
 
diff --git a/mm/allocpercpu.c b/mm/allocpercpu.c
index 1882923..139d5b7 100644
--- a/mm/allocpercpu.c
+++ b/mm/allocpercpu.c
@@ -143,7 +143,7 @@ void free_percpu(void *__pdata)
 {
 	if (unlikely(!__pdata))
 		return;
-	__percpu_depopulate_mask(__pdata, &cpu_possible_map);
+	__percpu_depopulate_mask(__pdata, cpu_possible_mask);
 	kfree(__percpu_disguise(__pdata));
 }
 EXPORT_SYMBOL_GPL(free_percpu);
diff --git a/mm/pdflush.c b/mm/pdflush.c
index 15de509..118905e 100644
--- a/mm/pdflush.c
+++ b/mm/pdflush.c
@@ -191,7 +191,7 @@ static int pdflush(void *dummy)
 
 	/*
 	 * Some configs put our parent kthread in a limited cpuset,
-	 * which kthread() overrides, forcing cpus_allowed == CPU_MASK_ALL.
+	 * which kthread() overrides, forcing cpus_allowed == cpu_all_mask.
 	 * Our needs are more modest - cut back to our cpusets cpus_allowed.
 	 * This is needed as pdflush's are dynamically created and destroyed.
 	 * The boottime pdflush's are easily placed w/o these 2 lines.
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 9114974..8cd81ea 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -27,7 +27,7 @@ static void sum_vm_events(unsigned long *ret, const struct cpumask *cpumask)
 
 	memset(ret, 0, NR_VM_EVENT_ITEMS * sizeof(unsigned long));
 
-	for_each_cpu_mask_nr(cpu, *cpumask) {
+	for_each_cpu(cpu, cpumask) {
 		struct vm_event_state *this = &per_cpu(vm_event_states, cpu);
 
 		for (i = 0; i < NR_VM_EVENT_ITEMS; i++)
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index c51fed4..bb507e2 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -312,7 +312,7 @@ svc_pool_map_set_cpumask(struct task_struct *task, unsigned int pidx)
 	switch (m->mode) {
 	case SVC_POOL_PERCPU:
 	{
-		set_cpus_allowed_ptr(task, &cpumask_of_cpu(node));
+		set_cpus_allowed_ptr(task, cpumask_of(node));
 		break;
 	}
 	case SVC_POOL_PERNODE:
