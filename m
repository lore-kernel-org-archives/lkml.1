Return-Path: <linux-kernel-owner+w=401wt.eu-S1756440AbXHAEws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbXHAEws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 00:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbXHAEwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 00:52:37 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58071 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751365AbXHAEwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 00:52:36 -0400
Date: Tue, 31 Jul 2007 21:52:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: postfail@hushmail.com
Cc: <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <linux-sound@vger.kernel.org>
Subject: Re: [PATCH]:  sound: ioremap/iounmap function balancing audit
Message-Id: <20070731215226.e456560d.akpm@linux-foundation.org>
In-Reply-To: <20070801040601.009F3DA820@mailserver8.hushmail.com>
References: <20070801040601.009F3DA820@mailserver8.hushmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Aug 2007 00:05:59 -0400 "Scott Thompson" <postfail@hushmail.com> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1

You might want to consider losing that stuff when sending patches - it just
makes things harder.

> This patch, along with previously submitted dmasound_awacs.c patch,
> completes an audit of the 'sound' tree for ioremap/iounmap
> balancing and return code checking on ioremap calls.  ioremap()
> must be balanced by an iounmap() (else this causes a memory leak).
> 
> i810_audio.c had a 'fixme' issue regarding ioremap fail that was
> addressed as well.
> 
> Signed-off-by: Scott Thompson <postfail <at> hushmail.com>
> - ---
> 
> diff --git a/sound/oss/i810_audio.c b/sound/oss/i810_audio.c
> index f5e31f1..407958c 100644
> - --- a/sound/oss/i810_audio.c
> +++ b/sound/oss/i810_audio.c
> @@ -3362,7 +3362,7 @@ static int __devinit i810_probe(struct
> pci_dev *pci_dev, const struct pci_device
> 
>  	if (card->use_mmio) {
>  		if (request_mem_region(card->ac97base_mmio_phys, 512, "ich_audio
> MMBAR")) {
> - -			if ((card->ac97base_mmio = ioremap(card->ac97base_mmio_phys,
> 512))) { /*@FIXME can ioremap fail? don't know (jsaw) */
> +			if ((card->ac97base_mmio = ioremap(card->ac97base_mmio_phys,
> 512))) {
>  				if (request_mem_region(card->iobase_mmio_phys, 256, "ich_audio
> MBBAR")) {
>  					if ((card->iobase_mmio = ioremap(card->iobase_mmio_phys,
> 256))) {
>  						printk(KERN_INFO "i810: %s mmio at 0x%04lx and 0x%04lx\n",

The patch is terribly wordwrapped.

I suspect a lot of the code which you're fixing is about to be removed. 
But I suppose we should fix it before removing it anwyay.  Still, please
split this patch into at least one for sound/oss and one for sound/soc and
sound/pci, thanks.

