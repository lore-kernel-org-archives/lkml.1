Return-Path: <linux-kernel-owner+w=401wt.eu-S1752154AbXLSGdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbXLSGdv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 01:33:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755160AbXLSGdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 01:33:42 -0500
Received: from il.qumranet.com ([82.166.9.18]:35725 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755118AbXLSGdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 01:33:41 -0500
Message-ID: <4768BB43.1000609@qumranet.com>
Date: Wed, 19 Dec 2007 08:33:39 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Guest kernel hangs in smp kvm for older kernels prior to tsc
 sync cleanup
References: <47680173.6060606@qumranet.com> <20071218221930.GA26109@elte.hu>
In-Reply-To: <20071218221930.GA26109@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> While the change mentions that it fixes a time warp bug, it also says 
>> it should be rare.  So clearly kvm smp tsc handing is buggy.  
>> Ingo/Thomas, (or anybody else), do you have any insight as to what kvm 
>> can be doing wrong to trigger this behavior?
>>     
>
> hm. Those time warps were really small, due to the small imperfections 
> in the "sync up all CPUs to the same moment and do a WRMSR to clear all 
> their TSCs" mechanism. I.e. at most a few usec time warps. I really dont 
> know how that should result in udevd hanging. Can you debug udevd in any 
> way?
>
>   

Adding debug didn't help.  I'll try some sysrq keys to see what the 
guest thinks is happening.

> so the only thing that KVM might be doing incorrectly here is the 
> emulation of the WRMSR that clears the TSC of each vcpu?
>   

By inspection, it is correct.  Of course I may be missing something, so 
I'll write a unit test for it.  It should also be much slower than the 
native wrmsr.

-- 
error compiling committee.c: too many arguments to function

