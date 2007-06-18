Return-Path: <linux-kernel-owner+w=401wt.eu-S1765339AbXFRUYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765339AbXFRUYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 16:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763180AbXFRUYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 16:24:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:37039 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762295AbXFRUYi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 16:24:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,436,1175497200"; 
   d="scan'208";a="255964703"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch-mm 00/25] High resolution timer updates and x86_64 support - V2
Date: Mon, 18 Jun 2007 13:24:33 -0700
Message-ID: <653FFBB4508B9042B5D43DC9E18836F501091308@scsmsx415.amr.corp.intel.com>
In-Reply-To: <6972.1182197191@turing-police.cc.vt.edu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch-mm 00/25] High resolution timer updates and x86_64 support - V2
Thread-Index: Acex5DOFuleKuffiQZOpac5HLAac+gAAe/Fg
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: <Valdis.Kletnieks@vt.edu>, "Thomas Gleixner" <tglx@linutronix.de>
Cc: "LKML" <linux-kernel@vger.kernel.org>, "Andrew Morton" <akpm@osdl.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <ak@suse.de>,
       "Chris Wright" <chrisw@sous-sol.org>,
       "Arjan van de Ven" <arjan@infradead.org>
X-OriginalArrivalTime: 18 Jun 2007 20:24:36.0162 (UTC) FILETIME=[B04A9220:01C7B1E6]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Valdis.Kletnieks@vt.edu [mailto:Valdis.Kletnieks@vt.edu] 
>Sent: Monday, June 18, 2007 1:07 PM
>To: Thomas Gleixner
>Cc: LKML; Andrew Morton; Ingo Molnar; Andi Kleen; Chris 
>Wright; Arjan van de Ven; Pallipadi, Venkatesh
>Subject: Re: [patch-mm 00/25] High resolution timer updates 
>and x86_64 support - V2
>
>On Sat, 16 Jun 2007 10:36:00 -0000, Thomas Gleixner said:
>> The following patch series contains:
>> 
>> - dyntick bugfixes for -mm (caused by the cpuidle changes in ACPI)
>> 
>> - updates and improvements to high resolution timer / dynticks 
>> 
>> - high resolution timer / dynticks support for x86_64
>
>Am running with the 22-rc4-mm2-hrt4 patch on my Latitude D820. 
> Mostly seems
>to work, but for some reason the Intel 'powertop' util thinks 
>it's 100% busy:
>
>     PowerTOP version 1.7       (C) 2007 Intel Corporation
>
>Cn          Avg residency (5s)          P-states (frequencies)
>C0 (cpu running)        (100.0%)
>C1                0.0ms ( 0.0%)         2.00 Ghz     0.0%
>C2                0.0ms ( 0.0%)         1.67 Ghz     0.0%
>C3                0.0ms ( 0.0%)         1333 Mhz     0.0%
>                                        1000 Mhz   100.0%
>
>In reality:
>
>[/sys/devices/system/cpu/cpu0/cpuidle] for i in */*; do echo 
>-n "$i: "; cat $i; done
>state0/latency: 1
>state0/power: 1000
>state0/time: 0
>state0/usage: 3
>state1/latency: 1
>state1/power: 500
>state1/time: 1756017623
>state1/usage: 1837402
>state2/latency: 57
>state2/power: 100
>state2/time: -159524787
>state2/usage: 15007443
>

The problem is powertop only understands /proc/acpi/processor/CPU*/power
for
and not /sys..cpuidle for the moment.

I had a patch in recent cpuidle fixes series that makes /proc interface
active
again with cpuidle which should correct this. Those patches are not in
rc4-mm2-hrt4, but are there in latest rc4-hrt and rc5-hrt series.

Thanks,
Venki 
