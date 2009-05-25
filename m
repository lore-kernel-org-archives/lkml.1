Return-Path: <linux-kernel-owner+w=401wt.eu-S1754449AbZEYSQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbZEYSQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 14:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbZEYSQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 14:16:09 -0400
Received: from gecko.sbs.de ([194.138.37.40]:24641 "EHLO gecko.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbZEYSQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 14:16:08 -0400
Message-ID: <4A1AE04F.9070808@siemens.com>
Date: Mon, 25 May 2009 20:15:43 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Huang Ying <ying.huang@intel.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] KVM: MCE: Add MCE support to KVM
References: <1242031695.8213.17.camel@yhuang-dev.sh.intel.com> <4A105DE2.8090200@redhat.com> <4A1AD816.1060702@siemens.com> <4A1ADED5.4020605@redhat.com>
In-Reply-To: <4A1ADED5.4020605@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Jan Kiszka wrote:
>> Avi Kivity wrote:
>>  
>>> Huang Ying wrote:
>>>    
>>>> The related MSRs are emulated. MCE capability is exported via
>>>> extension KVM_CAP_MCE and ioctl KVM_X86_GET_MCE_CAP_SUPPORTED.  A new
>>>> vcpu ioctl command KVM_X86_SETUP_MCE is used to setup MCE emulation
>>>> such as the mcg_cap. MCE is injected via vcpu ioctl command
>>>> KVM_X86_SET_MCE. Extended machine-check state (MCG_EXT_P) and CMCI are
>>>> not implemented.
>>>>
>>>>         
>>> Applied, thanks.
>>>
>>>     
>>
>> This patch breaks kvm build for 32-bit hosts.
>>   
> 
> Strange, I build-test on i386.  What's your failure?

This is against some 2.6.28 kernel:

  CC [M]  /data/kvm-kmod/x86/x86.o
/data/kvm-kmod/x86/x86.c: In function ‘set_msr_mce’:
/data/kvm-kmod/x86/x86.c:794: error: ‘MCG_CTL_P’ undeclared (first use in this function)
/data/kvm-kmod/x86/x86.c:794: error: (Each undeclared identifier is reported only once
/data/kvm-kmod/x86/x86.c:794: error: for each function it appears in.)
/data/kvm-kmod/x86/x86.c: In function ‘get_msr_mce’:
/data/kvm-kmod/x86/x86.c:950: error: ‘MCG_CTL_P’ undeclared (first use in this function)
/data/kvm-kmod/x86/x86.c: In function ‘kvm_arch_dev_ioctl’:
/data/kvm-kmod/x86/x86.c:1216: error: ‘MCG_CTL_P’ undeclared (first use in this function)
/data/kvm-kmod/x86/x86.c: In function ‘kvm_vcpu_ioctl_x86_setup_mce’:
/data/kvm-kmod/x86/x86.c:1592: error: ‘MCG_CTL_P’ undeclared (first use in this function)
/data/kvm-kmod/x86/x86.c: In function ‘kvm_vcpu_ioctl_x86_set_mce’:
/data/kvm-kmod/x86/x86.c:1613: error: ‘MCI_STATUS_VAL’ undeclared (first use in this function)
/data/kvm-kmod/x86/x86.c:1619: error: ‘MCI_STATUS_UC’ undeclared (first use in this function)
/data/kvm-kmod/x86/x86.c:1619: error: ‘MCG_CTL_P’ undeclared (first use in this function)
/data/kvm-kmod/x86/x86.c:1630: error: ‘MCG_STATUS_MCIP’ undeclared (first use in this function)
/data/kvm-kmod/x86/x86.c:1639: error: ‘MCI_STATUS_OVER’ undeclared (first use in this function)

> 
>> Is the KVM MCE interface completely or only partially limited to x86-64,
>> ie. can I completely #ifdef it away on 32-bit hosts (including
>> KVM_CAP_MCE) or is this more complicated?
>>   
> 
> I don't see any reason to limit it to x86_64?
> 

Well, if I look at the definition of MCI_STATUS_VAL as (1UL<<63),
something tells me: "Hey, only use me on 64-bit hosts!" But I have no
clue about details of this stuff, and from a second glance at it is
seems to include at least some parts that are valid on 32-bit as well.

Jan

-- 
Siemens AG, Corporate Technology, CT SE 2
Corporate Competence Center Embedded Linux
