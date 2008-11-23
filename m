Return-Path: <linux-kernel-owner+w=401wt.eu-S1757753AbYKWDbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753AbYKWDbg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 22:31:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755411AbYKWDb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 22:31:26 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:20727 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384AbYKWDbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 22:31:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=EXHHYdkHi4NBR2DCwlsZ3Ox/4MC1ZZH2jRrDigGg1WUuiSAWIIHt0HcAweWFpP8noZ
         lmbRP4DelN9LfH/rQX9bClkjGe/bnwk9VtsOwgkj0ORNCtjC+T2CgDBhu+CuQLh21Fjt
         2QE4dVpYPpOzaH3jft9mBg+Ngvu7uafJfHaXs=
Subject: Re: processors core stuck in full throttle after waking up from
 s2ram
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <200811222333.06459.rjw@sisk.pl>
References: <1227168699.4276.24.camel@LiNuX>
	 <200811222151.49273.rjw@sisk.pl> <1227389306.3171.14.camel@LiNuX>
	 <200811222333.06459.rjw@sisk.pl>
Content-Type: text/plain
Date: Sat, 22 Nov 2008 19:31:21 -0800
Message-Id: <1227411081.3282.12.camel@LiNuX>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-11-22 at 23:33 +0100, Rafael J. Wysocki wrote:
> On Saturday, 22 of November 2008, Justin P. Mattock wrote:
> > On Sat, 2008-11-22 at 21:51 +0100, Rafael J. Wysocki wrote:
> > > On Thursday, 20 of November 2008, Justin P. Mattock wrote:
> > > > (before getting into this I need to see if somebody else with a macbook
> > > > pro(ATI with radeon drivers) is experiencing the same issue?)
> > > > I'm not sure I this is caused by the kernel or the program s2ram.
> > > > when I cat watch /proc/cpuinfo I see: (after waking up from suspend.)
> > > > 
> > > > Every 2.0s: cat /proc/cpuinfo
> > > > Wed Nov 19 23:49:13 2008
> > > > 
> > > > processor       : 0
> > > > vendor_id       : GenuineIntel
> > > > cpu family      : 6
> > > > model           : 15
> > > > model name      : Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz
> > > > stepping        : 6
> > > > cpu MHz         : 2167.000  
> > > > cache size      : 4096 KB
> > > > physical id     : 0
> > > > siblings        : 2
> > > > core id         : 0
> > > > cpu cores       : 2
> > > > apicid          : 0
> > > > initial apicid  : 0
> > > > fdiv_bug        : no
> > > > hlt_bug         : no
> > > > f00f_bug        : no
> > > > coma_bug        : no
> > > > fpu             : yes
> > > > fpu_exception   : yes
> > > > cpuid level     : 10
> > > > wp              : yes
> > > > flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> > > > mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm
> > > > constant_tsc arch_perfmon pebs bts pni dtes64 monitor ds_cpl vmx
> > > >  est tm2 ssse3 cx16 xtpr pdcm lahf_lm tpr_shadow
> > > > bogomips        : 4322.49
> > > > clflush size    : 64
> > > > power management:
> > > > 
> > > > processor       : 1
> > > > vendor_id       : GenuineIntel
> > > > cpu family      : 6
> > > > model           : 15
> > > > model name      : Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz
> > > > stepping        : 6
> > > > cpu MHz         : 1000.000
> > > > cache size      : 4096 KB
> > > > physical id     : 0
> > > > siblings        : 2
> > > > core id         : 1
> > > > cpu cores       : 2
> > > > apicid          : 1
> > > > initial apicid  : 1
> > > > fdiv_bug        : no
> > > > hlt_bug         : no
> > > > f00f_bug        : no
> > > > coma_bug        : no
> > > > fpu             : yes
> > > > fpu_exception   : yes
> > > > cpuid level     : 10
> > > > wp              : yes
> > > > flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> > > > mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm
> > > > constant_tsc arch_perfmon pebs bts pni dtes64 monitor ds_cpl vmx
> > > >  est tm2 ssse3 cx16 xtpr pdcm lahf_lm tpr_shadow
> > > > bogomips        : 4322.60
> > > > clflush size    : 64
> > > > power management:
> > > > 
> > > > 
> > > > the processor is full throttle on one of the cores.
> > > 
> > > Surely not.  The first core shows 2.16 GHz.
> > > 
> > > Anyway, it certainly is not related to the s2ram program in any way.
> > 
> > Normally I would see cpu MHz: 1000 under both entries,
> > this time upon wakeup theres 1000 and 2167.00. the 2167.00 doesn't move
> > down to 1000 i.g. example of system normally:
> >  cat /proc/cpuinfo <below>
> > 
> > processor       : 0
> > vendor_id       : GenuineIntel
> > cpu family      : 6
> > model           : 15
> > model name      : Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz
> > stepping        : 6
> > cpu MHz         : 1000.000   
> > cache size      : 4096 KB
> > physical id     : 0
> > siblings        : 2
> > core id         : 0
> > cpu cores       : 2
> > apicid          : 0
> > initial apicid  : 0
> > fdiv_bug        : no
> > hlt_bug         : no
> > f00f_bug        : no
> > coma_bug        : no
> > fpu             : yes
> > fpu_exception   : yes
> > cpuid level     : 10
> > wp              : yes
> > flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> > mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm
> > constant_tsc arch_perfmon                             pebs bts pni
> > dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm
> > tpr_shadow
> > bogomips        : 4322.48
> > clflush size    : 64
> > power management:
> > 
> > processor       : 1
> > vendor_id       : GenuineIntel
> > cpu family      : 6
> > model           : 15
> > model name      : Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz
> > stepping        : 6
> > cpu MHz         : 1000.000
> > cache size      : 4096 KB
> > physical id     : 0
> > siblings        : 2
> > core id         : 1
> > cpu cores       : 2
> > apicid          : 1
> > initial apicid  : 1
> > fdiv_bug        : no
> > hlt_bug         : no
> > f00f_bug        : no
> > coma_bug        : no
> > fpu             : yes
> > fpu_exception   : yes
> > cpuid level     : 10
> > wp              : yes
> > flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> > mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm
> > constant_tsc arch_perfmon                             pebs bts pni
> > dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm
> > tpr_shadow
> > bogomips        : 4322.51
> > clflush size    : 64
> > power management:
> > 
> > under normal use this 
> > will move between 2167.00 to 1000 simultaneously under load with both
> > cores, but then back down to 1000, for both when settled down.
> > in this situation as I reported, the 2167.00 just
> > stays at that number for one of the cores(if thats what I'm seeing) when
> > waking up from suspend for some reason or another. 
> 
> Ah, ok.  So the problem is that core remains at the highest frequency.
> 
> What cpufreq driver is used on this box?
> 
> Rafael

The setup I have is cpufreq_ondemand for
regular use, switch to cpufreq_powersave when watching
flash movies, or media. The acpi_cpufreq module is loaded
as well. The daemon I use is powersaved.
At this point I think what I'm going to do is downgrade
my xserver, so I can load the other gpu driver, to see
how it reacts upon wakeup(that is if I can get it to load); 
This way I can determine if it's a graphics module that causing
this or not.
regards;


-- 
Justin P. Mattock <justinmattock@gmail.com>

