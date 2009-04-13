Return-Path: <linux-kernel-owner+w=401wt.eu-S1754619AbZDME1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbZDME1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 00:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbZDME0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 00:26:55 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:36997 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbZDME0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 00:26:54 -0400
Message-ID: <49E2BEE2.8070305@oracle.com>
Date: Sun, 12 Apr 2009 21:26:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andres Salomon <dilinger@queued.net>
CC: akpm@linux-foundation.org, david-b@pacbell.net, jordan@cosmicpenguin.net,
       katzj@redhat.com, tiwai@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: + cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix-fix.patch
 added to -mm tree
References: <200904062355.n36NtLTf018342@imap1.linux-foundation.org>	<49DFA576.6040005@oracle.com> <20090412215203.45e2a876@ephemeral>
In-Reply-To: <20090412215203.45e2a876@ephemeral>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010209.49E2BEC6.0001:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andres Salomon wrote:
> On Fri, 10 Apr 2009 13:00:54 -0700
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
>> akpm@linux-foundation.org wrote:
>>> The patch titled
>>>      cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix-fix
>>> has been added to the -mm tree.  Its filename is
>>>      cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix-fix.patch
>>>
>>> Before you just go and hit "reply", please:
>>>    a) Consider who else should be cc'ed
>>>    b) Prefer to cc a suitable mailing list as well
>>>    c) Ideally: find the original patch on the mailing list and do a
>>>       reply-to-all to that, adding suitable additional cc's
>>>
>>> *** Remember to use Documentation/SubmitChecklist when testing your
>>> code ***
>>>
>>> See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
>>> out what to do about this
>>>
>>> The current -mm tree may be found at
>>> http://userweb.kernel.org/~akpm/mmotm/
>>>
>>> ------------------------------------------------------
>>> Subject:
>>> cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix-fix From:
>>> Andres Salomon <dilinger@queued.net>
>>>
>>> force GPIO_CS553X to be defined when OLPC is selected
>>>
>>> We've begun using the generic GPIO stuff for geodes, so OLPC
>>> implicitly depends upon this.  This patch forces selection of it.
>>>
>>> Signed-off-by: Andres Salomon <dilinger@debian.org>
>>> Cc: Takashi Iwai <tiwai@suse.de>
>>> Cc: Jeremy Katz <katzj@redhat.com>
>>> Cc: Jordan Crouse <jordan@cosmicpenguin.net>
>>> Cc: David Brownell <david-b@pacbell.net>
>>> Cc: Randy Dunlap <randy.dunlap@oracle.com>
>>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>>> ---
>>>
>>>  arch/x86/Kconfig         |    1 +
>>>  pci/cs5535audio/Makefile |    0 
>>>  2 files changed, 1 insertion(+)
>>>
>>> diff -puN
>>> arch/x86/Kconfig~cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix-fix
>>> arch/x86/Kconfig ---
>>> a/arch/x86/Kconfig~cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix-fix
>>> +++ a/arch/x86/Kconfig @@ -1972,6 +1972,7 @@ config
>>> GEODE_MFGPT_TIMER config OLPC
>>>  	bool "One Laptop Per Child support"
>>> +	select GPIO_CS553X
>>>  	default n
>>>  	---help---
>>>  	  Add support for detecting the unique features of the OLPC
>>
>> In mmotm-2009-0410, this patch causes build errors when GPIOLIB is
>> not enabled since GPIO_CS553X uses gpiolib functions & struct fields:
>>
>> drivers/gpio/cs553x-gpio.c:23: error: field 'chip' has incomplete type
> [...]
>>
>> One possible patch is also to select GPIOLIB above in the OLPC config
>> block.
>>
> 
> Does the following help?  I think this is what we want (gpio-cs553x uses
> gpiolib).  I'm a bit unclear how the other gpio drivers get away with
> including linux/gpio.h and using gpio_chip without requiring GPIOLIB.
> Maybe they implicitly are built on architectures which select
> CONFIG_ARCH_REQUIRE_GPIOLIB?
> 

It helps some (and is needed), but there is another problem.

When PCI is not enabled:

drivers/gpio/cs553x-gpio.c: In function 'cs553x_gpio_probe':
drivers/gpio/cs553x-gpio.c:176: error: implicit declaration of function 'pci_enable_device_io'
drivers/gpio/cs553x-gpio.c:182: error: implicit declaration of function 'pci_request_region'
drivers/gpio/cs553x-gpio.c:207: error: implicit declaration of function 'pci_release_region'

I guess that OLPC needs an additional dependency on PCI ??

> 
> 
> Force GPIO_CS553X to select GPIOLIB, which it makes use of.
> 
> Signed-off-by: Andres Salomon <dilinger@debian.org>
> 
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index 797ff45..17d7364 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -148,6 +148,7 @@ comment "PCI GPIO expanders:"
>  config GPIO_CS553X
>  	tristate "AMD cs5535/cs5536 GPIO support"
>  	depends on PCI && !CS5535_GPIO && !MGEODE_LX
> +	select GPIOLIB
>  	help
>  	  The AMD cs5535 and cs5536 southbridges support 28 GPIO pins that
>  	  can be used for quite a number of things.  The cs553x is found on


-- 
~Randy
