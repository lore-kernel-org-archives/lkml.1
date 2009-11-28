Return-Path: <linux-kernel-owner+w=401wt.eu-S1752618AbZK1SKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbZK1SKS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 13:10:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbZK1SKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 13:10:17 -0500
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197]:49827 "EHLO
	mta2.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbZK1SKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 13:10:16 -0500
Date: Sat, 28 Nov 2009 13:10:21 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Re: Problem? intel_iommu=off; perf top shows acpi_os_read_port as
 extremely busy
In-reply-to: <20091128094530.0ede7b1a@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel@vger.kernel.org
Message-id: <4B11678D.8020601@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4B106CC0.4050406@majjas.com> <20091128071808.GA32183@elte.hu>
 <20091128094530.0ede7b1a@infradead.org>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok - my only question then is why things appear so different with 
intel_iommu enabled.
Arjan van de Ven wrote:
> On Sat, 28 Nov 2009 08:18:08 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
>
>   
>> * Michael Breuer <mbreuer@majjas.com> wrote:
>>
>>     
>>> Having given up for now on VT-D, I rebooted 2.6.38 rc8 with 
>>> intel_iommu=off. Whilst my myriad of broken bios issues cleared, I
>>> now see in perf top acpi_os_read_port as continually the busiest
>>> function. With intel_iommu enabled, _spin_lock was always on top,
>>> and nothing else was notable.
>>>
>>> This seems odd to me, perhaps this will make sense to someone else.
>>>
>>> FWIW, I'm running on an Asus p6t deluxe v2; ht enabled; no errors
>>> or oddities in dmesg or /var/log/messages.
>>>       
>> Could you post the perf top output please?
>>
>> Also, could you also post the output of:
>>
>> 	perf stat -a --repeat 10 sleep 1
>>
>> this will show us how idle the system is. (My guess is that your
>> system is idle and perf top shows acpi_os_read_port because the
>> system goes to idle via ACPI methods and PIO is slow. In that case
>> all is nominal and your system is fine. But it's hard to tell without
>> more details.)
>>
>>     
>
> yeah the os_read_port is part of the idle loop, so if your system is
> idle it'll show up big.... not much we can optimize there though...
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   

