Return-Path: <linux-kernel-owner+w=401wt.eu-S1756497Ab0A0X0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab0A0X0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 18:26:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755589Ab0A0X0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 18:26:21 -0500
Received: from mail1.radix.net ([207.192.128.31]:48120 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755437Ab0A0X0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 18:26:20 -0500
Subject: Re: linux-next: v4l-dvb tree build failure
From: Andy Walls <awalls@radix.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Devin Heitmueller <dheitmueller@kernellabs.com>
In-Reply-To: <20100127175917.5d690f52.sfr@canb.auug.org.au>
References: <20100127175917.5d690f52.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Wed, 27 Jan 2010 18:24:48 -0500
Message-Id: <1264634688.3088.1.camel@palomino.walls.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-27 at 17:59 +1100, Stephen Rothwell wrote:
> Hi Mauro,
> 
> Today's linux-next build (powerpc allyesconfig) failed like this:
> 
> drivers/media/video/cx18/cx18-alsa-pcm.c: In function 'snd_pcm_alloc_vmalloc_buffer':
> drivers/media/video/cx18/cx18-alsa-pcm.c:234: error: implicit declaration of function 'vfree'
> drivers/media/video/cx18/cx18-alsa-pcm.c:236: error: implicit declaration of function 'vmalloc'
> 
> Caused by commit 5e9a302853301e0a2bb6671036daac3366fd85f4 ("V4L/DVB: cx18: overhaul ALSA PCM device handling so it works").
> 
> I applied the following patch for today.
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 27 Jan 2010 17:53:39 +1100
> Subject: [PATCH] V4L/DVB: using vmalloc requires include of linux/vmalloc.h
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Stephen,

Looks good to me.

Acked-by: Andy Walls <awalls@radix.net>

Regards,
Andy

> ---
>  drivers/media/video/cx18/cx18-alsa-pcm.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/cx18/cx18-alsa-pcm.c b/drivers/media/video/cx18/cx18-alsa-pcm.c
> index 6e56df9..b9f42b1 100644
> --- a/drivers/media/video/cx18/cx18-alsa-pcm.c
> +++ b/drivers/media/video/cx18/cx18-alsa-pcm.c
> @@ -25,6 +25,7 @@
>  
>  #include <linux/init.h>
>  #include <linux/kernel.h>
> +#include <linux/vmalloc.h>
>  
>  #include <media/v4l2-device.h>
>  
> -- 
> 1.6.6
> 

