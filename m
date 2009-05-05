Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946AbZEEOAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbZEEOAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 10:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbZEEOA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 10:00:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41638 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbZEEOA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 10:00:26 -0400
Message-ID: <4A004676.4050604@redhat.com>
Date: Tue, 05 May 2009 17:00:22 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com>
In-Reply-To: <4A0041BA.6060106@novell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> Avi Kivity wrote:
>   
>> Gregory Haskins wrote:
>>     
>>> (Applies to Linus' tree, b4348f32dae3cb6eb4bc21c7ed8f76c0b11e9d6a)
>>>
>>> Please see patch 1/3 for a description.  This has been tested with a KVM
>>> guest on x86_64 and appears to work properly.  Comments, please.
>>>   
>>>       
>> What about the hypercalls in include/asm/kvm_para.h?
>>
>> In general, hypercalls cannot be generic since each hypervisor
>> implements its own ABI.
>>     
> Please see the prologue to 1/3.  Its all described there, including a
> use case which I think answers your questions.  If there is still
> ambiguity, let me know.
>
>   

Yeah, sorry.

>>   The abstraction needs to be at a higher level (pv_ops is such a level).
>>     
> Yep, agreed.  Thats exactly what this series is doing, actually.
>   

No, it doesn't.  It makes "making hypercalls" a pv_op, but hypervisors 
don't implement the same ABI.

pv_ops all _use_ hypercalls to implement higher level operations, like 
set_pte (probably the only place set_pte can be considered a high level 
operation).

In this case, the higher level event could be 
hypervisor_dynamic_event(number); each pv_ops implementation would use 
its own hypercalls to implement that.

-- 
error compiling committee.c: too many arguments to function

