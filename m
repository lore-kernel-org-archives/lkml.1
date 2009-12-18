Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbZLRR3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbZLRR3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 12:29:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755053AbZLRR3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 12:29:38 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:43467 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbZLRR3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 12:29:37 -0500
From: Andreas Schwab <schwab@linux-m68k.org>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6 v5] CPU probe/release files
References: <4AE8ADCF.6090104@austin.ibm.com>
	<4AE8B072.1070603@austin.ibm.com> <m2oclw9wt4.fsf@igel.home>
	<4B2BACD3.7010903@austin.ibm.com>
X-Yow: CALIFORNIA is where people from IOWA or NEW YORK go to subscribe to
 CABLE TELEVISION!!
Date: Fri, 18 Dec 2009 18:29:31 +0100
In-Reply-To: <4B2BACD3.7010903@austin.ibm.com> (Nathan Fontenot's message of
	"Fri, 18 Dec 2009 10:24:51 -0600")
Message-ID: <m2k4wk9on8.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nathan Fontenot <nfont@austin.ibm.com> writes:

> Andreas Schwab wrote:
>> Nathan Fontenot <nfont@austin.ibm.com> writes:
>>
>>> Index: powerpc/arch/powerpc/Kconfig
>>> ===================================================================
>>> --- powerpc.orig/arch/powerpc/Kconfig	2009-10-28 15:21:47.000000000 -0500
>>> +++ powerpc/arch/powerpc/Kconfig	2009-10-28 15:21:53.000000000 -0500
>>> @@ -320,6 +320,10 @@
>>>   	  Say N if you are unsure.
>>>  +config ARCH_CPU_PROBE_RELEASE
>>> +	def_bool y
>>> +	depends on HOTPLUG_CPU
>>> +
>>
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
> These two routines should be defined as a no-op if CONFIG_ARCH_CPU_PROBE_RELEASE
> is not defined in linux/cpu.h.

??? CONFIG_ARCH_CPU_PROBE_RELEASE *is* defined.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
