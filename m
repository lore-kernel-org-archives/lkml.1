Return-Path: <linux-kernel-owner+w=401wt.eu-S1030563AbXAYUzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030563AbXAYUzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 15:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965605AbXAYUzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 15:55:00 -0500
Received: from agmk.net ([87.236.194.20]:1641 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965596AbXAYUy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 15:54:59 -0500
From: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20rc5 k8/acpi regression ( 2.6.17.13 works fine ).
Date: Thu, 25 Jan 2007 21:54:16 +0100
User-Agent: KMail/1.9.6
Cc: Len Brown <lenb@kernel.org>, Adrian Bunk <bunk@stusta.de>,
       linux-acpi@vger.kernel.org, cpufreq@lists.linux.org.uk
References: <200701242346.44673.pluto@agmk.net> <20070124225238.GT17836@stusta.de> <200701242350.45276.lenb@kernel.org>
In-Reply-To: <200701242350.45276.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200701252154.16723.pluto@agmk.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 of January 2007 05:50:45 Len Brown wrote:
> On Wednesday 24 January 2007 17:52, Adrian Bunk wrote:
> > On Wed, Jan 24, 2007 at 11:46:44PM +0100, Paweł Sikora wrote:
> > > for 2.6.20rc5 i get an acpi related oops during x86-64 boot:
> > > http://minus.ds14.agh.edu.pl/~pluto/2.6.20rc5-acpi-oops.jpg
> > > disabling the "amd-k8 cool'n'quiet" option in bios helps.
> > > moreover, it works fine for 2.6.17.13, so it looks like
> > > a recent regression. i can provide more details if you need.
> >
> > thanks for your report.
> >
> > Can you narrow down a bit when it started?
> > Is 2.6.19 OK?
> > Is 2.6.18 OK?

ok, here are results of my tests:

M/B: http://www.epox.nl/products/view.php?product_id=421

$ cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 55
model name      : AMD Athlon(tm) 64 Processor 3700+
stepping        : 2
cpu MHz         : 2200.000
cache size      : 1024 KB
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx mmxext fxsr_opt lm 
3dnowext 3dnow pni lahf_lm
bogomips        : 4423.06
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp

amd-k8 cool'n'quiet enabled in bios.

2.6.17.13-uni, 2.6.17.14-smp, 2.6.18.6-smp and 2.6.20rc5-uni work.
2.6.20rc5-smp ooopses during boot but works if c'n'q is disabled.
pure 2.6.19.x not tested yet...

> Is the stack trace always the same?  It doesn't make much sense to me.
>
> if AMD cool & quiet is enabled in the BIOS, but CONFIG_CPU_FREQ=n
> in the kernel, do you see the same problem?

looks like not related to config_cpu_freq.
