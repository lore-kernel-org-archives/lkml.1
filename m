Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbZBTV4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbZBTV4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 16:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbZBTV4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 16:56:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:33494 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753871AbZBTV4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 16:56:04 -0500
Message-ID: <499F26D1.104@kernel.org>
Date: Fri, 20 Feb 2009 13:55:29 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: state of some x86 acpi patches
References: <495C677F.6080707@goop.org> <49810211.9030808@kernel.org>	 <498CF8DA.30004@goop.org> <498CFD95.5070004@kernel.org>	 <498E229C.5030205@goop.org> <20090209123711.GK17782@elte.hu>	 <20090215193655.GA18674@elte.hu> <499891D5.1080804@kernel.org>	 <20090215224607.GA2653@elte.hu> <4998A0D9.9090303@kernel.org> <12c511ca0902201354q738f2f91hd94a5e9826e0696f@mail.gmail.com>
In-Reply-To: <12c511ca0902201354q738f2f91hd94a5e9826e0696f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Luck wrote:
> On Sun, Feb 15, 2009 at 3:10 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> Index: linux-2.6/arch/ia64/kernel/acpi.c
>> ===================================================================
>> --- linux-2.6.orig/arch/ia64/kernel/acpi.c
>> +++ linux-2.6/arch/ia64/kernel/acpi.c
>> @@ -199,7 +199,7 @@ char *__init __acpi_map_table(unsigned l
>>        return __va(phys_addr);
>>  }
>>
>> -char *__init __acpi_unmap_table(unsigned long virt_addr, unsigned long size)
>> +void __init __acpi_unmap_table(char *map, unsigned long size)
>>  {
>>  }
> 
> I'm seeing some section mismatch warnings for this function (when building
> linux-next tag: next-20090220) as it is called by some non __init functions:
> 
> WARNING: vmlinux.o(.text+0x498912): Section mismatch in reference from
> the function early_acpi_os_unmap_memory() to the function
> .init.text:__acpi_unmap_table()
> 
> WARNING: vmlinux.o(.text+0x4989a2): Section mismatch in reference from
> the function acpi_os_unmap_memory() to the function
> .init.text:__acpi_unmap_table()
> 
> Simplest solution would seem to be dropping the "__init" (since the
> function is empty, it won't bloat the kernel by much if we don't manage
> to free up the memory - just 32 bytes :-)

it seems Jeremy has one patch for that...not sure if Ingo put that in tip or not..

YH
