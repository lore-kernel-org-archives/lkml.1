Return-Path: <linux-kernel-owner+w=401wt.eu-S1762037AbZLJWpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762037AbZLJWpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 17:45:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762021AbZLJWpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 17:45:42 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:63012 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456AbZLJWpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 17:45:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kUBy7K/zWewTKm1A075DUYfRkW+txUKNDQ/Dr7gT2O5zLINwc8GvOY0wmX0hy7hWJi
         i3tEzvKvk2OBcwb9H7ziZreT18uAwL7T9svSJMtTU39TRDXTJfoGNwkJeZxOJHN8v8u3
         N/QCxfaA/5KAKQdwZhr4aUBrT7PboOwKiP5FU=
Message-ID: <4B217A2A.2040708@gmail.com>
Date: Thu, 10 Dec 2009 14:46:02 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Alexey Starikovskiy <aystarik@gmail.com>
CC: Pavel Machek <pavel@ucw.cz>, Xiaotian Feng <dfeng@redhat.com>,
       lenb@kernel.org, ming.m.lin@intel.com, robert.moore@intel.com,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPICA: don't cond_resched() when irq_disabled or in_atomic
References: <1259900760-6424-1-git-send-email-dfeng@redhat.com> <20091210100907.GA2446@ucw.cz> <4B2136D5.1030402@gmail.com> <20091210181800.GM19454@elf.ucw.cz> <4B214007.2080409@gmail.com>
In-Reply-To: <4B214007.2080409@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/09 10:37, Alexey Starikovskiy wrote:
> Pavel Machek пишет:
>> On Thu 2009-12-10 20:58:45, Alexey Starikovskiy wrote:
>>
>>> Hi Pavel,
>>>
>>> Please elaborate... Your comments "ugly as hell" are too often to be
>>> specific...
>>> There is only one use of ACPI_PREEMPTION_POINT(), and it is in the
>>> ACPICA code,
>>> which we all agreed to keep OS independent, thus the need for #define.
>>> Do you see any other way to add preemption point without introducing
>>> Linux-specific
>>> code into ACPICA?
>>>
>>
>> I believe we want linux-specific code in acpica at this point.
>>
>>
> The point there we call cond_resched() in ACPICA is an interpreter parse
> loop. This parse loop may be executed from within atomic context and even
> with interrupts off. In this case, cond_resched() should not be called
> to not make
> might_sleep() guards angry.
>
> Please post the code, which will do the above and will not look "ugly as
> hell".
> I still don't follow your vague comments.
>> (Or maybe... I guess other systems have concept of preemption and not
>> all actions are permitted from all contexts, so maybe something like
>> that would be important for them, too?)
>>
> None of them cared about it up to this point.
> With the macro above we allowed them to follow Linux, but to go or not
> is their call.
>
> Regards,
> Alex.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

o.k. I went did a pull to update
the kernel, and then changed
aclinux.h to the above post.

I'm am not seeing this warning message
upon wake-up.
but with the acpi merge stuff with
acpi_walk_namespace seems to break nvidia
(nvidia's problem now)

there is also some thing where the machine
takes a good 30 secs or so to wake up
(not sure if this is from the updated patch)
in dmesg I see:

platform microcode: firmware requesting intel-ucode/06-17-0a
firmware microcode: parent mocrocode should not be sleeping.

I'm thinking I need something in /lib/firmare

Justin P. Mattock
