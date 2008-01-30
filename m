Return-Path: <linux-kernel-owner+w=401wt.eu-S1755868AbYA3GKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbYA3GKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 01:10:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbYA3GKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 01:10:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39486 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbYA3GKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 01:10:31 -0500
Message-ID: <47A014AF.5040605@zytor.com>
Date: Tue, 29 Jan 2008 22:09:51 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: yi.y.yang@intel.com
CC: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 2.6.24] x86: add sysfs interface for cpuid module
References: <1199441414.19185.9.camel@yangyi-dev.bj.intel.com>	 <1201043126.3861.5.camel@yangyi-dev.bj.intel.com>	 <1201562058.12722.9.camel@yangyi-dev.bj.intel.com>	 <479F4B99.4060701@zytor.com> <1201629138.12722.23.camel@yangyi-dev.bj.intel.com>
In-Reply-To: <1201629138.12722.23.camel@yangyi-dev.bj.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yi Yang wrote:
>>
>> It's broken, because it doesn't take into account the fact that Intel 
>> broke CPUID level 4 and made it "repeating" (neither did the cpuid char 
>> device, because it predated the Intel braindamage; I've had a patch for 
>> it privately for a while, but didn't push it upstream because paravirt 
>> broke it royally and I wanted the situation to settle down.)
>>
>> It's broken, because the algorithm used to determine valid CPUID levels 
>> is incorrect; it fails to recognize any CPUID levels other than the main 
>> Intel and AMD ones, e.g. the Transmeta 0x8086xxxx (and sometimes more) 
>> and VIA 0xc000xxxx levels.
> Thank you for pointing out these issues, i think we can let users input
> any cpuid level and output the corresponding cpuid, in this way we can
> avoid to consider cpu differences and left this to userspace. We can
> also consider all the x86 platforms to do cpuid for every one.
> 
>> It's broken, because it is better for the userspace extractor to have 
>> this logic than to stuff it into the kernel, where it sits hogging 
>> unswappable memory at all times.
> It seems not to be very appropriate to let user space consider hardware
> details. /proc/cpuinfo should be an example to justify this.

/proc/cpuinfo represents what the kernel needs to know, so it reflects 
the kernel's interpretation of CPUID.  There is no reason to interpret 
things in the kernel that the kernel doesn't need.

> Is there any user application using /dev/cpu/*/cpuid? if no, i think it
> is feasible to provide an interface in the kernel.

Yes.  It's called x86info, I believe.

	-hpa
