Return-Path: <linux-kernel-owner+w=401wt.eu-S1758886AbYEMOjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886AbYEMOjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 10:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760802AbYEMOi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 10:38:59 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:40051 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757461AbYEMOi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 10:38:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=MZs5NM5T8/S5ASNjUor9BNr0RQwiHGGbzhOdM4j+d4XmWq0aFunj2tGBF1uJjLOkRAiLoHzyFpFs/1+RDyzDxMGqkDKssX3mFVyrYYpNozuqp69DQoLfmYD6jSppO2pi+Q5eToyzEC57E3y+lntSkrbXkCP/f5e3C2zAFRPAa9M=
Message-ID: <4829A7FB.5070507@gmail.com>
Date: Tue, 13 May 2008 16:38:51 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: linux-mm@kvack.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       pageexec@freemail.hu, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       herbert@gondor.apana.org.au, penberg@cs.helsinki.fi,
       akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC 1/1] mm: add virt to phys debug
References: <Pine.LNX.4.64.0804281322510.31163@schroedinger.engr.sgi.com> <1209669740-10493-1-git-send-email-jirislaby@gmail.com> <Pine.LNX.4.64.0805011310390.9288@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0805011310390.9288@schroedinger.engr.sgi.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter napsal(a):
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

Hrm, not that easy. I ended up in splitting fixmap_32.h (VMALLOC constants 
depends on it on 32-bit), moving around constants from over all the tree 
(NR_CPUS, FIX_ACPI_PAGES...) to not include files which would create loops, 
but still not having e.g. PMD_MASK available on all configurations. I think 
it's not worth it. Objections to merging the patch as was 
(http://lkml.org/lkml/2008/5/1/300)?

Thanks.
