Return-Path: <linux-kernel-owner+w=401wt.eu-S1757485AbYA3Hfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485AbYA3Hfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 02:35:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754355AbYA3HfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 02:35:25 -0500
Received: from mga11.intel.com ([192.55.52.93]:9690 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754263AbYA3HfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 02:35:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,276,1199692800"; 
   d="scan'208";a="510349363"
Subject: Re: [PATCH 2.6.24] x86: add sysfs interface for cpuid module
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: Sam Ravnborg <sam@ravnborg.org>
Cc: tglx@linutronix.de, hpa@zytor.com, mingo@redhat.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20080129084435.GA8962@uranus.ravnborg.org>
References: <1199441414.19185.9.camel@yangyi-dev.bj.intel.com>
	 <1201043126.3861.5.camel@yangyi-dev.bj.intel.com>
	 <1201562058.12722.9.camel@yangyi-dev.bj.intel.com>
	 <20080129084435.GA8962@uranus.ravnborg.org>
Content-Type: text/plain
Organization: Intel
Date: Wed, 30 Jan 2008 06:22:43 +0800
Message-Id: <1201645363.12722.38.camel@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-01-29 at 09:44 +0100, Sam Ravnborg wrote:
> > +
> > +static struct notifier_block __cpuinitdata cpuid_sysfs_cpu_notifier = {
> > +	.notifier_call = cpuid_sysfs_cpu_callback,
> > +};
> Data is annotated _cpuintidata
> 
> but
> 
> > +
> Data is annotated _cpuintidata
> 
> > @@ -217,11 +445,14 @@ static void __exit cpuid_exit(void)
> >  {
> >  	int cpu = 0;
> >  
> > -	for_each_online_cpu(cpu)
> > +	for_each_online_cpu(cpu) {
> >  		cpuid_device_destroy(cpu);
> > +		remove_cpuid_sysfs(cpu);
> > +	}
> >  	class_destroy(cpuid_class);
> >  	unregister_chrdev(CPUID_MAJOR, "cpu/cpuid");
> >  	unregister_hotcpu_notifier(&cpuid_class_cpu_notifier);
> > +	unregister_hotcpu_notifier(&cpuid_sysfs_cpu_notifier);
> 
> used in an __exit function.
> 
> You should have seen a Section mismatch warning for this.
> The right fix is to annotate the cpuid_sysfs_cpu_notifier
> with __initdata_refok (soon to be named __refdata)
> Or even better to declare it const and use _refconst.
I think __cpuinitdata is different from __initdata, i have tested it
by insmod, rmmod, echo 0/1 > /sys/devices/system/cpu/cpu1/online
repeatly, it hasn't any issue.

> 
> 	Sam

