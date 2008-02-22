Return-Path: <linux-kernel-owner+w=401wt.eu-S1761608AbYBVRCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761608AbYBVRCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 12:02:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756781AbYBVRCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 12:02:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:36783 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310AbYBVRC3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 12:02:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,392,1199692800"; 
   d="scan'208";a="344192192"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="koi8-r"
Content-Transfer-Encoding: 8BIT
Subject: RE: 100% C0 with 2.6.25-rc
Date: Fri, 22 Feb 2008 09:03:55 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE9A9620@orsmsx423.amr.corp.intel.com>
In-Reply-To: <47BEF0A6.9000405@willies.info>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 100% C0 with 2.6.25-rc
Thread-Index: Ach1bB1y+7BttFl3TJCC8O/BI5cHaAACJhig
References: <47BD600F.9090502@willies.info> <200802211733.54759.rjw@sisk.pl> <47BEF0A6.9000405@willies.info>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Jan Willies" <jan@willies.info>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: <linux-acpi@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
X-OriginalArrivalTime: 22 Feb 2008 17:02:28.0272 (UTC) FILETIME=[B45D2B00:01C87574]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Jan Willies [mailto:jan@willies.info] 
>Sent: Friday, February 22, 2008 7:56 AM
>To: Rafael J. Wysocki
>Cc: linux-acpi@vger.kernel.org; Ingo Molnar; LKML; Thomas 
>Gleixner; Pallipadi, Venkatesh
>Subject: Re: 100% C0 with 2.6.25-rc
>
>Rafael J. Wysocki wrote:
>> On Thursday, 21 of February 2008, Jan Willies wrote:
>>> Since 2.6.25-rc1 I have a lot of wakeups/s (—134191,4) and 
>spend 100% in C0.
>>> It worked fine with 2.6.24 and commandline nolapic. Without 
>nolapic I had 80k
>>> wakeups/s after some time, but not right from the start like now.  
>> 
>> We have a regression from 2.6.24, apparently interrupts-related.
>
>After a lot of bisecting I've found the bad commit: 
>
>9b12e18cdc1553de62d931e73443c806347cd974 is first bad commit
>commit 9b12e18cdc1553de62d931e73443c806347cd974
>Author: venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com>
>Date:   Thu Jan 31 17:35:05 2008 -0800
>
>    ACPI: cpuidle: Support C1 idle time accounting
>    
>    Show C1 idle time in /sysfs cpuidle interface. C1 idle time may not
>    be entirely accurate in all cases. It includes the time spent
>    in the interrupt handler after wakeup with "hlt" based C1. 
>But, it will
>    be accurate with "mwait" based C1.
>
>
>Reverting the commit brings my laptop back to C2.
>

Thanks for the bisect info. I will look at the bad side effects that patch may be having and I should have a patch for you to test later today....

Thanks,
Venki
