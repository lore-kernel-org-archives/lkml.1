Return-Path: <linux-kernel-owner+w=401wt.eu-S1755594AbYJQVKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbYJQVKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 17:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbYJQVKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 17:10:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50692 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753769AbYJQVKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 17:10:46 -0400
Date: Fri, 17 Oct 2008 17:08:54 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, hbabu@us.ibm.com
Subject: Re: [PATCH] add additional symbols to /sys/kernel/vmcoreinfo data
	for ppc(64)
Message-ID: <20081017210854.GB10013@redhat.com>
References: <20081009151408.GA25268@hmsendeavour.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081009151408.GA25268@hmsendeavour.rdu.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2008 at 11:20:27AM -0400, Neil Horman wrote:
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

Hi Neil,

Looks like contig_page_data is already being saved in arch independent
portion of kexec (crash_save_vmcoreinfo_init()). We probably don't need
to save it here again?

#ifndef CONFIG_NEED_MULTIPLE_NODES
        VMCOREINFO_SYMBOL(mem_map);
        VMCOREINFO_SYMBOL(contig_page_data);
#endif

Thanks
Vivek
