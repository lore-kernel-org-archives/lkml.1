Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbZIKP4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbZIKP4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 11:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbZIKP4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 11:56:23 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:13336 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbZIKP4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 11:56:23 -0400
Message-ID: <4AAA72F3.9090103@caviumnetworks.com>
Date: Fri, 11 Sep 2009 08:55:31 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 02/10] x86: Convert BUG() to use unreachable()
References: <4AA991C1.1050800@caviumnetworks.com> <1252627011-2933-2-git-send-email-ddaney@caviumnetworks.com> <4AA9A031.5000602@zytor.com> <alpine.LFD.2.01.0909101806110.3654@localhost.localdomain> <20090911060701.GA18740@elte.hu>
In-Reply-To: <20090911060701.GA18740@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Sep 2009 15:55:32.0921 (UTC) FILETIME=[4B3F7A90:01CA32F8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>> On Thu, 10 Sep 2009, H. Peter Anvin wrote:
>>
>>> On 09/10/2009 04:56 PM, David Daney wrote:
>>>> Use the new unreachable() macro instead of for(;;);.  When
>>>> allyesconfig is built with a GCC-4.5 snapshot on i686 the size of the
>>>> text segment is reduced by 3987 bytes (from 6827019 to 6823032).
>>>>
>>>> Signed-off-by: David Daney <ddaney@caviumnetworks.com>
>>>> CC: Thomas Gleixner <tglx@linutronix.de>
>>>> CC: Ingo Molnar <mingo@redhat.com>
>>>> CC: "H. Peter Anvin" <hpa@zytor.com>
>>>> CC: x86@kernel.org
>>> Acked-by: H. Peter Anvin <hpa@zytor.com>
>>>
>>> ... although of course this clashes with Roland McGrath's 
>>> patchset for the same thing which I applied earlier.  I have to 
>>> say I like unreachable() in lower case better though...
>> I like David's version a bit better, since it takes care of more 
>> architectures, and also because it avoids that butt-ugly special 
>> case for gcc-4.4.1-RH-relase-10 backporting this feature.
>>
>> I realize that the RH backport thing is good for testing now, but 
>> at the same time, it really does look nasty. I wonder if we could 
>> add some config-time compiler feature testing - so that you'd not 
>> have a version test at all, but a CONFIG_BUILTIN_UNREACHABLE.
>>
>> There are other cases where that kind of config-time testing could 
>> be useful, and we could avoid doing various gcc checks dynamically 
>> from within 'make' (along with checking for known-buggy versions 
>> etc).
>>
>> And yeah, it looks better in lower case. That said, I don't care 
>> _that_ much, and people can fight it out.
> 
> Another detail that would be nice to be fixed is to propagate the 
> unreachable() call into the !CONFIG_BUG case as well in 
> asm-generic/bug.h.
> 

Perhaps, although with a pre-GCC-4.5 compiler, it would end up adding 
the endless loop code to BUG() sites for configurations where the user 
has explicitly stated their preference for the code to be as small as 
possible (by turning off CONFIG_BUG).

If that is acceptable, I will prepare another revision of the patch set.

Thanks,
David Daney


> That would kill dozens of !CONFIG_BUG compiler warnings and would 
> make a dont-allow-warnings policy a possibility for random builds.
> 
> 	Ingo

