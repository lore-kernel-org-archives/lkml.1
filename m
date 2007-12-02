Return-Path: <linux-kernel-owner+w=401wt.eu-S1756473AbXLBTt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473AbXLBTt7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 14:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754351AbXLBTtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 14:49:50 -0500
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4960 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbXLBTtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 14:49:49 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: v4l-dvb-maintainer@linuxtv.org
Subject: Re: [v4l-dvb-maintainer] [PATCH 1/2] ivtv: Some general fixes
Date: Sun, 2 Dec 2007 20:49:33 +0100
User-Agent: KMail/1.9.5
Cc: Richard Knutsson <ricknu-0@student.ltu.se>, mchehab@infradead.org,
       linux-kernel@vger.kernel.org
References: <20071202173329.15374.4223.sendpatchset@thinktank.campus.ltu.se>
In-Reply-To: <20071202173329.15374.4223.sendpatchset@thinktank.campus.ltu.se>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712022049.33601.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 December 2007 18:46, Richard Knutsson wrote:
> Fix "warning: Using plain integer as NULL pointer".

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

> Remove a gcc-2.95 requirement.

NACK! The main v4l-dvb repository that contains this driver can also be 
compiled on older systems. I'd like to keep the option that the driver 
can be compiled with an older gcc version, unless Mauro thinks 
otherwise. Other than the removal of one comment and one space there 
are no other benefits of this change, so I'd prefer to keep it.

> Convert 'x < y ? x : y' to use min() instead.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

Thanks,

	Hans


