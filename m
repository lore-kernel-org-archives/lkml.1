Return-Path: <linux-kernel-owner+w=401wt.eu-S1764611AbXHDJuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764611AbXHDJuZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 05:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759852AbXHDJuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 05:50:13 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:36820 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbXHDJuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 05:50:12 -0400
Message-ID: <46B44B2B.7050609@gmail.com>
Date: Sat, 04 Aug 2007 11:47:23 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Manuel Jander <mjander@embedded.cl>, alsa-devel@alsa-project.org
Subject: Re: [PATCH] au88x0: mem leak fix in snd_vortex_create()
References: <200708040209.25589.jesper.juhl@gmail.com>
In-Reply-To: <200708040209.25589.jesper.juhl@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2007 02:09 AM, Jesper Juhl wrote:

> In sound/pci/au88x0/au88x0.c::snd_vortex_create() : 
> The Coverity checker found that if we allocate storage for 'chip' 
> but then leave via the  regions_out:  label, then we end up leaking 
> the storage allocated for 'chip'.
> I believe simply freeing 'chip' before the "return err;" line is 
> all we need to fix this, but please double-check me :)
> 
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> ---
> 
> diff --git a/sound/pci/au88x0/au88x0.c b/sound/pci/au88x0/au88x0.c
> index 5ec1b6f..f70286a 100644
> --- a/sound/pci/au88x0/au88x0.c
> +++ b/sound/pci/au88x0/au88x0.c
> @@ -232,6 +232,7 @@ snd_vortex_create(struct snd_card *card, struct pci_dev *pci, vortex_t ** rchip)
>  	pci_disable_device(chip->pci_dev);
>  	//FIXME: this not the right place to unregister the gameport
>  	vortex_gameport_unregister(chip);
> +	kfree(chip);
>  	return err;
>  }

ACK.

Rene.
