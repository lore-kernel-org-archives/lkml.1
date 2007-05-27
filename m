Return-Path: <linux-kernel-owner+w=401wt.eu-S1759153AbXE0VKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759153AbXE0VKq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 17:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbXE0VKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 17:10:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:52153 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbXE0VKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 17:10:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=KSxU+SHmR4tpo09A3zaeMH9uiovuq1NW3MSZVJoKm8vH2N0zIWZUU02xuLPOwVxMpvamHAnJIZEDATAfJZVqNvQl4ftu+03yuXnhEK6Ej97noU8Kjq2mfloNwau32ul/ZgmJLN88NVXZ8X5NtX6mdZBu5Hvtys28mJu5tV/K+QY=
Message-ID: <4659F3C8.8080606@gmail.gom>
Date: Sun, 27 May 2007 22:10:32 +0100
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Randy Dunlap <rdunlap@xenotime.net>, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Richard Hughes <hughsient@gmail.com>,
       Julian Sikorski <belegdol@gmail.com>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH} x86_64 PM_TRACE support.
References: <1180161174.9773.60.camel@nigel.suspend2.net> <20070527203955.GE3989@ucw.cz>
In-Reply-To: <20070527203955.GE3989@ucw.cz>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Julian Sikorski <belegdol@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek pisze:
> Hi!
> 
>> As promised I took another look at the patch and at what Randy had
>> prepared to fix the IA64 compilation error. I did some more work on it,
>> and believe that the following is the tidiest correct solution I can
>> come up with. It differs from the version that caused the compilation
>> error primarily in that:
>>
>> * the #include <asm/resume-trace.h> is inside the #ifdef 
>>   CONFIG_PM_TRACE.
>> * now-unnecessary protection for multiple #includes and ifdef testing of
>>   CONFIG_PM_TRACE in the asm code were removed.
>> * do-nothing definitions for !PM_TRACE restored to
>>   include/linux/resume-trace.h.
>>
>> We're therefore depending upon kernel/power/Kconfig having the right
>> depends condition. As far as I can see, IA64 doesn't define CONFIG_X86.
>> Is that correct, or do we need to have (X86 && !IA64)?
> 
> ia64? did you mean x86-64?
> 
> Otherwise looks ok to me.
> 
IIRC enabling pm_trace on x86_64 was breaking compilation on ia64, so I
think Nigel meant the latter.
