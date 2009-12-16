Return-Path: <linux-kernel-owner+w=401wt.eu-S964921AbZLPTWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964921AbZLPTWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 14:22:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964915AbZLPTWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 14:22:34 -0500
Received: from outbound-mail-140.bluehost.com ([67.222.39.30]:54135 "HELO
	outbound-mail-140.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S964911AbZLPTWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 14:22:33 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=H+uLfb5d5x3d4vfjBAMm3aD7q/MuWRuus7iZBLS7lsBMmjdrif/mSCA/OkYBI+D/Dq68IiuTPaeYLiph7Z5O52apWM6yTcN3sdFCWAX8K0Juv+SwT7KEIKfFH2ed5jZr;
Date: Wed, 16 Dec 2009 11:22:09 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Csaba Henk <csaba@gluster.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] PCI: Handle case when no pci device can provide
 cache line size hint
Message-ID: <20091216112209.4468ee53@jbarnes-piketon>
In-Reply-To: <20091215122525.GA21846@foogalware.zresearch.com>
References: <20091215122525.GA21846@foogalware.zresearch.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Dec 2009 17:55:25 +0530
Csaba Henk <csaba@gluster.com> wrote:

> Prior to this patch, if pci_read_config_byte(dev,
> PCI_CACHE_LINE_SIZE, ...) returns 0 for all dev, pci_cache_line_size
> ends up set to zero (instead of pci_dfl_cache_line_size).
> 
> This patch ensures the pci_cache_line_size = pci_dfl_cache_line_size
> setting in the above scenario.
> 
> This happens in case of a kvm-88 guest (where, consequently, the
> rtl8139 NIC failed to initialize).
> 
> Signed-off-by: Csaba Henk <csaba@gluster.com>
> ---
>  drivers/pci/quirks.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 7cfa7c3..f70f4e2 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -2629,7 +2629,7 @@ static int __init pci_apply_final_quirks(void)
>  	if (!pci_cache_line_size) {
>  		printk(KERN_DEBUG "PCI: CLS %u bytes, default %u\n",
>  		       cls << 2, pci_dfl_cache_line_size << 2);
> -		pci_cache_line_size = cls;
> +		pci_cache_line_size = cls ? cls :
> pci_dfl_cache_line_size; }
>  
>  	return 0;

Applied, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
