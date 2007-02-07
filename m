Return-Path: <linux-kernel-owner+w=401wt.eu-S1422771AbXBGVQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422771AbXBGVQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 16:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422778AbXBGVQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 16:16:16 -0500
Received: from smtp19.orange.fr ([80.12.242.1]:49836 "EHLO smtp19.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422771AbXBGVQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 16:16:15 -0500
X-ME-UUID: 20070207211343434.6A1751C00082@mwinf1922.orange.fr
Message-ID: <45CA40F0.10808@wanadoo.fr>
Date: Wed, 07 Feb 2007 22:13:20 +0100
From: Thibaud Hulin <hulin.thibaud@wanadoo.fr>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] Re: error 2 after a compile
References: <45C8DE76.5000109@wanadoo.fr> <20070206121027.0a38e6ad.randy.dunlap@oracle.com>
In-Reply-To: <20070206121027.0a38e6ad.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks. Before seeing your message, I erase the line with this module in 
the .config, and if worked. However, I must recompile it, because I 
forgot someting for suspend2.
I'd like install your patch. But how can I do it ? Have you join a patch 
sched.h ?


Randy Dunlap a écrit :
> On Tue, 06 Feb 2007 21:00:54 +0100 Thibaud Hulin wrote:
> 
>> Hello !
>> I'm trying to compile a kernel from 2.6.17-10 to 2.6.19 with suspend2.
>> After this command :
>> make-kpkg --append-to-version=swsusp2.070206 kernel_image --initrd 
>> kernel_headers --revision=2.6.1
>>
>> I obtain :
>>   Building modules, stage 2.
>>    MODPOST 1479 modules
>> WARNING: Can't handle masks in drivers/ide/pci/atiixp:FFFF05
>> WARNING: "try_to_freeze" [drivers/usb/atm/ueagle-atm.ko] undefined!
>> make[2]: *** [__modpost] Erreur 1
>> make[1]: *** [modules] Erreur 2
>> make[1]: quittant le répertoire « /home/hulin/src/linux-2.6.19 »
>> make: *** [debian/stamp-build-kernel] Erreur 2
>>
>> I don't understand the error ?
> 
> 
> The driver is missing #include <linux/sched.h>.
> Please try the patch below and report back on it.
> ---
> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Driver needs sched.h for try_to_freeze().
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/usb/atm/ueagle-atm.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-2619-pv.orig/drivers/usb/atm/ueagle-atm.c
> +++ linux-2619-pv/drivers/usb/atm/ueagle-atm.c
> @@ -61,6 +61,7 @@
>  #include <linux/usb.h>
>  #include <linux/firmware.h>
>  #include <linux/ctype.h>
> +#include <linux/sched.h>
>  #include <linux/kthread.h>
>  #include <linux/version.h>
>  #include <linux/mutex.h>
> 
> 


