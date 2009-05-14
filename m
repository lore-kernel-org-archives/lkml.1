Return-Path: <linux-kernel-owner+w=401wt.eu-S1757309AbZENLLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbZENLLc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 07:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753823AbZENLLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 07:11:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39910 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794AbZENLLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 07:11:20 -0400
Message-ID: <4A0BFC56.9090601@redhat.com>
Date: Thu, 14 May 2009 14:11:18 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       davidel@xmailserver.org
Subject: Re: [KVM PATCH v7 3/3] kvm: add iofd support
References: <20090512181134.26131.10023.stgit@dev.haskins.net> <20090512182701.26131.66801.stgit@dev.haskins.net>
In-Reply-To: <20090512182701.26131.66801.stgit@dev.haskins.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> iofd is a mechanism to register PIO/MMIO regions to trigger an eventfd
> signal when written to.  Userspace can register any arbitrary address
> with a corresponding eventfd.
>
>   

Please start a separate patchset for this so I can merge irqfd.

>
> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> index dfc4bcc..99b6e45 100644
> --- a/include/linux/kvm.h
> +++ b/include/linux/kvm.h
> @@ -292,6 +292,17 @@ struct kvm_guest_debug {
>  	struct kvm_guest_debug_arch arch;
>  };
>  
> +#define KVM_IOFD_FLAG_DEASSIGN  (1 << 0)
> +#define KVM_IOFD_FLAG_PIO       (1 << 1)
> +
> +struct kvm_iofd {
> +	__u64 addr;
> +	__u32 len;
> +	__u32 fd;
> +	__u32 flags;
> +	__u8  pad[12];
> +};
> +
>   
Please add a data match capability.  virtio uses a write with the data 
containing the queue ID, and we want a separate event for each queue.


>   * kvm trace categories
> @@ -508,6 +519,7 @@ struct kvm_irqfd {
>  #define KVM_DEASSIGN_DEV_IRQ       _IOW(KVMIO, 0x75, struct kvm_assigned_irq)
>  #define KVM_ASSIGN_IRQFD           _IOW(KVMIO, 0x76, struct kvm_irqfd)
>  #define KVM_DEASSIGN_IRQFD         _IOW(KVMIO, 0x77, __u32)
> +#define KVM_IOFD                   _IOW(KVMIO, 0x78, struct kvm_iofd)
>   

Too general a name.  It's not doing IO, just sending out notifications.

Why have assign/deassign for irqfd and a single ioctl for iofd?

The rest looks good.

-- 
error compiling committee.c: too many arguments to function

