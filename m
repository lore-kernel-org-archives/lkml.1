Return-Path: <linux-kernel-owner+w=401wt.eu-S1752791AbXLFAg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbXLFAg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 19:36:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbXLFAgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 19:36:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:6877 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbXLFAgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 19:36:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,257,1194249600"; 
   d="scan'208";a="225916307"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Subject: RE: constant_tsc and TSC unstable
Date: Wed, 5 Dec 2007 16:35:43 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE34B165@orsmsx423.amr.corp.intel.com>
In-Reply-To: <20071130075258.24a785d4@tux.DEF.witbe.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: constant_tsc and TSC unstable
Thread-Index: AcgzHcds7UbZhof3TTKD52mtwLStQgEgZvjw
References: <20071129171142.56c7890a@tux.DEF.witbe.net><924EFEDD5F540B4284297C4DC59F3DEE2FAA12@orsmsx423.amr.corp.intel.com> <20071130075258.24a785d4@tux.DEF.witbe.net>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: =?iso-2022-jp?B?UGF1bCBSb2xsYW5kICgbJEIlXSE8JWshJiVtJWklcxsoQik=?= 
	<rol@witbe.net>
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
X-OriginalArrivalTime: 06 Dec 2007 00:35:22.0383 (UTC) FILETIME=[E2C331F0:01C8379F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org 
>[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Paul 
>Rolland (???・???)
>Sent: Thursday, November 29, 2007 10:53 PM
>To: Pallipadi, Venkatesh
>Cc: Linux Kernel; Siddha, Suresh B; rol@witbe.net
>Subject: Re: constant_tsc and TSC unstable
>
>Hello,
>
>On Thu, 29 Nov 2007 15:29:49 -0800
>"Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com> wrote:
>
>
>
>> TSCs on Core 2 Duo are supposed to be in sync unless CPU 
>supports deep idle
>> states like C2, C3. Can you send the full /proc/cpuinfo and 
>full dmesg.
>> 
>Sure I can...
>[root@tux log]# cat /proc/cpuinfo 
>processor       : 0
>vendor_id       : GenuineIntel
>cpu family      : 6
>model           : 15
>model name      : Intel(R) Core(TM)2 CPU         T5300  @ 1.73GHz
>stepping        : 2
>cpu MHz         : 800.000
>cache size      : 2048 KB
>physical id     : 0
>siblings        : 2
>core id         : 0
>cpu cores       : 2
>fdiv_bug        : no
>hlt_bug         : no
>f00f_bug        : no
>coma_bug        : no
>fpu             : yes
>fpu_exception   : yes
>cpuid level     : 10
>wp              : yes
>flags           : fpu vme de pse tsc msr pae mce cx8 apic mtrr 
>pge mca cmov pat ps
>e36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm 
>constant_tsc arch_perfmo
>n pebs bts pni monitor ds_cpl est tm2 ssse3 cx16 xtpr lahf_lm
>bogomips        : 3461.13
>clflush size    : 64
>

Tried reproducing this here, but on a similar system (slightly newer CPU stepping) I don’t see this happening. This error does not matter on this particular system as even with TSC synchronization passes, TSC is going to be disabled later due to C2, C3 states, with a message like this
Marking TSC unstable due to: TSC halts in idle.

Will try to reproduce it on other systems to see whether there are any bugs in sync routines.

Thanks,
Venki
