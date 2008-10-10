Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029AbYJJAb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbYJJAb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 20:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYJJAbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 20:31:17 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:46148 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbYJJAbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 20:31:17 -0400
Message-ID: <48EE9FD0.4070501@mxs.nes.nec.co.jp>
Date: Fri, 10 Oct 2008 09:20:32 +0900
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, vgoyal@redhat.com,
       hbabu@us.ibm.com
Subject: Re: [PATCH] add additional symbols to /sys/kernel/vmcoreinfo data
 for	ppc(64)
References: <20081009151408.GA25268@hmsendeavour.rdu.redhat.com>
In-Reply-To: <20081009151408.GA25268@hmsendeavour.rdu.redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Neil,

I had created similar patch, but your patch is better than mine because
your patch has right configuration dependency. So I think this patch is
fine.

Reviewed-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>


Thanks
Ken'ichi Ohmichi

* Reference:
http://lists.infradead.org/pipermail/kexec/2008-June/001970.html

Neil Horman wrote:
> Hey-
> 	The makdumpdile dump filtering program, in some modes of operation needs
> the node_data and/or contig_page_data symbols to function properly.  These
> symbols are missing from the powerpc kernel.  This patch adds those symbols in
> properly.  Tested successfully by myself and the reporter.
> 
> Regards
> Neil
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> 
> 
>  machine_kexec.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> 
> diff --git a/arch/powerpc/kernel/machine_kexec.c b/arch/powerpc/kernel/machine_kexec.c
> index aab7688..2f9b5aa 100644
> --- a/arch/powerpc/kernel/machine_kexec.c
> +++ b/arch/powerpc/kernel/machine_kexec.c
> @@ -44,6 +44,16 @@ void machine_kexec_cleanup(struct kimage *image)
>  		ppc_md.machine_kexec_cleanup(image);
>  }
>  
> +void arch_crash_save_vmcoreinfo(void)
> +{
> +#ifdef CONFIG_NEED_MULTIPLE_NODES
> +	VMCOREINFO_SYMBOL(node_data);
> +	VMCOREINFO_LENGTH(node_data, MAX_NUMNODES);
> +#else
> +	VMCOREINFO_SYMBOL(contig_page_data);
> +#endif
> +}
> +
>  /*
>   * Do not allocate memory (or fail in any way) in machine_kexec().
>   * We are past the point of no return, committed to rebooting now.


