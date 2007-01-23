Return-Path: <linux-kernel-owner+w=401wt.eu-S965584AbXAWXKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965584AbXAWXKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 18:10:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965586AbXAWXKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 18:10:21 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56502 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965584AbXAWXKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 18:10:19 -0500
Subject: Re: [PATCH] videobuf_qbuf: fix? possible videobuf_queue->stream
	corruption and lockup
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Chris Wright <chrisw@sous-sol.org>, Adrian Bunk <bunk@stusta.de>
In-Reply-To: <20070123175714.GA299@tv-sign.ru>
References: <20070123175714.GA299@tv-sign.ru>
Content-Type: text/plain; charset=ISO-8859-15
Date: Tue, 23 Jan 2007 21:10:08 -0200
Message-Id: <1169593808.18437.4.camel@areia>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0-1mdv2007.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Ter, 2007-01-23 às 20:57 +0300, Oleg Nesterov escreveu:
> I am pretty sure the bug is real, but the patch may be wrong, please review.
> 
> We are doing ->buf_prepare(buf) before adding buf to q->stream list. This
> means that videobuf_qbuf() should not try to re-add a STATE_PREPARED buffer.
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>

Chris/Adrian,

IMO, this should also be applied at -stable trees.
> 
> --- 6.19/drivers/media/video/video-buf.c~v4l_lockup	2006-11-17 19:42:25.000000000 +0300
> +++ 6.19/drivers/media/video/video-buf.c	2007-01-23 19:44:19.000000000 +0300
> @@ -700,6 +700,7 @@ videobuf_qbuf(struct videobuf_queue *q,
>  		goto done;
>  	}
>  	if (buf->state == STATE_QUEUED ||
> +	    buf->state == STATE_PREPARED ||
>  	    buf->state == STATE_ACTIVE) {
>  		dprintk(1,"qbuf: buffer is already queued or active.\n");
>  		goto done;
> 

