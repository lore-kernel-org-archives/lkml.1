Return-Path: <linux-kernel-owner+w=401wt.eu-S932597AbZLDXzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597AbZLDXzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 18:55:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757600AbZLDXza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 18:55:30 -0500
Received: from outbound-mail-138.bluehost.com ([67.222.39.28]:51240 "HELO
	outbound-mail-138.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757597AbZLDXz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 18:55:29 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Oailb1fmC4FzPKjhleM20Zmhk+Bj5DLV5QbBz+qzv88eFLeTNW2DkKyW9dFzL3/OELGJ/B0u7StVsjjtDr+z07kEs1/l189FGMFq/wICqZHzNAgTtdRlD0C44pHFV5k+;
Date: Fri, 4 Dec 2009 15:54:47 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
       Aristeu Sergio <arozansk@redhat.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>, linux-pci@vger.kernel.org,
       x86@kernel.org
Subject: Re: [PATCH 2/2] X86: pci, fix section mismatches
Message-ID: <20091204155447.7c72d1d3@jbarnes-piketon>
In-Reply-To: <1259612382-32722-2-git-send-email-jslaby@suse.cz>
References: <1259612382-32722-1-git-send-email-jslaby@suse.cz>
	<1259612382-32722-2-git-send-email-jslaby@suse.cz>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009 21:19:42 +0100
Jiri Slaby <jslaby@suse.cz> wrote:

> pcibios_scan_specific_bus calls pci_scan_bus_on_node which is
> __devinit. Mark it __devinit as well. All users are now __init or
> __devinit.
> 
> Remark update_res from __init to __devinit as it is called also from
> __devinit functions.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Aristeu Sergio <arozansk@redhat.com>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: linux-pci@vger.kernel.org
> Cc: x86@kernel.org
> ---
>  arch/x86/pci/amd_bus.c |    2 +-
>  arch/x86/pci/legacy.c  |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
> index 995f360..b78ffff 100644
> --- a/arch/x86/pci/amd_bus.c
> +++ b/arch/x86/pci/amd_bus.c
> @@ -119,7 +119,7 @@ static void __init update_range(struct res_range
> *range, size_t start, }
>  }
>  
> -void __init update_res(struct pci_root_info *info, size_t start,
> +void __devinit update_res(struct pci_root_info *info, size_t start,
>  			      size_t end, unsigned long flags, int
> merge) {
>  	int i;
> diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
> index a8194c8..8cf7835 100644
> --- a/arch/x86/pci/legacy.c
> +++ b/arch/x86/pci/legacy.c
> @@ -39,7 +39,7 @@ static int __init pci_legacy_init(void)
>  	return 0;
>  }
>  
> -void pcibios_scan_specific_bus(int busn)
> +void __devinit pcibios_scan_specific_bus(int busn)
>  {
>  	int devfn;
>  	long node;

amd_bus.c got refactored, can you respin?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
