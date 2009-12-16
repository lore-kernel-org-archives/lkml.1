Return-Path: <linux-kernel-owner+w=401wt.eu-S933702AbZLPBqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933702AbZLPBqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 20:46:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932576AbZLPBqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 20:46:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:35135 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932374AbZLPBqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 20:46:42 -0500
Message-ID: <4B283C8A.6040700@kernel.org>
Date: Wed, 16 Dec 2009 10:48:58 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Csaba Henk <csaba@gluster.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] PCI: Handle case when no pci device can provide cache
 line size hint
References: <20091215122525.GA21846@foogalware.zresearch.com>
In-Reply-To: <20091215122525.GA21846@foogalware.zresearch.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/15/2009 09:25 PM, Csaba Henk wrote:
> Prior to this patch, if pci_read_config_byte(dev, PCI_CACHE_LINE_SIZE, ...)
> returns 0 for all dev, pci_cache_line_size ends up set to zero
> (instead of pci_dfl_cache_line_size).
> 
> This patch ensures the pci_cache_line_size = pci_dfl_cache_line_size
> setting in the above scenario.
> 
> This happens in case of a kvm-88 guest (where, consequently, the rtl8139
> NIC failed to initialize).
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
> +		pci_cache_line_size = cls ? cls : pci_dfl_cache_line_size;

Oh, so, all CLS values are zero?  I've never thought of that.

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
