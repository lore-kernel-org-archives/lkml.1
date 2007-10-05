Return-Path: <linux-kernel-owner+w=401wt.eu-S1759247AbXJEFwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247AbXJEFwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 01:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbXJEFvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 01:51:52 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:60768 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbXJEFvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 01:51:51 -0400
Message-ID: <4705D070.7080403@ah.jp.nec.com>
Date: Fri, 05 Oct 2007 14:49:36 +0900
From: Takenori Nagano <t-nagano@ah.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: vgoyal@in.ibm.com
CC: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       k-miyoshi@cb.jp.nec.com, kexec@lists.infradead.org,
       Bernhard Walle <bwalle@suse.de>, Keith Owens <kaos@ocs.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, kdb@oss.sgi.com
Subject: Re: [PATCH 1/2] add tunable_notifier function
References: <4704D0BA.4090507@ah.jp.nec.com> <20071005054205.GB4893@in.ibm.com>
In-Reply-To: <20071005054205.GB4893@in.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Thu, Oct 04, 2007 at 08:38:34PM +0900, Takenori Nagano wrote:
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
>> diff -uprN linux-2.6.23-rc9.orig/include/linux/notifier.h
>> linux-2.6.23-rc9/include/linux/notifier.h
>> --- linux-2.6.23-rc9.orig/include/linux/notifier.h	2007-10-02 12:24:52.000000000
>> +0900
>> +++ linux-2.6.23-rc9/include/linux/notifier.h	2007-10-03 14:48:04.288000000 +0900
>> @@ -13,6 +13,7 @@
>>  #include <linux/mutex.h>
>>  #include <linux/rwsem.h>
>>  #include <linux/srcu.h>
>> +#include <linux/kobject.h>
>>
>>  /*
>>   * Notifier chains are of four types:
>> @@ -53,6 +54,14 @@ struct notifier_block {
>>  	int priority;
>>  };
>>
>> +struct tunable_notifier_block {
>> +	struct notifier_block *nb;
>> +	struct tunable_notifier_head *head;
>> +	struct dentry *dir;
>> +	struct dentry *pri_dentry;
>> +	struct dentry *desc_dentry;
>> +};
>> +
> 
> Should this be tunable_atomic_notifier_block? I think there are two kind
> of lists. One where handlers have to be atomic and other one where handlers
> can be blocking one. I think you are making atomic one tunable. If that's
> the case it should be reflected in the naming everywhere.

Hi Vivek,

Yes, it based on atomic_notifier_list. I think your opinion is reasonable.
I'll change the name tunable_notifier to tunable_atomic_notifier.

Thanks,

Takenori Nagano <t-nagano@ah.jp.nec.com>
