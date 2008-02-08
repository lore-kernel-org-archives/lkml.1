Return-Path: <linux-kernel-owner+w=401wt.eu-S1751983AbYBHXyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbYBHXyV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 18:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754343AbYBHXxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 18:53:46 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35959 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754119AbYBHXxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 18:53:44 -0500
Date: Fri, 8 Feb 2008 15:53:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, arjan@infradead.org,
       linux-pcmcia@lists.infradead.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] pcmcia: fix i82092 printk format
Message-Id: <20080208155319.dfc584c8.akpm@linux-foundation.org>
In-Reply-To: <20080208152244.8aa5fdbb.randy.dunlap@oracle.com>
References: <20080208152244.8aa5fdbb.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2008 15:22:44 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix printk format warnings:
> linux-2.6.24-git19/drivers/pcmcia/i82092.c:650: warning: format '%lx' expects type 'long unsigned int', but argument 3 has type 'resource_size_t'
> linux-2.6.24-git19/drivers/pcmcia/i82092.c:650: warning: format '%lx' expects type 'long unsigned int', but argument 4 has type 'resource_size_t'
> 
> Fix very long source line size.
> Fix spacing within the printk format string.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/pcmcia/i82092.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> --- linux-2.6.24-git19.orig/drivers/pcmcia/i82092.c
> +++ linux-2.6.24-git19/drivers/pcmcia/i82092.c
> @@ -647,7 +647,9 @@ static int i82092aa_set_mem_map(struct p
>  	if ( (mem->card_start > 0x3ffffff) || (region.start > region.end) ||
>  	     (mem->speed > 1000) ) {
>  		leave("i82092aa_set_mem_map: invalid address / speed");
> -		printk("invalid mem map for socket %i : %lx to %lx with a start of %x \n",sock,region.start, region.end, mem->card_start);
> +		printk("invalid mem map for socket %i: %llx to %llx with a start of %x\n",
> +			sock, (unsigned long long)region.start,
> +			(unsigned long long)region.end, mem->card_start);
>  		return -EINVAL;
>  	}
>  	

I've apleady sent a similar patch to Greg
(drivers-pcmcia-i82092c-fix-up-after-pci_bus_region-changes.patch) but I
imagine he's swamped with -stable fun and games at present.

