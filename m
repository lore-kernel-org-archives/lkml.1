Return-Path: <linux-kernel-owner+w=401wt.eu-S1757376AbZBKWYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbZBKWYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 17:24:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754589AbZBKWYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 17:24:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48380 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754219AbZBKWYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 17:24:34 -0500
Date: Wed, 11 Feb 2009 14:24:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Risto Suominen <risto.suominen@gmail.com>
Cc: geert@linux-m68k.org, adaplas@pol.net,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH] fb: hide cursor in graphics mode
Message-Id: <20090211142409.b88c577e.akpm@linux-foundation.org>
In-Reply-To: <46e1c7760902101350r5a04d076j49cc611a843e6429@mail.gmail.com>
References: <46e1c7760901230433i3045f273oa109ce97e790bca3@mail.gmail.com>
	<Pine.LNX.4.64.0901240951110.13803@anakin>
	<46e1c7760901240109m5a0f3a85p788aa3ce35b49fa9@mail.gmail.com>
	<Pine.LNX.4.64.0901241425310.13803@anakin>
	<46e1c7760901240649v1e45bbb1v8c9997f236a3ec4c@mail.gmail.com>
	<46e1c7760902101337qe239336n9ef2652a47f89aed@mail.gmail.com>
	<46e1c7760902101350r5a04d076j49cc611a843e6429@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Feb 2009 23:50:08 +0200
Risto Suominen <risto.suominen@gmail.com> wrote:

> The same as attachment, so the last line won't disappear.
> 
> Risto
> 
> 
> [fbcon-graphics-nocursor.diff  application/octet-stream (814B)]

help.  My knowledge of fbcon is near zero.

> Xserver Xfbdev (kdrive) uses linux framebuffer in graphics mode. It doesn't
> need the text mode cursor, it's a bit annoying to have it there sitting in a
> corner. This patch disables the cursor even when in graphics mode.
> 
> Signed-off-by: Risto Suominen <Risto.Suominen@gmail.com>
> ---
> The testing is done on kernel version 2.6.18.

That's a truly ancient kernel.  Is the patch needed on current kernels?
Does it work correctly in current kernels?

> --- a/drivers/video/console/fbcon.c.org	2007-03-03 07:14:54.000000000 +0200
> +++ b/drivers/video/console/fbcon.c	2009-01-23 12:42:14.000000000 +0200
> @@ -1363,6 +1363,12 @@ static void fbcon_cursor(struct vc_data 
>  	int y;
>   	int c = scr_readw((u16 *) vc->vc_pos);
>  
> +	if (mode == CM_ERASE && info->fbops->fb_cursor) {
> +		/* Hide H/W-cursor unconditionally */
> +		ops->cursor(vc, info, mode, 0, 0, 0);
> +		return;
> +	}
> +
>  	if (fbcon_is_inactive(vc, info) || vc->vc_deccm != 1)
>  		return;
>  

How does the cursor get re-enabled?

Should we be calling ops->cursor() if fbcon_is_inactive() is true?
