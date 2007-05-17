Return-Path: <linux-kernel-owner+w=401wt.eu-S1759002AbXEQV3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759002AbXEQV3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 17:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759277AbXEQV30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 17:29:26 -0400
Received: from rwcrmhc15.comcast.net ([204.127.192.85]:33637 "EHLO
	rwcrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758405AbXEQV3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 17:29:25 -0400
Message-ID: <464CC920.6030409@comcast.net>
Date: Thu, 17 May 2007 17:29:04 -0400
From: Ed Sweetman <safemode2@comcast.net>
User-Agent: Icedove 1.5.0.10 (X11/20070328)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Len Brown <lenb@kernel.org>,
       Daniel Drake <dsd@gentoo.org>, duaneg@dghda.com, prakash@punnoor.de,
       jhoblitt@ifa.hawaii.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powernow-k8: depend on acpi-processor for SMP systems
References: <20070516235050.9B4237B409F@zog.reactivated.net> <200705171413.42595.lenb@kernel.org> <20070517182340.GA25691@redhat.com>
In-Reply-To: <20070517182340.GA25691@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Thu, May 17, 2007 at 02:13:42PM -0400, Len Brown wrote:
>
>  > > Index: linux/arch/i386/kernel/cpu/cpufreq/Kconfig
>  > > ===================================================================
>  > > --- linux.orig/arch/i386/kernel/cpu/cpufreq/Kconfig
>  > > +++ linux/arch/i386/kernel/cpu/cpufreq/Kconfig
>  > > @@ -81,6 +81,7 @@ config X86_POWERNOW_K7_ACPI
>  > >  config X86_POWERNOW_K8
>  > >  	tristate "AMD Opteron/Athlon64 PowerNow!"
>  > >  	select CPU_FREQ_TABLE
>  > > +	select ACPI_PROCESSOR if SMP
>  > >  	depends on EXPERIMENTAL
>  > >  	help
>  > >  	  This adds the CPUFreq driver for mobile AMD Opteron/Athlon64 processors.
>  > 
>  > Unfortunately this patch will not actually enable ACPI_PROCESSOR in
>  > the SMP=y ACPI=n case.  "select" doesn't work for targets that
>  > have dependencies.
>
> I don't think we can fix this perfectly tbh, but the above at
> least gets us close for the majority of users.
>
> Are there many x86-64 users that don't enable acpi ?
>
> 	Dave
>
>   
I've just always compiled acpi_processor in, it's only logical that if 
you are using a power management feature, that you compile in the power 
management interface, and if your stuff deals directly with the cpu, you 
may want to compile the acpi_processor driver in.  The only reason I 
knew to do that though, was because i go through each option.  Someone 
else looking to just enable cpufreq, would skip the sub-drivers of ACPI, 
and never know better. We dont suggest anywhere in the cpufreq driver, 
we dont mention restrictions or limits of the driver without acpi, and 
we certainly dont select it or make it dependent (except silently and 
invisibly to the user). 

Every other cpufreq driver demands acpi.  In windows you have to have 
acpi, the p states are called acpi p states everywhere.  The problem 
here is that the author to the powernow_k8 driver found a way to get 
some cpufreq functionality without acpi. 

So to make everyone happy, maybe we should have the silently 
selected/deselected driver exposed to the user, as a sub-driver. 

->  Powernow K8 / athlon64  cpufreq driver     y/m/n
------->    ACPI support      y/m/n


we do this silently in the Kconfig, i dont see the problem with exposing 
it so we dont have to muck around forcing people to use acpi that dont 
need to and selecting drivers they may not really need. 
