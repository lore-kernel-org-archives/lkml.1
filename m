Return-Path: <linux-kernel-owner+w=401wt.eu-S1756744AbZJ0TmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbZJ0TmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 15:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbZJ0TmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 15:42:09 -0400
Received: from relay1.sgi.com ([192.48.179.29]:50881 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753299AbZJ0TmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 15:42:09 -0400
Message-ID: <4AE74D25.8090901@sgi.com>
Date: Tue, 27 Oct 2009 12:42:29 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [PATCH] x86: Don't print number of MCE banks for every CPU
References: <adaeip473qt.fsf@cisco.com>
In-Reply-To: <adaeip473qt.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland,

I've found that I'm getting one of these lines for every cpu:

mce: CPU supports 0 MCE banks

Regards,
Mike

Roland Dreier wrote:
> The MCE initialization code explicitly says it doesn't handle asymmetric
> configurations where different CPUs support different numbers of MCE
> banks, and it prints a big warning in that case.  Therefore, printing
> the "mce: CPU supports <x> MCE banks" message into the kernel log for
> every CPU is pure redundancy that clutters the log significantly for
> systems with lots of CPUs.
> 
> Signed-off-by: Roland Dreier <rolandd@cisco.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index b1598a9..721a77c 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -1214,7 +1214,8 @@ static int __cpuinit mce_cap_init(void)
>  	rdmsrl(MSR_IA32_MCG_CAP, cap);
>  
>  	b = cap & MCG_BANKCNT_MASK;
> -	printk(KERN_INFO "mce: CPU supports %d MCE banks\n", b);
> +	if (!banks)
> +		printk(KERN_INFO "mce: CPU supports %d MCE banks\n", b);
>  
>  	if (b > MAX_NR_BANKS) {
>  		printk(KERN_WARNING
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
