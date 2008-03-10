Return-Path: <linux-kernel-owner+w=401wt.eu-S1751364AbYCJMZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364AbYCJMZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 08:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbYCJMZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 08:25:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56074 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbYCJMZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 08:25:23 -0400
Date: Mon, 10 Mar 2008 09:23:57 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: Joe Perches <joe@perches.com>, v4l-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] em28xx-core.c: add missing parentheses in
 em28xx_write_ac97()
Message-ID: <20080310092357.61020c7e@gaivota>
In-Reply-To: <47CEE9E2.6040303@tiscali.nl>
References: <47CEDE8D.7090707@tiscali.nl>
	<1204740974.17370.29.camel@localhost>
	<47CEE9E2.6040303@tiscali.nl>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel and Joe,

Thanks for your patches.

I've already received and committed two patches with your proposed changes:

http://linuxtv.org/hg/v4l-dvb/rev/127f67dea087
http://linuxtv.org/hg/v4l-dvb/rev/f83ed13f5bf5

Cheers,
Mauro

On Wed, 05 Mar 2008 19:43:46 +0100
Roel Kluin <12o3l@tiscali.nl> wrote:

> Joe Perches wrote:
> 
> >> -		if (!((u8) ret) & 0x01)
> >> +		if (!(((u8) ret) & 0x01))
> > 
> > I think it'd be clearer without the cast to (u8)
> > which is then implicit cast back to int anyway
> > 
> > 	if (!(ret & 1))
> 
> ok.
> ---
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/drivers/media/video/em28xx/em28xx-core.c b/drivers/media/video/em28xx/em28xx-core.c
> index 7d1537c..c797472 100644
> --- a/drivers/media/video/em28xx/em28xx-core.c
> +++ b/drivers/media/video/em28xx/em28xx-core.c
> @@ -267,7 +267,7 @@ static int em28xx_write_ac97(struct em28xx *dev, u8 reg, u8 *val)
>  	for (i = 0; i < 10; i++) {
>  		if ((ret = em28xx_read_reg(dev, AC97BUSY_REG)) < 0)
>  			return ret;
> -		if (!((u8) ret) & 0x01)
> +		if (!(ret & 1))
>  			return 0;
>  		msleep(5);
>  	}




Cheers,
Mauro
