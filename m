Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbZCFTvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbZCFTvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 14:51:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754808AbZCFTu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 14:50:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:40675 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754728AbZCFTu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 14:50:57 -0500
Message-ID: <49B17E6C.2040702@kernel.org>
Date: Fri, 06 Mar 2009 11:50:04 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: introduce bootmem_state -v2
References: <1236257708-27269-7-git-send-email-penberg@cs.helsinki.fi> <49B02498.9080300@kernel.org> <49B02C68.1030203@cs.helsinki.fi> <49B0640A.5080607@kernel.org> <20090306145928.GE21907@elte.hu> <49B16DA6.4090108@kernel.org> <20090306191249.GC28582@elte.hu>
In-Reply-To: <20090306191249.GC28582@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> Impact: cleanup
>>
>> extend after_bootmem and after_init_bootmem to bootmem_state
>> and will have BEFORE_BOOTMEM, DURING_BOOTMEM, AFTER_BOOTMEM
>>
>> v2: style changes according to ingo
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  arch/x86/kernel/setup.c |    1 +
>>  arch/x86/mm/init.c      |   13 +++++++------
>>  arch/x86/mm/init_32.c   |   28 ++++++++++++++++++++--------
>>  arch/x86/mm/init_64.c   |   33 +++++++++++++++++++--------------
>>  include/linux/mm.h      |    9 +++++++++
>>  5 files changed, 56 insertions(+), 28 deletions(-)
> 
>> Index: linux-2.6/include/linux/mm.h
>> ===================================================================
>> --- linux-2.6.orig/include/linux/mm.h
>> +++ linux-2.6/include/linux/mm.h
>> @@ -1067,6 +1067,15 @@ extern void __init mmap_init(void);
>>  extern void show_mem(void);
>>  extern void si_meminfo(struct sysinfo * val);
>>  extern void si_meminfo_node(struct sysinfo *val, int nid);
>> +
>> +enum bootmem_state {
>> +	BEFORE_BOOTMEM,
>> +	DURING_BOOTMEM,
>> +	AFTER_BOOTMEM
>> +};
>> +
>> +extern enum bootmem_state bootmem_state;
>> +
>>  extern int after_bootmem;
> 
> Btw., the after_bootmem variable itself should either move to 
> x86 (and arch/sh), or should be defined in mm/bootmem.c.
> 
> Right now we have this weird mm.h construct that is not actually 
> useful to generic code.

with this patch, only sh is using after_bootmem. could
1. make sh to use bootmem_state
2. then remove after_bootmem

YH
