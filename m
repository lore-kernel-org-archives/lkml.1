Return-Path: <linux-kernel-owner+w=401wt.eu-S932891AbZJOCdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932891AbZJOCdv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 22:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760893AbZJOCdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 22:33:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:50428 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608AbZJOCdt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 22:33:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,563,1249282800"; 
   d="scan'208";a="559697695"
From: "Zhang, Xiantao" <xiantao.zhang@intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "kvm-ia64@vger.kernel.org" <kvm-ia64@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>
Date: Thu, 15 Oct 2009 10:32:49 +0800
Subject: RE: [PATCH -next] kvm: fix ia64 printk formats
Thread-Topic: [PATCH -next] kvm: fix ia64 printk formats
Thread-Index: AcpNG0neTm85ETrTQTGSmklcx6i3KQAHMyzA
Message-ID: <706158FABBBA044BAD4FE898A02E4BC201C9B81776@pdsmsx503.ccr.corp.intel.com>
References: <20091014163445.f0441473.sfr@canb.auug.org.au>
 <20091014151008.3d48b9fe.randy.dunlap@oracle.com>
In-Reply-To: <20091014151008.3d48b9fe.randy.dunlap@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems strict checks are applied to latest kernel. Okay to me.  Thanks!
Acked-By Xiantao Zhang <xiantao.zhang@intel.com>
Xiantao

Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix printk formats in ia64/kvm:
> 
> arch/ia64/kvm/kvm-ia64.c:250: warning: format '%lx' expects type
> 'long unsigned int', but argument 2 has type 'uint64_t'
> arch/ia64/kvm/kvm-ia64.c:774: warning: format '%lx' expects type
> 'long unsigned int', but argument 2 has type 'uint64_t'
> arch/ia64/kvm/kvm_fw.c:151: warning: format '%ld' expects type 'long
> int', but argument 3 has type 's64' arch/ia64/kvm/kvm_fw.c:151:
> warning: format '%lx' expects type 'long unsigned int', but argument
> 4 has type 'u64' arch/ia64/kvm/kvm_fw.c:151: warning: format '%lx'
> expects type 'long unsigned int', but argument 5 has type 'u64'
> arch/ia64/kvm/kvm_fw.c:548: warning: format '%lx' expects type 'long
> unsigned int', but argument 2 has type 'u64'     
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Xiantao Zhang <xiantao.zhang@intel.com>
> ---
>  arch/ia64/kvm/kvm-ia64.c |    4 ++--
>  arch/ia64/kvm/kvm_fw.c   |    9 +++++----
>  2 files changed, 7 insertions(+), 6 deletions(-)
> 
> --- linux-next-20091014.orig/arch/ia64/kvm/kvm-ia64.c
> +++ linux-next-20091014/arch/ia64/kvm/kvm-ia64.c
> @@ -247,7 +247,7 @@ mmio:
>  		r = kvm_io_bus_write(&vcpu->kvm->mmio_bus, p->addr,
>  				     p->size, &p->data);
>  	if (r)
> -		printk(KERN_ERR"kvm: No iodevice found! addr:%lx\n", p->addr);
> +		printk(KERN_ERR "kvm: No iodevice found! addr:%llx\n", p->addr);
>  	p->state = STATE_IORESP_READY;
> 
>  	return 1;
> @@ -771,7 +771,7 @@ static struct kvm *kvm_alloc_kvm(void)
>  	kvm = (struct kvm *)(vm_base +
>  			offsetof(struct kvm_vm_data, kvm_vm_struct));
>  	kvm->arch.vm_base = vm_base;
> -	printk(KERN_DEBUG"kvm: vm's data area:0x%lx\n", vm_base);
> +	printk(KERN_DEBUG "kvm: vm's data area:0x%llx\n", vm_base);
> 
>  	return kvm;
>  }
> --- linux-next-20091014.orig/arch/ia64/kvm/kvm_fw.c
> +++ linux-next-20091014/arch/ia64/kvm/kvm_fw.c
> @@ -146,9 +146,10 @@ static struct ia64_pal_retval pal_cache_
>  						&result.v0);
>  	local_irq_restore(psr);
>  	if (result.status != 0)
> -		printk(KERN_ERR"vcpu:%p crashed due to cache_flush err:%ld"
> +		printk(KERN_ERR "vcpu:%p crashed due to cache_flush err:%ld"
>  				"in1:%lx,in2:%lx\n",
> -				vcpu, result.status, gr29, gr30);
> +				vcpu, (long)result.status,
> +				(unsigned long)gr29, (unsigned long)gr30);
> 
>  #if 0
>  	if (gr29 == PAL_CACHE_TYPE_COHERENT) {
> @@ -544,8 +545,8 @@ int kvm_pal_emul(struct kvm_vcpu *vcpu,
>  		break;
>  	default:
>  		INIT_PAL_STATUS_UNIMPLEMENTED(result);
> -		printk(KERN_WARNING"kvm: Unsupported pal call,"
> -					" index:0x%lx\n", gr28);
> +		printk(KERN_WARNING "kvm: Unsupported pal call,"
> +					" index:0x%lx\n", (unsigned long)gr28);
>  	}
>  	set_pal_result(vcpu, result);
>  	return ret;

