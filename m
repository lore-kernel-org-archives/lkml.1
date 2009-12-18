Return-Path: <linux-kernel-owner+w=401wt.eu-S1754928AbZLRQY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbZLRQY5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 11:24:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754811AbZLRQY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 11:24:56 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:42611 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754714AbZLRQYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 11:24:55 -0500
Message-ID: <4B2BACD3.7010903@austin.ibm.com>
Date: Fri, 18 Dec 2009 10:24:51 -0600
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andreas Schwab <schwab@linux-m68k.org>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6 v5] CPU probe/release files
References: <4AE8ADCF.6090104@austin.ibm.com>	<4AE8B072.1070603@austin.ibm.com> <m2oclw9wt4.fsf@igel.home>
In-Reply-To: <m2oclw9wt4.fsf@igel.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab wrote:
> Nathan Fontenot <nfont@austin.ibm.com> writes:
> 
>> Index: powerpc/arch/powerpc/Kconfig
>> ===================================================================
>> --- powerpc.orig/arch/powerpc/Kconfig	2009-10-28 15:21:47.000000000 -0500
>> +++ powerpc/arch/powerpc/Kconfig	2009-10-28 15:21:53.000000000 -0500
>> @@ -320,6 +320,10 @@
>>  
>>  	  Say N if you are unsure.
>>  
>> +config ARCH_CPU_PROBE_RELEASE
>> +	def_bool y
>> +	depends on HOTPLUG_CPU
>> +
> 
> That does not work.
> 
> drivers/built-in.o: In function `.store_online':
> cpu.c:(.ref.text+0xf5c): undefined reference to `.cpu_hotplug_driver_lock'
> cpu.c:(.ref.text+0xfc8): undefined reference to `.cpu_hotplug_driver_unlock'
> make: *** [.tmp_vmlinux1] Error 1
> 
> cpu_hotplug_driver_lock is only defined on pseries, but HOTPLUG_CPU is
> also defined on pmac.

These two routines should be defined as a no-op if CONFIG_ARCH_CPU_PROBE_RELEASE
is not defined in linux/cpu.h.  The update below should be in the patch set
you are looking at. 

from linux/cpu.h:

#ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
extern void cpu_hotplug_driver_lock(void);
extern void cpu_hotplug_driver_unlock(void);
#else
static inline void cpu_hotplug_driver_lock(void)
{
}

static inline void cpu_hotplug_driver_unlock(void)
{
}
#endif

-Nathan Fontenot
