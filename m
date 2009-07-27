Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbZG0KbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbZG0KbP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 06:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755992AbZG0KbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 06:31:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39480 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755986AbZG0KbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 06:31:14 -0400
Message-ID: <4A6D81EB.6020307@redhat.com>
Date: Mon, 27 Jul 2009 13:31:07 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: "Yang, Sheng" <sheng.yang@intel.com>,
       "H. Peter Anvin" <h.peter.anvin@intel.com>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       kvm-devel <kvm@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: cpuinfo and HVM features
References: <4A68A6E5.6010808@siemens.com> <4A6AD69E.7030201@web.de> <4A6CAB8B.4080706@intel.com> <200907270912.00470.sheng.yang@intel.com> <4A6D6E9A.6030400@siemens.com>
In-Reply-To: <4A6D6E9A.6030400@siemens.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2009 12:08 PM, Jan Kiszka wrote:
>> When I add feature reporting to cpuinfo, I just put highlight features there,
>> otherwise the VMX feature list would at least as long as CPU one.
>>      
>
> That could become true. But the question is always what the highlights
> are. Often this depends on the hypervisor as it may implement
> workarounds for missing features differently (or not at all). So I'm
> also for exposing feature information consistently.
>    


I'd put everything in there.  It's information that is often useful.  
Even minor features can expose bugs in the hypervisor.

>> I have also suggested another field for virtualization feature for it, but
>> some concern again userspace tools raised.
>>
>> For we got indeed quite a lot features, and would get more, would it better to
>> export the part of struct vmcs_config entries(that's pin_based_exec_ctrl,
>> cpu_based_exec_ctrl, and cpu_based_2nd_exec_ctrl) through
>> sys/module/kvm_intel/? Put every feature to cpuinfo seems not that necessary
>> for such a big list.
>>      
>
> I don't think this information should only come from KVM. Consider you
> didn't build it into some kernel but still want to find out what your
> system is able to provide.
>
> What about adding some dedicated /proc entry for CPU virtualization
> features, say /proc/hvminfo?
>    

The flags line is already very long, and already has some virt features, 
so I see no problem extending it.  If we don't want that. I'd prefer a 
virtualization  line in /proc/cpuinfo rather than a new file.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

