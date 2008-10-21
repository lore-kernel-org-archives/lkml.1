Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910AbYJUKab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbYJUKab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 06:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbYJUKaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 06:30:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58111 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbYJUKaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 06:30:22 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       David Howells <dhowells@redhat.com>
Subject: Re: [announce] new tree: "fix all build warnings, on all configs" II
From: Andi Kleen <andi@firstfloor.org>
References: <20081017171139.GA1792@elte.hu> <87r66ejqla.fsf@basil.nowhere.org>
Date: Tue, 21 Oct 2008 12:30:22 +0200
In-Reply-To: <87r66ejqla.fsf@basil.nowhere.org> (Andi Kleen's message of "Sat, 18 Oct 2008 09:43:29 +0200")
Message-ID: <87zlkydyv5.fsf_-_@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:
>>  		if (battery->have_sysfs_alarm)
>> diff --git a/drivers/acpi/sleep/main.c b/drivers/acpi/sleep/main.c
>> index d13194a..2276d75 100644
>> --- a/drivers/acpi/sleep/main.c
>> +++ b/drivers/acpi/sleep/main.c
>> @@ -63,7 +63,7 @@ void __init acpi_old_suspend_ordering(void)
>>  /**
>>   *	acpi_pm_disable_gpes - Disable the GPEs.
>>   */
>> -static int acpi_pm_disable_gpes(void)
>> +static inline int acpi_pm_disable_gpes(void)
>
> Just to satisfy my curiosity, what compiler warning does marking functions inline 
> fix?

No reply. 

General note: ignoring review comments does not make the problems go away.

The reason I asked is that the patch is very likely wrong.

AFAIK the only warning that can be fixed by this inline would
be a linker section mismatch (that is why I asked).

But for linker section mismatch this is not the correct
change:

- inline is only advisory and gcc is free to disregard it.
So you could get the warning back any time.
- If you really want inlining for correctness you need
to use __always_inline
- Or if it's really to satisfy a linker section mismatch 
it's typically better to just declare all inlined functions
in the correct section, e.g. __init

Please fix this properly.

Thanks,
-Andi

-- 
ak@linux.intel.com
