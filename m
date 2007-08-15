Return-Path: <linux-kernel-owner+w=401wt.eu-S1760161AbXHOHp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760161AbXHOHp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 03:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754267AbXHOHpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 03:45:11 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:11620 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236AbXHOHpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 03:45:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GUQSf354LotciseFQYzF2Cj+QDlj6i2tps40E85JVuGgin3NA6ex2OI8lmuufLQkMe7OrkKmPy7cLa45xjF0/T0z5ow2F3p7oabxIw+rGPMwT8qv+QhM8x6h3a+0C/kuZsqmdgube2Pc9S005UMD7ezOx5ZTLu19o6yP9ouHqhU=
Message-ID: <a8e1da0708150045i4b02e0a4u51a10084f1b439da@mail.gmail.com>
Date: Wed, 15 Aug 2007 15:45:08 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Randy Dunlap" <rdunlap@xenotime.net>
Subject: Re: two questions about the boot_delay
Cc: "Dave Jones" <davej@codemonkey.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070811163331.b8ff4a6b.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0708080039w1deed062hf5920e1257eb1cbb@mail.gmail.com>
	 <20070811163331.b8ff4a6b.rdunlap@xenotime.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>On 8/12/07, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Wed, 8 Aug 2007 07:39:33 +0000 Dave Young wrote:
>
> > Hi,
> > I have tried the "slow down printk" , and I have two questions.
> >
> > 1. why it depends the DEBUG_KERNEL? Sometimes we only need boot_delay
> > to see the printk infomations.  How about set it as a standalone
> > config option?
>
> Is depending on DEBUG_KERNEL a problem?  If so, why?

IMHO, the DEBUG_KERNEL will build a big kernel and the building time
is long, so if the we only want to look at the boot messages at panic
point, the DEBUG_KERNEL is not needed.

>
> It sure seems like a kernel debug option to me, although
> I have no strong preference pro or con on this.
>
> > 2. In My system if I boot with boot_delay=200 the early part of
> > booting will be very slow, eapecially at the very beginning (after the
> > compressing  and start kernel, it nearly stop here many minutes).
> >
> > And I wonder if we can simply use mdelay in the boot_delay_msec(). I
> > tested the mdelay , and the result is more accurate.
>
> I wasn't convinced that loops_per_jiffy was always set for all
> architectures that early during boot.  Did you audit and verify that
> it is set early enough to use during boot_delay_msec()?
> and if so, for all architectures?
> What architectures did you test this on?

I386 for me. I tested boot_delay=300 again:

1. From "Uncompressing Linux.. Ok,booting the kernel" to "console
[tty0] enabled"
keep the same screen about 5-6 minutes

2. After that every line will need 20-30 seconds.

My cpuinfo:
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 4
model name	: Intel(R) Pentium(R) D CPU 2.80GHz
stepping	: 7
cpu MHz		: 2793.181
cache size	: 1024 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 5
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm
constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl cid cx16 xtpr
lahf_lm
bogomips	: 5591.66
clflush size	: 64

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 15
model		: 4
model name	: Intel(R) Pentium(R) D CPU 2.80GHz
stepping	: 7
cpu MHz		: 2793.181
cache size	: 1024 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 5
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm
constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl cid cx16 xtpr
lahf_lm
bogomips	: 5587.46
clflush size	: 64


Regards
dave
