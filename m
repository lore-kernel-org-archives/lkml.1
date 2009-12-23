Return-Path: <linux-kernel-owner+w=401wt.eu-S1754299AbZLWROx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbZLWROx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 12:14:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbZLWROx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 12:14:53 -0500
Received: from mga02.intel.com ([134.134.136.20]:20908 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800AbZLWROw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 12:14:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,443,1257148800"; 
   d="scan'208";a="478677691"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
CC: Mark Hounschell <markh@compro.net>,
       "dmarkh@cfl.rr.com" <dmarkh@cfl.rr.com>, Alain Knaff <alain@knaff.lu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "fdutils@fdutils.linux.lu" <fdutils@fdutils.linux.lu>,
       "Li, Shaohua" <shaohua.li@intel.com>, Ingo Molnar <mingo@elte.hu>
Date: Wed, 23 Dec 2009 09:19:42 -0800
Subject: RE: [Fdutils] DMA cache consistency bug introduced in 2.6.28
Thread-Topic: [Fdutils] DMA cache consistency bug introduced in 2.6.28
Thread-Index: AcqD8B6dcCBJAY4DSd+tPU5Tp2giogAA4NWQ
Message-ID: <6598A4E21F1DB24D80BF72956484F59802EFD2F1@orsmsx001.amr.corp.intel.com>
References: <4AFB3962.2020106@ntlworld.com> <4B2B4485.6000305@cfl.rr.com>
 <4B2B5F86.1090403@cfl.rr.com>
 <alpine.LFD.2.00.0912180716400.3712@localhost.localdomain>
 <4B2B9F9F.7040802@compro.net>
 <alpine.LFD.2.00.0912180734220.3712@localhost.localdomain>
 <4B2BE05B.9050006@compro.net>
 <alpine.LFD.2.00.0912181213540.3712@localhost.localdomain>
 <4B30E1B4.7000702@compro.net>
 <alpine.LFD.2.00.0912220922250.31313@localhost.localdomain>
 <4B310879.9050701@compro.net> <1261525076.16916.4.camel@localhost.localdo
 main> <4B3162BC.9000508@cfl.rr.com> <4B3214EC.6020308@compro.net>
 <6598A4E21F1DB24D80BF72956484F59802EFD1C6@orsmsx001.amr.corp.intel.com>
 <4B32386B.2060509@compro.net>
 <alpine.LFD.2.00.0912230828230.6879@localhost.localdomain>
 <87bphpd4rt.fsf@basil.nowhere.org>
 <alpine.LFD.2.00.0912230845550.6879@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912230845550.6879@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Linus Torvalds [mailto:torvalds@linux-foundation.org] 
>Sent: Wednesday, December 23, 2009 8:50 AM
>To: Andi Kleen
>Cc: Mark Hounschell; Pallipadi, Venkatesh; dmarkh@cfl.rr.com; 
>Alain Knaff; Linux Kernel Mailing List; 
>fdutils@fdutils.linux.lu; Li, Shaohua; Ingo Molnar
>Subject: Re: [Fdutils] DMA cache consistency bug introduced in 2.6.28
>
>
>
>On Wed, 23 Dec 2009, Andi Kleen wrote:
>> 
>> I suspect it's a system where the APIC timer stops in deeper idle
>> states and it supports them. In this case CPU #0 does timer 
>broadcasts
>> when needed to wake the other CPUs up from deep C, but for 
>that it has
>> to run with HPET. At least the other ones can still enjoy the LAPIC
>> timer.
>
>Ahh, ok, that makes sense. I was assuming the broadcast timer 
>would act in 
>that capacity, but..

This is what I was thining yday and asked Mark to try idle=halt.
This /proc/interrupts is with idle=halt when there should not be any
C-states and broadcasts involved.
>>> HPET_MSI-edge      hpet2
>>> NMI:          0          0          0          0   
>>> Non-maskable interrupts
>>> LOC:        268     513395     513138     522088   Local timer 
>>> interrupts

Not sure how this is related to floppy problem. But, we surely
have something wrong with percpu HPET usage here.

Thanks,
Venki
