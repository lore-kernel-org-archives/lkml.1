Return-Path: <linux-kernel-owner+w=401wt.eu-S1765106AbXHPHUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765106AbXHPHUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 03:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756038AbXHPHUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 03:20:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:16098 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbXHPHUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 03:20:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=ewOKE6tGTRcMyER+am/7lf2Em8LG7Kxx4RrrxKWZ+h+mCYVLSDJHCoylk/WCZ5QljmCQ5Dua15MoEJ0WFA+p10ipLNZ85zTdqkweHQmYz4U9ufHyCgwXKQerhQ9uxP19L1tFaMmQ20n6V6GZE+ANNozoaWb0sYkJGYHqkFpRmaw=
Message-ID: <46C3FAB5.5070903@gmail.com>
Date: Thu, 16 Aug 2007 11:20:21 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] [2.6 patch] dvb_net_ule(): fix check-after-use
References: <20070814212241.GA18945@stusta.de>
In-Reply-To: <20070814212241.GA18945@stusta.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> The Coverity checker spotted that we'd have already oops'ed if "dev"
> was NULL.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> --- linux-2.6.23-rc1-mm2/drivers/media/dvb/dvb-core/dvb_net.c.old	2007-08-08 06:17:19.000000000 +0200
> +++ linux-2.6.23-rc1-mm2/drivers/media/dvb/dvb-core/dvb_net.c	2007-08-08 06:17:35.000000000 +0200
> @@ -346,33 +346,28 @@
>  static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
>  {
>  	struct dvb_net_priv *priv = dev->priv;
>  	unsigned long skipped = 0L;
>  	const u8 *ts, *ts_end, *from_where = NULL;
>  	u8 ts_remain = 0, how_much = 0, new_ts = 1;
>  	struct ethhdr *ethh = NULL;
>  
>  #ifdef ULE_DEBUG
>  	/* The code inside ULE_DEBUG keeps a history of the last 100 TS cells processed. */
>  	static unsigned char ule_hist[100*TS_SZ];
>  	static unsigned char *ule_where = ule_hist, ule_dump = 0;
>  #endif
>  
> -	if (dev == NULL) {
> -		printk( KERN_ERR "NO netdev struct!\n" );
> -		return;
> -	}
> -
>  	/* For all TS cells in current buffer.
>  	 * Appearently, we are called for every single TS cell.
>  	 */
>  	for (ts = buf, ts_end = buf + buf_len; ts < ts_end; /* no default incr. */ ) {
>  
>  		if (new_ts) {
>  			/* We are about to process a new TS cell. */
>  
>  #ifdef ULE_DEBUG
>  			if (ule_where >= &ule_hist[100*TS_SZ]) ule_where = ule_hist;
>  			memcpy( ule_where, ts, TS_SZ );
>  			if (ule_dump) {
>  				hexdump( ule_where, TS_SZ );
>  				ule_dump = 0;
> 
> 

Signed-off-by: Manu Abraham <manu@linuxtv.org>
