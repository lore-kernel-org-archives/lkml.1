Return-Path: <linux-kernel-owner+w=401wt.eu-S1761227AbYHVC0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761227AbYHVC0o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 22:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbYHVC0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 22:26:37 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:51030 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963AbYHVC0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 22:26:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=k/kSOQJAtbdUgGcXO43PI+0/+7h1VQRTmtjmv4WIsV+b4cP1QJoDOLcPt+C3ApuN7w
         px0kCQskhb1C0agCdNUXk4p2D2CzLndX6aBaioETmJUjxShneL9aSl7GqtKfmmx8Eu/X
         OuGc4ypUh+VE/s0FOHfPRvskt5Quq1OvOb9uQ=
Message-ID: <86802c440808211926k1ec5b2a2g2bec1b7faee7ebbb@mail.gmail.com>
Date: Thu, 21 Aug 2008 19:26:35 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Joshua Hoblitt" <josh@hoblitt.com>
Subject: Re: [Bug 11388] New: 2.6.27-rc3 warns about MTRR range; only 3 of 16gb of memory is usable
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       j_kernel@hoblitt.com
In-Reply-To: <20080822021512.GJ23377@hoblitt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440808201849k6665c395x5a5b871eca55addd@mail.gmail.com>
	 <86802c440808211451u4483f88ft845cd20c3f23c53a@mail.gmail.com>
	 <20080821233317.GE23377@hoblitt.com>
	 <20080822001047.GF23377@hoblitt.com>
	 <86802c440808211728r4b5a7a37w929c2dd68616361d@mail.gmail.com>
	 <20080822002952.GG23377@hoblitt.com>
	 <20080822010014.GH23377@hoblitt.com>
	 <20080822011055.GI23377@hoblitt.com>
	 <86802c440808211855h50ea65faudc169e48f83e18e2@mail.gmail.com>
	 <20080822021512.GJ23377@hoblitt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 7:15 PM, Joshua Hoblitt <josh@hoblitt.com> wrote:
> On Thu, Aug 21, 2008 at 06:55:58PM -0700, Yinghai Lu wrote:
>> can you send out /proc/cpuinfo
>
> See below.  I should also add that this kernel correctly sets up the mtrrs
> on an amd system.
>
> --
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 23
> model name      : Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz
> stepping        : 6
> cpu MHz         : 2400.000
> cache size      : 6144 KB
> physical id     : 0
> siblings        : 4
> core id         : 0
> cpu cores       : 4
> apicid          : 0
> initial apicid  : 0
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 10
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
> syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl pni
> monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr dca sse4_1 lahf_lm
> bogomips        : 6386.99
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 38 bits physical, 48 bits virtual
> power management:
>
> processor       : 1
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 23
> model name      : Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz
> stepping        : 6
> cpu MHz         : 2400.000
> cache size      : 6144 KB
> physical id     : 1
> siblings        : 4
> core id         : 0
> cpu cores       : 4
> apicid          : 4
> initial apicid  : 4
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 10
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
> syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl pni
> monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr dca sse4_1 lahf_lm
> bogomips        : 6386.12
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 38 bits physical, 48 bits virtual

good, the root cause is your bios not set mask correctly...

it should set var mtrr like

[    0.429971]  MSR00000200: 00000000d0000000
[    0.433305]  MSR00000201: 0000000ff0000800
==> [    0.433305]  MSR00000201: 0000003ff0000800

[    0.436638]  MSR00000202: 00000000e0000000
[    0.439971]  MSR00000203: 0000000fe0000800
==> [    0.439971]  MSR00000203: 0000003fe0000800

[    0.443304]  MSR00000204: 0000000000000006
[    0.446637]  MSR00000205: 0000000c00000800
==> [    0.446637]  MSR00000205: 0000003c00000800

[    0.449970]  MSR00000206: 0000000400000006
[    0.453303]  MSR00000207: 0000000fe0000800
==>[    0.453303]  MSR00000207: 0000003fe0000800

[    0.456636]  MSR00000208: 0000000420000006
[    0.459970]  MSR00000209: 0000000ff0000800
==> [    0.459970]  MSR00000209: 0000003ff0000800

you may talk to your BIOS vendor or system vendor to request one new
updated BIOS.

YH
