Return-Path: <linux-kernel-owner+w=401wt.eu-S1758070AbYGROEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070AbYGROEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 10:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756096AbYGROEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 10:04:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754790AbYGROEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 10:04:40 -0400
Date: Fri, 18 Jul 2008 10:04:31 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Bernhard Walle <bwalle@suse.de>
Cc: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>,
       linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: kdump: Report actual value of VMCOREINFO_OSRELEASE in
	VMCOREINFO
Message-ID: <20080718140431.GE11492@redhat.com>
References: <20080718000745.51d32607@kopernikus.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080718000745.51d32607@kopernikus.site>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 12:07:45AM +0200, Bernhard Walle wrote:
> The current implementation reports the structure name as
> VMCOREINFO_OSRELEASE in VMCOREINFO, e.g.
> 
>         VMCOREINFO_OSRELEASE=init_uts_ns.name.release
> 
> That doesn't make sense because it's always the same. Instead, use the
> value, e.g.
> 
>         VMCOREINFO_OSRELEASE=2.6.26-rc3
> 
> That's also what the 'makedumpfile -g' does.
> 
> Signed-off-by: Bernhard Walle <bwalle@suse.de>
> 
> diff --git a/include/linux/kexec.h b/include/linux/kexec.h
> index 3265968..3c7784d 100644
> --- a/include/linux/kexec.h
> +++ b/include/linux/kexec.h
> @@ -127,8 +127,8 @@ void vmcoreinfo_append_str(const char *fmt, ...)
>  	__attribute__ ((format (printf, 1, 2)));
>  unsigned long paddr_vmcoreinfo_note(void);
>  
> -#define VMCOREINFO_OSRELEASE(name) \
> -	vmcoreinfo_append_str("OSRELEASE=%s\n", #name)
> +#define VMCOREINFO_OSRELEASE(value) \
> +	vmcoreinfo_append_str("OSRELEASE=%s\n", value)
>  #define VMCOREINFO_PAGESIZE(value) \
>  	vmcoreinfo_append_str("PAGESIZE=%ld\n", value)
>  #define VMCOREINFO_SYMBOL(name) \

Makes sense.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek
