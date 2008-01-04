Return-Path: <linux-kernel-owner+w=401wt.eu-S1755010AbYADV61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbYADV61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 16:58:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbYADV6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 16:58:18 -0500
Received: from mga09.intel.com ([134.134.136.24]:7167 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754023AbYADV6R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 16:58:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,247,1196668800"; 
   d="scan'208";a="271619280"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: + restore-missing-sysfs-max_cstate-attr.patch added to -mm tree
Date: Fri, 4 Jan 2008 13:59:01 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE4FCC51@orsmsx423.amr.corp.intel.com>
In-Reply-To: <477EAAB0.1000101@rtr.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: + restore-missing-sysfs-max_cstate-attr.patch added to -mm tree
Thread-Index: AchPHCd8kElkRfddQcaUb+5IcCxKvgAADeaw
References: <20071130142058.816d1693.akpm@linux-foundation.org> <924EFEDD5F540B4284297C4DC59F3DEE2FAEAF@orsmsx423.amr.corp.intel.com> <4750CC78.9070105@rtr.ca> <20071130190227.1976e682@laptopd505.fenrus.org> <4750D180.6080001@rtr.ca> <20071130191816.3e744205@laptopd505.fenrus.org> <4750D585.1030200@rtr.ca> <477C2143.8090406@rtr.ca> <924EFEDD5F540B4284297C4DC59F3DEE4FC485@orsmsx423.amr.corp.intel.com> <477C622F.6010304@rtr.ca> <20080104021619.GA15409@linux-os.sc.intel.com> <477DA529.4000500@rtr.ca> <477EAAB0.1000101@rtr.ca>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Mark Lord" <lkml@rtr.ca>
Cc: "Arjan van de Ven" <arjan@infradead.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, <abelay@novell.com>,
       <lenb@kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
       <rjw@sisk.pl>
X-OriginalArrivalTime: 04 Jan 2008 21:58:16.0009 (UTC) FILETIME=[E8992B90:01C84F1C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>-----Original Message-----
>From: Mark Lord [mailto:lkml@rtr.ca] 
>Sent: Friday, January 04, 2008 1:53 PM
>To: Pallipadi, Venkatesh
>Cc: Arjan van de Ven; Andrew Morton; abelay@novell.com; 
>lenb@kernel.org; Ingo Molnar; linux-kernel@vger.kernel.org; 
>linux-acpi@vger.kernel.org; rjw@sisk.pl
>Subject: Re: + restore-missing-sysfs-max_cstate-attr.patch 
>added to -mm tree
>
>Mark Lord wrote:
>> Venki Pallipadi wrote:
>>> Reintroduce run time configurable max_cstate for !CPU_IDLE case.
>>>
>>> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>>>
>>> Index: linux-2.6.24-rc/drivers/acpi/processor_idle.c
>>> ===================================================================
>>> --- linux-2.6.24-rc.orig/drivers/acpi/processor_idle.c
>>> +++ linux-2.6.24-rc/drivers/acpi/processor_idle.c
>>> @@ -76,7 +76,11 @@ static void (*pm_idle_save) (void) __rea
>>>  #define PM_TIMER_TICKS_TO_US(p)        (((p) * 
>>> 1000)/(PM_TIMER_FREQUENCY/1000))
>>>  
>>>  static unsigned int max_cstate __read_mostly = 
>ACPI_PROCESSOR_MAX_POWER;
>>> +#ifdef CONFIG_CPU_IDLE
>>>  module_param(max_cstate, uint, 0000);
>>> +#else
>>> +module_param(max_cstate, uint, 0644);
>>> +#endif
>>>  static unsigned int nocst __read_mostly;
>>>  module_param(nocst, uint, 0000);
>>>  
>> ..
>> 
>> I'll try and re-test with this on Friday.
>..
>
>Okay, with !CONFIG_CPU_IDLE, this works fine -- same as 2.6.23 
>and earlier.
>

Good to know. Atleast we do not have a regression for 2.6.24 now.

>> Meanwhile, can you give a short summary of how behaviour differs
>> between CONFIG_CPU_IDLE and !CONFIG_CPU_IDLE  ??
>> 
>> I'm not at all clear on how this really affects things.
>

With CPU_IDLE, the C-state policy is removed from acpi driver. Ideally
policy should have nothing to do with ACPI, as ACPI only provides the
C-state mechanisms. So, with CPU_IDLE, it is not easy to control this
variable through a acpi driver module at run time. Also, the latency
interface that was mentioned before is to serve the same purpose in a
more clear manner (based on the wakeup latency) instead of a C-state
number which may not mean much from the end user point of view.

I will look at why latency does not work on a single core system
soon(Was that with UP kernel or SMP kernel?). That way we will have a
proper cover for this with CPU_IDLE in future.

Thanks,
Venki
