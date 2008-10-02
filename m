Return-Path: <linux-kernel-owner+w=401wt.eu-S1754174AbYJBMO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbYJBMO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 08:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbYJBMOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 08:14:48 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:13626 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078AbYJBMOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 08:14:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=UaVOSilpblS98zs6/QV2SAWCtYQuu+9Cq/3/L7qOFaIljb/Mccxc5WLZUXzKPagwx4
         lGP2DDMU4CSiRPjz/gSNp4pQXCnoi4SaNGBbh2t+TkCLXA5VEx8LBD/tHhM+196ztGOa
         Hwu7gA8kaRi5U5Rl8G9kueL54fezG8OkHvjNY=
Message-ID: <5201e28f0810020514g606e3ddbr26c2ed86693ced42@mail.gmail.com>
Date: Thu, 2 Oct 2008 08:14:46 -0400
From: "Stefan Bader" <stefan.bader@canonical.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: Reserve FIRST_DEVICE_VECTOR in used_vectors bitmap.
Cc: linux-kernel@vger.kernel.org, "Yinghai Lu" <yinghai@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <48E22165.7040907@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48E0DA7C.5010403@canonical.com> <20080930095149.GA7557@elte.hu>
	 <48E22165.7040907@canonical.com>
X-Google-Sender-Auth: fed32e6363b54bcc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/30 Stefan Bader <stefan.bader@canonical.com>:
> Ingo Molnar wrote:
>>> Someone from the community found out, that after repeatedly unloading
>>> and loading a device driver that uses MSI IRQs, the system eventually
>>> assigned the vector initially reserved for IRQ0 to the device driver.
>>
>>> The reason for this is, that although IRQ0 is tied to the
>>> FIRST_DEVICE_VECTOR when declaring the irq_vector table, the
>>> corresponding bit in the used_vectors map is not set. So, if vectors
>>> are released and assigned often enough, the vector will get assigned
>>> to another interrupt. This happens more often with MSI interrupts as
>>> those are exclusively using a vector.
>>>
>>> Fix this by setting the bit for the FIRST_DEVICE_VECTOR in the bitmap.
>>
>> hi, the IO-APIC code got unified in the x86 tree for v2.6.28.
>>
>> So could you please send the fix against tip/master:
>>
>>   http://people.redhat.com/mingo/tip.git/README
>>
>> Thanks,
>>
>>       Ingo
>
> I can't see this as required for tip. FIRST_DEVICE_VECTOR is there defined
> distinct to the ISA IRQs (IRQ15_VECTOR+2) while it is defined to be equal to
> IRQ0_VECTOR on 2.6.27 and before (at least down to 2.6.24).
>

Hi Ingo,

I didn't see any follow up, so for clarification: there is nothing to
fix in tip but the bug is there in kernels between 2.6.24 and 2.6.27.
Could you push it to 2.6.27 and possibly to the stable trees?

Stefan
