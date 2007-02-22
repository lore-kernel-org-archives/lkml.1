Return-Path: <linux-kernel-owner+w=401wt.eu-S1751804AbXBVT6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804AbXBVT6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 14:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbXBVT6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 14:58:22 -0500
Received: from mga03.intel.com ([143.182.124.21]:12263 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806AbXBVT6V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 14:58:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,207,1170662400"; 
   d="scan'208"; a="185822651:sNHT26686961"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: NO_HZ: timer interrupt stuck [Re: Linux 2.6.21-rc1]
Date: Thu, 22 Feb 2007 11:58:17 -0800
Message-ID: <EB12A50964762B4D8111D55B764A8454014CBC24@scsmsx413.amr.corp.intel.com>
In-Reply-To: <1172160024.25076.188.camel@localhost.localdomain>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: NO_HZ: timer interrupt stuck [Re: Linux 2.6.21-rc1]
thread-index: AcdWmgA9nqe/+aA2SqG+HnJOaR/BYwAIJA7A
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: <tglx@linutronix.de>, "Pierre Ossman" <drzeus-list@drzeus.cx>
Cc: "Arjan van de Ven" <arjan@infradead.org>,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Luca Tettamanti" <kronos.it@gmail.com>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 22 Feb 2007 19:58:18.0456 (UTC) FILETIME=[CBFCBD80:01C756BB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org 
>[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of 
>Thomas Gleixner
>Sent: Thursday, February 22, 2007 8:00 AM
>To: Pierre Ossman
>Cc: Arjan van de Ven; Jan Engelhardt; Luca Tettamanti; 
>linux-kernel@vger.kernel.org
>Subject: Re: NO_HZ: timer interrupt stuck [Re: Linux 2.6.21-rc1]
>
>On Thu, 2007-02-22 at 16:13 +0100, Pierre Ossman wrote:
>> > Sure. My dmesg is full of mmc debug crud right now, but 
>I'll just reboot
>> > and I'll have a clean one for you.
>> > 
>> 
>> Here we go.
>
>> [   44.498253] ACPI: Lid Switch [C136]
>> [   44.577672] No dock devices found.
>> [   44.714156] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
>
>---------------------------------------------------------^^^^^
>
>Here is the reason. The local APIC stops working in C3 state 
>and we fall
>back to the PIT in that case. Not really exciting for dynticks, but the
>only way to keep the system alive. There is a patch coming up from
>Intel, which finds out how to use HPET even if it is not enabled by the
>BIOS. This will still end up on IRQ#0, but will give way longer idle
>sleeps than the PIT.
>
>	tglx
>
>

Thomas,

I have the patchset for this HPET part ready to roll out. But, looks
like 
NO_HZ and lapic eventsource support is only in i386 and not in x86-64 in
2.6.21-rc1.
Do you know the state of NO_HZ x86-64 support?

Will it get into git soon? In which case I can rebase my patches against
git
and send it out for review/testing.

Otherwise, I will send out my patches, which are against rt (and my
initial
implementation of this HPET part is only for x86-64).

Thanks,
Venki
