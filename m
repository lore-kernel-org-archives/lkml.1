Return-Path: <linux-kernel-owner+w=401wt.eu-S1754719AbYKVV2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbYKVV2m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 16:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbYKVV2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 16:28:32 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:62312 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbYKVV2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 16:28:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kL/AtRv+bVhmVrkgBjO8Z9Dc5ldEbYIFOmEDFelQl78UqaAU0RTv1yEj/iumdG1zZ5
         xikCSHshz4SV4T1Q573gAH+p9Ia4BgZTjkcf33tAVMIR1xXUh/pmmzkXqzClqmzJSoIK
         TGm4/Cpdvd4NmWbWm1re39iV2LIjGY+3cIRnw=
Subject: Re: processors core stuck in full throttle after waking up from
 s2ram
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <200811222151.49273.rjw@sisk.pl>
References: <1227168699.4276.24.camel@LiNuX>
	 <200811222151.49273.rjw@sisk.pl>
Content-Type: text/plain
Date: Sat, 22 Nov 2008 13:28:26 -0800
Message-Id: <1227389306.3171.14.camel@LiNuX>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-11-22 at 21:51 +0100, Rafael J. Wysocki wrote:
> On Thursday, 20 of November 2008, Justin P. Mattock wrote:
> > (before getting into this I need to see if somebody else with a macbook
> > pro(ATI with radeon drivers) is experiencing the same issue?)
> > I'm not sure I this is caused by the kernel or the program s2ram.
> > when I cat watch /proc/cpuinfo I see: (after waking up from suspend.)
> > 
> > Every 2.0s: cat /proc/cpuinfo
> > Wed Nov 19 23:49:13 2008
> > 
> > processor       : 0
> > vendor_id       : GenuineIntel
> > cpu family      : 6
> > model           : 15
> > model name      : Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz
> > stepping        : 6
> > cpu MHz         : 2167.000  
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
> > constant_tsc arch_perfmon pebs bts pni dtes64 monitor ds_cpl vmx
> >  est tm2 ssse3 cx16 xtpr pdcm lahf_lm tpr_shadow
> > bogomips        : 4322.49
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
> > constant_tsc arch_perfmon pebs bts pni dtes64 monitor ds_cpl vmx
> >  est tm2 ssse3 cx16 xtpr pdcm lahf_lm tpr_shadow
> > bogomips        : 4322.60
> > clflush size    : 64
> > power management:
> > 
> > 
> > the processor is full throttle on one of the cores.
> 
> Surely not.  The first core shows 2.16 GHz.
> 
> Anyway, it certainly is not related to the s2ram program in any way.
> 
> Thanks,
> Rafael


Normally I would see cpu MHz: 1000 under both entries,
this time upon wakeup theres 1000 and 2167.00. the 2167.00 doesn't move
down to 1000 i.g. example of system normally:
 cat /proc/cpuinfo <below>

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz
stepping        : 6
cpu MHz         : 1000.000   
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm
constant_tsc arch_perfmon                             pebs bts pni
dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm
tpr_shadow
bogomips        : 4322.48
clflush size    : 64
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz
stepping        : 6
cpu MHz         : 1000.000
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
apicid          : 1
initial apicid  : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm
constant_tsc arch_perfmon                             pebs bts pni
dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm
tpr_shadow
bogomips        : 4322.51
clflush size    : 64
power management:

under normal use this 
will move between 2167.00 to 1000 simultaneously under load with both
cores, but then back down to 1000, for both when settled down.
in this situation as I reported, the 2167.00 just
stays at that number for one of the cores(if thats what I'm seeing) when
waking up from suspend for some reason or another. 

regards;


-- 
Justin P. Mattock <justinmattock@gmail.com>

