Return-Path: <linux-kernel-owner+w=401wt.eu-S1759466AbZDKVQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759466AbZDKVQ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 17:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbZDKVQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 17:16:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43981 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbZDKVQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 17:16:18 -0400
Message-ID: <49E10886.8010101@zytor.com>
Date: Sat, 11 Apr 2009 14:15:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] deal with interrupt shadow state for emulated instruction
References: <1239226966-8205-1-git-send-email-glommer@redhat.com> <49E0C767.8060603@redhat.com>
In-Reply-To: <49E0C767.8060603@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
>>  
>> -    rip = kvm_rip_read(vcpu);
>> -    rip += vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
>> -    kvm_rip_write(vcpu, rip);
>> +    if (!(interruptibility & interruptibility_mask))
>> +        vmcs_write32(GUEST_INTERRUPTIBILITY_INFO,
>> +                 interruptibility | interruptibility_mask);
>> +    vcpu->arch.interrupt_window_open = 0;
>>   
> 
> Setting both _MOV_SS and _STI is wierd; can't happen on real hardware.
> 

Not at architecturally visible boundaries, for sure.  It can be an
implementation artifact internally to an instruction, though.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

