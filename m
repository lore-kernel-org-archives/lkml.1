Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab0BXDg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 22:36:26 -0500
Received: from cantor.suse.de ([195.135.220.2]:52602 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab0BXDgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 22:36:25 -0500
Date: Tue, 23 Feb 2010 17:56:57 -0800
From: Greg KH <gregkh@suse.de>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/serial2002: Fix filp_open usage
Message-ID: <20100224015657.GB13959@suse.de>
References: <87zl31b0zp.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zl31b0zp.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 03:04:42AM +0900, OGAWA Hirofumi wrote:
> 
> Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> ---
> 
>  drivers/staging/comedi/drivers/serial2002.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -puN drivers/staging/comedi/drivers/serial2002.c~serial2002-filp_open-fix drivers/staging/comedi/drivers/serial2002.c
> --- linux-2.6/drivers/staging/comedi/drivers/serial2002.c~serial2002-filp_open-fix	2010-02-22 23:22:27.000000000 +0900
> +++ linux-2.6-hirofumi/drivers/staging/comedi/drivers/serial2002.c	2010-02-22 23:22:27.000000000 +0900
> @@ -397,7 +397,7 @@ static void serial_2002_open(struct come
>  	char port[20];
>  
>  	sprintf(port, "/dev/ttyS%d", devpriv->port);
> -	devpriv->tty = filp_open(port, 0, O_RDWR);
> +	devpriv->tty = filp_open(port, O_RDWR, 0);

Oh wow that code is scary :)

I'll queue this up and remember to nuke the whole thing soon...

thanks,

greg k-h
