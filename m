Return-Path: <linux-kernel-owner+w=401wt.eu-S1754331AbZHaDDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbZHaDDO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 23:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbZHaDDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 23:03:12 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:58775 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277AbZHaDDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 23:03:11 -0400
To: michael@ellerman.id.au
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, linux-ia64@vger.kernel.org,
       Neil Horman <nhorman@redhat.com>, kamezawa.hiroyu@jp.fujitsu.com,
       Andi Kleen <andi@firstfloor.org>, "M. Mohan Kumar" <mohan@in.ibm.com>,
       akpm@linux-foundation.org, bernhard.walle@gmx.de,
       Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [Patch 0/8] V5 Implement crashkernel=auto
References: <20090827031800.4534.94868.sendpatchset@localhost.localdomain>
	<1251680096.5279.6.camel@concordia>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 30 Aug 2009 20:03:00 -0700
In-Reply-To: <1251680096.5279.6.camel@concordia> (Michael Ellerman's message of "Mon\, 31 Aug 2009 10\:54\:56 +1000")
Message-ID: <m1ws4kznvf.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: michael@ellerman.id.au, avorontsov@ru.mvista.com, mingo@elte.hu, fenghua.yu@intel.com, bernhard.walle@gmx.de, akpm@linux-foundation.org, mohan@in.ibm.com, andi@firstfloor.org, kamezawa.hiroyu@jp.fujitsu.com, nhorman@redhat.com, linux-ia64@vger.kernel.org, tony.luck@intel.com, linux-kernel@vger.kernel.org, amwang@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman <michael@ellerman.id.au> writes:

> On Wed, 2009-08-26 at 23:15 -0400, Amerigo Wang wrote:
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
>
> I don't want to sound like a micro-kernel zealot, I'm not, but I'm still
> unconvinced as to why the auto logic needs to go in the kernel. What is
> the compelling reason that the kernel needs to do this calculation vs
> some userspace tool? We already have the syntax that allows defining a
> different crash size depending on the size of RAM.
>
> The shrinking of reserved memory is cool.

Michael I am in agreement with you.
The shrinking is good.

If we can come up with some simple and generic logic that we can use
to reserve memory then I am in favor.  However all this patchset is
doing is moving user space specific arbitrary hacks into the kernel we
do that perfectly well on the command line.  Having the amount to
reserve be arch specific is complete non-sense and a major maintenance
pain.

Eric

