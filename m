Return-Path: <linux-kernel-owner+w=401wt.eu-S933427AbXGQIYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933427AbXGQIYD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 04:24:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933151AbXGQIXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 04:23:36 -0400
Received: from il.qumranet.com ([82.166.9.18]:56466 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932440AbXGQIXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 04:23:34 -0400
Message-ID: <469C7C8D.1020600@qumranet.com>
Date: Tue, 17 Jul 2007 11:23:41 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       KVM devel <kvm-devel@lists.sourceforge.net>
Subject: Re: [PATCH 3/3] KVM - add hypercall nr to kvm_run
References: <20070716192447.GA16253@c2.user-mode-linux.org>
In-Reply-To: <20070716192447.GA16253@c2.user-mode-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Dike wrote:
> Add the hypercall number to kvm_run and initialize it.  This might be
> considered API-changing, so I kept it separate.
>
> Signed-off-by: Jeff Dike <jdike@linux.intel.com>
> --
>  drivers/kvm/kvm_main.c |    1 +
>  include/linux/kvm.h    |    1 +
>  2 files changed, 2 insertions(+)
>
> Index: kvm/drivers/kvm/kvm_main.c
> ===================================================================
> --- kvm.orig/drivers/kvm/kvm_main.c
> +++ kvm/drivers/kvm/kvm_main.c
> @@ -1361,6 +1361,7 @@ int kvm_hypercall(struct kvm_vcpu *vcpu,
>  	}
>  	switch (nr) {
>  	default:
> +		run->hypercall.nr = nr;
>  		run->hypercall.args[0] = a0;
>  		run->hypercall.args[1] = a1;
>  		run->hypercall.args[2] = a2;
> Index: kvm/include/linux/kvm.h
> ===================================================================
> --- kvm.orig/include/linux/kvm.h
> +++ kvm/include/linux/kvm.h
> @@ -106,6 +106,7 @@ struct kvm_run {
>  		} mmio;
>  		/* KVM_EXIT_HYPERCALL */
>  		struct {
> +			__u64 nr;
>  			__u64 args[6];
>  			__u64 ret;
>  			__u32 longmode;
>   

It isn't API changing as the API could not be (and has not been) used.  
We do need to add a padding element to the union to make sure additional 
union members don't cause its size to change.

Quite sad that we got this far with such brokenness.

-- 
error compiling committee.c: too many arguments to function

