Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835AbZBQJkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbZBQJkB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 04:40:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbZBQJju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 04:39:50 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35905 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbZBQJjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 04:39:49 -0500
Date: Tue, 17 Feb 2009 06:38:52 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>, mingo@elte.hu, x86@kernel.org,
       sam@ravnborg.org, jirislaby@gmail.com, gregkh@suse.de,
       davem@davemloft.net, xyzzy@speakeasy.org, jens.axboe@oracle.com,
       linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] Make exported headers use strict posix types
Message-ID: <20090217063852.6c8a7e97@pedra.chehab.org>
In-Reply-To: <200902051707.55457.arnd@arndb.de>
References: <20090204064307.GA18415@gondor.apana.org.au>
	<200902051530.25897.arnd@arndb.de>
	<498B0315.5080804@zytor.com>
	<200902051707.55457.arnd@arndb.de>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Feb 2009 17:07:53 +0100
Arnd Bergmann <arnd@arndb.de> wrote:

> A number of standard posix types are used in exported headers, which
> is not allowed if __STRICT_KERNEL_NAMES is defined. Change them all
> to use the safe __kernel variant so that we can make __STRICT_KERNEL_NAMES
> the default.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> [...]
> diff --git a/include/linux/dvb/video.h b/include/linux/dvb/video.h
> index bd49c3e..ee5d2df 100644
> --- a/include/linux/dvb/video.h
> +++ b/include/linux/dvb/video.h
> @@ -137,7 +137,7 @@ struct video_event {
>  #define VIDEO_EVENT_FRAME_RATE_CHANGED	2
>  #define VIDEO_EVENT_DECODER_STOPPED 	3
>  #define VIDEO_EVENT_VSYNC 		4
> -	time_t timestamp;
> +	__kernel_time_t timestamp;
>  	union {
>  		video_size_t size;
>  		unsigned int frame_rate;	/* in frames per 1000sec */
> [...]

For the dvb side, it seems ok.

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Cheers,
Mauro
