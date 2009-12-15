Return-Path: <linux-kernel-owner+w=401wt.eu-S932463AbZLOBTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463AbZLOBTp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 20:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758946AbZLOBTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 20:19:43 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59231 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758945AbZLOBTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 20:19:42 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B26E41A.2090700@jp.fujitsu.com>
Date: Tue, 15 Dec 2009 10:19:22 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: jbarnes@virtuousgeek.org, jirislaby@gmail.com,
       linux-kernel@vger.kernel.org, Aristeu Sergio <arozansk@redhat.com>,
       linux-pci@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/1] X86: pci, fix section mismatches
References: <1260388570-680-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1260388570-680-1-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2009/12/10 4:56), Jiri Slaby wrote:
> pcibios_scan_specific_bus calls pci_scan_bus_on_node which is __devinit.
> Mark it __devinit as well. All users are now __init or __devinit.
> 
> Remark update_res from __init to __devinit as it is called also from
> __devinit functions.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Aristeu Sergio <arozansk@redhat.com>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: linux-pci@vger.kernel.org
> Cc: x86@kernel.org
> ---
>  arch/x86/pci/bus_numa.c |    2 +-
>  arch/x86/pci/legacy.c   |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/pci/bus_numa.c b/arch/x86/pci/bus_numa.c
> index 145df00..f939d60 100644
> --- a/arch/x86/pci/bus_numa.c
> +++ b/arch/x86/pci/bus_numa.c
> @@ -51,7 +51,7 @@ void x86_pci_root_bus_res_quirks(struct pci_bus *b)
>  	}
>  }
>  
> -void __init update_res(struct pci_root_info *info, size_t start,
> +void __devinit update_res(struct pci_root_info *info, size_t start,
>  			      size_t end, unsigned long flags, int merge)
>  {
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

It seems that the pcibios_scan_specific_bus() is not available on
Linus's tree yet.
And according to the linux-next/master, this function is now exported
by EXPORT_SYMBOL_GPL().  So latter hunk is not appropriate.

I have no complain about the former hunk.


Thanks,
H.Seto


