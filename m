Return-Path: <linux-kernel-owner+w=401wt.eu-S933328AbXAaPCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933328AbXAaPCG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 10:02:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933330AbXAaPCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 10:02:06 -0500
Received: from il.qumranet.com ([62.219.232.206]:42813 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933328AbXAaPCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 10:02:05 -0500
Message-ID: <45C0AF6B.4020406@qumranet.com>
Date: Wed, 31 Jan 2007 17:02:03 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: akpm@osdl.org
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [PATCH] KVM: Fix lockup on 32-bit intel hosts with nx disabled
 in the	bios
References: <20070131150017.020B9A0014@il.qumranet.com>
In-Reply-To: <20070131150017.020B9A0014@il.qumranet.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Intel hosts, without long mode, and with nx support disabled in the bios
> have an efer that is readable but not writable.  This causes a lockup on
> switch to guest mode (even though it should exit with reason 34 according to
> the documentation).
>
>   

Andrew, I believe this is 2.6.20 material.

> Signed-off-by: Avi Kivity <avi@qumranet.com>
>
> Index: linux-2.6/drivers/kvm/vmx.c
> ===================================================================
> --- linux-2.6.orig/drivers/kvm/vmx.c
> +++ linux-2.6/drivers/kvm/vmx.c
> @@ -1128,6 +1128,8 @@ static int vmx_vcpu_setup(struct kvm_vcp
>  
>  		if (rdmsr_safe(index, &data_low, &data_high) < 0)
>  			continue;
> +		if (wrmsr_safe(index, data_low, data_high) < 0)
> +			continue;
>  		data = data_low | ((u64)data_high << 32);
>  		vcpu->host_msrs[j].index = index;
>  		vcpu->host_msrs[j].reserved = 0;
>   


-- 
error compiling committee.c: too many arguments to function

