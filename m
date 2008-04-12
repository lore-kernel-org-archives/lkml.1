Return-Path: <linux-kernel-owner+w=401wt.eu-S1760957AbYDLLE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760957AbYDLLE1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 07:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757921AbYDLLER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 07:04:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:57093 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756955AbYDLLER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 07:04:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=GhqlzMPhCeq6UKJyjY72axc2v1fl4FIlKuxgE2/1rl284fWNY8lAYdB9H7Jo3CARjJPNtZJCRCGNV5V2iF/YF0aeJtbfld0H9jp+dwYhyt5kGBJrtNcdR4h5jyCw5zzB1fZWo7Zt68daExWqJImbhYomfvzncsr8sFnrCoQjp18=
Message-ID: <48009650.5090306@gmail.com>
Date: Sat, 12 Apr 2008 13:00:32 +0200
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       tglx@linutronix.de
Subject: Re: [PATCH] x86: setup_trampoline() - fix section mismatch warning
References: <47FE6799.9030606@gmail.com> <20080411175006.GA31716@uranus.ravnborg.org>
In-Reply-To: <20080411175006.GA31716@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Sam,

Sam Ravnborg pisze:
[!snip]
>> diff --git a/arch/x86/kernel/trampoline_64.S b/arch/x86/kernel/trampoline_64.S
>> index 4aedd0b..2a07e67 100644
>> --- a/arch/x86/kernel/trampoline_64.S
>> +++ b/arch/x86/kernel/trampoline_64.S
>> @@ -32,7 +32,7 @@
>>  
>>  /* We can free up trampoline after bootup if cpu hotplug is not supported. */
>>  #ifndef CONFIG_HOTPLUG_CPU
>> -.section .init.data, "aw", @progbits
>> +.section .cpuinit.data, "aw", @progbits
>>  #else
>>  .section .rodata, "a", @progbits
>>  #endif
> 
> The correct fix would be to drop the
> preprocessor directves and use __CPUINITDATA

Hmm...IMO this should stay in that form at least now.
I will make some tests with __CPUINITDATA (look into objects, etc.) and later on we can
switch. Is it OK for you?

> 
> Like this: (hand edited):
> 
>> diff --git a/arch/x86/kernel/trampoline_64.S b/arch/x86/kernel/trampoline_64.S
>> index 4aedd0b..2a07e67 100644
>> --- a/arch/x86/kernel/trampoline_64.S
>> +++ b/arch/x86/kernel/trampoline_64.S
>> @@ -32,7 +32,7 @@
>>  
>>  /* We can free up trampoline after bootup if cpu hotplug is not supported. */
>>  #ifndef CONFIG_HOTPLUG_CPU
>> -.section .init.data, "aw", @progbits
>> -#else
>> -.section .rodata, "a", @progbits
>> -#endif
>> +__CPUINITDATA
> 
> If your testing confirms this then please apply similar fix to the _32.S
> version of the file too.

Yep, I'm now working on 32bit stuff.

-Jacek
