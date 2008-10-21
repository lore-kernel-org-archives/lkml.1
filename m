Return-Path: <linux-kernel-owner+w=401wt.eu-S1753578AbYJUJSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578AbYJUJSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 05:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbYJUJSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 05:18:03 -0400
Received: from www.tglx.de ([62.245.132.106]:53895 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753073AbYJUJSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 05:18:01 -0400
Date: Tue, 21 Oct 2008 11:17:51 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: hjk@linutronix.de, tglx@tglx.de, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pci: use pci_ioremap_bar() in drivers/uio
Message-ID: <20081021091750.GA2966@local>
References: <20081020215444.098868d5@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081020215444.098868d5@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added Greg KH to CC since he handles the UIO patch queue. Also added
lkml since UIO patches are discussed there.

On Mon, Oct 20, 2008 at 09:54:44PM -0700, Arjan van de Ven wrote:
> 
> >From 8d0e600e37f36d379b2f7652912f1b1090c9dfa3 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Sun, 28 Sep 2008 16:20:35 -0700
> Subject: [PATCH] pci: use pci_ioremap_bar() in drivers/uio
> 
> Use the newly introduced pci_ioremap_bar() function in drivers/uio.
> pci_ioremap_bar() just takes a pci device and a bar number, with the goal
> of making it really hard to get wrong, while also having a central place
> to stick sanity checks.
> 
> CC: tglx@tglx.de
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

Signed-off-by: Hans J. Koch <hjk@linutronix.de>

> ---
>  drivers/uio/uio_cif.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/uio/uio_cif.c b/drivers/uio/uio_cif.c
> index 5737606..c60b8fc 100644
> --- a/drivers/uio/uio_cif.c
> +++ b/drivers/uio/uio_cif.c
> @@ -57,8 +57,7 @@ static int __devinit hilscher_pci_probe(struct pci_dev *dev,
>  	info->mem[0].addr = pci_resource_start(dev, 0);
>  	if (!info->mem[0].addr)
>  		goto out_release;
> -	info->mem[0].internal_addr = ioremap(pci_resource_start(dev, 0),
> -					     pci_resource_len(dev, 0));
> +	info->mem[0].internal_addr = pci_ioremap_bar(dev, 0);
>  	if (!info->mem[0].internal_addr)
>  		goto out_release;
>  
> -- 
> 1.5.5.1
> 
> 
> -- 
> Arjan van de Ven 	Intel Open Source Technology Centre
> For development, discussion and tips for power savings, 
> visit http://www.lesswatts.org
