Return-Path: <linux-kernel-owner+w=401wt.eu-S1753629AbYGWNgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbYGWNgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 09:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbYGWNgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 09:36:16 -0400
Received: from [85.204.20.254] ([85.204.20.254]:56939 "EHLO megainternet.ro"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751400AbYGWNgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 09:36:15 -0400
Subject: Re: [PATCH] cdc-acm: don't unlock acm->mutex on error path
From: Andrei Popa <andrei.popa@i-neo.ro>
Reply-To: andrei.popa@i-neo.ro
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, gregkh@suse.de
In-Reply-To: <20080723132310.GB4894@martell.zuzino.mipt.ru>
References: <1216817556.4415.29.camel@ierdnac>
	 <20080723132310.GB4894@martell.zuzino.mipt.ru>
Content-Type: text/plain
Organization: INEOSOFT
Date: Wed, 23 Jul 2008 16:36:05 +0300
Message-Id: <1216820165.4415.35.camel@ierdnac>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's ok now, thanks.

On Wed, 2008-07-23 at 17:23 +0400, Alexey Dobriyan wrote:
> On Wed, Jul 23, 2008 at 03:52:36PM +0300, Andrei Popa wrote:
> > I installed gnokii-0.6.22-r2 and gave the command "gnokii --identify"
> > and the kernel oopsed:
> > 
> > BUG: unable to handle kernel NULL pointer dereference at 00000458
> > IP: [<c0444b52>] mutex_unlock+0x0/0xb
> >  [<c03830ae>] acm_tty_open+0x4c/0x214
> 
> Try this:
> 
> [PATCH] cdc-acm: don't unlock acm->mutex on error path
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  drivers/usb/class/cdc-acm.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/usb/class/cdc-acm.c
> +++ b/drivers/usb/class/cdc-acm.c
> @@ -595,8 +595,8 @@ static int acm_tty_open(struct tty_struct *tty, struct file *filp)
>  	tasklet_schedule(&acm->urb_task);
>  
>  done:
> -err_out:
>  	mutex_unlock(&acm->mutex);
> +err_out:
>  	mutex_unlock(&open_mutex);
>  	return rv;
>  
> 

