Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab0CBBFj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 20:05:39 -0500
Received: from claw.goop.org ([74.207.240.146]:40913 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533Ab0CBBFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 20:05:38 -0500
Message-ID: <4B8C6460.6020506@goop.org>
Date: Mon, 01 Mar 2010 17:05:36 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: Keir Fraser <keir.fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Xen-devel] [PATCH 4/7] xen: The entrance for PV extension of
 HVM
References: <1267436315-24486-1-git-send-email-sheng@linux.intel.com> <1267436315-24486-5-git-send-email-sheng@linux.intel.com>
In-Reply-To: <1267436315-24486-5-git-send-email-sheng@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2010 01:38 AM, Sheng Yang wrote:
> xen_guest_init() would setup the environment.
>
> Cc: Ingo Molnar<mingo@elte.hu>
> Signed-off-by: Sheng Yang<sheng@linux.intel.com>
> ---
>   arch/x86/kernel/setup.c |    8 ++++++++
>   1 files changed, 8 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 5d9e40c..2b61d46 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -113,6 +113,10 @@
>   #endif
>   #include<asm/mce.h>
>
> +#ifdef CONFIG_XEN
> +#include<xen/xen.h>
> +#endif
>    

No #ifdefs; put them in xen.h if necessary (which they aren't).  This 
probably isn't the right header anyway; this is specifically for testing 
the presence of Xen and/or the current domain type.  It shouldn't have 
any other prototypes in it, or include anything else (it probably 
already includes too much).  Given this is already x86-specific code, 
include asm/xen/something.h.

> +
>   /*
>    * end_pfn only includes RAM, while max_pfn_mapped includes all e820 entries.
>    * The direct mapping extends to max_pfn_mapped, so that we can directly access
> @@ -740,6 +744,10 @@ void __init setup_arch(char **cmdline_p)
>
>   	x86_init.oem.arch_setup();
>
> +#ifdef CONFIG_XEN
> +	xen_guest_init();
> +#endif
>    

Again, no #ifdefs here.  Put an #ifdeffed stub in an appropriate header.

     J
