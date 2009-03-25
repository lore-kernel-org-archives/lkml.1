Return-Path: <linux-kernel-owner+w=401wt.eu-S1761659AbZCYNiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761659AbZCYNiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 09:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754835AbZCYNiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 09:38:06 -0400
Received: from rtr.ca ([76.10.145.34]:55944 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756524AbZCYNiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 09:38:05 -0400
Message-ID: <49CA33B8.5050503@rtr.ca>
Date: Wed, 25 Mar 2009 09:38:00 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       akataria@vmware.com
Subject: Re: [PATCH -tip] x86: move vmware to hypervisor
References: <1237281581.7907.2.camel@ht.satnam>	 <20090317093919.GD6477@elte.hu> <1237283318.7907.9.camel@ht.satnam>	 <49BFC6CB.9070603@zytor.com> <1237958994.5556.5.camel@localhost.localdomain>
In-Reply-To: <1237958994.5556.5.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> On Tue, 2009-03-17 at 08:50 -0700, H. Peter Anvin wrote:
>> Jaswinder Singh Rajput wrote:
>>>> I dont really like this one. KVM is a hypervisor too, and so is 
>>>> Xen and lguest. VMware is one of the many types of a 
>>>> hypervisors.
>>> Can we use common hypervisor for Xen, lguest, vmware, etc.
>>> And Xen, lguest, vmware will be the sub-options.
>> Obviously.  We spent a lot of time breaking up the cpu stuff into common
>> and vendor-specific portions, we shouldn't go backwards w.r.t. hypervisors.
>> 	
> 
> OK, agreed.
> 
> But atleast give freedom to users to disable this who are not willing to
> use it.
> 
> Currently hypervisor is used only used by VMWARE, so is I prepare this
> freedom patch:
> 
> From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Date: Wed, 25 Mar 2009 10:40:01 +0530
> Subject: [PATCH] x86: Introduce CONFIG_X86_VMWARE option
> 
> Impact: freedom to choose
> 
> Gives freedom to users to select or suppress CONFIG_X86_VMWARE option.
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/Kconfig                  |    7 +++++++
>  arch/x86/include/asm/hypervisor.h |    9 +++++++++
>  arch/x86/kernel/cpu/Makefile      |    2 +-
>  3 files changed, 17 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index f5d7d29..56e1a9c 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -554,6 +554,13 @@ config HPET_EMULATE_RTC
>  	def_bool y
>  	depends on HPET_TIMER && (RTC=y || RTC=m || RTC_DRV_CMOS=m || RTC_DRV_CMOS=y)
>  
> +config X86_VMWARE
> +	bool
> +	default n
> +	prompt "X86 VMware support"
> +	---help---
> +	 Enable X86 VMware Hypervisor support.
>
..


Could that perhaps be clarified somewhat, changing the prompt
string to either "X86 VMware host support"
or "X86 VMware guest support", to remove any confusion ?

thanks
