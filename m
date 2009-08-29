Return-Path: <linux-kernel-owner+w=401wt.eu-S1752301AbZH2SSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbZH2SSH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 14:18:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261AbZH2SSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 14:18:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35361 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbZH2SSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 14:18:06 -0400
Message-ID: <4A997088.60908@zytor.com>
Date: Sat, 29 Aug 2009 11:16:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Xiao Guangrong <ericxiao.gr@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jens Axboe <jens.axboe@oracle.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, x86@kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: reuse the boot-time mappings of fixed_addresses
References: <4A90AADE.20307@gmail.com> <20090829110046.GA6812@elte.hu>
In-Reply-To: <20090829110046.GA6812@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Xiao Guangrong <ericxiao.gr@gmail.com> wrote:
> 
>> From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
>>
>> Some fixed_addresses items are only used when system boot, after 
>> boot, they are free but no way to use, like early ioremap area. 
>> They are wasted for us, we can reuse them after system boot.
>>
>> In this patch, we put them in permanent kmap's area and expand 
>> vmalloc's address range. In boot time, reserve them in 
>> permanent_kmaps_init() to avoid multiple used, after system boot, 
>> we unreserved them then user can use it.
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
>> ---
>>  arch/x86/include/asm/fixmap.h           |    2 ++
>>  arch/x86/include/asm/pgtable_32_types.h |    4 ++--
>>  arch/x86/mm/init_32.c                   |    8 ++++++++
>>  include/linux/highmem.h                 |    2 ++
>>  mm/highmem.c                            |   26 ++++++++++++++++++++++++++
>>  5 files changed, 40 insertions(+), 2 deletions(-)
> 
> I'm wondering, how much space do we save this way, on a typical 
> bootup on a typical PC?
> 

Not a huge lot... a few dozen pages.

	-hpa
