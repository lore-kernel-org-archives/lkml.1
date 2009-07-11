Return-Path: <linux-kernel-owner+w=401wt.eu-S1753588AbZGKRYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588AbZGKRYU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 13:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbZGKRX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 13:23:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43316 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbZGKRXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 13:23:55 -0400
Date: Sat, 11 Jul 2009 10:04:56 -0700
From: Greg KH <gregkh@suse.de>
To: Julia Lawall <julia@diku.dk>
Cc: jirislaby@gmail.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 5/5, revised] staging/otus: Drop an unnecessary NULL
 test
Message-ID: <20090711170456.GB5205@suse.de>
References: <Pine.LNX.4.64.0907111031480.29592@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0907111031480.29592@ask.diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 11, 2009 at 10:32:23AM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Apparently, the NULL test is not necessary at this point.
> 
> The semantic patch that finds this problem is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @@
> type T;
> expression E;
> identifier i,fld;
> statement S;
> @@
> 
> - T i = E->fld;
> + T i;
>   ... when != E
>       when != i
>   if (E == NULL) S
> + i = E->fld;
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/staging/otus/wwrap.c |    5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/staging/otus/wwrap.c b/drivers/staging/otus/wwrap.c
> index 4db8f6e..855ff41 100644
> --- a/drivers/staging/otus/wwrap.c
> +++ b/drivers/staging/otus/wwrap.c
> @@ -1018,11 +1018,6 @@ void kevent(struct work_struct *work)
>                 container_of(work, struct usbdrv_private, kevent);
>      zdev_t *dev = macp->device;
>  
> -    if (macp == NULL)
> -    {
> -        return;
> -    }
> -

Ok, that will teach me to read all of my mail before responding... :)

This looks good, I'll queue it up, thanks.

greg k-h
