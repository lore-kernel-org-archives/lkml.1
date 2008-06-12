Return-Path: <linux-kernel-owner+w=401wt.eu-S1758052AbYFLJM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052AbYFLJM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 05:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797AbYFLJMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 05:12:21 -0400
Received: from as1.cineca.com ([130.186.84.213]:35069 "EHLO as1.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145AbYFLJMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 05:12:20 -0400
Message-ID: <4850E866.9030609@gmail.com>
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.12) Gecko/20070604 Thunderbird/1.5.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: balbir@linux.vnet.ibm.com, linux-mm@kvack.org, skumar@linux.vnet.ibm.com,
       yamamoto@valinux.co.jp, menage@google.com, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, xemul@openvz.org,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [-mm][PATCH 2/4] Setup the memrlimit controller (v5)
References: <20080521152921.15001.65968.sendpatchset@localhost.localdomain>	<20080521152948.15001.39361.sendpatchset@localhost.localdomain>	<4850070F.6060305@gmail.com>	<20080611121510.d91841a3.akpm@linux-foundation.org>	<485032C8.4010001@gmail.com>	<20080611134323.936063d3.akpm@linux-foundation.org>	<485055FF.9020500@gmail.com>	<20080611155530.099a54d6.akpm@linux-foundation.org>	<4850BE9B.5030504@linux.vnet.ibm.com>	<4850E3BC.308@gmail.com> <20080612020235.29a81d7c.akpm@linux-foundation.org>
In-Reply-To: <20080612020235.29a81d7c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 12 Jun 2008 11:12:06 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -9,6 +9,7 @@
>>  #include <linux/list.h>
>>  #include <linux/mmzone.h>
>>  #include <linux/rbtree.h>
>> +#include <linux/kernel.h>
>>  #include <linux/prio_tree.h>
>>  #include <linux/debug_locks.h>
>>  #include <linux/mm_types.h>
>> @@ -41,6 +42,9 @@ extern unsigned long mmap_min_addr;
>>  
>>  #define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
>>  
>> +/* to align the pointer to the (next) page boundary */
>> +#define PAGE_ALIGN(addr) ALIGN(addr, PAGE_SIZE)
>> +
>>  /*
>>   * Linux kernel virtual memory manager primitives.
>>   * The idea being to have a "virtual" mm in the same way
> 
> You don't really need the #include <linux/kernel.h> there.  As long as
> all callsites which _use_ PAGE_ALIGN are including kernel.h via some
> means (and they surely will be) then things will work OK.

OK, testing without linux/kernel.h inclusion.

-Andrea

> 
> But it won't hurt.  We're already picking up kernel.h there via
> mmzone.h->spinlock.h and probably 100 other routes.  One more won't
> make a lot of difference ;)
