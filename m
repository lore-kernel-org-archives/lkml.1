Return-Path: <linux-kernel-owner+w=401wt.eu-S1760004AbZF2Pa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760004AbZF2Pa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 11:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760023AbZF2PaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 11:30:00 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:24475 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759857AbZF2P36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 11:29:58 -0400
Message-ID: <4A48DD69.9030204@oracle.com>
Date: Mon, 29 Jun 2009 08:27:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Len Brown <lenb@kernel.org>, Corentin Chary <corentincj@iksaif.net>,
       Matthew Garrett <mjg@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH, v3] eeepc-laptop: Fix build failure with HOTPLUG_PCI
 && !SYSFS
References: <alpine.LFD.2.00.0906260025380.20608@localhost.localdomain> <20090629080754.GA28336@elte.hu> <20090629081016.GA31398@elte.hu> <20090629081339.GA321@elte.hu>
In-Reply-To: <20090629081339.GA321@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt002.oracle.com [141.146.116.11]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010207.4A48DD6C.01F9:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>>> The patch below fixes the build failure by turning the select 
>>> lines into a single 'depends on' line. [...]
>> i did the fix against the bisection point and the patch has a 
>> conflict against later mainline - below is a merged up patch.
> 
>> -	select HOTPLUG
>> -	select HOTPLUG_PCI if PCI
>> +       select HOTPLUG
>> +       select HOTPLUG_PCI if PCI
> 
> uhm, not a very nice conflict resolution this is.
> 
> The one below is actually tested ;-)
> 
> 	Ingo
> 
> -------------------->
> From de3e1cacc93ca48a288e27af5e82a365ba90020f Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Mon, 29 Jun 2009 10:07:54 +0200
> Subject: [PATCH] eeepc-laptop: Fix build failure with HOTPLUG_PCI && !SYSFS (was: ACPI & driver patches for 2.6.31-rc1)
> 
> FYI, there's a post-rc1 build regression with certain configs:
> 
>  drivers/built-in.o: In function `pci_hp_deregister':
>  (.text+0xb166): undefined reference to `pci_hp_remove_module_link'
>  drivers/built-in.o: In function `pci_hp_deregister':
>  (.text+0xb19f): undefined reference to `pci_destroy_slot'
>  drivers/built-in.o: In function `__pci_hp_register':
>  (.text+0xb583): undefined reference to `pci_create_slot'
>  drivers/built-in.o: In function `__pci_hp_register':
>  (.text+0xb5b1): undefined reference to `pci_hp_create_module_link'
>  make: *** [.tmp_vmlinux1] Error 1
> 
> Caused by:
> 
> | 2b121bc262fa03c94e653b2d44356c2f86c1bcdc is first bad commit
> | commit 2b121bc262fa03c94e653b2d44356c2f86c1bcdc
> | Date:   Thu Jun 25 13:25:36 2009 +0200
> |
> |     eeepc-laptop: Register as a pci-hotplug device
> 
> The problem is caused by this portion of the commit:
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Ack.  Thanks for fixing this.


> ---
>  drivers/platform/x86/Kconfig |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> index 4bc72d0..c0be866 100644
> --- a/drivers/platform/x86/Kconfig
> +++ b/drivers/platform/x86/Kconfig
> @@ -356,10 +356,9 @@ config EEEPC_LAPTOP
>  	depends on INPUT
>  	depends on EXPERIMENTAL
>  	depends on RFKILL || RFKILL = n
> +	depends on HOTPLUG_PCI
>  	select BACKLIGHT_CLASS_DEVICE
>  	select HWMON
> -	select HOTPLUG
> -	select HOTPLUG_PCI if PCI
>  	---help---
>  	  This driver supports the Fn-Fx keys on Eee PC laptops.
>  


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
