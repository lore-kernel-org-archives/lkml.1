Return-Path: <linux-kernel-owner+w=401wt.eu-S1759854AbYAJTYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759854AbYAJTYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbYAJTYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:24:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbYAJTYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:24:08 -0500
Message-ID: <478670BA.6010600@redhat.com>
Date: Thu, 10 Jan 2008 14:23:38 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: Fix x86 32 bit FRAME_POINTER chasing code
References: <20080109220421.630d3516@laptopd505.fenrus.org> <20080110065438.GA23022@elte.hu>
In-Reply-To: <20080110065438.GA23022@elte.hu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2008 01:54 AM, Ingo Molnar wrote:
> * Arjan van de Ven <arjan@infradead.org> wrote:
> 
>> +++ linux-2.6.24-rc7/arch/x86/kernel/traps_32.c
>> @@ -124,7 +124,8 @@ static inline unsigned long print_contex
>>  		unsigned long addr;
>>  
>>  		addr = frame->return_address;
>> -		ops->address(data, addr);
>> +		if (__kernel_text_address(addr))
>> +			ops->address(data, addr);
>>  		/*
>>  		 * break out of recursive entries (such as
>>  		 * end_of_stack_stop_unwind_function). Also,
>> @@ -132,6 +133,7 @@ static inline unsigned long print_contex
>>  		 * move downwards!
>>  		 */
>>  		next = frame->next_frame;
>> +		ebp = (unsigned long) next;
>>  		if (next <= frame)
> 
> thanks, applied. Nice catch!
> 
>> This patch is simple; I don't know if it's .24 candidate; the bug is 
>> pretty bad but not a recent regression, and there is obviously some 
>> risk with touching this code.
> 
> it's a 2.6.24.1 candidate i believe. We trigger plenty of various 
> crashes during x86.git maintenance and others hit various crashes in 
> -mm, so by the time .1 is released we'll have it in .25 and can backport 
> it. Most folks/distros will update to 2.6.24.1 very quickly so there's 
> no risk of months loss of quality to kerneloops.org data either.
> 

Using the same logic, why not put it in 2.6.24 and then remove it in 2.6.24.1
if it's broken?
