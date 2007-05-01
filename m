Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbXEARDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbXEARDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 13:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754854AbXEARDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 13:03:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37288 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbXEARDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 13:03:39 -0400
Subject: Re: [PATCH] VIDEO4LINUX-2: Replace MINOR() with a call to iminor().
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, michael@mihu.de,
       Hans Verkuil <hverkuil@xs4all.nl>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>
In-Reply-To: <Pine.LNX.4.64.0704280628180.571@localhost.localdomain>
References: <Pine.LNX.4.64.0704280628180.571@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 01 May 2007 14:03:30 -0300
Message-Id: <1178039010.6754.20.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

Em Sáb, 2007-04-28 às 06:32 -0400, Robert P. J. Day escreveu:
> Replace the call to MINOR() with a call to the inline iminor()
> routine.
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> 
> ---
> 
> that's the last of those changes, but it's not clear who the official
> maintainer is, so i took a chance and picked a likely looking victim
> out of the MAINTAINERS file.  apologies if i picked wrong.

You've picked it wrongly. The Maintainer for ivtv is Hans Verkuil.
However, for every stuff under drivers/media, you can reach the active
maintainers at v4l-dvb-maintainers list
(v4l-dvb-maintainer@linuxtv.org).

Hans,

If you are ok with this trivial change, please send me your acked-by or
SOB for me to commit and send to mainstream.
> 
> 
> diff --git a/drivers/media/video/ivtv/ivtv-fileops.c b/drivers/media/video/ivtv/ivtv-fileops.c
> index 1637097..8976487 100644
> --- a/drivers/media/video/ivtv/ivtv-fileops.c
> +++ b/drivers/media/video/ivtv/ivtv-fileops.c
> @@ -804,7 +804,7 @@ int ivtv_v4l2_open(struct inode *inode, struct file *filp)
>  	struct ivtv_open_id *item;
>  	struct ivtv *itv = NULL;
>  	struct ivtv_stream *s = NULL;
> -	int minor = MINOR(inode->i_rdev);
> +	int minor = iminor(inode);
> 
>  	/* Find which card this open was on */
>  	spin_lock(&ivtv_cards_lock);
-- 
Cheers,
Mauro

