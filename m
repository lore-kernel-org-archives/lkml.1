Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab0CBVTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 16:19:32 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46413 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab0CBVTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 16:19:30 -0500
Message-ID: <4B8D80C3.1050006@ru.mvista.com>
Date: Wed, 03 Mar 2010 00:18:59 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Anton Vorontsov <avorontsov@ru.mvista.com>
CC: Jeff Garzik <jgarzik@redhat.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/12] ahci: Introduce ahci_set_em_messages()
References: <20100302182850.GA32057@oksana.dev.rtsoft.ru> <20100302182939.GI3445@oksana.dev.rtsoft.ru>
In-Reply-To: <20100302182939.GI3445@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Anton Vorontsov wrote:

> Factor out some ahci_em_messages handling code from ahci_init_one().
> We would like to reuse it for non-PCI devices.
>
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
>  drivers/ata/ahci.c |   41 ++++++++++++++++++++++++-----------------
>  1 files changed, 24 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index 18443e9..6694b17 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -3040,6 +3040,29 @@ static inline void ahci_gtf_filter_workaround(struct ata_host *host)
>  {}
>  #endif
>  
> +static void ahci_set_em_messages(struct ahci_host_priv *hpriv,
> +				 struct ata_port_info *pi)
> +{
> +	u8 messages;
> +	void __iomem *mmio = hpriv->mmio;
> +	u32 em_loc = readl(mmio + HOST_EM_LOC);
> +	u32 em_ctl = readl(mmio + HOST_EM_CTL);
> +
> +	if (!ahci_em_messages || !(hpriv->cap & HOST_CAP_EMS))
> +		return;
> +
> +	messages = (em_ctl & EM_CTRL_MSG_TYPE) >> 16;
> +
> +	/* we only support LED message type right now */
> +	if ((messages & 0x01) && (ahci_em_messages == 1)) {
> +		/* store em_loc */
> +		hpriv->em_loc = ((em_loc >> 16) * 4);
>   

   Could drop unneeded parens, while at it...

MBR, Sergei

