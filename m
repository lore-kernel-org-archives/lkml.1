Return-Path: <linux-kernel-owner+w=401wt.eu-S965635AbYD1Qd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965635AbYD1Qd6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 12:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965443AbYD1Qdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 12:33:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:45744 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965438AbYD1Qde convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 12:33:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,717,1199692800"; 
   d="scan'208";a="322203994"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [2.6.25-stable PATCH] regression: powertop says 120K wakeups/sec
Date: Mon, 28 Apr 2008 09:36:01 -0700
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEEF31621@orsmsx423.amr.corp.intel.com>
In-Reply-To: <200804281209.47927.danielklaffenbach@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [2.6.25-stable PATCH] regression: powertop says 120K wakeups/sec
Thread-Index: AcipFylq96VdWoI9QGqT0tKwroypiwANOYqw
References: <200804242015.19462.lenb@kernel.org> <200804281209.47927.danielklaffenbach@gmail.com>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Daniel Klaffenbach" <danielklaffenbach@gmail.com>,
       "Len Brown" <lenb@kernel.org>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 28 Apr 2008 16:33:33.0630 (UTC) FILETIME=[99B34DE0:01C8A94D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Daniel Klaffenbach [mailto:danielklaffenbach@gmail.com] 
>Sent: Monday, April 28, 2008 3:10 AM
>To: Len Brown
>Cc: Linux Kernel Mailing List; Pallipadi, Venkatesh
>Subject: Re: [2.6.25-stable PATCH] regression: powertop says 
>120K wakeups/sec
>
>> commit 0fda6b403f0eca66ad8a7c946b3996e359100443
>>
>> Patch to fix huge number of wakeups reported due to recent changes in
>> processor_idle.c. The problem was that the entry_method 
>determination was
>> broken due to one of the recent commits (bc71bec91f987) causing
>> C1 entry to not to go to halt.
>>
>> http://lkml.org/lkml/2008/3/22/124
>>
>> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>> Signed-off-by: Len Brown <len.brown@intel.com>
>OK, this fixes my issue with the massive amount of wakeups:
>http://lkml.org/lkml/2008/4/24/70
>
>However the CPU does not really go to C1 or C2 after applying 
>this patch to 
>the latest git kernel:
>
>Cn                Avg residency       P-states (frequencies)
>C0 (cpu running)        (99,4%)         1,80 Ghz     0,0%
>C1                0,0ms ( 0,0%)         1,60 Ghz     0,0%
>C2                0,0ms ( 0,6%)          800 Mhz   100,0%
>


Did C1, C2 work fine with 2.6.24?
Can you send me the full dmesg when it is failing to enter C1, C2 with
latest git + patch.
Output of
#grep . /sys/devices/system/cpu/cpu*/cpuidle/*/*
And also attach the acpidump output (pmtools package here
http://www.lesswatts.org/projects/acpi/utilities.php)

Thanks,
Venki
