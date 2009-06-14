Return-Path: <linux-kernel-owner+w=401wt.eu-S1751729AbZFNFnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729AbZFNFnB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 01:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbZFNFmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 01:42:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:45597 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbZFNFmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 01:42:51 -0400
Subject: Re: [RFC][GIT PULL][PATCH 0/10 -tip] cpu_debug patches 20090613
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       x86 maintainers <x86@kernel.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Dave Jones <davej@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robert Richter <robert.richter@amd.com>, rth@twiddle.net,
       starvik@axis.com, geert@linux-m68k.org, dhowells@redhat.com,
       lethal@linux-sh.org, chris@zankel.net, linux@arm.linux.org.uk,
       dhowells@redhat.com, tony.luck@intel.com, philb@gnu.org,
       kyle@mcmartin.ca, davem@davemloft.net, hskinnemoen@atmel.com,
       monstr@monstr.eu, benh@kernel.crashing.org, vapier@gentoo.org,
       ysato@users.sourceforge.jp, takata@linux-m32r.org, ralf@linux-mips.org,
       schwidefsky@de.ibm.com
In-Reply-To: <alpine.LFD.2.00.0906132056540.2800@localhost.localdomain>
References: <1244910436.11733.14.camel@ht.satnam>
	 <alpine.LFD.2.00.0906132056540.2800@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 14 Jun 2009 11:05:39 +0530
Message-Id: <1244957739.2679.42.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-14 at 00:27 +0200, Thomas Gleixner wrote:
> On Sat, 13 Jun 2009, Jaswinder Singh Rajput wrote:
> 
> > Please let me know how we can improve it and add more features so it
> > becomes more useful.
> 
> I really have to ask, why this is useful at all.
> 

Currently for X86 I can do :

1. read complete state (dump all registers like for MTRR, APIC)
2. read individual register
3. write to individual register
4. read/write these registers/info with shell through debugfs
5. read these registers/info before getting shell

And I did this for complete X86 CPU registers and info:
1. Standard Registers
2. Control Registers
3. Debug Registers
4. Descriptor Tables
5. APIC Registers
6. Model specific Register (MSRs)
7. PCI configuration registers (for AMD)
8. Basic cpuinfo
9. CPUID Functions

This will be really useful for :
1. developer who is porting/developing the kernel or drivers.
2. User who is reading hardware manual and want to see these value on
its CPU

Of course you need a Hardware manual to check address and detail
information. I do not want to keep detail for each register.

In X86 many tools are available which can read many registers but not
available for many architectures (I CCed some architecture maintainers
so that they can also specify issues they face when supporting new
CPU/architecture), they can also take advantage of it if we move
cpu_debug architecture independent portion outside X86.

I am not against of any tool but some issues about tools are :
1. Not supported for all architectures
2. Do not support latest or upcoming hardware
3. You need to mount filesystem and execute some shell to give commands
4. you need different tools to access different registers

So I want to know how can we can make cpu_debug more useful.


> The reinvention of useful tools like lspci, cpuid, rdmsr, wrmsr inside
> of the kernel with a worse user interface and less information
> provided is just a waste of time and resources.
> 

what user interface and information you want ?

Thanks,
--
JSR

