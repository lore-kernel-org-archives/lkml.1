Return-Path: <linux-kernel-owner+w=401wt.eu-S1755031AbZJLIx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031AbZJLIx4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 04:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754981AbZJLIxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 04:53:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754900AbZJLIxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 04:53:54 -0400
Message-ID: <4AD2EE86.50807@redhat.com>
Date: Mon, 12 Oct 2009 10:53:26 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] allow userspace to adjust kvmclock offset
References: <1254849896-3947-1-git-send-email-glommer@redhat.com>
In-Reply-To: <1254849896-3947-1-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2009 07:24 PM, Glauber Costa wrote:
> When we migrate a kvm guest that uses pvclock between two hosts, we may
> suffer a large skew. This is because there can be significant differences
> between the monotonic clock of the hosts involved. When a new host with
> a much larger monotonic time starts running the guest, the view of time
> will be significantly impacted.
>
> Situation is much worse when we do the opposite, and migrate to a host with
> a smaller monotonic clock.
>
> This new proposed ioctl will allow userspace to inform us what is the monotonic
> clock value in the source host, so we can keep the time skew short, and more
> importantly, never goes backwards.
>
>    

> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> index f8f8900..0cd5ad8 100644
> --- a/include/linux/kvm.h
> +++ b/include/linux/kvm.h
> @@ -546,6 +546,7 @@ struct kvm_irqfd {
>   #define KVM_CREATE_PIT2		   _IOW(KVMIO, 0x77, struct kvm_pit_config)
>   #define KVM_SET_BOOT_CPU_ID        _IO(KVMIO, 0x78)
>   #define KVM_IOEVENTFD             _IOW(KVMIO, 0x79, struct kvm_ioeventfd)
> +#define KVM_ADJUST_CLOCK	  _IOW(KVMIO, 0x7a, __u64)
>    

Please change to a struct with some reserved space.

Do we want an absolute or relative adjustment?

-- 
error compiling committee.c: too many arguments to function

