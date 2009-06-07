Return-Path: <linux-kernel-owner+w=401wt.eu-S1754101AbZFGGBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbZFGGBt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 02:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbZFGGBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 02:01:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52551 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbZFGGBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 02:01:38 -0400
Message-ID: <4A2B57B9.7070207@redhat.com>
Date: Sun, 07 Jun 2009 09:01:29 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, ying.huang@intel.com
Subject: Re: [PATCH] KVM: Add VT-x machine check support v2
References: <20090605232356.GA7091@basil.nowhere.org>
In-Reply-To: <20090605232356.GA7091@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> KVM: Add VT-x machine check support v2
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
> Thanks to Huang Ying and Jiang Yunhong for help and testing.
>
> Cc: ying.huang@intel.com
>
> v2: Handle machine checks still in interrupt off context
> to avoid problems on preemptible kernels.
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
>
>   

Only applies with -C0.  What tree was this generated against?

Please diff and test against latest kvm.git.

> ===================================================================
> --- linux.orig/arch/x86/include/asm/kvm_host.h	2009-06-04 16:12:31.000000000 +0200
> +++ linux/arch/x86/include/asm/kvm_host.h	2009-06-04 16:15:20.000000000 +0200
> @@ -371,6 +371,8 @@
>  	unsigned long dr6;
>  	unsigned long dr7;
>  	unsigned long eff_db[KVM_NR_DB_REGS];
> +
> +	u32 exit_reason;
>  };
>   

This should be in 'struct vcpu_vmx' (vmx.c), as it's vmx specific.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

