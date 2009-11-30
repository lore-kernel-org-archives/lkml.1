Return-Path: <linux-kernel-owner+w=401wt.eu-S1753207AbZK3TID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbZK3TID (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 14:08:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbZK3TIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 14:08:01 -0500
Received: from claw.goop.org ([74.207.240.146]:53039 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839AbZK3TIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 14:08:00 -0500
Message-ID: <4B1417FA.3050206@goop.org>
Date: Mon, 30 Nov 2009 11:07:38 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen: cleanup for xen_pv_domain()/xen_hvm_domain()
References: <4B13637E.3040400@cn.fujitsu.com>
In-Reply-To: <4B13637E.3040400@cn.fujitsu.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/09 22:17, Xiao Guangrong wrote:
> Remove unnecessary judgment in xen_pv_domain() and xen_hvm_domain()
>   

I'd prefer not to change it.  These changes make no difference to the
generated code, and I see a small semantic difference between "is this a
Xen domain?" and "what kind of Xen domain is it?", as the latter on
really makes sense if it is in fact a Xen domain; the fact that
xen_domain() is also implemented in terms of xen_domain_type is just a
detail.

    J

> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/include/asm/xen/hypervisor.h |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/include/asm/xen/hypervisor.h b/arch/x86/include/asm/xen/hypervisor.h
> index d5b7e90..f94bd0a 100644
> --- a/arch/x86/include/asm/xen/hypervisor.h
> +++ b/arch/x86/include/asm/xen/hypervisor.h
> @@ -50,10 +50,8 @@ extern enum xen_domain_type xen_domain_type;
>  #endif
>  
>  #define xen_domain()		(xen_domain_type != XEN_NATIVE)
> -#define xen_pv_domain()		(xen_domain() &&			\
> -				 xen_domain_type == XEN_PV_DOMAIN)
> -#define xen_hvm_domain()	(xen_domain() &&			\
> -				 xen_domain_type == XEN_HVM_DOMAIN)
> +#define xen_pv_domain()		(xen_domain_type == XEN_PV_DOMAIN)
> +#define xen_hvm_domain()	(xen_domain_type == XEN_HVM_DOMAIN)
>  
>  #ifdef CONFIG_XEN_DOM0
>  #include <xen/interface/xen.h>
>   

