Return-Path: <linux-kernel-owner+w=401wt.eu-S1755385AbZBUWor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbZBUWor (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 17:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754218AbZBUWoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 17:44:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:33986 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497AbZBUWoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 17:44:39 -0500
Message-ID: <49A083A2.30303@kernel.org>
Date: Sat, 21 Feb 2009 14:43:46 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: enable x2apic early at the first point
References: <499DD40F.40102@kernel.org> <20090220095127.GK24555@elte.hu>	 <20090220095530.GA15186@elte.hu> <1235255001.14523.76.camel@vayu>
In-Reply-To: <1235255001.14523.76.camel@vayu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> On Fri, 2009-02-20 at 01:55 -0800, Ingo Molnar wrote:
>> * Ingo Molnar <mingo@elte.hu> wrote:
>>
>>>>  arch/x86/kernel/apic/apic.c           |    3 +--
>>>>  arch/x86/kernel/apic/x2apic_cluster.c |    5 ++++-
>>>>  arch/x86/kernel/apic/x2apic_phys.c    |    5 ++++-
>>>>  arch/x86/kernel/apic/x2apic_uv_x.c    |    4 +++-
>>>>  drivers/pci/dmar.c                    |    3 ++-
>>>>  5 files changed, 14 insertions(+), 6 deletions(-)
>>> I've applied it because it fixes a real bug, but this code 
>>> really needs a cleanup. Look at the repeat patterns:
>> unapplied it again as it breaks the build:
>>
>> arch/x86/kernel/apic/x2apic_cluster.c: In function 'x2apic_acpi_madt_oem_check':
>> arch/x86/kernel/apic/x2apic_cluster.c:17: error: 'disable_x2apic' undeclared (first use in this function)
>> arch/x86/kernel/apic/x2apic_cluster.c:17: error: (Each undeclared identifier is reported only once
>> arch/x86/kernel/apic/x2apic_cluster.c:17: error: for each function it appears in.)
>>
>> so please resend the fixed and cleaned up version.
> 
> From: Suresh Siddha <suresh.b.siddha@intel.com>
> Subject: x86: select x2apic ops in early apic probe only if x2apic mode is enabled
> 
> If BIOS hands over the control to OS in legacy xapic mode, select legacy xapic
> related ops in the early apic probe and shift to x2apic ops later in the boot
> sequence, only after enabling x2apic mode.
> 
> If BIOS hands over the control in x2apic mode, select x2apic related ops
> in the early apic probe.
> 
> This fixes the early boot panic, where we were selecting x2apic ops,
> while the cpu is still in legacy xapic mode.

good, other than that.

for x2apic preenabled system,
when nox2apic is used, cpu_has_x2apic will be cleared, apic will be xapic phys_flat or flat.
is that expected?

should
1. ignore nox2apic
2. or try to disable x2apic?

YH
