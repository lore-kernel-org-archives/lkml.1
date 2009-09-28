Return-Path: <linux-kernel-owner+w=401wt.eu-S1752560AbZI1BmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbZI1BmA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 21:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752291AbZI1Bl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 21:41:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918AbZI1Bl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 21:41:59 -0400
Message-ID: <4AC013E7.1030508@redhat.com>
Date: Sun, 27 Sep 2009 15:39:51 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH: kvm 3/5] Fix hotadd of CPUs for KVM.
References: <20090924151049.GB14102@amt.cnet> <1253839640-12695-1-git-send-email-zamsden@redhat.com> <1253839640-12695-2-git-send-email-zamsden@redhat.com> <1253839640-12695-3-git-send-email-zamsden@redhat.com> <1253839640-12695-4-git-send-email-zamsden@redhat.com> <4ABF27C8.2000406@redhat.com>
In-Reply-To: <4ABF27C8.2000406@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2009 10:52 PM, Avi Kivity wrote:
> On 09/25/2009 03:47 AM, Zachary Amsden wrote:
>>
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -1716,9 +1716,6 @@ static int kvm_cpu_hotplug(struct 
>> notifier_block *notifier, unsigned long val,
>>   {
>>       int cpu = (long)v;
>>
>> -    if (!kvm_usage_count)
>> -        return NOTIFY_OK;
>> -
>
> Why?  You'll now do hardware_enable() even if kvm is not in use.

Because otherwise you'll never allocate and hardware_enable_all will fail:

Switch to broadcast mode on CPU1
svm_hardware_enable: svm_data is NULL on 1
kvm: enabling virtualization on CPU1 failed
qemu-system-x86[8698]: segfault at 20 ip 00000000004db22f sp 
00007fff0a3b4560 error 6 in qemu-system-x86_64[400000+21f000]

Perhaps I can make this work better by putting the allocation within 
hardware_enable_all.

Zach
