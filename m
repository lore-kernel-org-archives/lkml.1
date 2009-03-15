Return-Path: <linux-kernel-owner+w=401wt.eu-S1758919AbZCOGVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919AbZCOGVd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 02:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbZCOGVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 02:21:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:38922 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbZCOGVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 02:21:23 -0400
Message-ID: <49BC9E14.4000005@kernel.org>
Date: Sat, 14 Mar 2009 23:20:04 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/mm] x86: make e820_update_range() handle small range
 update
References: <49B9F0C1.10402@kernel.org> <tip-78a8b35bc7abf8b8333d6f625e08c0f7cc1c3742@git.kernel.org> <20090314121705.GA13685@elte.hu> <49BBF59D.7060401@kernel.org> <20090314184010.GA17695@elte.hu> <49BC2279.2030101@kernel.org> <20090315060456.GF20949@elte.hu>
In-Reply-To: <20090315060456.GF20949@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> Ingo Molnar wrote:
>>> * Yinghai Lu <yinghai@kernel.org> wrote:
>>>
>>>> Ingo Molnar wrote:
>>>>> * Yinghai Lu <yinghai@kernel.org> wrote:
>>>>>
>>>>>> Commit-ID:  78a8b35bc7abf8b8333d6f625e08c0f7cc1c3742
>>>>>> Gitweb:     http://git.kernel.org/tip/78a8b35bc7abf8b8333d6f625e08c0f7cc1c3742
>>>>>> Author:     Yinghai Lu <yinghai@kernel.org>
>>>>>> AuthorDate: Thu, 12 Mar 2009 22:36:01 -0700
>>>>>> Commit:     Ingo Molnar <mingo@elte.hu>
>>>>>> CommitDate: Sat, 14 Mar 2009 12:20:07 +0100
>>>>>>
>>>>>> x86: make e820_update_range() handle small range update
>>>>>>
>>>>>> Impact: enhance e820 code to handle more cases
>>>>>>
>>>>>> Try to handle new range which could be covered by one entry.
>>>>>>
>>>>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>>>>> Cc: jbeulich@novell.com
>>>>>> LKML-Reference: <49B9F0C1.10402@kernel.org>
>>>>>> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>>>> -tip testing found a bootup crash + reboot due to this patch.
>>>>>
>>>>> config attached. The bootup crashes here:
>>>>>
>>>>> [    0.000000] MTRR variable ranges enabled:
>>>>> [    0.000000]   0 base 0000000000 mask FFC0000000 write-back
>>>>> [    0.000000]   1 disabled
>>>>> [    0.000000]   2 disabled
>>>>> [    0.000000]   3 disabled
>>>>> [    0.000000]   4 disabled
>>>>> [    0.000000]   5 disabled
>>>>> [    0.000000]   6 disabled
>>>>> [    0.000000]   7 disabled
>>>>> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
>>>>> [    0.000000]   get_mtrr: cpu0 reg00 base=0000000000 size=0000040000 write-back
>>>>> [    reboot  ]
>>>>>
>>>> what does the e820 map look like?
>>> [    0.000000] BIOS-provided physical RAM map:
>>> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
>>> [    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
>>> [    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
>>> [    0.000000]  BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
>>> [    0.000000]  BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
>>> [    0.000000]  BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
>>> [    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
>>> [    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
>>>
>> it seems that patch revealed the bug in 
>> setup_bios_corruption_check
> 
> Cool. I'm wondering, could this explain:
> 
>    http://bugzilla.kernel.org/show_bug.cgi?id=12645
> 

i wonder if we need to add print out about range from e820_update_range() 
or add sth like boundary checking in e820_update_range() to stop crazy calling?

YH
