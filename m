Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbXKFHip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbXKFHip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 02:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753648AbXKFHii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 02:38:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbXKFHih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 02:38:37 -0500
Date: Tue, 6 Nov 2007 02:38:21 -0500
From: Dave Jones <davej@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/10] x86: unification of cfufreq/Kconfig
Message-ID: <20071106073821.GA12733@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Sam Ravnborg <sam@ravnborg.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <11941338801315-git-send-email-sam@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11941338801315-git-send-email-sam@ravnborg.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 04, 2007 at 12:51:11AM +0100, Sam Ravnborg wrote:

 > @@ -26,7 +29,7 @@ config X86_ACPI_CPUFREQ
 >  config ELAN_CPUFREQ
 >  	tristate "AMD Elan SC400 and SC410"
 >  	select CPU_FREQ_TABLE
 > -	depends on X86_ELAN
 > +	depends on X86_32 && X86_ELAN
 >  	---help---
 >  	  This adds the CPUFreq driver for AMD Elan SC400 and SC410
 >  	  processors.
 > @@ -42,7 +45,7 @@ config ELAN_CPUFREQ
 >  config SC520_CPUFREQ
 >  	tristate "AMD Elan SC520"
 >  	select CPU_FREQ_TABLE
 > -	depends on X86_ELAN
 > +	depends on X86_32 && X86_ELAN
 >  	---help---
 >  	  This adds the CPUFreq driver for AMD Elan SC520 processor.

X86_ELAN should depend on X86_32 rather than adding this everywhere.

 >  config X86_POWERNOW_K7
 >  	tristate "AMD Mobile Athlon/Duron PowerNow!"
 >  	select CPU_FREQ_TABLE
 > +	depends on X86_32
 >  	help
 >  	  This adds the CPUFreq driver for mobile AMD K7 mobile processors.
 >  
 > @@ -76,23 +81,27 @@ config X86_POWERNOW_K7_ACPI
 >  	bool
 >  	depends on X86_POWERNOW_K7 && ACPI_PROCESSOR
 >  	depends on !(X86_POWERNOW_K7 = y && ACPI_PROCESSOR = m)
 > +	depends on X86_32
 >  	default y

This 2nd hunk shouldn't be necessary, as it depends on X86_POWERNOW_K7
which you just added the 32bit dependancy to. 

 >  config X86_SPEEDSTEP_RELAXED_CAP_CHECK
 >  	bool "Relaxed speedstep capability checks"
 > -	depends on (X86_SPEEDSTEP_SMI || X86_SPEEDSTEP_ICH)
 > +	depends on X86_32 && (X86_SPEEDSTEP_SMI || X86_SPEEDSTEP_ICH)

Should also be unnecessary due to those items now being 32bit dependant.

	Dave

-- 
http://www.codemonkey.org.uk
