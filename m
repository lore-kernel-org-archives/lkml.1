Return-Path: <linux-kernel-owner+w=401wt.eu-S1753077AbZB1Hbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbZB1Hbx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 02:31:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbZB1Hbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 02:31:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:59583 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbZB1Hbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 02:31:44 -0500
Message-ID: <49A8E830.1090202@kernel.org>
Date: Fri, 27 Feb 2009 23:30:56 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: J
References: <1235785882-17580-1-git-send-email-jeremy@goop.org>	 <1235785882-17580-4-git-send-email-jeremy@goop.org> <86802c440902272302n3787b2bex3741b46a372a19b0@mail.gmail.com> <49A8E235.6010900@goop.org>
In-Reply-To: <49A8E235.6010900@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Yinghai Lu wrote:
>> On Fri, Feb 27, 2009 at 5:51 PM, Jeremy Fitzhardinge <jeremy@goop.org>
>> wrote:
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
> What are you asking?  __brk_base is _end rounded up to a page boundary,
> so head_32.S can use it directly for pagetable allocation.  Are you
> flagging the '&' typo?  Something else?

why start don't have &, but end has &

YH
