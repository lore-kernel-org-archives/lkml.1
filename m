Return-Path: <linux-kernel-owner+w=401wt.eu-S1753566AbYFAQJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbYFAQJR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 12:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbYFAQJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 12:09:03 -0400
Received: from mx1.suse.de ([195.135.220.2]:33628 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbYFAQJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 12:09:02 -0400
Date: Sun, 1 Jun 2008 18:09:00 +0200
From: Karsten Keil <kkeil@suse.de>
To: Akinobu@suse.de, "Mita <akinobu.mita"@gmail.com
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 05/23] isdn: use simple_read_from_buffer
Message-ID: <20080601160900.GA6831@pingi.kke.suse.de>
Mail-Followup-To: Akinobu@suse.de, "Mita <akinobu.mita"@gmail.com,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <20080601150017.176540188@gmail.com> <20080601150114.022504880@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080601150114.022504880@gmail.com>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.54-0.2.5-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2008 at 12:00:22AM +0900, Akinobu@suse.de wrote:
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Acked-by: Karsten Keil <kkeil@suse.de>

> Cc: Karsten Keil <kkeil@suse.de>
> ---
>  drivers/isdn/hysdn/hysdn_procconf.c |   27 +++++++--------------------
>  1 file changed, 7 insertions(+), 20 deletions(-)
> 
> Index: 2.6-git/drivers/isdn/hysdn/hysdn_procconf.c
> ===================================================================
> --- 2.6-git.orig/drivers/isdn/hysdn/hysdn_procconf.c
> +++ 2.6-git/drivers/isdn/hysdn/hysdn_procconf.c
> @@ -207,30 +207,17 @@ hysdn_conf_write(struct file *file, cons
>  /* read conf file -> output card info data */
>  /*******************************************/
>  static ssize_t
> -hysdn_conf_read(struct file *file, char __user *buf, size_t count, loff_t * off)
> +hysdn_conf_read(struct file *file, char __user *buf, size_t count, loff_t *off)
>  {
>  	char *cp;
> -	int i;
>  
> -	if (file->f_mode & FMODE_READ) {
> -		if (!(cp = file->private_data))
> -			return (-EFAULT);	/* should never happen */
> -		i = strlen(cp);	/* get total string length */
> -		if (*off < i) {
> -			/* still bytes to transfer */
> -			cp += *off;	/* point to desired data offset */
> -			i -= *off;	/* remaining length */
> -			if (i > count)
> -				i = count;	/* limit length to transfer */
> -			if (copy_to_user(buf, cp, i))
> -				return (-EFAULT);	/* copy error */
> -			*off += i;	/* adjust offset */
> -		} else
> -			return (0);
> -	} else
> -		return (-EPERM);	/* no permission to read */
> +	if (!(file->f_mode & FMODE_READ))
> +		return -EPERM;	/* no permission to read */
>  
> -	return (i);
> +	if (!(cp = file->private_data))
> +		return -EFAULT;	/* should never happen */
> +
> +	return simple_read_from_buffer(buf, count, off, cp, strlen(cp));
>  }				/* hysdn_conf_read */
>  
>  /******************/
> 
> -- 

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
