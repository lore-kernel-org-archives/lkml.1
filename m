Return-Path: <linux-kernel-owner+w=401wt.eu-S933252AbZLJWyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933252AbZLJWyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 17:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761998AbZLJWyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 17:54:49 -0500
Received: from mga09.intel.com ([134.134.136.24]:41943 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761995AbZLJWyr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 17:54:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,377,1257148800"; 
   d="scan'208";a="474759030"
From: "Moore, Robert" <robert.moore@intel.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>,
       Alexey Starikovskiy <aystarik@gmail.com>
CC: Pavel Machek <pavel@ucw.cz>, Xiaotian Feng <dfeng@redhat.com>,
       "lenb@kernel.org" <lenb@kernel.org>,
       "Lin, Ming M" <ming.m.lin@intel.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 10 Dec 2009 14:54:47 -0800
Subject: RE: [PATCH] ACPICA: don't cond_resched() when irq_disabled or
 in_atomic
Thread-Topic: [PATCH] ACPICA: don't cond_resched() when irq_disabled or
 in_atomic
Thread-Index: Acp56oQpyEGNGISRRbW0IqVLHr5Z9AAATMHA
Message-ID: <4911F71203A09E4D9981D27F9D83085840F38881@orsmsx503.amr.corp.intel.com>
References: <1259900760-6424-1-git-send-email-dfeng@redhat.com>
 <20091210100907.GA2446@ucw.cz> <4B2136D5.1030402@gmail.com>
 <20091210181800.GM19454@elf.ucw.cz> <4B214007.2080409@gmail.com>
 <4B217A2A.2040708@gmail.com>
In-Reply-To: <4B217A2A.2040708@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="koi8-r"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let me know when you guys have finalized any changes to aclinux.h, and I will update this file in the base ACPICA code.

Bob


>-----Original Message-----
>From: Justin P. Mattock [mailto:justinmattock@gmail.com]
>Sent: Thursday, December 10, 2009 2:46 PM
>To: Alexey Starikovskiy
>Cc: Pavel Machek; Xiaotian Feng; lenb@kernel.org; Lin, Ming M; Moore,
>Robert; linux-acpi@vger.kernel.org; linux-kernel@vger.kernel.org
>Subject: Re: [PATCH] ACPICA: don't cond_resched() when irq_disabled or
>in_atomic
>
>On 12/10/09 10:37, Alexey Starikovskiy wrote:
>> Pavel Machek пишет:
>>> On Thu 2009-12-10 20:58:45, Alexey Starikovskiy wrote:
>>>
>>>> Hi Pavel,
>>>>
>>>> Please elaborate... Your comments "ugly as hell" are too often to be
>>>> specific...
>>>> There is only one use of ACPI_PREEMPTION_POINT(), and it is in the
>>>> ACPICA code,
>>>> which we all agreed to keep OS independent, thus the need for #define.
>>>> Do you see any other way to add preemption point without introducing
>>>> Linux-specific
>>>> code into ACPICA?
>>>>
>>>
>>> I believe we want linux-specific code in acpica at this point.
>>>
>>>
>> The point there we call cond_resched() in ACPICA is an interpreter parse
>> loop. This parse loop may be executed from within atomic context and even
>> with interrupts off. In this case, cond_resched() should not be called
>> to not make
>> might_sleep() guards angry.
>>
>> Please post the code, which will do the above and will not look "ugly as
>> hell".
>> I still don't follow your vague comments.
>>> (Or maybe... I guess other systems have concept of preemption and not
>>> all actions are permitted from all contexts, so maybe something like
>>> that would be important for them, too?)
>>>
>> None of them cared about it up to this point.
>> With the macro above we allowed them to follow Linux, but to go or not
>> is their call.
>>
>> Regards,
>> Alex.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
>o.k. I went did a pull to update
>the kernel, and then changed
>aclinux.h to the above post.
>
>I'm am not seeing this warning message
>upon wake-up.
>but with the acpi merge stuff with
>acpi_walk_namespace seems to break nvidia
>(nvidia's problem now)
>
>there is also some thing where the machine
>takes a good 30 secs or so to wake up
>(not sure if this is from the updated patch)
>in dmesg I see:
>
>platform microcode: firmware requesting intel-ucode/06-17-0a
>firmware microcode: parent mocrocode should not be sleeping.
>
>I'm thinking I need something in /lib/firmare
>
>Justin P. Mattock
