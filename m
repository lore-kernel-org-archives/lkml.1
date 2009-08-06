Return-Path: <linux-kernel-owner+w=401wt.eu-S1753327AbZHFByo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbZHFByo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 21:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbZHFByn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 21:54:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42311 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184AbZHFBym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 21:54:42 -0400
Message-ID: <4A7A3847.6070406@redhat.com>
Date: Thu, 06 Aug 2009 09:56:23 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: "Yu, Fenghua" <fenghua.yu@intel.com>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "Luck, Tony" <tony.luck@intel.com>,
       "'linux-ia64@vger.kernel.org'" <linux-ia64@vger.kernel.org>,
       "'Neil Horman'" <nhorman@redhat.com>,
       "'Eric W. Biederman'" <ebiederm@xmission.com>,
       "'akpm@linux-foundation.org'" <akpm@linux-foundation.org>,
       "'Ingo Molnar'" <mingo@elte.hu>,
       "'Anton Vorontsov'" <avorontsov@ru.mvista.com>
Subject: Re: [Patch 2/7] x86: implement crashkernel=auto
References: <20090805112123.6552.73574.sendpatchset@localhost.localdomain> <20090805112142.6552.18373.sendpatchset@localhost.localdomain> <A6AD88C3F2289247BE726C37303E1EB8B38E48D7@orsmsx505.amr.corp.intel.com>
In-Reply-To: <A6AD88C3F2289247BE726C37303E1EB8B38E48D7@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yu, Fenghua wrote:
>> +#ifdef CONFIG_KEXEC_AUTO_RESERVE
>> +	if (strncmp(ck_cmdline, "auto", 4) == 0) {
>> +		unsigned long long size;
>> +		char tmp[32];
>> +
>> +		size = arch_default_crash_size(system_ram);
>> +		if (size != 0) {
>> +			*crash_size = size;
>> +			*crash_base = arch_default_crash_base();
>> +			size = scnprintf(tmp, sizeof(tmp), "%luM@%luM",
>> +					(unsigned long)(*crash_size)>>20,
>> +					(unsigned long)(*crash_base)>>20);
>> +			/* size can't be <= 4. */
>> +			if (likely((size - 4 + strlen(cmdline))
>> +					< COMMAND_LINE_SIZE - 1)) {
>> +				memmove(ck_cmdline + size, ck_cmdline + 4,
>> +					strlen(cmdline) - (ck_cmdline + 4 - cmdline)
>> + 1);
>> +				memcpy(ck_cmdline, tmp, size);
>> +			}
>>     
>
> Here the variable "size" has two different meanings. First it used for crash size. Then its meaning is changed to buffer size in ck_cmdline. And types are different too. The type for crash size is unsigned long long. But scnprintf() return int.
>
> Could you use two variables to represent the two meanings for less confusion?
>   

Sure, OK, will do.

Thanks.

