Return-Path: <linux-kernel-owner+w=401wt.eu-S1752665AbZLVCRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbZLVCRz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 21:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbZLVCRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 21:17:54 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52970 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424AbZLVCRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 21:17:53 -0500
Message-ID: <4B302C46.2010802@austin.ibm.com>
Date: Mon, 21 Dec 2009 20:17:42 -0600
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Andreas Schwab <schwab@linux-m68k.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6 v5] CPU probe/release files
References: <4AE8ADCF.6090104@austin.ibm.com>	 <4AE8B072.1070603@austin.ibm.com>  <m2oclw9wt4.fsf@igel.home> <1261212415.2173.94.camel@pasglop>
In-Reply-To: <1261212415.2173.94.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Fri, 2009-12-18 at 15:33 +0100, Andreas Schwab wrote:
>> Nathan Fontenot <nfont@austin.ibm.com> writes:
>>
>>> Index: powerpc/arch/powerpc/Kconfig
>>> ===================================================================
>>> --- powerpc.orig/arch/powerpc/Kconfig	2009-10-28 15:21:47.000000000 -0500
>>> +++ powerpc/arch/powerpc/Kconfig	2009-10-28 15:21:53.000000000 -0500
>>> @@ -320,6 +320,10 @@
>>>  
>>>  	  Say N if you are unsure.
>>>  
>>> +config ARCH_CPU_PROBE_RELEASE
>>> +	def_bool y
>>> +	depends on HOTPLUG_CPU
>>> +
>> That does not work.
>>
>> drivers/built-in.o: In function `.store_online':
>> cpu.c:(.ref.text+0xf5c): undefined reference to `.cpu_hotplug_driver_lock'
>> cpu.c:(.ref.text+0xfc8): undefined reference to `.cpu_hotplug_driver_unlock'
>> make: *** [.tmp_vmlinux1] Error 1
>>
>> cpu_hotplug_driver_lock is only defined on pseries, but HOTPLUG_CPU is
>> also defined on pmac.
> 
> Well, the stuff was merged ... so we need to fix it.
> 
> Nathan, the problem is that the above wlil define ARCH_CPU_PROBE_RELEASE
> for any powerpc platform that has HOTPLUG_CPU. So a kernel that doesn't
> have pSeries support but has hotplug CPU will have a problem, though for
> some reason none of my test configs triggered it (I'll have to check why
> next week).
> 
> The right approach here is to have cpu_hotplug_driver_lock go through
> ppc_md. I suppose, along with some of the other CPU hotplug platform
> specific bits.
> 

Sounds good to me,  I'll get a patch together.

-Nathan Fontenot
