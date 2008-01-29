Return-Path: <linux-kernel-owner+w=401wt.eu-S1756427AbYA2Iom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427AbYA2Iom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 03:44:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbYA2Iof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 03:44:35 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:49756 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582AbYA2Ioe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 03:44:34 -0500
Date: Tue, 29 Jan 2008 09:44:35 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Yi Yang <yi.y.yang@intel.com>
Cc: tglx@linutronix.de, hpa@zytor.com, mingo@redhat.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 2.6.24] x86: add sysfs interface for cpuid module
Message-ID: <20080129084435.GA8962@uranus.ravnborg.org>
References: <1199441414.19185.9.camel@yangyi-dev.bj.intel.com> <1201043126.3861.5.camel@yangyi-dev.bj.intel.com> <1201562058.12722.9.camel@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201562058.12722.9.camel@yangyi-dev.bj.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +
> +static struct notifier_block __cpuinitdata cpuid_sysfs_cpu_notifier = {
> +	.notifier_call = cpuid_sysfs_cpu_callback,
> +};
Data is annotated _cpuintidata

but

> +
Data is annotated _cpuintidata

> @@ -217,11 +445,14 @@ static void __exit cpuid_exit(void)
>  {
>  	int cpu = 0;
>  
> -	for_each_online_cpu(cpu)
> +	for_each_online_cpu(cpu) {
>  		cpuid_device_destroy(cpu);
> +		remove_cpuid_sysfs(cpu);
> +	}
>  	class_destroy(cpuid_class);
>  	unregister_chrdev(CPUID_MAJOR, "cpu/cpuid");
>  	unregister_hotcpu_notifier(&cpuid_class_cpu_notifier);
> +	unregister_hotcpu_notifier(&cpuid_sysfs_cpu_notifier);

used in an __exit function.

You should have seen a Section mismatch warning for this.
The right fix is to annotate the cpuid_sysfs_cpu_notifier
with __initdata_refok (soon to be named __refdata)
Or even better to declare it const and use _refconst.

	Sam
