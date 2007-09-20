Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770AbXITFRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbXITFRP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 01:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbXITFRB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 01:17:01 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:47360 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbXITFRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 01:17:00 -0400
Message-Id: <46F20233.1040209@mxs.nes.nec.co.jp>
Date: Thu, 20 Sep 2007 14:16:35 +0900
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@kernel.org>,
       kexec-ml <kexec@lists.infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] [-mm patch]  Add nodemask_t's size and NR_FREE_PAGES's
 value to vmcoreinfo_data.
References: <46E9F6A9.8060500@mxs.nes.nec.co.jp> <46E9F854.9030804@mxs.nes.nec.co.jp> <alpine.DEB.0.9999.0709132034540.30494@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.0.9999.0709132034540.30494@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi David,

David Rientjes wrote:
> On Fri, 14 Sep 2007, Ken'ichi Ohmichi wrote:
>
>> diff -rpuN a/include/linux/kexec.h b/include/linux/kexec.h
>> --- a/include/linux/kexec.h    2007-09-10 23:28:42.000000000 +0900
>> +++ b/include/linux/kexec.h    2007-09-10 23:29:52.000000000 +0900
>> @@ -132,11 +132,16 @@ unsigned long paddr_vmcoreinfo_note(void
>>  #define SIZE(name) \
>>      vmcoreinfo_append_str("SIZE(%s)=%lu\n", #name, \
>>                    (unsigned long)sizeof(struct name))
>> +#define TYPEDEF_SIZE(name) \
>> +    vmcoreinfo_append_str("SIZE(%s)=%lu\n", #name, \
>> +                  (unsigned long)sizeof(name))
>>   #define OFFSET(name, field) \
>>      vmcoreinfo_append_str("OFFSET(%s.%s)=%lu\n", #name, #field, \
>>                    (unsigned long)&(((struct name *)0)->field))
>>  #define LENGTH(name, value) \
>>      vmcoreinfo_append_str("LENGTH(%s)=%lu\n", #name, (unsigned long)value)
>> +#define NUMBER(name) \
>> +    vmcoreinfo_append_str("NUMBER(%s)=%ld\n", #name, (long)name)
>>  #define CONFIG(name) \
>>      vmcoreinfo_append_str("CONFIG_%s=y\n", #name)
>>
>
> The #define SIZE() should be renamed STRUCT_SIZE() since it's always returning the size of the struct with a given name.  This would allow TYPEDEF_SIZE() to simply become SIZE() since it need not be used exclusively for typedefs.

Thank you for the comment.
That sounds good, I'll post a new patch including it.


Thanks
Ken'ichi Ohmichi
