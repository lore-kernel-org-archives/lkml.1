Return-Path: <linux-kernel-owner+w=401wt.eu-S1758360AbZFDMtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360AbZFDMtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 08:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757186AbZFDMtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 08:49:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37756 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755673AbZFDMtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 08:49:09 -0400
Message-ID: <4A27C2BF.3090108@redhat.com>
Date: Thu, 04 Jun 2009 15:49:03 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: ying.huang@intel.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/2] KVM: Add VT-x machine check support
References: <20090604112.650907584@firstfloor.org> <20090604111205.C47C31D0282@basil.firstfloor.org> <4A27B481.5020003@redhat.com> <20090604125123.GY1065@one.firstfloor.org>
In-Reply-To: <20090604125123.GY1065@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> This assumption is incorrect.  This code is executed after preemption 
>> has been enabled, and we may have even slept before reaching it.
>>     
>
> The only thing that counts here is the context before the machine
> check event. If there was a vmexit we know it was in guest context.
>
> The only requirement we have is that we're running still on the same
> CPU. I assume that's true, otherwise the vmcb accesses wouldn't work?
>   

It's not true, we're in preemptible context and may have even slept.

vmcs access work because we have a preempt notifier called when we are 
scheduled in, and will execute vmclear/vmptrld as necessary.  Look at 
kvm_preempt_ops in virt/kvm_main.c.

>> We get both an explicit EXIT_REASON and an exception?
>>     
>
> These are different cases. The exception is #MC in guest context,
> the EXIT_REASON is when a #MC happens while the CPU is executing
> the VM entry microcode.
>   

I see, thanks.

-- 
error compiling committee.c: too many arguments to function

