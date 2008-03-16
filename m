Return-Path: <linux-kernel-owner+w=401wt.eu-S1753467AbYCPT5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbYCPT5e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 15:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbYCPT5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 15:57:25 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:49136 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752353AbYCPT5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 15:57:24 -0400
X-Sasl-enc: DN0YFK6RNgPEKTeJphJ+hnKUiO8IaUsLl2dopfYIo/M7 1205697443
Date: Sun, 16 Mar 2008 16:57:22 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Antonino Daplas <adaplas@pol.net>
Subject: Re: [PATCH] i810fb: Fix console switch regression
Message-ID: <20080316195722.GB31782@khazad-dum.debian.net>
References: <200803161942.24555.stefan.bauer@cs.tu-chemnitz.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803161942.24555.stefan.bauer@cs.tu-chemnitz.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Mar 2008, Stefan Bauer wrote:
> From: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>
> 
> Commit eaa0ff15c30dc9799eb4d12660edb73aeb6d32c5 ("fix ! versus & precedence in 
> various places") introduced a regression in console switching when using 
> i810fb. Every 5th to 10th console switch causes 'pixel waste' - the same line 
> of multi-colored pixels repeated over the whole screen.
> This reverts eaa0ff1 for i810_main.c.
> 
> Signed-off-by: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>
> Cc: Antonino Daplas <adaplas@pol.net>
> 
> ---
> As I'm not subscribed to the LKML, please CC me, thanks.
> 
> --- linux-2.6/drivers/video/i810/i810_main.c.orig
> +++ linux-2.6/drivers/video/i810/i810_main.c
> @@ -1476,7 +1476,7 @@ static int i810fb_cursor(struct fb_info 
> 	struct i810fb_par *par = info->par;
> 	u8 __iomem *mmio = par->mmio_start_virtual;
> 
> -	if (!(par->dev_flags & LOCKUP))
> +	if (!par->dev_flags & LOCKUP)
> 		return -ENXIO;
> 
> 	if (cursor->image.width > 64 || cursor->image.height > 64)
> --

I think you need to add something to that line that avoids someone making
the same change as eaa0ff15c30dc9799eb4d12660edb73aeb6d32c5 some years down
the road.

Might I suggest using "((!par->dev_flags) & LOCKUP)"?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
