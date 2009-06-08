Return-Path: <linux-kernel-owner+w=401wt.eu-S1753772AbZFHJuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbZFHJuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 05:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbZFHJuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 05:50:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48760 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbZFHJuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 05:50:08 -0400
Message-ID: <4A2CDEC5.2070900@redhat.com>
Date: Mon, 08 Jun 2009 12:49:57 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v4] KVM: Add VT-x machine check support
References: <1244453829.8361.602.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1244453829.8361.602.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> VT-x needs an explicit MC vector intercept to handle machine checks in the 
> hyper visor.
>
> It also has a special option to catch machine checks that happen
> during VT entry.
>
> Do these interceptions and forward them to the Linux machine check
> handler. Make it always look like user space is interrupted because
> the machine check handler treats kernel/user space differently.
>
> Thanks to Jiang Yunhong for help and testing.
>
> v4: move exit_reason to struct vcpu_vmx, add is_machine_check()
>
> v3: Rebased on kvm.git
>
> v2: Handle machine checks still in interrupt off context
> to avoid problems on preemptible kernels.
>
>   

Applied, thanks.

>  
> +	vmx->exit_reason = vmcs_read32(VM_EXIT_REASON);
> +
> +	/* Handle machine checks before interrupts are enabled */
> +	if ((vmx->exit_reason == EXIT_REASON_MCE_DURING_VMENTRY) ||
> +	    is_machine_check(exit_intr_info))
> +		kvm_machine_check();
> +
>   

I added a check here for exit_reason == EXCEPTION_NMI.  I don't think 
exit_intr_info can be trusted otherwise.

-- 
error compiling committee.c: too many arguments to function

