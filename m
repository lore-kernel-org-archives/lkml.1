Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbYKKGez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbYKKGez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 01:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbYKKGep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 01:34:45 -0500
Received: from ms0.nttdata.co.jp ([163.135.193.231]:37401 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbYKKGeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 01:34:44 -0500
Message-ID: <4919277F.9050206@nttdata.co.jp>
Date: Tue, 11 Nov 2008 15:34:39 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.8.1.17) Gecko/20080914 Thunderbird/2.0.0.17 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: haradats@nttdata.co.jp, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp
Subject: Re: [TOMOYO #12 (2.6.28-rc2-mm1) 05/11] Memory and pathname management
 functions.
References: <20081104060847.086543472@nttdata.co.jp>	<20081104060949.942652091@nttdata.co.jp>	<20081105151217.4e8d11a9.akpm@linux-foundation.org>	<49180E29.2060004@nttdata.co.jp> <20081110210405.d43458f3.akpm@linux-foundation.org>
In-Reply-To: <20081110210405.d43458f3.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Nov 2008 06:34:40.0407 (UTC) FILETIME=[93355A70:01C943C7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>>> Note that I said "kmalloc", not "kzalloc".  This function zeroes
>>> everything all the time, and surely that is not necessary.  It's just a
>>> waste of CPU time.
>>>
>> Callers of tmy_alloc assume that allocated memory is zeroed.
> 
> That isn't the point.  For programmer convenience we could make
> __alloc_pages() and kmalloc() zero all the memory too.  But we don't
> because it is slow.
Are you saying "make the callers of tmy_alloc() tolerable with
uninitialized memory"?

>>>> +/**
>>>> + * tmy_read_memory_counter - Check for memory usage.
>>>> + *
>>>> + * @head: Pointer to "struct tmy_io_buffer".
>>>> + *
>>>> + * Returns memory usage.
>>> In what units?  Megabytes?
>>>
>> In bytes.
> 
> Let me rephrase:
> 
> The comment over tmy_read_memory_counter() fails to tell the reader
> what units are used for the return value.  It should do so.
I see. Replaced "Check for memory usage." by "Check for memory usage in bytes".
Thanks.

>> Creating pseudo files for each variables is fine, though I don't see
>> advantage by changing from
>> "echo Shared: 16777216 > /sys/kernel/security/tomoyo/meminfo" to
>> "echo 16777216 > /sys/kernel/security/tomoyo/quota/shared_memory".
> 
> Well for starters, the existing interface is ugly as sin and will make
> kernel developers unhappy.
> 
> There is a pretty strict one-value-per-file rule in sysfs files, and
> "multiple tagged values in one file" violates that a lot.
/sys/kernel/security/ is not sysfs but securityfs.
Does "one-value-per-file rule" also apply to securityfs?

Regards,