>
> Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
> ---
> Compile-tested on i386 with "allyesconfig" and "allmodconfig".
>
>  ivtv-driver.c  |    2 +-
>  ivtv-driver.h  |    4 +---
>  ivtv-ioctl.c   |    2 +-
>  ivtv-irq.c     |    4 ++--
>  ivtv-streams.c |    4 ++--
>  ivtvfb.c       |    2 +-
>  6 files changed, 8 insertions(+), 10 deletions(-)
>
>
> diff --git a/drivers/media/video/ivtv/ivtv-driver.c
> b/drivers/media/video/ivtv/ivtv-driver.c index 6d2dd87..96f340c
> 100644
> --- a/drivers/media/video/ivtv/ivtv-driver.c
> +++ b/drivers/media/video/ivtv/ivtv-driver.c
> @@ -979,7 +979,7 @@ static int __devinit ivtv_probe(struct pci_dev
> *dev, }
>
>  	itv = kzalloc(sizeof(struct ivtv), GFP_ATOMIC);
> -	if (itv == 0) {
> +	if (itv == NULL) {
>  		spin_unlock(&ivtv_cards_lock);
>  		return -ENOMEM;
>  	}
> diff --git a/drivers/media/video/ivtv/ivtv-driver.h
> b/drivers/media/video/ivtv/ivtv-driver.h index 49ce14d..5c4956c
> 100644
> --- a/drivers/media/video/ivtv/ivtv-driver.h
> +++ b/drivers/media/video/ivtv/ivtv-driver.h
> @@ -132,12 +132,10 @@ extern int ivtv_debug;
>  /* Flag to turn on high volume debugging */
>  #define IVTV_DBGFLG_HIGHVOL (1 << 10)
>
> -/* NOTE: extra space before comma in 'itv->num , ## args' is
> required for -   gcc-2.95, otherwise it won't compile. */
>  #define IVTV_DEBUG(x, type, fmt, args...) \
>  	do { \
>  		if ((x) & ivtv_debug) \
> -			printk(KERN_INFO "ivtv%d " type ": " fmt, itv->num , ## args); \
> +			printk(KERN_INFO "ivtv%d " type ": " fmt, itv->num, ## args); \
>  	} while (0)
>  #define IVTV_DEBUG_WARN(fmt, args...)  IVTV_DEBUG(IVTV_DBGFLG_WARN, 
> "warn",  fmt , ## args) #define IVTV_DEBUG_INFO(fmt, args...) 
> IVTV_DEBUG(IVTV_DBGFLG_INFO,  "info",  fmt , ## args) diff --git
> a/drivers/media/video/ivtv/ivtv-ioctl.c
> b/drivers/media/video/ivtv/ivtv-ioctl.c index fd6826f..24270de 100644
> --- a/drivers/media/video/ivtv/ivtv-ioctl.c
> +++ b/drivers/media/video/ivtv/ivtv-ioctl.c
> @@ -688,7 +688,7 @@ static int ivtv_debug_ioctls(struct file *filp,
> unsigned int cmd, void *arg) ivtv_reset_ir_gpio(itv);
>  		}
>  		if (val & 0x02) {
> -			itv->video_dec_func(itv, cmd, 0);
> +			itv->video_dec_func(itv, cmd, NULL);
>  		}
>  		break;
>  	}
> diff --git a/drivers/media/video/ivtv/ivtv-irq.c
> b/drivers/media/video/ivtv/ivtv-irq.c index fd1688e..1384615 100644
> --- a/drivers/media/video/ivtv/ivtv-irq.c
> +++ b/drivers/media/video/ivtv/ivtv-irq.c
> @@ -204,7 +204,7 @@ static int stream_enc_dma_append(struct
> ivtv_stream *s, u32 data[CX2341X_MBOX_MA s->sg_pending[idx].dst =
> buf->dma_handle;
>  		s->sg_pending[idx].src = offset;
>  		s->sg_pending[idx].size = s->buf_size;
> -		buf->bytesused = (size < s->buf_size) ? size : s->buf_size;
> +		buf->bytesused = min(size, s->buf_size);
>  		buf->dma_xfer_cnt = s->dma_xfer_cnt;
>
>  		s->q_predma.bytesused += buf->bytesused;
> @@ -705,7 +705,7 @@ static void ivtv_irq_dec_data_req(struct ivtv
> *itv) s = &itv->streams[IVTV_DEC_STREAM_TYPE_YUV];
>  	}
>  	else {
> -		itv->dma_data_req_size = data[2] >= 0x10000 ? 0x10000 : data[2];
> +		itv->dma_data_req_size = min_t(u32, data[2], 0x10000);
>  		itv->dma_data_req_offset = data[1];
>  		s = &itv->streams[IVTV_DEC_STREAM_TYPE_MPG];
>  	}
> diff --git a/drivers/media/video/ivtv/ivtv-streams.c
> b/drivers/media/video/ivtv/ivtv-streams.c index aa03e61..0e9e7d0
> 100644
> --- a/drivers/media/video/ivtv/ivtv-streams.c
> +++ b/drivers/media/video/ivtv/ivtv-streams.c
> @@ -572,10 +572,10 @@ int ivtv_start_v4l2_encode_stream(struct
> ivtv_stream *s) clear_bit(IVTV_F_I_EOS, &itv->i_flags);
>
>  		/* Initialize Digitizer for Capture */
> -		itv->video_dec_func(itv, VIDIOC_STREAMOFF, 0);
> +		itv->video_dec_func(itv, VIDIOC_STREAMOFF, NULL);
>  		ivtv_msleep_timeout(300, 1);
>  		ivtv_vapi(itv, CX2341X_ENC_INITIALIZE_INPUT, 0);
> -		itv->video_dec_func(itv, VIDIOC_STREAMON, 0);
> +		itv->video_dec_func(itv, VIDIOC_STREAMON, NULL);
>  	}
>
>  	/* begin_capture */
> diff --git a/drivers/media/video/ivtv/ivtvfb.c
> b/drivers/media/video/ivtv/ivtvfb.c index 52ffd15..f73ce98 100644
> --- a/drivers/media/video/ivtv/ivtvfb.c
> +++ b/drivers/media/video/ivtv/ivtvfb.c
> @@ -1053,7 +1053,7 @@ static int ivtvfb_init_card(struct ivtv *itv)
>  	}
>
>  	itv->osd_info = kzalloc(sizeof(struct osd_info), GFP_ATOMIC);
> -	if (itv->osd_info == 0) {
> +	if (itv->osd_info == NULL) {
>  		IVTVFB_ERR("Failed to allocate memory for osd_info\n");
>  		return -ENOMEM;
>  	}
>
> _______________________________________________
> v4l-dvb-maintainer mailing list
> v4l-dvb-maintainer@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/v4l-dvb-maintainer
