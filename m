Return-Path: <linux-kernel-owner+w=401wt.eu-S1756452AbXGIJqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452AbXGIJqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 05:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbXGIJqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 05:46:12 -0400
Received: from il.qumranet.com ([82.166.9.18]:46750 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbXGIJqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 05:46:11 -0400
Message-ID: <469203E9.7000109@qumranet.com>
Date: Mon, 09 Jul 2007 12:46:17 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: kvm-devel@lists.sourceforge.net, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] kvm-scheduler integration
References: <11838994974161-git-send-email-avi@qumranet.com> <1183971001.4254.3.camel@sli10-conroe.sh.intel.com>
In-Reply-To: <1183971001.4254.3.camel@sli10-conroe.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li wrote:
> On Sun, 2007-07-08 at 20:58 +0800, Avi Kivity wrote:
>   
>> The only fly in the ointment is that it crashes quite soon.  Haven't
>> figured
>> out why yet, but comments on the general direction would be welcome.
>>     
> Attached patch seems help in my test. prepare_task_switch is called with
> irq disabled.
>
>
>   

Thanks!!  Will integrate that.


>> -static void vmx_vcpu_load(struct kvm_vcpu *vcpu)
>> +static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>>  {
>>         u64 phys_addr = __pa(vcpu->vmcs);
>> -       int cpu;
>>         u64 tsc_this, delta;
>>
>> -       cpu = get_cpu();
>> -
>> +       WARN_ON(!preempt_count());
>>     
> This and below change will break preempt disabled case. better remove
> them.
>   


Right.  Will take them out.



-- 
error compiling committee.c: too many arguments to function

