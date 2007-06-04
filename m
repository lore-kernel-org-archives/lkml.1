Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536AbXFDKxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbXFDKxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 06:53:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbXFDKw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 06:52:59 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51952 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752293AbXFDKw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 06:52:58 -0400
Date: Mon, 4 Jun 2007 12:52:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ed Sweetman <safemode2@comcast.net>
Cc: Daniel Drake <dsd@gentoo.org>, davej@redhat.com, duaneg@dghda.com,
       prakash@punnoor.de, jhoblitt@ifa.hawaii.edu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powernow-k8: depend on acpi-processor for SMP systems
Message-ID: <20070604105251.GB4363@elf.ucw.cz>
References: <20070516235050.9B4237B409F@zog.reactivated.net> <20070517090227.GB3975@ucw.cz> <464C2D56.6030402@comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464C2D56.6030402@comcast.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2007-05-17 06:24:22, Ed Sweetman wrote:
> Pavel Machek wrote:
> >Hi!
> >
> >  
> >>powernow-k8 uses PSB BIOS tables to read frequency info on UP systems, but
> >>on SMP it requires the acpi-processor driver. Kconfig should be updated
> >>accordingly to avoid the issues that users are running into.
> >>
> >>http://bugzilla.kernel.org/show_bug.cgi?id=8075
> >>https://bugs.gentoo.org/show_bug.cgi?id=178585
> >>
> >>Signed-off-by: Daniel Drake <dsd@gentoo.org>
> >>
> >>Index: linux/arch/i386/kernel/cpu/cpufreq/Kconfig
> >>===================================================================
> >>--- linux.orig/arch/i386/kernel/cpu/cpufreq/Kconfig
> >>+++ linux/arch/i386/kernel/cpu/cpufreq/Kconfig
> >>@@ -81,6 +81,7 @@ config X86_POWERNOW_K7_ACPI
> >> config X86_POWERNOW_K8
> >> 	tristate "AMD Opteron/Athlon64 PowerNow!"
> >> 	select CPU_FREQ_TABLE
> >>+	select ACPI_PROCESSOR if SMP
> >> 	depends on EXPERIMENTAL
> >> 	help
> >> 	  This adds the CPUFreq driver for mobile AMD Opteron/Athlon64 
> >> 	  processors.
> >>    
> >
> >It is still possible to run SMP kernel on UP machine -- so this sounds
> >wrong.
> 
> It's possible to run a kernel with drivers for hardware you dont have.  
> But not having the dependencies correct for those drivers for that 
> hardware you dont have just because it's possible you can run a kernel 
> with those drivers without that hardware isn't correct. Got it?

Breaking working configs is not fine, got it? We are having the thing
called "stable release" here. Feel free to fix code to decide during
runtime.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
