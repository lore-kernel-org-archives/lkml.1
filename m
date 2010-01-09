Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161Ab0AID3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab0AID3s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 22:29:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189Ab0AID3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 22:29:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53159 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab0AID3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 22:29:47 -0500
Message-ID: <4B47F60E.3040803@zytor.com>
Date: Fri, 08 Jan 2010 19:20:46 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86, apic: use 0x20 for the IRQ_MOVE_CLEANUP_VECTOR 
 instead of 0x1f
References: <1263002989.2879.664.camel@sbs-t61.sc.intel.com> <86802c441001081907y7d9c2439x2cb15f8bd7ea6709@mail.gmail.com>
In-Reply-To: <86802c441001081907y7d9c2439x2cb15f8bd7ea6709@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2010 07:07 PM, Yinghai Lu wrote:
>> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
>> index d5bfa29..5c090a1 100644
>> --- a/arch/x86/kernel/apic/io_apic.c
>> +++ b/arch/x86/kernel/apic/io_apic.c
>> @@ -1162,8 +1162,8 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
>>         * Also, we've got to be careful not to trash gate
>>         * 0x80, because int 0x80 is hm, kind of importantish. ;)
>>         */
>> -       static int current_vector = FIRST_DEVICE_VECTOR + VECTOR_OFFSET_START;
>> -       static int current_offset = VECTOR_OFFSET_START % 8;
>> +       static int current_vector = FIRST_DEVICE_VECTOR;
>> +       static int current_offset = 0;
>>        unsigned int old_vector;
>>        int cpu, err;
>>        cpumask_var_t tmp_mask;
>>
> 
> looks like it returned to first version i suggested?
> 
> http://lkml.org/lkml/2010/1/4/26
> 
> maybe we can just kill FIRST_DEVICE_VECTOR...
> 

As I already said, I really don't like reverting this bit.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

