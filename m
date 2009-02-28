Return-Path: <linux-kernel-owner+w=401wt.eu-S1752834AbZB1HFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbZB1HFg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 02:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbZB1HF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 02:05:29 -0500
Received: from gw.goop.org ([64.81.55.164]:34777 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbZB1HF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 02:05:28 -0500
Message-ID: <49A8E235.6010900@goop.org>
Date: Fri, 27 Feb 2009 23:05:25 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: J
References: <1235785882-17580-1-git-send-email-jeremy@goop.org>	 <1235785882-17580-4-git-send-email-jeremy@goop.org> <86802c440902272302n3787b2bex3741b46a372a19b0@mail.gmail.com>
In-Reply-To: <86802c440902272302n3787b2bex3741b46a372a19b0@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Fri, Feb 27, 2009 at 5:51 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>   
>> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>
>> Rather than having special purpose init_pg_table_start/end variables
>> to delimit the kernel pagetable built by head_32.S, just use the brk
>> mechanism to extend the bss for the new pagetable.
>>
>> This patch removes init_pg_table_start/end and pg0, defines __brk_base
>> (which is page-aligned and immediately follows _end), initializes
>> the brk region to start there, and uses it for the 32-bit pagetable.
>>     
> ...
>
>   
>> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
>> index c246dc4..ed02176 100644
>> --- a/arch/x86/kernel/setup.c
>> +++ b/arch/x86/kernel/setup.c
>> @@ -113,8 +113,10 @@
>>  #endif
>>
>>  unsigned int boot_cpu_id __read_mostly;
>> -__initdata unsigned long _brk_start = (unsigned long)&_end;
>> -__initdata unsigned long _brk_end = (unsigned long)&_end;
>> +
>> +extern char __brk_base[];
>> +__initdata unsigned long _brk_start = (unsigned long)__brk_base;
>> +__initdata unsigned long _brk_end = (unsigned long)&__brk_base;
>>     
>
> ?
>   

What are you asking?  __brk_base is _end rounded up to a page boundary, 
so head_32.S can use it directly for pagetable allocation.  Are you 
flagging the '&' typo?  Something else?

    J
