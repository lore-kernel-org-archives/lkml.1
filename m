Return-Path: <linux-kernel-owner+w=401wt.eu-S1758516AbZEFKvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758516AbZEFKvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 06:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756781AbZEFKvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 06:51:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52165 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756382AbZEFKvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 06:51:41 -0400
Message-ID: <4A016B98.7070701@redhat.com>
Date: Wed, 06 May 2009 13:51:04 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] deal with interrupt shadow state for emulated	instruction
References: <1241548811-8138-1-git-send-email-glommer@redhat.com> <20090506080321.GU9795@redhat.com>
In-Reply-To: <20090506080321.GU9795@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gleb Natapov wrote:
> On Tue, May 05, 2009 at 02:40:11PM -0400, Glauber Costa wrote:
>   
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 8e680c3..a49d07b 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -510,6 +510,8 @@ struct kvm_x86_ops {
>>  	void (*run)(struct kvm_vcpu *vcpu, struct kvm_run *run);
>>  	int (*handle_exit)(struct kvm_run *run, struct kvm_vcpu *vcpu);
>>  	void (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
>> +	void (*set_interrupt_shadow)(struct kvm_vcpu *vcpu, int mask);
>>     
> There is .drop_interrupt_shadow() callback. The patch should remove it and
> replace its use by set_interrupt_shadow().
>   

That would be [PATCH 1/2].

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

