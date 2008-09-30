Return-Path: <linux-kernel-owner+w=401wt.eu-S1753766AbYI3MyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbYI3MyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 08:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbYI3MyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 08:54:05 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57075 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbYI3MyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 08:54:04 -0400
Message-ID: <48E22165.7040907@canonical.com>
Date: Tue, 30 Sep 2008 08:53:57 -0400
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Reserve FIRST_DEVICE_VECTOR in used_vectors	bitmap.
References: <48E0DA7C.5010403@canonical.com> <20080930095149.GA7557@elte.hu>
In-Reply-To: <20080930095149.GA7557@elte.hu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> Someone from the community found out, that after repeatedly unloading 
>> and loading a device driver that uses MSI IRQs, the system eventually 
>> assigned the vector initially reserved for IRQ0 to the device driver.
> 
>> The reason for this is, that although IRQ0 is tied to the 
>> FIRST_DEVICE_VECTOR when declaring the irq_vector table, the 
>> corresponding bit in the used_vectors map is not set. So, if vectors 
>> are released and assigned often enough, the vector will get assigned 
>> to another interrupt. This happens more often with MSI interrupts as 
>> those are exclusively using a vector.
>>
>> Fix this by setting the bit for the FIRST_DEVICE_VECTOR in the bitmap.
> 
> hi, the IO-APIC code got unified in the x86 tree for v2.6.28.
> 
> So could you please send the fix against tip/master:
> 
>   http://people.redhat.com/mingo/tip.git/README
> 
> Thanks,
> 
> 	Ingo

I can't see this as required for tip. FIRST_DEVICE_VECTOR is there defined
distinct to the ISA IRQs (IRQ15_VECTOR+2) while it is defined to be equal to
IRQ0_VECTOR on 2.6.27 and before (at least down to 2.6.24).

Regards,
Stefan
-- 

When all other means of communication fail, try words!


