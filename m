Return-Path: <linux-kernel-owner+w=401wt.eu-S1754849AbXJYIFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbXJYIFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 04:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754581AbXJYIEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 04:04:52 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:59827 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbXJYIEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 04:04:50 -0400
Message-ID: <47204D84.1060706@ah.jp.nec.com>
Date: Thu, 25 Oct 2007 17:02:12 +0900
From: Takenori Nagano <t-nagano@ah.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: linux-kernel@vger.kernel.org, vgoyal@in.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, k-miyoshi@cb.jp.nec.com,
       kexec@lists.infradead.org, Bernhard Walle <bwalle@suse.de>,
       Keith Owens <kaos@ocs.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, kdb@oss.sgi.com
Subject: Re: [PATCH 1/2] add tunable_notifier function ,take2
References: <4716FFDB.7090502@ah.jp.nec.com>	<47171EEC.4030408@ah.jp.nec.com> <20071024111629.3e28b452.rdunlap@xenotime.net>
In-Reply-To: <20071024111629.3e28b452.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Thu, 18 Oct 2007 17:53:00 +0900 Takenori Nagano wrote:
> 
>> This patch adds new notifier function tunable_notifier_chain. Its base is
>> atomic_notifier_chain.
>>
>> Thanks,
>>
>> ---
>>
>> Signed-off-by: Takenori Nagano <t-nagano@ah.jp.nec.com>
>>
>> ---
>> diff -uprN linux-2.6.23.orig/kernel/sys.c linux-2.6.23/kernel/sys.c
>> --- linux-2.6.23.orig/kernel/sys.c	2007-10-10 05:31:38.000000000 +0900
>> +++ linux-2.6.23/kernel/sys.c	2007-10-18 10:08:52.728000000 +0900
>> @@ -38,6 +38,7 @@
>>  #include <linux/syscalls.h>
>>  #include <linux/kprobes.h>
>>  #include <linux/user_namespace.h>
>> +#include <linux/debugfs.h>
>>  
>>  #include <asm/uaccess.h>
>>  #include <asm/io.h>
>> @@ -393,6 +394,243 @@ int blocking_notifier_call_chain(struct 
>>  EXPORT_SYMBOL_GPL(blocking_notifier_call_chain);
> 
>> +/**
>> + *	tunable_atomic_notifier_chain_register
>> + *				- Add notifier to an tunable notifier chain
> 
> Function name & short description must be on one (long?) line.  :(

OK. I'll fix next version.

>> +
>> +int __kprobes __tunable_atomic_notifier_call_chain(
>> +					struct tunable_atomic_notifier_head *nh,
>> +					unsigned long val, void *v,
>> +					int nr_to_call, int *nr_calls)
>> +{
>> +	int ret;
>> +
>> +	rcu_read_lock();
>> +	ret = notifier_call_chain(&nh->head, val, v, nr_to_call, nr_calls);
>> +	rcu_read_unlock();
>> +	return ret;
>> +}
>> +
>> +EXPORT_SYMBOL_GPL(__tunable_atomic_notifier_call_chain);
> 
> Blank line is usually omitted before EXPORT_SYMBOL....

OK. I'll fix, too.

Thanks,
  Takenori

> ---
> ~Randy
> 
> 
