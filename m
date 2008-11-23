Return-Path: <linux-kernel-owner+w=401wt.eu-S1757239AbYKWD7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239AbYKWD7d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 22:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbYKWD70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 22:59:26 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:23882 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502AbYKWD7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 22:59:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=JG2njj+I+H/eJeqXqpAsBiM09xyO045cS5OOpo4rbH6yE89+8XmipFM5hWpZzidAe2
         jUVPXkAE+Gq4kMt4p1w+FLgijdK6k/MKmTo+WepUlHTll/KwbpDBA0EdPRiuVFN5WpiQ
         UiSj3g+AskAd8nSY6zcc1LIUgZcSQR3lNojIQ=
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
Date: Sat, 22 Nov 2008 19:59:20 -0800
Message-Id: <1227412760.3191.10.camel@LiNuX>
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

O.K. Now I'm confused, this morning
I pulled, then let the system sit and idle 
all day, now after sending you a post 
I decided to make sure that this was happening,
before I go and downgrade the xserver, to load the other
graphics module. Much to my surprise the cores 
were reacting properly, both at 1000 MHz.
("pooof", it's fixed);
So with that in mind(I'm not crazy, really I'm not....)
whatever was commited between  2.6.28-rc5-00118-geef8eed
and 2.6.28-rc6-00011-g3791555 fixed the issue.
At this point thanks for assisting me, and for now
I'll just keep my eyes open and send a post if I see
anything out of the ordinary. As for the:

 [ INFO: possible circular locking dependency detected ]
in my original post, Seems to show up when I disable 
hot-plugging in my xorg.conf(I still need to check that);

regards;


-- 
Justin P. Mattock <justinmattock@gmail.com>

