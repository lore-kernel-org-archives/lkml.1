Return-Path: <linux-kernel-owner+w=401wt.eu-S1754952AbYADVw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952AbYADVw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 16:52:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753297AbYADVwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 16:52:51 -0500
Received: from rtr.ca ([76.10.145.34]:3117 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230AbYADVwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 16:52:50 -0500
Message-ID: <477EAAB0.1000101@rtr.ca>
Date: Fri, 04 Jan 2008 16:52:48 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, abelay@novell.com,
       lenb@kernel.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, rjw@sisk.pl
Subject: Re: + restore-missing-sysfs-max_cstate-attr.patch added to -mm tree
References: <20071130142058.816d1693.akpm@linux-foundation.org> <924EFEDD5F540B4284297C4DC59F3DEE2FAEAF@orsmsx423.amr.corp.intel.com> <4750CC78.9070105@rtr.ca> <20071130190227.1976e682@laptopd505.fenrus.org> <4750D180.6080001@rtr.ca> <20071130191816.3e744205@laptopd505.fenrus.org> <4750D585.1030200@rtr.ca> <477C2143.8090406@rtr.ca> <924EFEDD5F540B4284297C4DC59F3DEE4FC485@orsmsx423.amr.corp.intel.com> <477C622F.6010304@rtr.ca> <20080104021619.GA15409@linux-os.sc.intel.com> <477DA529.4000500@rtr.ca>
In-Reply-To: <477DA529.4000500@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Venki Pallipadi wrote:
>> Reintroduce run time configurable max_cstate for !CPU_IDLE case.
>>
>> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>>
>> Index: linux-2.6.24-rc/drivers/acpi/processor_idle.c
>> ===================================================================
>> --- linux-2.6.24-rc.orig/drivers/acpi/processor_idle.c
>> +++ linux-2.6.24-rc/drivers/acpi/processor_idle.c
>> @@ -76,7 +76,11 @@ static void (*pm_idle_save) (void) __rea
>>  #define PM_TIMER_TICKS_TO_US(p)        (((p) * 
>> 1000)/(PM_TIMER_FREQUENCY/1000))
>>  
>>  static unsigned int max_cstate __read_mostly = ACPI_PROCESSOR_MAX_POWER;
>> +#ifdef CONFIG_CPU_IDLE
>>  module_param(max_cstate, uint, 0000);
>> +#else
>> +module_param(max_cstate, uint, 0644);
>> +#endif
>>  static unsigned int nocst __read_mostly;
>>  module_param(nocst, uint, 0000);
>>  
> ..
> 
> I'll try and re-test with this on Friday.
..

Okay, with !CONFIG_CPU_IDLE, this works fine -- same as 2.6.23 and earlier.

> Meanwhile, can you give a short summary of how behaviour differs
> between CONFIG_CPU_IDLE and !CONFIG_CPU_IDLE  ??
> 
> I'm not at all clear on how this really affects things.

???
