Return-Path: <linux-kernel-owner+w=401wt.eu-S1754445AbYHYARw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbYHYARw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 20:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbYHYARo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 20:17:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55613 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbYHYARn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 20:17:43 -0400
Message-ID: <48B1F9F9.6090407@zytor.com>
Date: Sun, 24 Aug 2008 17:16:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Alok Kataria <akataria@vmware.com>, Sean Young <sean@mess.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.27-rc4-git1: Reported regressions from 2.6.26
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <alpine.LFD.1.10.0808241141470.3363@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808241141470.3363@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
>> 
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index 46af716..9bed5ca 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -325,6 +325,10 @@ static struct notifier_block time_cpufreq_notifier_block = {
>  
>  static int __init cpufreq_tsc(void)
>  {
> +	if (!cpu_has_tsc)
> +		return 0;
> +	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
> +		return 0;
>  	cpufreq_register_notifier(&time_cpufreq_notifier_block,
>  				CPUFREQ_TRANSITION_NOTIFIER);
>  	return 0;

I added this patch to x86/urgent.

	-hpa
