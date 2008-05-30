Return-Path: <linux-kernel-owner+w=401wt.eu-S1754826AbYE3VZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbYE3VZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 17:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753398AbYE3VZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 17:25:17 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:56756 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbYE3VZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 17:25:10 -0400
Message-ID: <4840716F.9000309@keyaccess.nl>
Date: Fri, 30 May 2008 23:28:15 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Takashi Iwai <tiwai@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       ALSA devel <alsa-devel@alsa-project.org>, Andrew Morton <akpm@osdl.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [DEVICE MODEL] dev->dma_mask
References: <4823AAF2.7070102@keyaccess.nl> <482B0807.9050404@keyaccess.nl> <482B3274.2060006@keyaccess.nl> <200805141250.57115.bjorn.helgaas@hp.com> <482B38D6.5030804@keyaccess.nl> <48406E8D.8050408@keyaccess.nl>
In-Reply-To: <48406E8D.8050408@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30-05-08 23:15, Rene Herman wrote:

On ...

> @@ -167,6 +168,9 @@ struct pnp_card *pnp_alloc_card(struct pnp_protocol *protocol, int id, char *pnp
>  	sprintf(card->dev.bus_id, "%02x:%02x", card->protocol->number,
>  		card->number);
>  
> +	card->dev.coherent_dma_mask = DMA_24BIT_MASK;
> +	card->dev.dma_mask = &card->dev.coherent_dma_mask;
> +
>  	dev_id = pnp_add_card_id(card, pnpid);
>  	if (!dev_id) {
>  		kfree(card);
> 

... this note by the way I believe pnp_dev might as well get rid of its 
dma_mask as well. As far I've googled up the history of that the reason 
why dev->dma_mask is a pointer is only that it's been moved into struct 
device from struct pci_dev where the latter location was kept as the 
main one so as to not upset then current code.

Everyone else seems to have then faithfully cloned pci_dev and stuck it 
in their private structs as well but for no good reason it would appear.

And in the case of the PnP ISA masks, we're talking about constant 
masks, dictated by the shared global DMA controller and not the card 
itself (there are a few ISA cards that do their own busmastering but 
they're special) so the mask might as well just point to the coherent mask.

Unless I'm missing something ofcourse...

Rene.
