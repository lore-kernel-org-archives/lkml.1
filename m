Return-Path: <linux-kernel-owner+w=401wt.eu-S935612AbZLPTbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935612AbZLPTbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 14:31:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935574AbZLPTbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 14:31:12 -0500
Received: from outbound-mail-24.bluehost.com ([69.89.21.19]:37181 "HELO
	outbound-mail-24.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S935466AbZLPTbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 14:31:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=gy+tuKAaXS797yG0z83iFDB8QRQjXp2Ri4tJAlvjFDDiEdKJKmTp8VDS6bPuHjprusA49cSVblSa2mIl1tXmtkrzmBtPDiDodPS92AaLISloi84N/gIvHY5X1cwysSOj;
Date: Wed, 16 Dec 2009 11:30:44 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
       Aristeu Sergio <arozansk@redhat.com>, linux-pci@vger.kernel.org,
       x86@kernel.org
Subject: Re: [PATCH] pci: fix section mismatch on update_res()
Message-ID: <20091216113044.2d3e282b@jbarnes-piketon>
In-Reply-To: <4B26E436.9000806@jp.fujitsu.com>
References: <4B26E436.9000806@jp.fujitsu.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Dec 2009 10:19:50 +0900
Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:

> From: Jiri Slaby <jslaby@suse.cz>
> 
> Remark update_res from __init to __devinit as it is called also
> from __devinit functions.
> 
> This patch removes the following warning message:
> 
>   WARNING: vmlinux.o(.devinit.text+0x774a): Section mismatch
>   in reference from the function pci_root_bus_res() to the
>   function .init.text:update_res()
>   The function __devinit pci_root_bus_res() references
>   a function __init update_res().
>   If update_res is only used by pci_root_bus_res then
>   annotate update_res with a matching annotation.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Aristeu Sergio <arozansk@redhat.com>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: linux-pci@vger.kernel.org
> Cc: x86@kernel.org
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> ---
>  arch/x86/pci/bus_numa.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
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
>  			      size_t end, unsigned long flags, int
> merge) {
>  	int i;

Applied, thanks Hidetoshi-san and Jiri.

-- 
Jesse Barnes, Intel Open Source Technology Center
