Return-Path: <linux-kernel-owner+w=401wt.eu-S1752895AbZB1HP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbZB1HP5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 02:15:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbZB1HPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 02:15:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57383 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbZB1HPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 02:15:48 -0500
Date: Sat, 28 Feb 2009 08:15:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: J
Message-ID: <20090228071534.GB9351@elte.hu>
References: <1235785882-17580-1-git-send-email-jeremy@goop.org> <1235785882-17580-4-git-send-email-jeremy@goop.org> <86802c440902272302n3787b2bex3741b46a372a19b0@mail.gmail.com> <49A8E235.6010900@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A8E235.6010900@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Yinghai Lu wrote:
>> On Fri, Feb 27, 2009 at 5:51 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>   
>>> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>>
>>> Rather than having special purpose init_pg_table_start/end variables
>>> to delimit the kernel pagetable built by head_32.S, just use the brk
>>> mechanism to extend the bss for the new pagetable.
>>>
>>> This patch removes init_pg_table_start/end and pg0, defines __brk_base
>>> (which is page-aligned and immediately follows _end), initializes
>>> the brk region to start there, and uses it for the 32-bit pagetable.
>>>     
>> ...
>>
>>   
>>> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
>>> index c246dc4..ed02176 100644
>>> --- a/arch/x86/kernel/setup.c
>>> +++ b/arch/x86/kernel/setup.c
>>> @@ -113,8 +113,10 @@
>>>  #endif
>>>
>>>  unsigned int boot_cpu_id __read_mostly;
>>> -__initdata unsigned long _brk_start = (unsigned long)&_end;
>>> -__initdata unsigned long _brk_end = (unsigned long)&_end;
>>> +
>>> +extern char __brk_base[];
>>> +__initdata unsigned long _brk_start = (unsigned long)__brk_base;
>>> +__initdata unsigned long _brk_end = (unsigned long)&__brk_base;
>>>     
>>
>> ?
>>   
>
> What are you asking?  __brk_base is _end rounded up to a page 
> boundary, so head_32.S can use it directly for pagetable 
> allocation.  Are you flagging the '&' typo?  Something else?

it's not really a typo either (__brk_base and &__brk_base should 
be the same) - just a bit weird looking.

	Ingo
