Return-Path: <linux-kernel-owner+w=401wt.eu-S1760643AbZDLMrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760643AbZDLMrh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 08:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760420AbZDLMr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 08:47:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45256 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760397AbZDLMr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 08:47:26 -0400
Message-ID: <49E1E2B2.3060609@redhat.com>
Date: Sun, 12 Apr 2009 15:46:42 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Luis Henriques <henrix@sapo.pt>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Problem with kvm on -tip
References: <20090409210738.GA4566@hades.domain.com> <49E08857.2090503@redhat.com> <20090412124243.GA20281@elte.hu>
In-Reply-To: <20090412124243.GA20281@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> @@ -630,10 +630,12 @@ static void kvm_write_guest_time(struct kvm_vcpu *v)
>>  	if ((!vcpu->time_page))
>>  		return;
>>  
>> +	preempt_disable();
>>  	if (unlikely(vcpu->hv_clock_tsc_khz != __get_cpu_var(cpu_tsc_khz))) {
>>  		kvm_set_time_scale(__get_cpu_var(cpu_tsc_khz), &vcpu->hv_clock);
>>  		vcpu->hv_clock_tsc_khz = __get_cpu_var(cpu_tsc_khz);
>>  	}
>> +	preempt_enable();
>>     
>
> fix look good, but note that this is an open-coded get_cpu_var() 
> sequence - please use get_cpu_var()/put_cpu_var() instead.
>   

Right, will do.

-- 
error compiling committee.c: too many arguments to function

