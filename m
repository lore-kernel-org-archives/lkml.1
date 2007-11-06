Return-Path: <linux-kernel-owner+w=401wt.eu-S1755753AbXKFWE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbXKFWE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 17:04:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbXKFWEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 17:04:49 -0500
Received: from mail.hauppauge.com ([167.206.143.4]:4558 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbXKFWEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 17:04:48 -0500
X-Greylist: delayed 925 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Nov 2007 17:04:47 EST
Message-ID: <4730DDB4.70101@linuxtv.org>
From: mkrufky@linuxtv.org
To: v4l-dvb-maintainer@linuxtv.org
Cc: bunk@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] [2.6 patch] dvb-usb: make some debug var
	s static
Date: Tue, 6 Nov 2007 16:33:40 -0500 
MIME-Version: 1.0
X-Mailer: Internet Mail Service (5.5.2657.72)
in-reply-to: <20071105170706.GH12045@stusta.de>
x-originalarrivaltime: 06 Nov 2007 21:32:38.0246 (UTC) FILETIME=[8DA5E860:01C820BC]
user-agent: Thunderbird 2.0.0.6 (Windows/20070728)
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch makes some needlessly global debug variables static.
>
> opera1.h became so small that I removed it.
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>
>   

Reviewed-by: Michael Krufky <mkrufky@linuxtv.org>

Mauro, please apply.

-Mike

