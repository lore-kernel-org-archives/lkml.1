Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbZHFBxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbZHFBxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 21:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbZHFBxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 21:53:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42289 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbZHFBxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 21:53:41 -0400
Message-ID: <4A7A3807.8090803@redhat.com>
Date: Thu, 06 Aug 2009 09:55:19 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [Patch 1/7] x86: add CONFIG_KEXEC_AUTO_RESERVE
References: <20090805112123.6552.73574.sendpatchset@localhost.localdomain>	<20090805112133.6552.69619.sendpatchset@localhost.localdomain> <87zlaeiakr.fsf@basil.nowhere.org>
In-Reply-To: <87zlaeiakr.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Amerigo Wang <amwang@redhat.com> writes:
>
>   
>> Introduce a new config option KEXEC_AUTO_RESERVE for x86.
>>     
>
> The description of the feature belongs in the changelog.
>
> I like the basic idea, but:
>
>   
>> +config KEXEC_AUTO_RESERVE
>> +	bool "automatically reserve memory for kexec kernel"
>> +	depends on KEXEC
>> +	default y
>> +	---help---
>> +	  Automatically reserve memory for a kexec kernel, so that you don't
>> +	  need to specify numbers for the "crashkernel=X@Y" boot option,
>> +	  instead you can use "crashkernel=auto".
>> +	  On x86, 128M is reserved.
>>     
>
> The obvious problem is the hardcoded 128MB (and 128MB is very large
> for a crash kernel anyways)
>   


I think that size has to be hardcoded, or we can make it a bit 
changeable,  according to the page size.... e.g. on PPC and IA64, page 
size can be 16K or more, but x86's page size is always 4K I think.

Hmm, yes, I choose such a large size in order to be safe, but since you 
feel this is too large, how about 64M on x86? (On x86_64 Fedora and 
RHEL, the size of a kernel binary is about 2M~3M.)
> More useful would seem a crashkernel=size@auto
>   
We already have this, just use "crashkernel=size@0". :)

Thanks.

