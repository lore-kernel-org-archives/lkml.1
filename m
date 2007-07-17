Return-Path: <linux-kernel-owner+w=401wt.eu-S933084AbXGQIPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933084AbXGQIPh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 04:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762380AbXGQIPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 04:15:20 -0400
Received: from il.qumranet.com ([82.166.9.18]:44062 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760825AbXGQIPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 04:15:19 -0400
Message-ID: <469C7A9E.30207@qumranet.com>
Date: Tue, 17 Jul 2007 11:15:26 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Anthony Liguori <aliguori@us.ibm.com>
CC: Jeff Dike <jdike@addtoit.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM devel <kvm-devel@lists.sourceforge.net>
Subject: Re: [PATCH 2/3] KVM - Fix hypercall arguments
References: <20070716192447.GA16248@c2.user-mode-linux.org>
In-Reply-To: <20070716192447.GA16248@c2.user-mode-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Dike wrote:
> It looks like kvm_hypercall is trying to match the system call
> convention and mixed up the call number and first argument in the
> 32-bit case.
>
> Signed-off-by: Jeff Dike <jdike@linux.intel.com>
> --
>  drivers/kvm/kvm_main.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> Index: kvm/drivers/kvm/kvm_main.c
> ===================================================================
> --- kvm.orig/drivers/kvm/kvm_main.c
> +++ kvm/drivers/kvm/kvm_main.c
> @@ -1351,8 +1351,8 @@ int kvm_hypercall(struct kvm_vcpu *vcpu,
>  	} else
>  #endif
>  	{
> -		nr = vcpu->regs[VCPU_REGS_RBX] & -1u;
> -		a0 = vcpu->regs[VCPU_REGS_RAX] & -1u;
> +		nr = vcpu->regs[VCPU_REGS_RAX] & -1u;
> +		a0 = vcpu->regs[VCPU_REGS_RBX] & -1u;
>  		a1 = vcpu->regs[VCPU_REGS_RCX] & -1u;
>  		a2 = vcpu->regs[VCPU_REGS_RDX] & -1u;
>  		a3 = vcpu->regs[VCPU_REGS_RSI] & -1u;
>   

Anthony?  I think you were hacking this area?

-- 
error compiling committee.c: too many arguments to function

