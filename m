Return-Path: <linux-kernel-owner+w=401wt.eu-S1754401AbZGANl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbZGANl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 09:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbZGANlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 09:41:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34774 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920AbZGANlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 09:41:09 -0400
Message-ID: <4A4B67A2.9090300@redhat.com>
Date: Wed, 01 Jul 2009 16:41:54 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andi Kleen <ak@linux.intel.com>, Greg KH <gregkh@suse.de>,
       Stefan Lippers-Hollmann <s.L-H@gmx.de>, linux-kernel@vger.kernel.org,
       ying.huang@intel.com, stable@kernel.org
Subject: Re: patch kvm-add-vt-x-machine-check-support.patch added to	2.6.30-stable
 tree
References: <20090629184144.76C9948FD3@coco.kroah.org>	<200907010053.40900.s.L-H@gmx.de> <20090630234206.GA22546@suse.de>	<4A4B0BB1.2010102@linux.intel.com> <4A4B11A6.6080402@redhat.com> <87d48kiliq.fsf@basil.nowhere.org>
In-Reply-To: <87d48kiliq.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2009 04:24 PM, Andi Kleen wrote:
>
> KVM: Add VT-x machine check support v3
>
> VT-x needs an explicit MC vector intercept to handle machine checks in the
> hypervisor.
>
> It also has a special option to catch machine checks that happen
> during VT entry.
>
> Do these interceptions and forward them to the Linux machine check
> handler. Make it always look like user space is interrupted because
> the machine check handler treats kernel/user space differently.
>
> Thanks to Huang Ying and Jiang Yunhong for help and testing.
>
> Cc: ying.huang@intel.com
>
> v2: Handle machine checks still in interrupt off context
> to avoid problems on preemptible kernels.
> v3: Handle old style 32bit and make fully standalone
>
>
> ===================================================================
> --- linux-2.6.30-ak.orig/arch/x86/include/asm/kvm_host.h
> +++ linux-2.6.30-ak/arch/x86/include/asm/kvm_host.h
> @@ -371,6 +371,8 @@ struct kvm_vcpu_arch {
>   	unsigned long dr6;
>   	unsigned long dr7;
>   	unsigned long eff_db[KVM_NR_DB_REGS];
> +
> +	u32 exit_reason;
>   };
>
>    

Should be in struct vmx_vcpu; otherwise ack.

-- 
error compiling committee.c: too many arguments to function

