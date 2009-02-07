Return-Path: <linux-kernel-owner+w=401wt.eu-S1752776AbZBGAyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbZBGAyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 19:54:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752912AbZBGAxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 19:53:47 -0500
Received: from kroah.org ([198.145.64.141]:36069 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752776AbZBGAxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 19:53:46 -0500
Date: Fri, 6 Feb 2009 16:01:48 -0800
From: Greg KH <greg@kroah.com>
To: Bryan Wu <cooloney@kernel.org>
Cc: felipe.balbi@nokia.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH] usb: musb: tweak musb_read_fifo() to avoid unused
	warnings
Message-ID: <20090207000148.GF31059@kroah.com>
References: <1233915736-18506-1-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233915736-18506-1-git-send-email-cooloney@kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 06, 2009 at 06:22:16PM +0800, Bryan Wu wrote:
> From: Mike Frysinger <vapier.adi@gmail.com>
> 
> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  drivers/usb/musb/blackfin.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/usb/musb/blackfin.c b/drivers/usb/musb/blackfin.c
> index 7861348..0ebb19d 100644
> --- a/drivers/usb/musb/blackfin.c
> +++ b/drivers/usb/musb/blackfin.c
> @@ -54,13 +54,11 @@ void musb_write_fifo(struct musb_hw_ep *hw_ep, u16 len, const u8 *src)
>  void musb_read_fifo(struct musb_hw_ep *hw_ep, u16 len, u8 *dst)
>  {
>  	void __iomem *fifo = hw_ep->fifo;
> +
> +#ifdef CONFIG_BF52x

Any way we can just not have ifdefs in .c files alltogether?

thanks,

greg k-h
