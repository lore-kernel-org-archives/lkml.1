Return-Path: <linux-kernel-owner+w=401wt.eu-S1752705AbXCEHFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbXCEHFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 02:05:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbXCEHFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 02:05:07 -0500
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4007 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbXCEHFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 02:05:04 -0500
X-Greylist: delayed 580 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Mar 2007 02:05:03 EST
From: Hans Verkuil <hverkuil@xs4all.nl>
To: v4l-dvb-maintainer@linuxtv.org
Subject: Re: [v4l-dvb-maintainer] [-mm patch] drivers/media/video/ivtv/: possible cleanups
Date: Mon, 5 Mar 2007 07:53:30 +0100
User-Agent: KMail/1.9.5
Cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       mchehab@infradead.org, linux-kernel@vger.kernel.org
References: <20070302030026.5eef0c92.akpm@linux-foundation.org> <20070305014919.GV3441@stusta.de>
In-Reply-To: <20070305014919.GV3441@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703050753.30953.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 March 2007 02:49, Adrian Bunk wrote:
> On Fri, Mar 02, 2007 at 03:00:26AM -0800, Andrew Morton wrote:
> >...
> > Changes since 2.6.20-mm2:
> >...
> >  git-dvb.patch
> >...
> >  git trees
> >...
>
> This patch contains the following possible cleanups:
> - every file should #include the headers containing the prototypes
> for it's global functions
> - make the following needlessly global variables static:
>   - ivtv-driver.c: newi2c
>   - ivtv-streams.c: struct ivtv_stream_info[]
> - make the following needlessly global functions static:
>   - ivtv-fileops.c: ivtv_stop_decoding()
>   - ivtv-i2c.c: ivtv_i2c_id_addr()
> - #if 0 the following unused global functions:
>   - ivtv-i2c.c: ivtv_msp34xx()
>   - ivtv-udma.c: ivtv_udma_setup()
>   - ivtv-video.c: ivtv_encoder_enable()
> - ivtv-driver.c: remove the unused EXPORT_SYMBOL's
>
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

NACK.

A patch to fix the needlessly global functions is already in v4l-dvb, 
and the 'unused EXPORT_SYMBOLs' ARE in fact used by the ivtv-fb 
framebuffer. This module is not yet in the kernel, although I hope to 
do that for 2.6.22.

Regards,

	Hans

