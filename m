Return-Path: <linux-kernel-owner+w=401wt.eu-S1762590AbYA1XBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762590AbYA1XBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758890AbYA1XA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:00:59 -0500
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1714 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758271AbYA1XA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:00:58 -0500
X-Greylist: delayed 568 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jan 2008 18:00:57 EST
From: Hans Verkuil <hverkuil@xs4all.nl>
To: v4l-dvb-maintainer@linuxtv.org
Subject: Re: [v4l-dvb-maintainer] [2.6 patch] ivtv-yuv.c: make 3 functions static
Date: Mon, 28 Jan 2008 23:50:22 +0100
User-Agent: KMail/1.9.7
Cc: Adrian Bunk <bunk@kernel.org>, Ian Armstrong <ian@iarmst.demon.co.uk>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org, ivtv-devel@ivtvdriver.org
References: <20080128221053.GS8767@does.not.exist>
In-Reply-To: <20080128221053.GS8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801282350.22243.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 January 2008 23:10:53 Adrian Bunk wrote:
> This patch makes the following needlessly global functions static:
> - ivtv_yuv_next_free()
> - ivtv_yuv_setup_frame()
> - ivtv_yuv_udma_frame()
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

Mauro, feel free to merge. Alternatively, I can add it to my v4l-dvb 
tree which has some additional patches (will post a PULL request for 
that in the next few days).

Regards,

	Hans

>
> ---
>
>  drivers/media/video/ivtv/ivtv-yuv.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> d73b9df5534f05010ef1c46db1ed2fe28874cfc1
> diff --git a/drivers/media/video/ivtv/ivtv-yuv.c
> b/drivers/media/video/ivtv/ivtv-yuv.c index 8518348..8fdd67c 100644
> --- a/drivers/media/video/ivtv/ivtv-yuv.c
> +++ b/drivers/media/video/ivtv/ivtv-yuv.c
> @@ -914,7 +914,7 @@ static void ivtv_yuv_init(struct ivtv *itv)
>  }
>
>  /* Get next available yuv buffer on PVR350 */
> -void ivtv_yuv_next_free(struct ivtv *itv)
> +static void ivtv_yuv_next_free(struct ivtv *itv)
>  {
>  	int draw, display;
>  	struct yuv_playback_info *yi = &itv->yuv_info;
> @@ -937,7 +937,7 @@ void ivtv_yuv_next_free(struct ivtv *itv)
>  }
>
>  /* Set up frame according to ivtv_dma_frame parameters */
> -void ivtv_yuv_setup_frame(struct ivtv *itv, struct ivtv_dma_frame
> *args) +static void ivtv_yuv_setup_frame(struct ivtv *itv, struct
> ivtv_dma_frame *args) {
>  	struct yuv_playback_info *yi = &itv->yuv_info;
>  	u8 frame = yi->draw_frame;
> @@ -1042,7 +1042,7 @@ void ivtv_yuv_frame_complete(struct ivtv *itv)
>  			(itv->yuv_info.draw_frame + 1) % IVTV_YUV_BUFFERS);
>  }
>
> -int ivtv_yuv_udma_frame(struct ivtv *itv, struct ivtv_dma_frame
> *args) +static int ivtv_yuv_udma_frame(struct ivtv *itv, struct
> ivtv_dma_frame *args) {
>  	DEFINE_WAIT(wait);
>  	int rc = 0;
>
>
> _______________________________________________
> v4l-dvb-maintainer mailing list
> v4l-dvb-maintainer@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/v4l-dvb-maintainer


