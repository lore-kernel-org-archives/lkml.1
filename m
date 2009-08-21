Return-Path: <linux-kernel-owner+w=401wt.eu-S932828AbZHURYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828AbZHURYj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 13:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932810AbZHURY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 13:24:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35234 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932764AbZHURYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 13:24:19 -0400
Message-ID: <4A8ED800.30901@zytor.com>
Date: Fri, 21 Aug 2009 10:23:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Shane Wang <shane.wang@intel.com>, Andi Kleen <andi@firstfloor.org>,
       "Cihula, Joseph" <joseph.cihula@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>,
       "Wei, Gang" <gang.wei@intel.com>
Subject: Re: [PATCH] intel_txt: fix the build errors of intel_txt patch on
 non-X86 platforms
References: <4A4ACA66.2000706@intel.com> <20090817154055.GA12985@elte.hu> <20090817155348.GA2254@elte.hu> <037F493892196B458CD3E193E8EBAD4F01EC3AB3B2@pdsmsx502.ccr.corp.intel.com> <20090820161038.GA29994@basil.fritz.box> <4A8E9B3C.5070604@intel.com> <20090821135050.GA30346@elte.hu> <4A8EBBF6.3020505@intel.com> <20090821161204.GB17731@elte.hu>
In-Reply-To: <20090821161204.GB17731@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2009 09:12 AM, Ingo Molnar wrote:
> 
> * Shane Wang <shane.wang@intel.com> wrote:
> 
>> Hi
>>
>> Forget the previous patch. I misundertood Andi's comments. It should be 
>> this one. Please comment.
>>
>> Thanks.
>> Shane
>>
>>
>> ---
>>  arch/x86/Kconfig              |    4 +++
>>  drivers/acpi/acpica/hwsleep.c |    2 -
>>  drivers/pci/dmar.c            |    2 -
>>  drivers/pci/intel-iommu.c     |    2 -
>>  include/linux/tboot.h         |   35 ++++++++++++++++++++++++++++++++
>>  init/main.c                   |    2 -
>>  kernel/cpu.c                  |    2 -
>>  security/Kconfig              |    2 -
>>  8 files changed, 45 insertions(+), 6 deletions(-)
>>
>> Signed-off-by: Shane Wang <shane.wang@intel.com>
>>
>>
>> diff -r e5406357eaf2 arch/x86/Kconfig
>> --- a/arch/x86/Kconfig	Thu Aug 20 21:10:50 2009 -0700
>> +++ b/arch/x86/Kconfig	Thu Aug 20 21:15:32 2009 -0700
>> @@ -179,6 +179,10 @@ config ARCH_SUPPORTS_OPTIMIZED_INLINING
>>
>>  config ARCH_SUPPORTS_DEBUG_PAGEALLOC
>>  	def_bool y
>> +
>> +config ARCH_HAS_INTEL_TXT
>> +	def_bool y
>> +	depends on EXPERIMENTAL && DMAR && ACPI
>>
>>  # Use the generic interrupt handling code in kernel/irq/:
>>  config GENERIC_HARDIRQS
>> diff -r e5406357eaf2 drivers/acpi/acpica/hwsleep.c
>> --- a/drivers/acpi/acpica/hwsleep.c	Thu Aug 20 21:10:50 2009 -0700
>> +++ b/drivers/acpi/acpica/hwsleep.c	Thu Aug 20 21:15:32 2009 -0700
>> @@ -45,7 +45,7 @@
>>  #include <acpi/acpi.h>
>>  #include "accommon.h"
>>  #include "actables.h"
>> -#include <asm/tboot.h>
>> +#include <linux/tboot.h>
>>
>>  #define _COMPONENT          ACPI_HARDWARE
>>  ACPI_MODULE_NAME("hwsleep")
>> diff -r e5406357eaf2 drivers/pci/dmar.c
>> --- a/drivers/pci/dmar.c	Thu Aug 20 21:10:50 2009 -0700
>> +++ b/drivers/pci/dmar.c	Thu Aug 20 21:15:32 2009 -0700
>> @@ -33,7 +33,7 @@
>>  #include <linux/timer.h>
>>  #include <linux/irq.h>
>>  #include <linux/interrupt.h>
>> -#include <asm/tboot.h>
>> +#include <linux/tboot.h>
>>
>>  #undef PREFIX
>>  #define PREFIX "DMAR:"
>> diff -r e5406357eaf2 drivers/pci/intel-iommu.c
>> --- a/drivers/pci/intel-iommu.c	Thu Aug 20 21:10:50 2009 -0700
>> +++ b/drivers/pci/intel-iommu.c	Thu Aug 20 21:15:32 2009 -0700
>> @@ -37,8 +37,8 @@
>>  #include <linux/iommu.h>
>>  #include <linux/intel-iommu.h>
>>  #include <linux/sysdev.h>
>> +#include <linux/tboot.h>
>>  #include <asm/cacheflush.h>
>> -#include <asm/tboot.h>
>>  #include <asm/iommu.h>
>>  #include "pci.h"
>>
>> diff -r e5406357eaf2 include/linux/tboot.h
>> --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
>> +++ b/include/linux/tboot.h	Thu Aug 20 21:15:32 2009 -0700
>> @@ -0,0 +1,35 @@
>> +/*
>> + * Copyright (c) 2006-2009, Intel Corporation
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms and conditions of the GNU General Public License,
>> + * version 2, as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope it will be useful, but WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
>> + * more details.
>> + *
>> + * You should have received a copy of the GNU General Public License along with
>> + * this program; if not, write to the Free Software Foundation, Inc.,
>> + * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
>> + *
>> + */
>> +
>> +#ifndef _LINUX_TBOOT_H
>> +#define _LINUX_TBOOT_H
>> +
>> +#ifdef CONFIG_ARCH_HAS_INTEL_TXT
>> +#include <asm/tboot.h>
>> +#else
>> +
>> +#define tboot_sleep(sleep_state, pm1a_control, pm1b_control)	\
>> +					do { } while (0)
>> +#define tboot_get_dmar_table(dmar_tbl)	(dmar_tbl)
>> +#define tboot_force_iommu()		0
>> +#define tboot_create_trampoline()	do { } while (0)
>> +#define tboot_wait_for_aps(num_aps)	0
>> +
>> +#endif /* !CONFIG_ARCH_HAS_INTEL_TXT */
> 
> If then these should be dummy inlines - but in any case, do you 
> expect tboot to be used by non-x86 too?
> 

It would have to be IA64 ... I can't ask Tony since he's out, but I
would assume it is x86-specific at this point.

	-hpa
