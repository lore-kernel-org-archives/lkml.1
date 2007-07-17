Return-Path: <linux-kernel-owner+w=401wt.eu-S1755942AbXGQNmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbXGQNmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 09:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbXGQNm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 09:42:26 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:38277 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbXGQNmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 09:42:25 -0400
Message-ID: <469CC73E.8000306@codemonkey.ws>
Date: Tue, 17 Jul 2007 08:42:22 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: Anthony Liguori <aliguori@us.ibm.com>,
       KVM devel <kvm-devel@lists.sourceforge.net>,
       Jeff Dike <jdike@addtoit.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] [PATCH 2/3] KVM - Fix hypercall arguments
References: <20070716192447.GA16248@c2.user-mode-linux.org> <469C7A9E.30207@qumranet.com>
In-Reply-To: <469C7A9E.30207@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Jeff Dike wrote:
>   
>> It looks like kvm_hypercall is trying to match the system call
>> convention and mixed up the call number and first argument in the
>> 32-bit case.
>>
>> Signed-off-by: Jeff Dike <jdike@linux.intel.com>
>> --
>>  drivers/kvm/kvm_main.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> Index: kvm/drivers/kvm/kvm_main.c
>> ===================================================================
>> --- kvm.orig/drivers/kvm/kvm_main.c
>> +++ kvm/drivers/kvm/kvm_main.c
>> @@ -1351,8 +1351,8 @@ int kvm_hypercall(struct kvm_vcpu *vcpu,
>>  	} else
>>  #endif
>>  	{
>> -		nr = vcpu->regs[VCPU_REGS_RBX] & -1u;
>> -		a0 = vcpu->regs[VCPU_REGS_RAX] & -1u;
>> +		nr = vcpu->regs[VCPU_REGS_RAX] & -1u;
>> +		a0 = vcpu->regs[VCPU_REGS_RBX] & -1u;
>>  		a1 = vcpu->regs[VCPU_REGS_RCX] & -1u;
>>  		a2 = vcpu->regs[VCPU_REGS_RDX] & -1u;
>>  		a3 = vcpu->regs[VCPU_REGS_RSI] & -1u;
>>   
>>     
>
> Anthony?  I think you were hacking this area?
>   

I make a similar change in my series.

Regards,

Anthony Liguori


