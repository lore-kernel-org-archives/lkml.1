Return-Path: <linux-kernel-owner+w=401wt.eu-S1758283AbXEURYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283AbXEURYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 13:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756182AbXEURYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 13:24:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:53370 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755872AbXEURYc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 13:24:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,562,1170662400"; 
   d="scan'208";a="230437854"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: Increased ipw2200 power usage with dynticks
Date: Mon, 21 May 2007 10:24:15 -0700
Message-ID: <653FFBB4508B9042B5D43DC9E18836F5EA4D36@scsmsx415.amr.corp.intel.com>
In-Reply-To: <20070521074938.GA15678@atjola.homenet>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Increased ipw2200 power usage with dynticks
Thread-Index: AcebfJjPk2BrcNMXSWOoE8jMCPxcdAAT9wjQ
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: =?iso-8859-1?Q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>,
       "Andi Kleen" <andi@firstfloor.org>, "Brown, Len" <len.brown@intel.com>
Cc: <tglx@linutronix.de>, <mingo@elte.hu>, "Zhu, Yi" <yi.zhu@intel.com>,
       <linux-kernel@vger.kernel.org>, <arjan@infradead.org>, <trenn@suse.de>
X-OriginalArrivalTime: 21 May 2007 17:24:16.0484 (UTC) FILETIME=[DBB1BA40:01C79BCC]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Björn Steinbrink [mailto:B.Steinbrink@gmx.de] 
>Sent: Monday, May 21, 2007 12:50 AM
>To: Andi Kleen
>Cc: tglx@linutronix.de; mingo@elte.hu; Zhu, Yi; 
>linux-kernel@vger.kernel.org; arjan@infradead.org; Pallipadi, 
>Venkatesh; trenn@suse.de
>Subject: Re: Increased ipw2200 power usage with dynticks
>
>On 2007.05.20 20:55:35 +0200, Andi Kleen wrote:
>> Björn Steinbrink <B.Steinbrink@gmx.de> writes:
>> > 
>> > Ok, it seems that ipw2200 is just a trigger for the 
>problem here. AFAICT
>> > the cause of the worse C state usage is that after ipw2200 
>has woken the
>> > cpu, acpi_processor_idle() chooses C2 (due to dma? bm? I have no
>> > idea...) as the prefered sleep state. Now without NO_HZ or 
>when I hold
>> > down a key, there are interrupts that wake up the CPU and when
>> > acpi_processor_idle() is called again the promotion to 
>C3/C4 happens.
>> > But with NO_HZ, there are no such interrupts, most wakeups 
>are caused by
>> > ipw2200 and so the processor doesn't go any deeper than C2 
>most of the
>> > time and thus wastes lots of power.
>> 
>> The cpuidle governour code Venki is working on is supposed 
>to address this.
>> There have been also earlier prototype patches by Adam Belay and
>> Thomas Renninger.
>
>Venki (at least I think it was him) also told me about cpuidle and the
>menu governor on #powertop. Unfortunately, cpuidle seems to be 
>gone from
>acpi-test (or I'm simply still too stupid for git/gitweb). I manually
>added the cpuidle and menu governor patches on top of my 
>2.6.22-rc1-hrt8
>kernel, but that broke C-state duration accounting.
>
>On the bright side of things is power usage though, which is down to an
>incredible 13.9W in idle+ipw2200 :)
>

Nice to hear that cpuidle-menu governor gets 13.9W :-).
Powertop will need some changes to go with cpuidle, but that should be simple.

We need some more testing for cpuidle before it gets into git.
Len: Looks like cpuidle got dropped out of mm again. Can you merge it back it please.

Thanks,
Venki
