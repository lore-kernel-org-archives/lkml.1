Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbZHGRJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbZHGRJe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 13:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752871AbZHGRJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 13:09:33 -0400
Received: from bar.sig21.net ([80.81.252.164]:37298 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818AbZHGRJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 13:09:33 -0400
Date: Fri, 7 Aug 2009 19:09:42 +0200
From: Johannes Stezenbach <js@sig21.net>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: 2.6.31-rc5 regression: x86 MCE malfunction on Thinkpad T42p
Message-ID: <20090807170942.GB9177@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.4 (---)
X-Spam-21-Report: No, score=-3.4 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=1.007,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm currently running linux-2.6.31-rc5-246-g90bc1a6 on
an old Thinkpad T42p.  During boot I get the following:

   Local APIC disabled by BIOS -- you can enable it with "lapic"
   APIC: disable apic facility
   ...
   mce: CPU supports 5 MCE banks
   Disabling lock debugging due to kernel taint
   ------------[ cut here ]------------
   WARNING: at arch/x86/kernel/apic/apic.c:247 native_apic_write_dummy+0x2d/0x39()
   Hardware name: 2373Y4M
   Modules linked in:
   Pid: 0, comm: swapper Tainted: G   M       2.6.31-rc5 #1
   Call Trace:
    [<c10248c1>] warn_slowpath_common+0x60/0x90
    [<c10248fe>] warn_slowpath_null+0xd/0x10
    [<c1013139>] native_apic_write_dummy+0x2d/0x39
    [<c100dcd2>] intel_init_thermal+0xb6/0x144
    [<c100d517>] ? mce_init+0x33/0xb0
    [<c100db4b>] mce_intel_feature_init+0xb/0x4c
    [<c14fc31e>] mcheck_init+0x1e2/0x253
    [<c14faef4>] identify_cpu+0x30b/0x31b
    [<c14d9af0>] identify_boot_cpu+0xd/0x23
    [<c14d9b3c>] check_bugs+0xb/0xd4
    [<c104f929>] ? delayacct_init+0x42/0x49
    [<c14d493c>] start_kernel+0x25e/0x26d
    [<c14d430b>] i386_start_kernel+0x65/0x6a
   ---[ end trace 4eaa2a86a8e2da22 ]---
   ...
   CPU: Intel(R) Pentium(R) M processor 1.80GHz stepping 06


mcelog reports:

   HARDWARE ERROR. This is *NOT* a software problem!
   Please contact your hardware vendor
   MCE 0
   CPU 0 BANK 1 
   TIME 1249662514 Fri Aug  7 18:28:34 2009
   MCG status:
   MCi status:
   Error overflow
   Uncorrected error
   Error enabled
   Processor context corrupt
   MCA: Unknown Error 30
   STATUS f200000000000030 MCGSTATUS 0
   MCGCAP 5 APICID 0 SOCKETID 0 
   CPUID Vendor Intel Family 6 Model 13


In .config I have:

   CONFIG_X86_UP_APIC=y
   # CONFIG_X86_UP_IOAPIC is not set
   CONFIG_X86_LOCAL_APIC=y
   CONFIG_X86_IO_APIC=y
   # CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
   CONFIG_X86_MCE=y
   # CONFIG_X86_OLD_MCE is not set
   CONFIG_X86_NEW_MCE=y
   CONFIG_X86_MCE_INTEL=y
   # CONFIG_X86_MCE_AMD is not set
   # CONFIG_X86_ANCIENT_MCE is not set
   CONFIG_X86_MCE_THRESHOLD=y
   # CONFIG_X86_MCE_INJECT is not set
   CONFIG_X86_THERMAL_VECTOR=y


I guess I should try to boot with "lapic"?  But I think
MCE worked without "lapic" in earlier kernels. On a 2.6.29.1
kernel dmesg said:

   Local APIC disabled by BIOS -- you can enable it with "lapic"
   ...
   Intel machine check architecture supported.
   Intel machine check reporting enabled on CPU#0.

2.6.29.1 doesn't log any MCE events, so I doubt this is a HW problem.


Johannes
