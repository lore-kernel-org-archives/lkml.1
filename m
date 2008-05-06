Return-Path: <linux-kernel-owner+w=401wt.eu-S1757046AbYEFVzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046AbYEFVzO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 17:55:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbYEFVy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 17:54:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:2023 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbYEFVyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 17:54:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=B+tjWnrcFSG1TTntUfe0B1OvpuWp/ozEb8lhmKptTnItQQnIxmryms05x6WvUbs4VQy2Hvvn3j7ctK2PS4Tp6AuvAfT1qqqxPZZx5RKGZpmwh49B0eM6q0jv8P7swQeei3GOD5wj5eZMrYo4NfAM8NwMDAS5FdXpccYEsvYd0W8=
Message-ID: <4820D39E.3090109@gmail.com>
Date: Tue, 06 May 2008 23:54:38 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: linux-mm@kvack.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       pageexec@freemail.hu, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       herbert@gondor.apana.org.au, penberg@cs.helsinki.fi,
       akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, rjw@sisk.pl, zdenek.kabelac@gmail.com,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC 1/1] mm: add virt to phys debug
References: <Pine.LNX.4.64.0804281322510.31163@schroedinger.engr.sgi.com> <1209669740-10493-1-git-send-email-jirislaby@gmail.com> <Pine.LNX.4.64.0805011310390.9288@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0805011310390.9288@schroedinger.engr.sgi.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2008 10:18 PM, Christoph Lameter wrote:
> On Thu, 1 May 2008, Jiri Slaby wrote:
>> Add some (configurable) expensive sanity checking to catch wrong address
>> translations on x86.
>>
>> - create linux/mmdebug.h file to be able include this file in
>>   asm headers to not get unsolvable loops in header files
>> - __phys_addr on x86_32 became a function in ioremap.c since
>>   PAGE_OFFSET and is_vmalloc_addr is undefined if declared in
>>   page_32.h (again circular dependencies)
>> - add __phys_addr_const for initializing doublefault_tss.__cr3
> 
> Hmmm.. We could use include/linux/bounds.h to make 
> VMALLOC_START/VMALLOC_END (or whatever you need for checking the memory 
> boundaries) a cpp constant which may allow the use in page_32.h without 
> circular dependencies.

I like the idea, I'll get back with a patch in few days (sorry, too busy). 
Anyway bounds.h should be include/asm/ thing though.
