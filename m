Return-Path: <linux-kernel-owner+w=401wt.eu-S1758033AbZEOI2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033AbZEOI2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 04:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755904AbZEOI1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 04:27:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:52684 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755530AbZEOI1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 04:27:42 -0400
Message-ID: <4A0D276B.4010703@kernel.org>
Date: Fri, 15 May 2009 17:27:23 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: mingo@elte.hu, andi@firstfloor.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [GIT PATCH] x86,percpu: fix pageattr handling with remap			 allocator
References: <1242305390-21958-1-git-send-email-tj@kernel.org> <4A0C46B80200007800000ED4@vpn.id2.novell.com> <4A0C3EF9.4050907@kernel.org> <4A0D3A390200007800001081@vpn.id2.novell.com> <4A0D23A4.30006@kernel.org> <4A0D424802000078000010C1@vpn.id2.novell.com>
In-Reply-To: <4A0D424802000078000010C1@vpn.id2.novell.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 15 May 2009 08:27:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
>>>> Tejun Heo <tj@kernel.org> 15.05.09 10:11 >>>
>>>>> This would additionally address a potential problem on 32-bits -
>>>>> currently, for a 32-CPU system you consume half of the vmalloc space
>>>>> with PAE (on non-PAE you'd even exhaust it, but I think it's
>>>>> unreasonable to expect a system having 32 CPUs to not need PAE).
>>>> I recall having about the same conversation before.  Looking up...
>>>>
>>>> -- QUOTE --
>>>>  Actually, I've been looking at the numbers and I'm not sure if the
>>>>  concern is valid.  On x86_32, the practical number of maximum
>>>>  processors would be around 16 so it will end up 32M, which isn't
>>>>  nice and it would probably a good idea to introduce a parameter to
>>>>  select which allocator to use but still it's far from consuming all
>>>>  the VM area.  On x86_64, the vmalloc area is obscenely large at 245,
>>>>  ie 32 terabytes.  Even with 4096 processors, single chunk is measly
>>>>  0.02%.
>>> Just to note - there must be a reason we (SuSE/Novell) build our default
>>> 32-bit kernel with support for 128 CPUs, which now is simply broken.
>> It's not broken, it will just fall back to 4k allocator.  Also, please
> 
> I'm afraid I have to disagree: There's no check (not even in
> vm_area_register_early()) whether the vmalloc area is actually large enough
> to fulfill the request.

Hah... indeed.  Well, it's solved now.

Thanks.

-- 
tejun
