Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186AbYCLBou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbYCLBou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 21:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbYCLBok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 21:44:40 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:44699 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbYCLBoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 21:44:39 -0400
Message-ID: <47D73500.5080205@oracle.com>
Date: Tue, 11 Mar 2008 18:42:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Ravikiran G Thirumalai <kiran@scalex86.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, linux-kernel@vger.kernel.org,
       Glauber de Oliveira Costa <glommer@gmail.com>, shai@scalex86.org
Subject: Re: 2.6.25-rc5-mm1 (paravirt/vsmp/no PCI)
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org> <20080311100955.ca113f90.randy.dunlap@oracle.com> <47D6CD04.8060303@goop.org> <20080312001040.GA6434@localdomain>
In-Reply-To: <20080312001040.GA6434@localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ravikiran G Thirumalai wrote:
> On Tue, Mar 11, 2008 at 11:18:44AM -0700, Jeremy Fitzhardinge wrote:
>> Randy Dunlap wrote:
>>
>> Added Cc:
>>
>>> On Tue, 11 Mar 2008 01:14:34 -0700 Andrew Morton wrote:
>>>
>>>
>>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc5/2.6.25-rc5-mm1/
>>>>
>>> randconfig (x86_64) with
>>> PCI=n
>>> PARAVIRT=y
>>> VSMP=n
>>>
>>> ends with
>>>
>>> arch/x86/kernel/built-in.o: In function `is_vsmp_box':
>>> (.text+0x1178d): undefined reference to `early_pci_allowed'
>>> arch/x86/kernel/built-in.o: In function `is_vsmp_box':
>>> (.text+0x117a9): undefined reference to `read_pci_config'
>>> arch/x86/kernel/built-in.o: In function `vsmp_init':
>>> (.init.text+0x4fcc): undefined reference to `early_pci_allowed'
>>> arch/x86/kernel/built-in.o: In function `vsmp_init':
>>> (.init.text+0x501a): undefined reference to `read_pci_config'
>>> make[1]: *** [.tmp_vmlinux1] Error 1
>>>
>>> config attached.
>>   J
> 
> 
> Would anyone have objection to have PARAVIRT depend on PCI, since the
> vsmp paravirt bits depend on PCI cfg space to determine if the system is
> vsmp?   If not, this patch would suffice.

Works for me.
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> Glauber?
> 
> Thanks,
> Kiran
> 
> ---
> 
> Make PARAVIRT depend on PCI.
> 
> vSMP PARAVIRT ops probe the pci config space to determine if the
> system is indeed a ScaleMP vSMP box.  Hence, depend on PCI to enable
> PARAVIRT.
> 
> Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
> 
> Index: linux-2.6.24/arch/x86/Kconfig
> ===================================================================
> --- linux-2.6.24.orig/arch/x86/Kconfig	2008-03-11 16:38:26.000000000 -0700
> +++ linux-2.6.24/arch/x86/Kconfig	2008-03-11 16:50:52.000000000 -0700
> @@ -384,7 +384,7 @@ source "arch/x86/lguest/Kconfig"
>  
>  config PARAVIRT
>  	bool "Enable paravirtualization code"
> -	depends on !(X86_VISWS || X86_VOYAGER)
> +	depends on !(X86_VISWS || X86_VOYAGER) && PCI
>  	help
>  	  This changes the kernel so it can modify itself when it is run
>  	  under a hypervisor, potentially improving performance significantly


-- 
~Randy
