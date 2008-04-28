Return-Path: <linux-kernel-owner+w=401wt.eu-S938108AbYD1VKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938108AbYD1VKu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 17:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935609AbYD1VKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 17:10:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:58562 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935281AbYD1VKg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 17:10:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,718,1199692800"; 
   d="scan'208";a="239089104"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [2.6.25-stable PATCH] regression: powertop says 120K wakeups/sec
Date: Mon, 28 Apr 2008 14:13:05 -0700
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEEF31967@orsmsx423.amr.corp.intel.com>
In-Reply-To: <200804282001.06680.danielklaffenbach@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [2.6.25-stable PATCH] regression: powertop says 120K wakeups/sec
Thread-Index: AcipWdp9su56CRZ2TG2Yu0fEnTjuEAAGkuJg
References: <200804242015.19462.lenb@kernel.org> <200804281209.47927.danielklaffenbach@gmail.com> <924EFEDD5F540B4284297C4DC59F3DEEF31621@orsmsx423.amr.corp.intel.com> <200804282001.06680.danielklaffenbach@gmail.com>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Daniel Klaffenbach" <danielklaffenbach@gmail.com>
Cc: "Len Brown" <lenb@kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 28 Apr 2008 21:10:35.0044 (UTC) FILETIME=[4CD5CE40:01C8A974]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Daniel Klaffenbach [mailto:danielklaffenbach@gmail.com] 
>Sent: Monday, April 28, 2008 11:01 AM
>To: Pallipadi, Venkatesh
>Cc: Len Brown; Linux Kernel Mailing List
>Subject: Re: [2.6.25-stable PATCH] regression: powertop says 
>120K wakeups/sec
>
>Pallipadi, Venkatesh wrote:
>> Did C1, C2 work fine with 2.6.24?
>> Can you send me the full dmesg when it is failing to enter 
>C1, C2 with
>> latest git + patch.
>> Output of
>> #grep . /sys/devices/system/cpu/cpu*/cpuidle/*/*
>> And also attach the acpidump output (pmtools package here
>> http://www.lesswatts.org/projects/acpi/utilities.php)
>No, C1/C2 did not seem to work with 2.6.24 - at least powertop 
>reported 99,9% 
>C0 usage. It was the same behavior as after applying the wakeup patch. 
>However in 2.6.25 and 2.6.25-git11 C1/C2 worked correctly and 
>C2 showed up in 
>pt. But after applying your patch to 2.6.25-git11 they did not:
>
>git11:
>PowerTOP version 1.9       (C) 2007 Intel Corporation
>Cn                Avg residency       P-states (frequencies)
>C0 (cpu running)        ( 9,4%)         1,80 Ghz   100,0%
>C1                0,0ms ( 0,0%)         1,60 Ghz     0,0%
>C2                0,4ms (90,6%)          800 Mhz     0,0%
>Wakeups-from-idle per second : 9051,0   interval: 5,0s
>
>git11 with wakeup-patch:
>PowerTOP version 1.9       (C) 2007 Intel Corporation
>Cn                Avg residency       P-states (frequencies)
>C0 (cpu running)        (99,9%)         1,80 Ghz   100,0%
>C1                0,0ms ( 0,0%)         1,60 Ghz     0,0%
>C2                0,2ms ( 0,1%)          800 Mhz     0,0%
>Wakeups-from-idle per second : 59,8     interval: 10,0s
>
>In both cases the system was idle. I've uploaded the files you wanted:
>http://www-user.tu-chemnitz.de/~klada/misc/kernel/cpuidle_git11.txt
>http://www-user.tu-chemnitz.de/~klada/misc/kernel/cpuidle_git11
>_wakeuppatch.txt
>http://www-user.tu-chemnitz.de/~klada/misc/kernel/dmesg_git11.txt
>http://www-user.tu-chemnitz.de/~klada/misc/kernel/dmesg_git11_w
akeuppatch.txt
>http://www-user.tu-chemnitz.de/~klada/misc/kernel/nx6125_acpidump.out
>
>If there is anything else I can do for debugging this issue 
>please let me 
>know.
>

With git11+wakeup patch, things seems to be working fine as per
>http://www-user.tu-chemnitz.de/~klada/misc/kernel/cpuidle_git11_wakeupp
atch.txt

CPU is spending most of the time in C3 state. Looks like there is some
problem with
powertop reporting here. I know there were some changes to this area in
powertop.
Can you try the latest powertop version from svn
(http://www.lesswatts.org/projects/powertop/download.php) and see
whether the issue is fixed.

Thanks,
Venki