> ---
>
>  drivers/media/dvb/dvb-usb/cxusb.c  |    5 ++++-
>  drivers/media/dvb/dvb-usb/cxusb.h  |    5 -----
>  drivers/media/dvb/dvb-usb/digitv.c |    3 ++-
>  drivers/media/dvb/dvb-usb/digitv.h |    3 ---
>  drivers/media/dvb/dvb-usb/opera1.c |    6 ++++--
>  drivers/media/dvb/dvb-usb/opera1.h |    9 ---------
>  drivers/media/dvb/dvb-usb/vp7045.c |    5 ++++-
>  drivers/media/dvb/dvb-usb/vp7045.h |    5 -----
>  8 files changed, 14 insertions(+), 27 deletions(-)
>
> 86038dd7d3d897cb762555ee79063945513dc93f 
> diff --git a/drivers/media/dvb/dvb-usb/cxusb.c
b/drivers/media/dvb/dvb-usb/cxusb.c
> index 04e31cf..5b6431e 100644
> --- a/drivers/media/dvb/dvb-usb/cxusb.c
> +++ b/drivers/media/dvb/dvb-usb/cxusb.c
> @@ -32,9 +32,12 @@
>  #include "zl10353.h"
>  
>  /* debug */
> -int dvb_usb_cxusb_debug;
> +static int dvb_usb_cxusb_debug;
>  module_param_named(debug, dvb_usb_cxusb_debug, int, 0644);
>  MODULE_PARM_DESC(debug, "set debugging level (1=rc (or-able))."
DVB_USB_DEBUG_STATUS);
> +#define deb_info(args...)   dprintk(dvb_usb_cxusb_debug,0x01,args)
> +#define deb_i2c(args...)    if (d->udev->descriptor.idVendor ==
USB_VID_MEDION) \
> +				dprintk(dvb_usb_cxusb_debug,0x01,args)
>  
>  static int cxusb_ctrl_msg(struct dvb_usb_device *d,
>  			  u8 cmd, u8 *wbuf, int wlen, u8 *rbuf, int rlen)
> diff --git a/drivers/media/dvb/dvb-usb/cxusb.h
b/drivers/media/dvb/dvb-usb/cxusb.h
> index c8ef775..79ca7ab 100644
> --- a/drivers/media/dvb/dvb-usb/cxusb.h
> +++ b/drivers/media/dvb/dvb-usb/cxusb.h
> @@ -4,11 +4,6 @@
>  #define DVB_USB_LOG_PREFIX "cxusb"
>  #include "dvb-usb.h"
>  
> -extern int dvb_usb_cxusb_debug;
> -#define deb_info(args...)   dprintk(dvb_usb_cxusb_debug,0x01,args)
> -#define deb_i2c(args...)    if (d->udev->descriptor.idVendor ==
USB_VID_MEDION) \
> -				dprintk(dvb_usb_cxusb_debug,0x01,args)
> -
>  /* usb commands - some of it are guesses, don't have a reference yet */
>  #define CMD_I2C_WRITE     0x08
>  #define CMD_I2C_READ      0x09
> diff --git a/drivers/media/dvb/dvb-usb/digitv.c
b/drivers/media/dvb/dvb-usb/digitv.c
> index bca1e09..3acbda4 100644
> --- a/drivers/media/dvb/dvb-usb/digitv.c
> +++ b/drivers/media/dvb/dvb-usb/digitv.c
> @@ -17,9 +17,10 @@
>  #include "nxt6000.h"
>  
>  /* debug */
> -int dvb_usb_digitv_debug;
> +static int dvb_usb_digitv_debug;
>  module_param_named(debug,dvb_usb_digitv_debug, int, 0644);
>  MODULE_PARM_DESC(debug, "set debugging level (1=rc (or-able))."
DVB_USB_DEBUG_STATUS);
> +#define deb_rc(args...)   dprintk(dvb_usb_digitv_debug,0x01,args)
>  
>  static int digitv_ctrl_msg(struct dvb_usb_device *d,
>  		u8 cmd, u8 vv, u8 *wbuf, int wlen, u8 *rbuf, int rlen)
> diff --git a/drivers/media/dvb/dvb-usb/digitv.h
b/drivers/media/dvb/dvb-usb/digitv.h
> index 8b43e3d..908c09f 100644
> --- a/drivers/media/dvb/dvb-usb/digitv.h
> +++ b/drivers/media/dvb/dvb-usb/digitv.h
> @@ -8,9 +8,6 @@ struct digitv_state {
>      int is_nxt6000;
>  };
>  
> -extern int dvb_usb_digitv_debug;
> -#define deb_rc(args...)   dprintk(dvb_usb_digitv_debug,0x01,args)
> -
>  /* protocol (from usblogging and the SDK:
>   *
>   * Always 7 bytes bulk message(s) for controlling
> diff --git a/drivers/media/dvb/dvb-usb/opera1.c
b/drivers/media/dvb/dvb-usb/opera1.c
> index d7c0495..21935bf 100644
> --- a/drivers/media/dvb/dvb-usb/opera1.c
> +++ b/drivers/media/dvb/dvb-usb/opera1.c
> @@ -10,7 +10,9 @@
>  * see Documentation/dvb/README.dvb-usb for more information
>  */
>  
> -#include "opera1.h"
> +#define DVB_USB_LOG_PREFIX "opera"
> +
> +#include "dvb-usb.h"
>  #include "stv0299.h"
>  
>  #define OPERA_READ_MSG 0
> @@ -38,7 +40,7 @@ struct opera_rc_keys {
>  	u32 event;
>  };
>  
> -int dvb_usb_opera1_debug;
> +static int dvb_usb_opera1_debug;
>  module_param_named(debug, dvb_usb_opera1_debug, int, 0644);
>  MODULE_PARM_DESC(debug,
>  		 "set debugging level
(1=info,xfer=2,pll=4,ts=8,err=16,rc=32,fw=64 (or-able))."
> diff --git a/drivers/media/dvb/dvb-usb/opera1.h
b/drivers/media/dvb/dvb-usb/opera1.h
> deleted file mode 100644
> index 5317442..0000000
> --- a/drivers/media/dvb/dvb-usb/opera1.h
> +++ /dev/null
> @@ -1,9 +0,0 @@
> -#ifndef _OPERA1_H_
> -#define _OPERA1_H_
> -
> -#define DVB_USB_LOG_PREFIX "opera"
> -#include "dvb-usb.h"
> -
> -extern int dvb_usb_opera1_debug;
> -#define deb_xfer(args...) dprintk(dvb_usb_opera1_debug,0x02,args)
> -#endif
> diff --git a/drivers/media/dvb/dvb-usb/vp7045.c
b/drivers/media/dvb/dvb-usb/vp7045.c
> index 5bbd2d5..c172bab 100644
> --- a/drivers/media/dvb/dvb-usb/vp7045.c
> +++ b/drivers/media/dvb/dvb-usb/vp7045.c
> @@ -15,9 +15,12 @@
>  #include "vp7045.h"
>  
>  /* debug */
> -int dvb_usb_vp7045_debug;
> +static int dvb_usb_vp7045_debug;
>  module_param_named(debug,dvb_usb_vp7045_debug, int, 0644);
>  MODULE_PARM_DESC(debug, "set debugging level (1=info,xfer=2,rc=4
(or-able))." DVB_USB_DEBUG_STATUS);
> +#define deb_info(args...) dprintk(dvb_usb_vp7045_debug,0x01,args)
> +#define deb_xfer(args...) dprintk(dvb_usb_vp7045_debug,0x02,args)
> +#define deb_rc(args...)   dprintk(dvb_usb_vp7045_debug,0x04,args)
>  
>  int vp7045_usb_op(struct dvb_usb_device *d, u8 cmd, u8 *out, int outlen,
u8 *in, int inlen, int msec)
>  {
> diff --git a/drivers/media/dvb/dvb-usb/vp7045.h
b/drivers/media/dvb/dvb-usb/vp7045.h
> index 9ce21a2..969688f 100644
> --- a/drivers/media/dvb/dvb-usb/vp7045.h
> +++ b/drivers/media/dvb/dvb-usb/vp7045.h
> @@ -17,11 +17,6 @@
>  #define DVB_USB_LOG_PREFIX "vp7045"
>  #include "dvb-usb.h"
>  
> -extern int dvb_usb_vp7045_debug;
> -#define deb_info(args...) dprintk(dvb_usb_vp7045_debug,0x01,args)
> -#define deb_xfer(args...) dprintk(dvb_usb_vp7045_debug,0x02,args)
> -#define deb_rc(args...)   dprintk(dvb_usb_vp7045_debug,0x04,args)
> -
>  /* vp7045 commands */
>  
>  /* Twinhan Vendor requests */
>
> _______________________________________________
> v4l-dvb-maintainer mailing list
> v4l-dvb-maintainer@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/v4l-dvb-maintainer
>   

