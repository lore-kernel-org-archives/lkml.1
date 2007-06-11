Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbXFKPzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbXFKPzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 11:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbXFKPzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 11:55:32 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:57946 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426AbXFKPz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 11:55:29 -0400
Date: Mon, 11 Jun 2007 08:55:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Dinakar Guniguntala <dino@in.ibm.com>
Subject: Re: v2.6.21.4-rt11
Message-ID: <20070611155527.GD9102@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070609210507.GA29194@elte.hu> <20070611011954.GG27982@linux.vnet.ibm.com> <20070611073634.GB32446@elte.hu> <20070611144401.GA9102@linux.vnet.ibm.com> <20070611153855.GA21136@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070611153855.GA21136@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2007 at 05:38:55PM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > > hm, what affinity do they start out with? Could they all be pinned 
> > > to CPU#0 by default?
> > 
> > They start off with affinity masks of 0xf on a 4-CPU system.  I would 
> > expect them to load-balance across the four CPUs, but they stay all on 
> > the same CPU until long after I lose patience (many minutes).
> 
> ugh. Would be nice to figure out why this happens. I enabled rcutorture 
> on a dual-core CPU and all the threads are spread evenly.

Here is the /proc/cpuinfo in case this helps.  I am starting up a test
on a dual-core CPU to see if that works better.

							Thanx, Paul

processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 5
model name      : AMD Opteron(tm) Processor 844
stepping        : 8
cpu MHz         : 1793.105
cache size      : 1024 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 syscall mmxext lm 3dnowext 3dnow
bogomips        : 3522.56

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 5
model name      : AMD Opteron(tm) Processor 844
stepping        : 8
cpu MHz         : 1793.105
cache size      : 1024 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 syscall mmxext lm 3dnowext 3dnow
bogomips        : 3579.90

processor       : 2
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 5
model name      : AMD Opteron(tm) Processor 844
stepping        : 8
cpu MHz         : 1793.105
cache size      : 1024 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 syscall mmxext lm 3dnowext 3dnow
bogomips        : 3579.90

processor       : 3
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 5
model name      : AMD Opteron(tm) Processor 844
stepping        : 8
cpu MHz         : 1793.105
cache size      : 1024 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 syscall mmxext lm 3dnowext 3dnow
bogomips        : 3579.90

