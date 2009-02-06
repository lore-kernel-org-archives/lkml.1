Return-Path: <linux-kernel-owner+w=401wt.eu-S1756829AbZBFTQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbZBFTQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 14:16:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753824AbZBFTQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 14:16:09 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:43452 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbZBFTQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 14:16:07 -0500
Date: Fri, 6 Feb 2009 21:15:59 +0200
From: Felipe Balbi <me@felipebalbi.com>
To: Bryan Wu <cooloney@kernel.org>
Cc: felipe.balbi@nokia.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH] usb: musb: tweak musb_read_fifo() to avoid unused
	warnings
Message-ID: <20090206191558.GD10711@frodo>
Reply-To: me@felipebalbi.com
References: <1233915736-18506-1-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233915736-18506-1-git-send-email-cooloney@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 06, 2009 at 06:22:16PM +0800, Bryan Wu wrote:
> From: Mike Frysinger <vapier.adi@gmail.com>

I'd like to get a patch body here.

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
>  	u8 epnum = hw_ep->epnum;
>  	u16 dma_reg = 0;

Is this patch avoiding a warning about these variables being unused ?

Would be nice to get this info to the patch body ;-)

otherwise, looks fine.

-- 
balbi
