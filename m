Return-Path: <linux-kernel-owner+w=401wt.eu-S1752933AbZIVUml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbZIVUml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 16:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbZIVUmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 16:42:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37306 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862AbZIVUmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 16:42:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [resend] 2.6.31 regression: hangs on Compaq Evo N800c with ACPI enabled - bisected
Date: Tue, 22 Sep 2009 22:43:55 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: venkatesh.pallipadi@intel.com, len.brown@intel.com,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200909221709.24091.linux@rainbow-software.org>
In-Reply-To: <200909221709.24091.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200909222243.55403.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 September 2009, Ondrej Zary wrote:
> Hello,
> kernel 2.6.31 hangs during boot on Compaq Evo N800c laptop. 2.6.30 works fine.
> See https://bugzilla.redhat.com/show_bug.cgi?id=522057

Can you please file a kernel Bugzilla report for this issue, in the ACPI
category?  The ACPI people use the kernel Bugzilla as the primary bug-tracking
facility.

> Bisection resulted in commit ee1ca48fae7e575d5e399d4fdcfe0afc1212a64c:
> 
> $ git bisect bad
> ee1ca48fae7e575d5e399d4fdcfe0afc1212a64c is first bad commit
> commit ee1ca48fae7e575d5e399d4fdcfe0afc1212a64c
> Author: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
> Date:   Thu May 21 17:09:10 2009 -0700
> 
>     ACPI: Disable ARB_DISABLE on platforms where it is not needed
> 
>     ARB_DISABLE is a NOP on all of the recent Intel platforms.
> 
>     For such platforms, reduce contention on c3_lock
>     by skipping the fake ARB_DISABLE.
> 
>     Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>     Signed-off-by: Len Brown <len.brown@intel.com>
> 
> :040000 040000 f05492fbba2c068f22d7aefca36896f07ff8611b 47e784478de3c386591a92181e7784f5d224a989 M      arch
> :040000 040000 a379b031d617def0094cca3f56c2eda510a0604b cc00f83544238d1757fdf2a5e62206d1a49de2de M      drivers
> 
> Reverting this commit fixes the regression.
> 
> CPU is Mobile Pentium 4-M:
> 
> processor	: 0
> vendor_id	: GenuineIntel
> cpu family	: 15
> model		: 2
> model name	: Mobile Intel(R) Pentium(R) 4 - M CPU 2.20GHz
> stepping	: 7
> cpu MHz		: 2200.000
> cache size	: 512 KB
> fdiv_bug	: no
> hlt_bug		: no
> f00f_bug	: no
> coma_bug	: no
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 2
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe up pebs bts cid
> bogomips	: 4395.79
> clflush size	: 64
> power management:

Best,
Rafael
