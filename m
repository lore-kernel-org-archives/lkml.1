Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461AbXJWWrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbXJWWrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 18:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbXJWWrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 18:47:01 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48947 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbXJWWrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 18:47:00 -0400
Message-ID: <471E79E2.2090204@garzik.org>
Date: Tue, 23 Oct 2007 18:46:58 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       avi@qumranet.com
Subject: Re: [PATCH 6/12] KVM: work around SMP requirement
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org> <20071023223640.EADF31F81AC@havoc.gtf.org> <20071023224455.GY30533@stusta.de>
In-Reply-To: <20071023224455.GY30533@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Tue, Oct 23, 2007 at 06:36:40PM -0400, Jeff Garzik wrote:
>> KVM is currently completely broken for the !CONFIG_SMP case.
>>
>> drivers/kvm/kvm_main.c: In function ‘kvm_flush_remote_tlbs’:
>> drivers/kvm/kvm_main.c:220: error: implicit declaration of function ‘smp_call_function_mask’
>>
>> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
>> ---
>> I hope the KVM maintainer can come up with a better solution...
>>
>> diff --git a/drivers/kvm/Kconfig b/drivers/kvm/Kconfig
>> index 8749fa4..e35fbc6 100644
>> --- a/drivers/kvm/Kconfig
>> +++ b/drivers/kvm/Kconfig
>> @@ -16,7 +16,7 @@ if VIRTUALIZATION
>>  
>>  config KVM
>>  	tristate "Kernel-based Virtual Machine (KVM) support"
>> -	depends on X86 && EXPERIMENTAL
>> +	depends on X86 && EXPERIMENTAL && SMP
>> ...
> 
> Assuming it won't get fixed soon, the pattern would be "(SMP || BROKEN)".
> 
> The effect is the same, but this makes it more obvious that KVM 
> does not depend architecturally on SMP but just broken.
> 
> Of course, the preferred solution is to simply get KVM fixed...

In general I agree, but I specifically avoided CONFIG_BROKEN in case it 
was an intentional choice to require an SMP kernel.

	Jeff


