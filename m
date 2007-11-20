Return-Path: <linux-kernel-owner+w=401wt.eu-S1762071AbXKTUcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762071AbXKTUcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:32:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758362AbXKTUc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:32:27 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43293 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759376AbXKTUc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:32:26 -0500
Date: Tue, 20 Nov 2007 12:31:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, apw@shadowen.org, balbir@linux.vnet.ibm.com,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: mm snapshot broken-out-2007-11-20-01-45 Build Failure
 mach_apic.h
Message-Id: <20071120123140.e0e41c90.akpm@linux-foundation.org>
In-Reply-To: <4742EDA1.3080308@linux.vnet.ibm.com>
References: <200711200953.lAK9qxjO030444@imap1.linux-foundation.org>
	<4742EDA1.3080308@linux.vnet.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007 19:52:25 +0530
Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> Hi Andrew,
> 
> The kernel build fails, on one of the machine 
> 
>   CC      arch/x86/mach-generic/summit.o
> In file included from arch/x86/mach-generic/summit.c:16:
> include/asm/mach-summit/mach_apic.h: In function ___target_cpus___:
> include/asm/mach-summit/mach_apic.h:23: error: ___per_cpu__cpu_mask___ undeclared (first use in this function)
> include/asm/mach-summit/mach_apic.h:23: error: (Each undeclared identifier is reported only once
> include/asm/mach-summit/mach_apic.h:23: error: for each function it appears in.)
> include/asm/mach-summit/mach_apic.h:23: warning: type defaults to ___int___ in declaration of ___type name___
> include/asm/mach-summit/mach_apic.h:23: error: invalid type argument of ___unary *___
> make[1]: *** [arch/x86/mach-generic/summit.o] Error 1
> make: *** [arch/x86/mach-generic] Error 2

        return cpumask_of_cpu(0);

Surely do-not-use-stack-to-allocate-cpumask-for-cpumask_of_cpu.patch.

We can't include percpu.h from cpumask.h because cpumask.h already includes
percpu.h.  So basically all users of cpumask_of_cpu() must include both
percpu.h and percpu.h.

akpm:/usr/src/linux-2.6.24-rc3> grep -rl cpumask_of_cpu . | wc -l
105

erp.  I'll drop the patch.
