Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbYFRNmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbYFRNmH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 09:42:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbYFRNl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 09:41:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:37812 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbYFRNl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 09:41:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=AenvvR3J0WmaOZcQuxMtLcwowuO998OvAXmgNcl/jwKBlMWQId0EDORz8b02KeCs5f
         V0NIJC2EFFal8zDMnqiJXGjhL7NaPCLcn6GdmfX0pjz9d7EqEnaE5+m6BRqNg1EnKymP
         r942jgpThjIBF25M5hahQ0IZot1dHi/cnH75k=
Message-ID: <485910A0.1060007@gmail.com>
Date: Wed, 18 Jun 2008 15:41:52 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Ingo Molnar <mingo@redhat.com>, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/1] MM: virtual address debug
References: <1213271800-1556-1-git-send-email-jirislaby@gmail.com> <200806182251.02486.nickpiggin@yahoo.com.au>
In-Reply-To: <200806182251.02486.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin napsal(a):
> On Thursday 12 June 2008 21:56, Jiri Slaby wrote:
>> Add some (configurable) expensive sanity checking to catch wrong address
>> translations on x86.
>>
>> - create linux/mmdebug.h file to be able include this file in
>>   asm headers to not get unsolvable loops in header files
>> - __phys_addr on x86_32 became a function in ioremap.c since
>>   PAGE_OFFSET, is_vmalloc_addr and VMALLOC_* non-constasts are undefined
>>   if declared in page_32.h
> 
> Uh, I have to disagree with this. __phys_addr is used in some really
> performance critical parts of the kernel, and the function calls are
> free mindset is just wrong. Even for modern x86 CPUs, the function
> call return might take 10 cycles or more when you include all costs.
> 
> And for something like this
> 
> #define __phys_addr(x)         ((x) - PAGE_OFFSET)
> 
> the code to call the function is probably bigger than inline generated
> code anyway.

Thanks for comments, well, are you OK with __phys_addr being a function only 
on CONFIG_VIRTUAL_DEBUG?
