Return-Path: <linux-kernel-owner+w=401wt.eu-S1758182AbZKKS1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182AbZKKS1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 13:27:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758035AbZKKS1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 13:27:43 -0500
Received: from isilmar.linta.de ([213.133.102.198]:58643 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757996AbZKKS1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 13:27:42 -0500
Date: Wed, 11 Nov 2009 19:27:46 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-pcmcia@lists.infradead.org,
       Harald Welte <laforge@gnumonks.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] pcmcia: fix printk formats
Message-ID: <20091111182746.GA10094@isilmar.linta.de>
Mail-Followup-To: Randy Dunlap <randy.dunlap@oracle.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-pcmcia@lists.infradead.org,
	Harald Welte <laforge@gnumonks.org>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, gregkh@suse.de,
	akpm <akpm@linux-foundation.org>
References: <20091111203159.a2a6eeeb.sfr@canb.auug.org.au> <20091111093107.9032f4bb.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091111093107.9032f4bb.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied to the PCMCIA tree, thanks.

On Wed, Nov 11, 2009 at 09:31:07AM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix printk format warnings on sizeof() [size_t] arguments.
> 
> drivers/char/pcmcia/cm4040_cs.c:267: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'size_t'
> drivers/char/pcmcia/cm4040_cs.c:272: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'size_t'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/char/pcmcia/cm4040_cs.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- linux-next-20091110.orig/drivers/char/pcmcia/cm4040_cs.c
> +++ linux-next-20091110/drivers/char/pcmcia/cm4040_cs.c
> @@ -264,12 +264,12 @@ static ssize_t cm4040_read(struct file *
>  
>  	bytes_to_read = 5 + le32_to_cpu(*(__le32 *)&dev->r_buf[1]);
>  
> -	DEBUGP(6, dev, "BytesToRead=%lu\n", bytes_to_read);
> +	DEBUGP(6, dev, "BytesToRead=%zu\n", bytes_to_read);
>  
>  	min_bytes_to_read = min(count, bytes_to_read + 5);
>  	min_bytes_to_read = min_t(size_t, min_bytes_to_read, READ_WRITE_BUFFER_SIZE);
>  
> -	DEBUGP(6, dev, "Min=%lu\n", min_bytes_to_read);
> +	DEBUGP(6, dev, "Min=%zu\n", min_bytes_to_read);
>  
>  	for (i = 0; i < (min_bytes_to_read-5); i++) {
>  		rc = wait_for_bulk_in_ready(dev);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
