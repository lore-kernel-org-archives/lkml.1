Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbZKRENY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbZKRENY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 23:13:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756608AbZKRENX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 23:13:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756209AbZKRENW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 23:13:22 -0500
Date: Tue, 17 Nov 2009 19:08:18 -0500
From: Dave Jones <davej@redhat.com>
To: Alex Chiang <achiang@hp.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: Re: [PATCH 1/3] [CPUFREQ] make ACPI P-state cpufreq drivers depend
 on CONFIG_CPU_FREQ
Message-ID: <20091118000817.GA1855@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Alex Chiang <achiang@hp.com>, linux-kernel@vger.kernel.org,
	cpufreq@vger.kernel.org
References: <20091117220729.25933.57884.stgit@bob.kio>
 <20091117221120.25933.46929.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091117221120.25933.46929.stgit@bob.kio>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > diff --git a/arch/x86/kernel/cpu/cpufreq/Kconfig b/arch/x86/kernel/cpu/cpufreq/Kconfig
 > index f138c6c..ca40a9f 100644
 > --- a/arch/x86/kernel/cpu/cpufreq/Kconfig
 > +++ b/arch/x86/kernel/cpu/cpufreq/Kconfig
 > @@ -13,7 +13,7 @@ comment "CPUFreq processor drivers"
 >  config X86_ACPI_CPUFREQ
 >  	tristate "ACPI Processor P-States driver"
 >  	select CPU_FREQ_TABLE
 > -	depends on ACPI_PROCESSOR
 > +	depends on ACPI_PROCESSOR && CPU_FREQ
 >  	help
 >  	  This driver adds a CPUFreq driver which utilizes the ACPI
 >  	  Processor Performance States.
 > @@ -69,7 +69,7 @@ config X86_POWERNOW_K6
 >  config X86_POWERNOW_K7
 >  	tristate "AMD Mobile Athlon/Duron PowerNow!"
 >  	select CPU_FREQ_TABLE
 > -	depends on X86_32
 > +	depends on X86_32 && CPU_FREQ
 >  	help
 >  	  This adds the CPUFreq driver for mobile AMD K7 mobile processors.
 >  
 > @@ -87,7 +87,7 @@ config X86_POWERNOW_K7_ACPI
 >  config X86_POWERNOW_K8
 >  	tristate "AMD Opteron/Athlon64 PowerNow!"
 >  	select CPU_FREQ_TABLE
 > -	depends on ACPI && ACPI_PROCESSOR
 > +	depends on ACPI && ACPI_PROCESSOR && CPU_FREQ
 >  	help
 >  	  This adds the CPUFreq driver for K8/K10 Opteron/Athlon64 processors.
 
This doesn't make sense, as this whole file is guarded with

if CPU_FREQ
...
endif

The dependancy has to be true, or you wouldn't ever see these options.

	Dave

