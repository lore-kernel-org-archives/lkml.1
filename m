Return-Path: <linux-kernel-owner+w=401wt.eu-S1757859AbXEQSP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859AbXEQSP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 14:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753949AbXEQSPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 14:15:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:57003 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753886AbXEQSPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 14:15:13 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Daniel Drake <dsd@gentoo.org>
Subject: Re: [PATCH] powernow-k8: depend on acpi-processor for SMP systems
Date: Thu, 17 May 2007 14:13:42 -0400
User-Agent: KMail/1.9.5
Cc: davej@redhat.com, duaneg@dghda.com, prakash@punnoor.de,
       jhoblitt@ifa.hawaii.edu, linux-kernel@vger.kernel.org
References: <20070516235050.9B4237B409F@zog.reactivated.net>
In-Reply-To: <20070516235050.9B4237B409F@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705171413.42595.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 May 2007 19:50, Daniel Drake wrote:
> powernow-k8 uses PSB BIOS tables to read frequency info on UP systems, but
> on SMP it requires the acpi-processor driver. Kconfig should be updated
> accordingly to avoid the issues that users are running into.
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=8075
> https://bugs.gentoo.org/show_bug.cgi?id=178585
> 
> Signed-off-by: Daniel Drake <dsd@gentoo.org>
> 
> Index: linux/arch/i386/kernel/cpu/cpufreq/Kconfig
> ===================================================================
> --- linux.orig/arch/i386/kernel/cpu/cpufreq/Kconfig
> +++ linux/arch/i386/kernel/cpu/cpufreq/Kconfig
> @@ -81,6 +81,7 @@ config X86_POWERNOW_K7_ACPI
>  config X86_POWERNOW_K8
>  	tristate "AMD Opteron/Athlon64 PowerNow!"
>  	select CPU_FREQ_TABLE
> +	select ACPI_PROCESSOR if SMP
>  	depends on EXPERIMENTAL
>  	help
>  	  This adds the CPUFreq driver for mobile AMD Opteron/Athlon64 processors.

Unfortunately this patch will not actually enable ACPI_PROCESSOR in
the SMP=y ACPI=n case.  "select" doesn't work for targets that
have dependencies.

-Len