>
> ---
>
>  drivers/media/video/ivtv/ivtv-driver.c  |   16 +---------------
>  drivers/media/video/ivtv/ivtv-fileops.c |    2 +-
>  drivers/media/video/ivtv/ivtv-fileops.h |    1 -
>  drivers/media/video/ivtv/ivtv-i2c.c     |    5 ++++-
>  drivers/media/video/ivtv/ivtv-i2c.h     |    2 --
>  drivers/media/video/ivtv/ivtv-streams.c |    2 +-
>  drivers/media/video/ivtv/ivtv-udma.c    |    2 ++
>  drivers/media/video/ivtv/ivtv-udma.h    |    2 --
>  drivers/media/video/ivtv/ivtv-video.c   |    2 ++
>  drivers/media/video/ivtv/ivtv-video.h   |    1 -
>  drivers/media/video/ivtv/ivtv-yuv.c     |    1 +
>  11 files changed, 12 insertions(+), 24 deletions(-)
>
> ---
> linux-2.6.21-rc2-mm1/drivers/media/video/ivtv/ivtv-driver.c.old	2007-
>03-04 21:00:12.000000000 +0100 +++
> linux-2.6.21-rc2-mm1/drivers/media/video/ivtv/ivtv-driver.c	2007-03-0
>4 21:04:50.000000000 +0100 @@ -121,7 +121,7 @@
>
>  int ivtv_debug = 0;
>
> -int newi2c = -1;
> +static int newi2c = -1;
>
>  module_param_array(tuner, int, &tuner_c, 0644);
>  module_param_array(radio, bool, &radio_c, 0644);
> @@ -1367,19 +1367,5 @@
>  	pci_unregister_driver(&ivtv_pci_driver);
>  }
>
> -EXPORT_SYMBOL(ivtv_set_irq_mask);
> -EXPORT_SYMBOL(ivtv_cards_active);
> -EXPORT_SYMBOL(ivtv_cards);
> -EXPORT_SYMBOL(ivtv_api);
> -EXPORT_SYMBOL(ivtv_vapi);
> -EXPORT_SYMBOL(ivtv_vapi_result);
> -EXPORT_SYMBOL(ivtv_clear_irq_mask);
> -EXPORT_SYMBOL(ivtv_debug);
> -EXPORT_SYMBOL(ivtv_reset_ir_gpio);
> -EXPORT_SYMBOL(ivtv_udma_setup);
> -EXPORT_SYMBOL(ivtv_udma_unmap);
> -EXPORT_SYMBOL(ivtv_udma_alloc);
> -EXPORT_SYMBOL(ivtv_udma_prepare);
> -
>  module_init(module_start);
>  module_exit(module_cleanup);
> ---
> linux-2.6.21-rc2-mm1/drivers/media/video/ivtv/ivtv-fileops.h.old	2007
>-03-04 21:00:35.000000000 +0100 +++
> linux-2.6.21-rc2-mm1/drivers/media/video/ivtv/ivtv-fileops.h	2007-03-
>04 21:00:41.000000000 +0100 @@ -30,7 +30,6 @@
>  int ivtv_start_capture(struct ivtv_open_id *id);
>  void ivtv_stop_capture(struct ivtv_open_id *id, int gop_end);
>  int ivtv_start_decoding(struct ivtv_open_id *id, int speed);
> -void ivtv_stop_decoding(struct ivtv_open_id *id, int flags, u64
> pts); void ivtv_mute(struct ivtv *itv);
>  void ivtv_unmute(struct ivtv *itv);
>
> ---
> linux-2.6.21-rc2-mm1/drivers/media/video/ivtv/ivtv-fileops.c.old	2007
>-03-04 21:00:50.000000000 +0100 +++
> linux-2.6.21-rc2-mm1/drivers/media/video/ivtv/ivtv-fileops.c	2007-03-
>04 21:01:01.000000000 +0100 @@ -730,7 +730,7 @@
>  	ivtv_release_stream(s);
>  }
>
> -void ivtv_stop_decoding(struct ivtv_open_id *id, int flags, u64 pts)
> +static void ivtv_stop_decoding(struct ivtv_open_id *id, int flags,
> u64 pts) {
>  	struct ivtv *itv = id->itv;
>  	struct ivtv_stream *s = &itv->streams[id->type];
> ---
> linux-2.6.21-rc2-mm1/drivers/media/video/ivtv/ivtv-i2c.h.old	2007-03-
>04 21:01:31.000000000 +0100 +++
> linux-2.6.21-rc2-mm1/drivers/media/video/ivtv/ivtv-i2c.h	2007-03-04
> 21:02:07.000000000 +0100 @@ -22,11 +22,9 @@
>  int ivtv_saa7115(struct ivtv *itv, unsigned int cmd, void *arg);
>  int ivtv_saa7127(struct ivtv *itv, unsigned int cmd, void *arg);
>  int ivtv_saa717x(struct ivtv *itv, unsigned int cmd, void *arg);
> -int ivtv_msp34xx(struct ivtv *itv, unsigned int cmd, void *arg);
>  int ivtv_upd64031a(struct ivtv *itv, unsigned int cmd, void *arg);
>  int ivtv_upd64083(struct ivtv *itv, unsigned int cmd, void *arg);
>
> -int ivtv_i2c_id_addr(struct ivtv *itv, u32 id);
>  int ivtv_i2c_hw_addr(struct ivtv *itv, u32 hw);
>  int ivtv_i2c_hw(struct ivtv *itv, u32 hw, unsigned int cmd, void
> *arg); int ivtv_i2c_id(struct ivtv *itv, u32 id, unsigned int cmd,
> void *arg); ---
> linux-2.6.21-rc2-mm1/drivers/media/video/ivtv/ivtv-i2c.c.old	2007-03-
>04 21:01:43.000000000 +0100 +++
> linux-2.6.21-rc2-mm1/drivers/media/video/ivtv/ivtv-i2c.c	2007-03-04
> 21:27:22.000000000 +0100 @@ -62,6 +62,7 @@
>  #include "ivtv-driver.h"
>  #include "ivtv-cards.h"
>  #include "ivtv-gpio.h"
> +#include "ivtv-i2c.h"
>
>  #include <media/ir-kbd-i2c.h>
>
> @@ -574,7 +575,7 @@
>
>  /* Find the i2c device based on the driver ID and return
>     its i2c address or -ENODEV if no matching device was found. */
> -int ivtv_i2c_id_addr(struct ivtv *itv, u32 id)
> +static int ivtv_i2c_id_addr(struct ivtv *itv, u32 id)
>  {
>  	struct i2c_client *client;
>  	int retval = -ENODEV;
> @@ -681,10 +682,12 @@
>  	return ivtv_call_i2c_client(itv, IVTV_SAA717x_I2C_ADDR, cmd, arg);
>  }
>
> +#if 0
>  int ivtv_msp34xx(struct ivtv *itv, unsigned int cmd, void *arg)
>  {
>  	return ivtv_call_i2c_client(itv, IVTV_MSP3400_I2C_ADDR, cmd, arg);
>  }
> +#endif  /*  0  */
>
>  int ivtv_upd64031a(struct ivtv *itv, unsigned int cmd, void *arg)
>  {
> ---
> linux-2.6.21-rc2-mm1/drivers/media/video/ivtv/ivtv-streams.c.old	2007
>-03-04 21:02:36.000000000 +0100 +++
> linux-2.6.21-rc2-mm1/drivers/media/video/ivtv/ivtv-streams.c	2007-03-
>04 21:02:44.000000000 +0100 @@ -66,7 +66,7 @@
>        .poll = ivtv_v4l2_dec_poll,
>  };
>
> -struct {
> +static struct {
>  	const char *name;
>  	int vfl_type;
>  	int minor_offset;
> ---
> linux-2.6.21-rc2-mm1/drivers/media/video/ivtv/ivtv-udma.h.old	2007-03
>-04 21:03:09.000000000 +0100 +++
> linux-2.6.21-rc2-mm1/drivers/media/video/ivtv/ivtv-udma.h	2007-03-04
> 21:03:16.000000000 +0100 @@ -22,8 +22,6 @@
>  void ivtv_udma_get_page_info(struct ivtv_dma_page_info *dma_page,
> unsigned long first, unsigned long size); int
> ivtv_udma_fill_sg_list(struct ivtv_user_dma *dma, struct
> ivtv_dma_page_info *dma_page, int map_offset); void
> ivtv_udma_fill_sg_array(struct ivtv_user_dma *dma, u32 buffer_offset,
> u32 buffer_offset_2, u32 split); -int ivtv_udma_setup(struct ivtv
> *itv, unsigned long ivtv_dest_addr, -		       void __user *userbuf,
> int size_in_bytes);
>  void ivtv_udma_unmap(struct ivtv *itv);
>  void ivtv_udma_free(struct ivtv *itv);
>  void ivtv_udma_alloc(struct ivtv *itv);
> ---
> linux-2.6.21-rc2-mm1/drivers/media/video/ivtv/ivtv-udma.c.old	2007-03
>-04 21:05:07.000000000 +0100 +++
> linux-2.6.21-rc2-mm1/drivers/media/video/ivtv/ivtv-udma.c	2007-03-04
> 21:05:30.000000000 +0100 @@ -84,6 +84,7 @@
>  	}
>  }
>
> +#if 0
>  int ivtv_udma_setup(struct ivtv *itv, unsigned long ivtv_dest_addr,
>  		       void __user *userbuf, int size_in_bytes)
>  {
> @@ -137,6 +138,7 @@
>  	ivtv_udma_sync_for_device(itv);
>  	return dma->page_count;
>  }
> +#endif  /*  0  */
>
>  void ivtv_udma_unmap(struct ivtv *itv)
>  {
> ---
> linux-2.6.21-rc2-mm1/drivers/media/video/ivtv/ivtv-video.h.old	2007-0
>3-04 21:06:31.000000000 +0100 +++
> linux-2.6.21-rc2-mm1/drivers/media/video/ivtv/ivtv-video.h	2007-03-04
> 21:06:38.000000000 +0100 @@ -21,5 +21,4 @@
>  void ivtv_set_cc(struct ivtv *itv, int mode, u8 cc1, u8 cc2, u8 cc3,
> u8 cc4); void ivtv_set_vps(struct ivtv *itv, int enabled, u8 vps1, u8
> vps2, u8 vps3, u8 vps4, u8 vps5);
> -void ivtv_encoder_enable(struct ivtv *itv, int enabled);
>  void ivtv_video_set_io(struct ivtv *itv);
> ---
> linux-2.6.21-rc2-mm1/drivers/media/video/ivtv/ivtv-video.c.old	2007-0
>3-04 21:06:46.000000000 +0100 +++
> linux-2.6.21-rc2-mm1/drivers/media/video/ivtv/ivtv-video.c	2007-03-04
> 21:06:59.000000000 +0100 @@ -85,6 +85,7 @@
>  	ivtv_saa7127(itv, VIDIOC_INT_S_VBI_DATA, &data);
>  }
>
> +#if 0
>  void ivtv_encoder_enable(struct ivtv *itv, int enabled)
>  {
>  	if (itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT) {
> @@ -92,6 +93,7 @@
>  				&enabled);
>  	}
>  }
> +#endif  /*  0  */
>
>  void ivtv_video_set_io(struct ivtv *itv)
>  {
> ---
> linux-2.6.21-rc2-mm1/drivers/media/video/ivtv/ivtv-yuv.c.old	2007-03-
>04 21:28:12.000000000 +0100 +++
> linux-2.6.21-rc2-mm1/drivers/media/video/ivtv/ivtv-yuv.c	2007-03-04
> 21:28:25.000000000 +0100 @@ -22,6 +22,7 @@
>  #include "ivtv-queue.h"
>  #include "ivtv-udma.h"
>  #include "ivtv-irq.h"
> +#include "ivtv-yuv.h"
>
>  static int ivtv_yuv_prep_user_dma(struct ivtv *itv, struct
> ivtv_user_dma *dma, struct ivtv_dma_frame *args)
>
>
> _______________________________________________
> v4l-dvb-maintainer mailing list
> v4l-dvb-maintainer@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/v4l-dvb-maintainer
