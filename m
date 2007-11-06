Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497AbXKFWuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbXKFWuX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 17:50:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754690AbXKFWuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 17:50:11 -0500
Received: from gw.goop.org ([64.81.55.164]:50054 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754455AbXKFWuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 17:50:09 -0500
Message-ID: <4730EF9F.3020803@goop.org>
Date: Tue, 06 Nov 2007 14:50:07 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <gcosta@redhat.com>
CC: linux-kernel@vger.kernel.org, avi@qumranet.com, aliguori@us.ibm.com,
       kvm-devel@lists.sourceforge.net, hollisb@us.ibm.com
Subject: Re: include files for kvmclock
References: <11943875362987-git-send-email-gcosta@redhat.com> <11943875433821-git-send-email-gcosta@redhat.com>
In-Reply-To: <11943875433821-git-send-email-gcosta@redhat.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> This patch introduces the include files for kvm clock.
> They'll be needed for both guest and host part.
>
> Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
> ---
>  include/asm-x86/kvm_para.h |   23 +++++++++++++++++++++++
>  include/linux/kvm.h        |    1 +
>  include/linux/kvm_para.h   |   20 ++++++++++++++++++++
>  3 files changed, 44 insertions(+), 0 deletions(-)
>
> diff --git a/include/asm-x86/kvm_para.h b/include/asm-x86/kvm_para.h
> index c6f3fd8..af9fb75 100644
> --- a/include/asm-x86/kvm_para.h
> +++ b/include/asm-x86/kvm_para.h
> @@ -10,15 +10,38 @@
>   * paravirtualization, the appropriate feature bit should be checked.
>   */
>  #define KVM_CPUID_FEATURES	0x40000001
> +#define KVM_FEATURE_CLOCKEVENTS 0
> +#define KVM_FEATURE_CLOCKSOURCE 1
> +
>  
>  #ifdef __KERNEL__
>  #include <asm/processor.h>
> +extern void kvmclock_init(void);
> +
> +union kvm_hv_clock {
>   

Why two copies of this structure?

> +	struct {
> +		u64 tsc_mult;
> +		u64 now_ns;
> +		/* That's the wall clock, not the water closet */
> +		u64 wc_sec;
> +		u64 wc_nsec;
> +		u64 last_tsc;
> +		/* At first, we could use the tsc value as a marker, but Jeremy
> +		 * well noted that it will cause us locking problems in 32-bit
> +		 * sys, so we have a special version field */
> +		u32 version;
> +	};
> +	char page_align[PAGE_SIZE];
> +};
> +
>   

[...]

> +
> +union kvm_hv_clock {
> +	struct {
> +		u64 tsc_mult;
> +		u64 now_ns;
> +		/* That's the wall clock, not the water closet */
> +		u64 wc_sec;
> +		u64 wc_nsec;
> +		u64 last_tsc;
> +		/* At first, we could use the tsc value as a marker, but Jeremy
> +		 * well noted that it will cause us locking problems in 32-bit
> +		 * sys, so we have a special version field */
> +		u32 version;
> +	};
> +	char page_align[PAGE_SIZE];
> +};
> +
>  /*
>   * hypercalls use architecture specific
>   */
>   

