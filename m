Return-Path: <linux-kernel-owner+w=401wt.eu-S1755289AbXEQJH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbXEQJH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 05:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbXEQJHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 05:07:23 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4561 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753655AbXEQJHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 05:07:22 -0400
Date: Thu, 17 May 2007 09:02:28 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Drake <dsd@gentoo.org>
Cc: davej@redhat.com, duaneg@dghda.com, prakash@punnoor.de,
       jhoblitt@ifa.hawaii.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powernow-k8: depend on acpi-processor for SMP systems
Message-ID: <20070517090227.GB3975@ucw.cz>
References: <20070516235050.9B4237B409F@zog.reactivated.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070516235050.9B4237B409F@zog.reactivated.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

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

It is still possible to run SMP kernel on UP machine -- so this sounds
wrong.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
