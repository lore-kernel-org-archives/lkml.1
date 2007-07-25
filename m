Return-Path: <linux-kernel-owner+w=401wt.eu-S1763470AbXGYGll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763470AbXGYGll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 02:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbXGYGle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 02:41:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36177 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751603AbXGYGld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 02:41:33 -0400
Date: Tue, 24 Jul 2007 23:40:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dave Jones <davej@codemonkey.org.uk>,
       cpufreq@www.linux.org.uk
Subject: Re: [PATCH]gx-suspmod.c use boot_cpu_data instead of
 current_cpu_data
Message-Id: <20070724234045.2cec5525.akpm@linux-foundation.org>
In-Reply-To: <20070725141905.GA4567@darkstar.te-china.tietoenator.com>
References: <20070725141905.GA4567@darkstar.te-china.tietoenator.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2007 14:19:05 +0000 Dave Young <hidave.darkstar@gmail.com> wrote:

> Hi,
> in preemptible kernel will report BUG: using smp_processor_id() in preemptible, so use boot_cpu_data instead of current_cpu_data.
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 
> 
> ---
> arch/i386/kernel/cpu/cpufreq/gx-suspmod.c |    4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff -pur linux/arch/i386/kernel/cpu/cpufreq/gx-suspmod.c linux.new/arch/i386/kernel/cpu/cpufreq/gx-suspmod.c
> --- linux/arch/i386/kernel/cpu/cpufreq/gx-suspmod.c	2007-07-25 14:11:06.000000000 +0000
> +++ linux.new/arch/i386/kernel/cpu/cpufreq/gx-suspmod.c	2007-07-25 13:57:29.000000000 +0000
> @@ -181,8 +181,8 @@ static __init struct pci_dev *gx_detect_
>  	struct pci_dev *gx_pci = NULL;
>  
>  	/* check if CPU is a MediaGX or a Geode. */
> -	if ((current_cpu_data.x86_vendor != X86_VENDOR_NSC) &&
> -	    (current_cpu_data.x86_vendor != X86_VENDOR_CYRIX)) {
> +	if ((boot_cpu_data.x86_vendor != X86_VENDOR_NSC) &&
> +	    (boot_cpu_data.x86_vendor != X86_VENDOR_CYRIX)) {
>  		dprintk("error: no MediaGX/Geode processor found!\n");
>  		return NULL;
>  	}

um, I suspect it really wants to get at the current CPU.  But putting a
preempt_disable() around just that code is meaningless: the current CPU
could change immediately before or after the code block. It needs deeper
fixing, methinks.

