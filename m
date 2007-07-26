Return-Path: <linux-kernel-owner+w=401wt.eu-S936153AbXGZS51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936153AbXGZS51 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 14:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765323AbXGZS5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 14:57:03 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:61423 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763234AbXGZS5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 14:57:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=glLd5Zm5iVzpZ0hlIruQS8sDV9NfdmrJWOxclw0nhS/sIhDkqqROjBJqNXG5MgC9yg4kErcjIqGueEy78SoRVqnGd0Xn7TfZXDAKOrdMNbAfJno8zUcXSOiYq9hE5KVkQJcRrsZ1S+ciTfSeTgduHmELokDUUMeCz50mwqrcVok=
Message-ID: <46A8EDA2.4000905@googlemail.com>
Date: Thu, 26 Jul 2007 20:53:22 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: david@lang.hm, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: defconfig , ACPI=n  compile error
References: <200707251238.50218.lenb@kernel.org> <200707260026.08183.lenb@kernel.org> <46A8727F.3030005@googlemail.com> <200707261405.09278.lenb@kernel.org>
In-Reply-To: <200707261405.09278.lenb@kernel.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> config ACPI_PROCESSOR
>>         tristate "Processor"
>>         default y
>>         help
>>           This driver installs ACPI as the idle handler for Linux, and uses
>>           ACPI C2 and C3 processor states to save power, on systems that
>>           support it.  It is required by several flavors of cpufreq
>>           Performance-state drivers.
>>
>> ...
>>
>> Is more logical for me to do it here but I may be wrong.
> 
> ACPI_PROCESSOR supports C-states and P-states and is not directly
> related to support for system sleep states.  If your system is recent,
> then it is likely that you want to enable this (and cpufreq) to save power --
> even if you are not interested in system-wide sleep states.

Btw nothing about HOTPLUG_CPU now but something is broken.

do a defconfig , make menuconfig , disable ACPI , make , and you get :

...

In file included from arch/i386/kernel/acpi/cstate.c:16:
include/acpi/processor.h:90: error: expected specifier-qualifier-list before 'acpi_integer'
include/acpi/processor.h:108: error: expected specifier-qualifier-list before 'acpi_integer'
include/acpi/processor.h:131: error: expected specifier-qualifier-list before 'acpi_integer'
include/acpi/processor.h:149: error: expected specifier-qualifier-list before 'acpi_integer'
include/acpi/processor.h:205: error: expected specifier-qualifier-list before 'acpi_handle'
include/acpi/processor.h:319: warning: 'struct acpi_device' declared inside parameter list
include/acpi/processor.h:319: warning: its scope is only this definition or declaration, which is probably not what you want
include/acpi/processor.h:322: warning: 'struct acpi_device' declared inside parameter list
make[2]: *** [arch/i386/kernel/acpi/cstate.o] Error 1
make[1]: *** [arch/i386/kernel/acpi] Error 2

...

$ grep ACPI .config
# Power management options (ACPI, APM)
# CONFIG_ACPI is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_X86_POWERNOW_K8_ACPI=y
CONFIG_X86_ACPI_CPUFREQ_PROC_INTF=y

Looks like CONFIG_X86_POWERNOW_K8_ACPI selects only ACPI_PROCESSOR , guessing it should depend on ACPI ?


> 
> -Len
> 


Gabriel
