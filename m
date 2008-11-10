Return-Path: <linux-kernel-owner+w=401wt.eu-S1754122AbYKJPu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbYKJPu0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 10:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbYKJPuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 10:50:16 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:37776 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbYKJPuP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 10:50:15 -0500
Message-ID: <49185828.4090306@cosmosbay.com>
Date: Mon, 10 Nov 2008 16:50:00 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] oprofile: re-arm APIC_DM_NMI in ppro_check_ctrs()
References: <20081107171339.GQ9785@erda.amd.com> <4917EB51.9020304@cosmosbay.com> <87ljvsott2.fsf@basil.nowhere.org> <491843C4.9090306@cosmosbay.com> <20081110154948.GW29626@one.firstfloor.org>
In-Reply-To: <20081110154948.GW29626@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 10 Nov 2008 16:50:00 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen a écrit :
>>  			oprofile_add_sample(regs, i);
>> +			/*
>> +			 * We need to unmask the apic vector *before*
>> +			 * writing reset_value to msr counter
>> +			 */
>> +			apic_write(APIC_LVTPC, APIC_DM_NMI);
>>  			wrmsrl(msrs->counters[i].addr, -reset_value[i]);
>>  		}
>>  	}
>>  
>> -	/* Only P6 based Pentium M need to re-unmask the apic vector but it
>> -	 * doesn't hurt other P6 variant */
>> -	apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
> 
> Did you also test if it really needs to be inside the if () or 
> just before the wrmsrl? 


In my testings, the "if (CTR_OVERFLOWED())" condition is always true.

(I am profiling one event only)

I felt uncomfortable issuing the apic_write() before oprofile_add_sample()

Do you mean doing the apic_write() right at the beginning of the ppro_check_ctrs()
function ?

