Return-Path: <linux-kernel-owner+w=401wt.eu-S1762090AbZEHFU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762090AbZEHFU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 01:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbZEHFUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 01:20:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45844 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbZEHFUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 01:20:46 -0400
Date: Fri, 8 May 2009 02:25:11 -0300
From: Glauber Costa <glommer@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] deal with interrupt shadow state for emulated
	instruction
Message-ID: <20090508052511.GC5953@poweredge.glommer>
References: <1241548811-8138-1-git-send-email-glommer@redhat.com> <20090506080321.GU9795@redhat.com> <4A016B98.7070701@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A016B98.7070701@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 01:51:04PM +0300, Avi Kivity wrote:
> Gleb Natapov wrote:
>> On Tue, May 05, 2009 at 02:40:11PM -0400, Glauber Costa wrote:
>>   
>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>>> index 8e680c3..a49d07b 100644
>>> --- a/arch/x86/include/asm/kvm_host.h
>>> +++ b/arch/x86/include/asm/kvm_host.h
>>> @@ -510,6 +510,8 @@ struct kvm_x86_ops {
>>>  	void (*run)(struct kvm_vcpu *vcpu, struct kvm_run *run);
>>>  	int (*handle_exit)(struct kvm_run *run, struct kvm_vcpu *vcpu);
>>>  	void (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
>>> +	void (*set_interrupt_shadow)(struct kvm_vcpu *vcpu, int mask);
>>>     
>> There is .drop_interrupt_shadow() callback. The patch should remove it and
>> replace its use by set_interrupt_shadow().
>>   
>
> That would be [PATCH 1/2].
[PATCH 2/2]. Otherwise we will break bisectability, as the pure removal of this
function would lead us to a non-functioning kernel for no reason.

Avi: if this patch is okay, please apply. I'll send another one later that replaces
the existing .drop_interrupt_shadow by the (then) in tree set_interrupt_shadow.


