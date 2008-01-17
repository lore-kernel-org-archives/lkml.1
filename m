Return-Path: <linux-kernel-owner+w=401wt.eu-S1756760AbYAQMqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760AbYAQMqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 07:46:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754542AbYAQMqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 07:46:42 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:34233 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756201AbYAQMqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 07:46:40 -0500
Date: Thu, 17 Jan 2008 18:16:22 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Linux ACPI mailing list <linux-acpi@vger.kernel.org>,
       Intel E/100 mailing list <e1000-devel@lists.sourceforge.net>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc8-mm1
Message-ID: <20080117124622.GA18450@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Linux ACPI mailing list <linux-acpi@vger.kernel.org>,
	Intel E/100 mailing list <e1000-devel@lists.sourceforge.net>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080117023514.9df393cf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org> [2008-01-17 02:35:14]:

> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc8/2.6.24-rc8-mm1/
> 
> - selinux is busted on one of my two selinux-enabled test machines.
> 
> - suspend-to-ram and suspend-to-disk are totally hosed on one of my test
>   machines.  I guess I get to bisect this.
> 
> - git-nfsd is dropped due to conflicts with git-nfs
> 
> - git-newsetup is dropped due to conflicts with git-x86 (I think)
> 
> - git-perfmon is dropped due to conflicts with git-x86 (I think)
> 
> - git-kgdb is dropped due to conflicts with git-damn-near-everything
> 
> - git-block is dropped due to conflicts with the IDE tree
> 
> - kvm probably doesn't work properly because I couldn't be bothered fixing
>   the conflicts between git-kvm and the driver tree
> 
> - the volume of rejects and build errors which are caused by subsystem
>   maintainers fiddling with other people's stuff is quite out of control. 
>   Something needs to happen here.

Hi, Andrew,

May be it was one of the conflicts, but my system fails to get
ethernet working with this version. I see

e100: Intel(R) PRO/100 Network Driver, 3. 5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
ACPI: PCI Interrupt 0000:04:08.0[A] -> GSI 20 (level, low) -> IRQ 20
modprobe:2584 conflicting cache attribute 50000000-50001000
uncached<->default
e100: 0000:04:08.0: e100_probe: Cannot map device registers, aborting.
ACPI: PCI interrupt for device 0000:04:08.0 disabled
e100: probe of 0000:04:08.0 failed with error -12

Other interesting boot information

Using ACPI (MADT) for SMP configuration information
PM: Registered nosave memory: 000000000008f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
PM: Registered nosave memory: 000000003e5d1000 - 000000003e6e5000
PM: Registered nosave memory: 000000003f574000 - 000000003f57c000
PM: Registered nosave memory: 000000003f62d000 - 000000003f631000
PM: Registered nosave memory: 000000003f6a7000 - 000000003f6e9000
PM: Registered nosave memory: 000000003f6ed000 - 000000003f6ff000
Allocating PCI resources starting at 50000000 (gap: 40000000:bff80000)

 PCI: Bridge: 0000:00:1c.0
   IO window: disabled.
   MEM window:
0x50300000-0x503fffff
   PREFETCH window: disabled.
 PCI: Bridge: 0000:00:1c.2
   IO window: disabled.
   MEM window:
0x50400000-0x504fffff
   PREFETCH window: disabled.
 PCI: Bridge: 0000:00:1c.3
   IO window: disabled.
   MEM window:
0x50500000-0x505fffff
   PREFETCH window: disabled.
 PCI: Bridge: 0000:00:1e.0
   IO window: 1000-1fff
   MEM window:
0x50000000-0x500fffff
   PREFETCH window: disabled.

I am yet to get down to the root cause, thought I'd report it first to
the x86 and ACPI list to see if someone has seen the problem before.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
