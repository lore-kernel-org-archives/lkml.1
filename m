Return-Path: <linux-kernel-owner+w=401wt.eu-S1756991AbYCKOAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991AbYCKOAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 10:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYCKOAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 10:00:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:22423 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbYCKOAG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 10:00:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,480,1199692800"; 
   d="scan'208";a="305304179"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: endless loop in native_flush_tlb_others in smp_64.c
Date: Tue, 11 Mar 2008 07:01:56 -0700
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEEAF9755@orsmsx423.amr.corp.intel.com>
In-Reply-To: <200803111130.55355.chunkeey@web.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: endless loop in native_flush_tlb_others in smp_64.c
Thread-Index: AciDY9WyaHKE8dJ1Rp66iQjB//+kdwAHF4Qg
References: <200803102316.54457.chunkeey@web.de> <df9815e70803110255s1c8323a8xf05b132ecc406bd0@mail.gmail.com> <200803111130.55355.chunkeey@web.de>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: <chunkeey@web.de>, "Jike Song" <albcamus@gmail.com>
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Brown, Len" <len.brown@intel.com>
X-OriginalArrivalTime: 11 Mar 2008 14:00:05.0368 (UTC) FILETIME=[35520780:01C88380]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: chunkeey@web.de [mailto:chunkeey@web.de] 
>Sent: Tuesday, March 11, 2008 3:31 AM
>To: Jike Song
>Cc: Linux Kernel; Pallipadi, Venkatesh; Ingo Molnar; Thomas 
>Gleixner; Brown, Len
>Subject: Re: endless loop in native_flush_tlb_others in smp_64.c
>
>On Tuesday 11 March 2008 10:55:40 Jike Song wrote:
>> On Tue, Mar 11, 2008 at 6:16 AM, Chr <chunkeey@web.de> wrote:
>> > Hi,
>> >  ever since I moved to 2.6.25-rcY (Y should be between 2 and 5!).
>> >  I've seen several, but really hard-to-catch instant freezes on my
>> >  AMD64 Athlon X2 4200+ system...
>>
>> Here I guess 2.6.24 is fine for you?
>Yes, 2.6.24(.3) is fine!
>
>> >  Most of them happend in X.org so at first I thought it 
>had something to
>> > do with the NVIDIA module... BUT, one time it froze "a way 
>before" the
>> > module could get loaded...
>> >
>> >  ---
>> >  SYSRQ-P revealed that the CPU were looping inside:
>> >
>> >  smp_64.c native_flush_tlb_others:
>> >  assembler code:
>> >  < 1ee:   f3 90                   pause
>> >  < 1f0:   f6 45 00 03             testb  $0x3,0x0(%rbp)
>> >  < 1f4:   75 f8                   jne    1ee
>> > <native_flush_tlb_others+0x5f>
>> >
>> >  also known as: (in C)
>> >
>> >  while (!cpus_empty(f->flush_cpumask))
>> >         cpu_relax();
>> >
>> >  So... has anyone a good idea what's happening here 
>exactly? Or is there
>> >  already another topic or even a patch available?
>>
>> Would you please attach your config file?  Do you have 
>CONFIG_CPU_IDLE set?
>(Attached). Yes, CONFIG_CPU_IDLE is enabled! I guess I should 
>now disable it, 
>try again and report back, right?! ;-) 

I don't think it is related to CPU_IDLE. SYSRQ-T that Thomas asked
should give more clues.

Thanks,
Venki
