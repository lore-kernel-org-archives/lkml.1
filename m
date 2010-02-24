Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083Ab0BXP7I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 10:59:08 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:57898 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756880Ab0BXP7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 10:59:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=XG3aub7Sg7ly261cn0gR/c0ENepOV7rsAFqsQN+UfRXRNz2E+OBCis+sUGXbXfyhrL
         8o/aMBEZ4xCRjt7OrjXFujza80oUvSjNgYIhF0JDcHBVNb/8sz9plO0pTRalCNgpnd9n
         duUiatqhz2k2RyAo/kWHtEThbB/MXx+7HwjFw=
Message-ID: <4B854CE1.9020505@gmail.com>
Date: Wed, 24 Feb 2010 07:59:29 -0800
From: "Justin P. mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: Dan Carpenter <error27@gmail.com>, linux1394-devel@lists.sourceforge.net,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ohci1394_dma=early crash since 2.6.32 (was Re: [Bug	 #14487]
 PANIC: early exception 08 rip 246:10 error	 ffffffff810251b5 cr2 0)
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera> <de962C6zBxL.A.H1G.1HiZLB@chimera> <4B6630CA.9010207@gmail.com> <20100201125441.GB2576@bicker> <4B671606.3080405@gmail.com> <4B673233.8000300@s5r6.in-berlin.de> <4B6740B5.5070601@gmail.com> <4B675534.5070107@s5r6.in-berlin.de> <4B676917.2080506@gmail.com> <4B67BC12.4080709@s5r6.in-berlin.de> <4B67C4D2.5050205@gmail.com> <4B67CC55.40301@s5r6.in-berlin.de> <4B67CCEC.2030103@s5r6.in-berlin.de> <4B68D4CA.2010803@gmail.com> <4B8547D20200007800031047@vpn.id2.novell.com>
In-Reply-To: <4B8547D20200007800031047@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2010 06:37 AM, Jan Beulich wrote:
>>>> "Justin P. Mattock"<justinmattock@gmail.com>  03.02.10 02:43>>>
> Could you try this simple patch (against plain 2.6.33-rc8)?
>
> Thanks, Jan
>
> --- a/arch/x86/include/asm/fixmap.h
> +++ b/arch/x86/include/asm/fixmap.h
> @@ -82,6 +82,9 @@ enum fixed_addresses {
>   #endif
>   	FIX_DBGP_BASE,
>   	FIX_EARLYCON_MEM_BASE,
> +#ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
> +	FIX_OHCI1394_BASE,
> +#endif
>   #ifdef CONFIG_X86_LOCAL_APIC
>   	FIX_APIC_BASE,	/* local (CPU) APIC) -- required for SMP or not */
>   #endif
> @@ -126,9 +129,6 @@ enum fixed_addresses {
>   	FIX_BTMAP_END = __end_of_permanent_fixed_addresses + 256 -
>   			(__end_of_permanent_fixed_addresses&  255),
>   	FIX_BTMAP_BEGIN = FIX_BTMAP_END + NR_FIX_BTMAPS*FIX_BTMAPS_SLOTS - 1,
> -#ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
> -	FIX_OHCI1394_BASE,
> -#endif
>   #ifdef CONFIG_X86_32
>   	FIX_WP_TEST,
>   #endif
>
>
>


heres the bug report on this..
http://bugzilla.kernel.org/show_bug.cgi?id=14487

Justin P. Mattock
