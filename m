Return-Path: <linux-kernel-owner+w=401wt.eu-S932545AbZDJUC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545AbZDJUC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 16:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765241AbZDJUBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 16:01:55 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:20310 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760733AbZDJUBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 16:01:54 -0400
Message-ID: <49DFA576.6040005@oracle.com>
Date: Fri, 10 Apr 2009 13:00:54 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: dilinger@queued.net, david-b@pacbell.net, dilinger@debian.org,
       jordan@cosmicpenguin.net, katzj@redhat.com, tiwai@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: + cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix-fix.patch
 added to -mm tree
References: <200904062355.n36NtLTf018342@imap1.linux-foundation.org>
In-Reply-To: <200904062355.n36NtLTf018342@imap1.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010204.49DFA562.00A6:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> The patch titled
>      cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix-fix
> has been added to the -mm tree.  Its filename is
>      cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix-fix.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
> ------------------------------------------------------
> Subject: cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix-fix
> From: Andres Salomon <dilinger@queued.net>
> 
> force GPIO_CS553X to be defined when OLPC is selected
> 
> We've begun using the generic GPIO stuff for geodes, so OLPC implicitly
> depends upon this.  This patch forces selection of it.
> 
> Signed-off-by: Andres Salomon <dilinger@debian.org>
> Cc: Takashi Iwai <tiwai@suse.de>
> Cc: Jeremy Katz <katzj@redhat.com>
> Cc: Jordan Crouse <jordan@cosmicpenguin.net>
> Cc: David Brownell <david-b@pacbell.net>
> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  arch/x86/Kconfig         |    1 +
>  pci/cs5535audio/Makefile |    0 
>  2 files changed, 1 insertion(+)
> 
> diff -puN arch/x86/Kconfig~cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix-fix arch/x86/Kconfig
> --- a/arch/x86/Kconfig~cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix-fix
> +++ a/arch/x86/Kconfig
> @@ -1972,6 +1972,7 @@ config GEODE_MFGPT_TIMER
>  
>  config OLPC
>  	bool "One Laptop Per Child support"
> +	select GPIO_CS553X
>  	default n
>  	---help---
>  	  Add support for detecting the unique features of the OLPC


In mmotm-2009-0410, this patch causes build errors when GPIOLIB is not enabled
since GPIO_CS553X uses gpiolib functions & struct fields:

drivers/gpio/cs553x-gpio.c:23: error: field 'chip' has incomplete type
drivers/gpio/cs553x-gpio.c:150: error: field name not in record or union initializer
drivers/gpio/cs553x-gpio.c:150: error: (near initialization for 'cs553x_gpio_chip.chip')
drivers/gpio/cs553x-gpio.c:151: error: field name not in record or union initializer
drivers/gpio/cs553x-gpio.c:151: error: (near initialization for 'cs553x_gpio_chip.chip')
drivers/gpio/cs553x-gpio.c:153: error: field name not in record or union initializer
drivers/gpio/cs553x-gpio.c:153: error: (near initialization for 'cs553x_gpio_chip.chip')
drivers/gpio/cs553x-gpio.c:154: error: field name not in record or union initializer
drivers/gpio/cs553x-gpio.c:154: error: (near initialization for 'cs553x_gpio_chip.chip')
drivers/gpio/cs553x-gpio.c:156: error: field name not in record or union initializer
drivers/gpio/cs553x-gpio.c:156: error: (near initialization for 'cs553x_gpio_chip.chip')
drivers/gpio/cs553x-gpio.c:157: error: field name not in record or union initializer
drivers/gpio/cs553x-gpio.c:157: error: (near initialization for 'cs553x_gpio_chip.chip')
drivers/gpio/cs553x-gpio.c:159: error: field name not in record or union initializer
drivers/gpio/cs553x-gpio.c:159: error: (near initialization for 'cs553x_gpio_chip.chip')
drivers/gpio/cs553x-gpio.c:160: error: field name not in record or union initializer
drivers/gpio/cs553x-gpio.c:160: error: (near initialization for 'cs553x_gpio_chip.chip')
drivers/gpio/cs553x-gpio.c:197: error: implicit declaration of function 'gpiochip_add'
drivers/gpio/cs553x-gpio.c:216: error: implicit declaration of function 'gpiochip_remove'


One possible patch is also to select GPIOLIB above in the OLPC config block.



-- 
~Randy
