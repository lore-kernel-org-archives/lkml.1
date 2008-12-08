Return-Path: <linux-kernel-owner+w=401wt.eu-S1753183AbYLHMXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbYLHMXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 07:23:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbYLHMXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 07:23:35 -0500
Received: from gecko.sbs.de ([194.138.37.40]:22730 "EHLO gecko.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbYLHMXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 07:23:34 -0500
X-Greylist: delayed 926 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Dec 2008 07:23:34 EST
Message-ID: <493D0E0A.2000400@siemens.com>
Date: Mon, 08 Dec 2008 13:07:38 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/45] KVM: x86: Support for user space injected NMIs
References: <1228736216-15787-1-git-send-email-avi@redhat.com> <1228736216-15787-13-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-13-git-send-email-avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> From: Jan Kiszka <jan.kiszka@siemens.com>
> 
> Introduces the KVM_NMI IOCTL to the generic x86 part of KVM for
> injecting NMIs from user space and also extends the statistic report
> accordingly.
> 
> Based on the original patch by Sheng Yang.
> 
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
> Signed-off-by: Sheng Yang <sheng.yang@intel.com>
> Signed-off-by: Avi Kivity <avi@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |    2 +
>  arch/x86/kvm/x86.c              |   46 +++++++++++++++++++++++++++++++++++++-
>  include/linux/kvm.h             |   11 +++++++-
>  3 files changed, 55 insertions(+), 4 deletions(-)
> 

...

> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> index f18b86f..44fd7fa 100644
> --- a/include/linux/kvm.h
> +++ b/include/linux/kvm.h
> @@ -83,18 +83,22 @@ struct kvm_irqchip {
>  #define KVM_EXIT_S390_SIEIC       13
>  #define KVM_EXIT_S390_RESET       14
>  #define KVM_EXIT_DCR              15
> +#define KVM_EXIT_NMI              16
> +#define KVM_EXIT_NMI_WINDOW_OPEN  17
>  
>  /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
>  struct kvm_run {
>  	/* in */
>  	__u8 request_interrupt_window;
> -	__u8 padding1[7];
> +	__u8 request_nmi_window;
> +	__u8 padding1[6];
>  
>  	/* out */
>  	__u32 exit_reason;
>  	__u8 ready_for_interrupt_injection;
>  	__u8 if_flag;
> -	__u8 padding2[2];
> +	__u8 ready_for_nmi_injection;
> +	__u8 padding2;
>  
>  	/* in (pre_kvm_run), out (post_kvm_run) */
>  	__u64 cr8;

Avi, please consider [1] again. You've already merged the related user
space cleanup, and I was just waiting for your comment on how to deal
with the kernel part, ideally _before_ merging the superfluous
ready_for/request NMI interface into mainline.

Thanks,
Jan

[1] http://permalink.gmane.org/gmane.comp.emulators.kvm.devel/25016

-- 
Siemens AG, Corporate Technology, CT SE 26
Corporate Competence Center Embedded Linux
