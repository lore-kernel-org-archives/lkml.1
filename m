Return-Path: <linux-kernel-owner+w=401wt.eu-S1755289AbZGKLKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbZGKLKc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 07:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbZGKLKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 07:10:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:46570 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754877AbZGKLKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 07:10:12 -0400
Subject: Re: [tip:x86/cleanups] x86/cpu: Clean up various files a bit
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: mingo@redhat.com
Cc: hpa@zytor.com, alan@linux.intel.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <1247310026.3032.17.camel@hpdv5.satnam>
References: <new-submission>
	 <tip-8bdbd962ecfcbdd96f9dbb02d780b4553afd2543@git.kernel.org>
	 <1247310026.3032.17.camel@hpdv5.satnam>
Content-Type: text/plain
Date: Sat, 11 Jul 2009 16:39:23 +0530
Message-Id: <1247310563.3032.20.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-07-11 at 16:30 +0530, Jaswinder Singh Rajput wrote:
> On Sat, 2009-07-11 at 09:57 +0000, tip-bot for Alan Cox wrote:
> > Commit-ID:  8bdbd962ecfcbdd96f9dbb02d780b4553afd2543
> > Gitweb:     http://git.kernel.org/tip/8bdbd962ecfcbdd96f9dbb02d780b4553afd2543
> > Author:     Alan Cox <alan@linux.intel.com>
> > AuthorDate: Sat, 4 Jul 2009 00:35:45 +0100
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Sat, 11 Jul 2009 11:24:09 +0200
> > 
> > x86/cpu: Clean up various files a bit
> > 
> > No code changes except printk levels (although some of the K6
> > mtrr code might be clearer if there were a few as would
> > splitting out some of the intel cache code).
> > 
> > Signed-off-by: Alan Cox <alan@linux.intel.com>
> > LKML-Reference: <new-submission>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > 
> > 
> > ---
> >  arch/x86/kernel/cpu/amd.c              |   37 ++++++-----
> >  arch/x86/kernel/cpu/bugs.c             |   10 ++--
> >  arch/x86/kernel/cpu/bugs_64.c          |    2 +-
> >  arch/x86/kernel/cpu/common.c           |    8 +-
> >  arch/x86/kernel/cpu/cyrix.c            |   19 +++--
> >  arch/x86/kernel/cpu/hypervisor.c       |    5 +-
> >  arch/x86/kernel/cpu/intel.c            |   11 ++--
> >  arch/x86/kernel/cpu/intel_cacheinfo.c  |  116 ++++++++++++++++---------------
> >  arch/x86/kernel/cpu/perfctr-watchdog.c |   45 ++++++------
> >  arch/x86/kernel/cpu/proc.c             |    2 +-
> >  arch/x86/kernel/cpu/vmware.c           |   18 +++---
> >  11 files changed, 144 insertions(+), 129 deletions(-)
> > 

> > diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> > index d6f27c9..c96ea44 100644
> > --- a/arch/x86/kernel/cpu/common.c
> > +++ b/arch/x86/kernel/cpu/common.c
> > @@ -18,8 +18,8 @@
> >  #include <asm/hypervisor.h>
> >  #include <asm/processor.h>
> >  #include <asm/sections.h>
> > -#include <asm/topology.h>
> > -#include <asm/cpumask.h>
> > +#include <linux/topology.h>
> > +#include <linux/cpumask.h>
> 
> ditto
> 

And <linux/cpumask.h> is not replacement of <asm/cpumask.h>

> >  #include <asm/pgtable.h>
> >  #include <asm/atomic.h>
> >  #include <asm/proto.h>
> > @@ -28,13 +28,13 @@
> >  #include <asm/desc.h>
> >  #include <asm/i387.h>
> >  #include <asm/mtrr.h>
> > -#include <asm/numa.h>
> > +#include <linux/numa.h>
> 
> ditto.
> 

And <linux/numa.h> is not replacement of <asm/numa.h>

> >  
> >  #ifdef CONFIG_X86_LOCAL_APIC
> >  #include <asm/uv/uv.h>
> > diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
> > index 593171e..19807b8 100644
> > --- a/arch/x86/kernel/cpu/cyrix.c
> > +++ b/arch/x86/kernel/cpu/cyrix.c
> > @@ -3,10 +3,10 @@
> >  #include <linux/delay.h>
> >  #include <linux/pci.h>
> >  #include <asm/dma.h>
> > -#include <asm/io.h>
> > +#include <linux/io.h>
> >  #include <asm/processor-cyrix.h>
> >  #include <asm/processor-flags.h>
> > -#include <asm/timer.h>
> > +#include <linux/timer.h>


And <linux/timer.h> is not replacement of <asm/timer.h>

Good work, Carry On.

--
JSR

