Return-Path: <linux-kernel-owner+w=401wt.eu-S1754392AbZHaD3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbZHaD3V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 23:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbZHaD3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 23:29:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754362AbZHaD3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 23:29:20 -0400
Message-ID: <4A9B430B.5060006@redhat.com>
Date: Mon, 31 Aug 2009 11:27:07 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: michael@ellerman.id.au
CC: linux-kernel@vger.kernel.org, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       kamezawa.hiroyu@jp.fujitsu.com, Andi Kleen <andi@firstfloor.org>,
       "M. Mohan Kumar" <mohan@in.ibm.com>, akpm@linux-foundation.org,
       bernhard.walle@gmx.de, Fenghua Yu <fenghua.yu@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [Patch 0/8] V5 Implement crashkernel=auto
References: <20090827031800.4534.94868.sendpatchset@localhost.localdomain> <1251680096.5279.6.camel@concordia>
In-Reply-To: <1251680096.5279.6.camel@concordia>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman wrote:
> On Wed, 2009-08-26 at 23:15 -0400, Amerigo Wang wrote:
>   
>> V4 -> V5:
>>  - Rename the global functions, as suggested by Andrew.
>>  - Save some macros, as suggested by Andrew.
>>  - Change the high threshold, from 32G to 4G.
>>  - Change the low threshold on ppc, suggested by ppc developers.
>>  - Make the mm part as a seperate function, suggest by Eric.
>>  - Make the IA64 code more readable.
>>  - Reorder the patchset again, since review from mm people is done.
>>
>> V3 -> V4:
>>  - Reorder the patches.
>>  - Really free the reserved memory, instead of remapping it.
>>    (Thanks to KAMEZAWA Hiroyuki!)
>>  - Release the reserved memory resource when the size is 0.
>>  - Use strict_strtoul() instead of simple_strtoul().
>>
>> V2 -> V3:
>>  - Use more clever way to calculate reserved memory size, especially for IA64.
>>  - Add that patch that implements shrinking reserved memory
>>
>> V1 -> V2:
>>  - Use include/asm-generic/kexec.h, suggested by Neil.
>>  - Rename a local variable, suggested by Fenghua.
>>  - Fix some style problems found by checkpatch.pl.
>>  - Unify the Kconfig docs.
>>
>> This series of patch implements automatically reserved memory for crashkernel,
>> by introducing a new boot option "crashkernel=auto". This idea is from Neil.
>>
>> In case of breaking user-space applications, it modifies this boot option after
>> it decides how much memory should be reserved.
>>
>> On different arch, the threshold and reserved memory size is different. Please
>> refer patch 7/8 which contains an update for the documentation.
>>
>> Patch 8/8 implements shrinking reserved memory at run-time, which is useful
>> when more than enough memory is reserved automatically.
>>
>> This patchset _is_ already tested on x86_64, IA64 and ppc64.
>>     
>
> I don't want to sound like a micro-kernel zealot, I'm not, but I'm still
> unconvinced as to why the auto logic needs to go in the kernel. What is
> the compelling reason that the kernel needs to do this calculation vs
> some userspace tool? We already have the syntax that allows defining a
> different crash size depending on the size of RAM.
>   

Take a look at the x86 part, it can not be done _directly_ in kernel 
command line with the syntax.

