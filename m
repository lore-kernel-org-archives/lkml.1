Return-Path: <linux-kernel-owner+w=401wt.eu-S1759975AbXEQWQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759975AbXEQWQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 18:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756784AbXEQWQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 18:16:25 -0400
Received: from alnrmhc13.comcast.net ([206.18.177.53]:53591 "EHLO
	alnrmhc13.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723AbXEQWQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 18:16:24 -0400
Message-ID: <464CD41F.9080306@comcast.net>
Date: Thu, 17 May 2007 18:15:59 -0400
From: Ed Sweetman <safemode2@comcast.net>
User-Agent: Icedove 1.5.0.10 (X11/20070328)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Ed Sweetman <safemode2@comcast.net>,
       Len Brown <lenb@kernel.org>, Daniel Drake <dsd@gentoo.org>,
       duaneg@dghda.com, prakash@punnoor.de, jhoblitt@ifa.hawaii.edu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powernow-k8: depend on acpi-processor for SMP systems
References: <20070516235050.9B4237B409F@zog.reactivated.net> <200705171413.42595.lenb@kernel.org> <20070517182340.GA25691@redhat.com> <464CC920.6030409@comcast.net> <464CCBCF.3010001@comcast.net> <20070517215200.GD398@redhat.com>
In-Reply-To: <20070517215200.GD398@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Thu, May 17, 2007 at 05:40:31PM -0400, Ed Sweetman wrote:
>
>  > Here's a patch
>
> (please inline patches so they can be quoted in replies).
>
> having this as a tristate makes no sense, that code can't be modular.
> Also, there's a gratuitous whitespace change, and the default should
> probably stay.
>
> If there's consensus we should make this a user-visible option,
> we can do that, though I still don't think this is any more
> perfect than the other option that Daniel posted.
>
> 	Dave
>
>   
yes i know, i rushed it before dinner.  maybe this one?

--- ./linux-backup/arch/x86_64/kernel/cpufreq/Kconfig 2007-02-04 
13:44:54.000000000 -0500
+++ ./linux-2.6.21-rc5-mm2/arch/x86_64/kernel/cpufreq/Kconfig 2007-05-17 
18:13:07.000000000 -0400
@@ -10,20 +10,27 @@
 
comment "CPUFreq processor drivers"
 
-config X86_POWERNOW_K8
+config  X86_POWERNOW_K8
 tristate "AMD Opteron/Athlon64 PowerNow!"
 select CPU_FREQ_TABLE
 help
   This adds the CPUFreq driver for mobile AMD Opteron/Athlon64 processors.
+   An acpi interface is available if acpi support has been selected.
+   This is required for multi-socket and other systems but not 
necessarily required for UP single socket systems.
 
   For details, take a look at <file:Documentation/cpu-freq/>.
 
   If in doubt, say N.
 
config X86_POWERNOW_K8_ACPI
- bool
- depends on X86_POWERNOW_K8 && ACPI_PROCESSOR
- depends on !(X86_POWERNOW_K8 = y && ACPI_PROCESSOR = m)
+ bool "ACPI Support"
+ select ACPI_PROCESSOR
+ depends on X86_POWERNOW_K8
+ help
+     This provides access to the acpi tables for full p-state 
functionality. This driver is also required
+     for cpufreq to work with multi-socket and other smp systems.
+     
+     It is safe to say Y here.  
 default y
 
config X86_SPEEDSTEP_CENTRINO


