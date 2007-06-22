Return-Path: <linux-kernel-owner+w=401wt.eu-S1760220AbXFVVpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760220AbXFVVpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 17:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754508AbXFVVpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 17:45:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:20084 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbXFVVpb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 17:45:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,452,1175497200"; 
   d="scan'208";a="257817802"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Cpuidle task list
Date: Fri, 22 Jun 2007 14:45:29 -0700
Message-ID: <653FFBB4508B9042B5D43DC9E18836F5010CC9AA@scsmsx415.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: RE: Cpuidle task list
Thread-Index: Acex5DOFuleKuffiQZOpac5HLAac+gAEMYgQABOfesAAtL2icA==
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "LKML" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 22 Jun 2007 21:45:30.0395 (UTC) FILETIME=[A74ABEB0:01C7B516]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 
I sent a mail to Adam to look at these...
Max_cstate is what I observed once. I don't have more data.
Sysfs output issue has below details. About the third wraparound issue
Adam knows the bug and can probably fix it faster.

Thanks,
Venki

-----Original Message-----
From: Li, Shaohua 
Sent: Tuesday, June 19, 2007 12:30 AM
To: Pallipadi, Venkatesh
Subject: RE: Cpuidle task list

I didn't follow cpuidle issue closely recently, are there links for
below issues?

>-----Original Message-----
>From: Pallipadi, Venkatesh
>Sent: Tuesday, June 19, 2007 9:12 AM
>To: Li, Shaohua
>Subject: Cpuidle task list
>
>
>I could not call you today. Will try to do it tomorrow morning your
time.
>
>Here are the cpuidle stuff that needs fixing:
>
>1) /sys output issues like one below.
>
>2) echo 1 > /sys/.../max_cstate hangs by system
>
>3) bm logic is wrapping around in the latest version of menu governor.
Adam
>said he will fix it earlier, but I haven't seen any patches from him
yet.
>
>Thanks,
>Venki
>
>-----Original Message-----
>From: Valdis.Kletnieks@vt.edu [mailto:Valdis.Kletnieks@vt.edu]
>Sent: Monday, June 18, 2007 1:07 PM
>To: Thomas Gleixner
>Cc: LKML; Andrew Morton; Ingo Molnar; Andi Kleen; Chris Wright; Arjan
van
>de Ven; Pallipadi, Venkatesh
>Subject: Re: [patch-mm 00/25] High resolution timer updates and x86_64
>support - V2
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
>Am running with the 22-rc4-mm2-hrt4 patch on my Latitude D820.  Mostly
>seems
>to work, but for some reason the Intel 'powertop' util thinks it's 100%
>busy:
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
>[/sys/devices/system/cpu/cpu0/cpuidle] for i in */*; do echo -n "$i: ";
cat
>$i; done
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
>I think we have a 32/64 bit issue on state2/time which is probably
borking
>things up....
