Return-Path: <linux-kernel-owner+w=401wt.eu-S1764307AbXINBxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764307AbXINBxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 21:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbXINBxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 21:53:34 -0400
Received: from as4.cineca.com ([130.186.84.213]:35360 "EHLO as4.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755680AbXINBxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 21:53:33 -0400
From: Luca Risolia <luca.risolia@studio.unibo.it>
Reply-To: luca.risolia@studio.unibo.it
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] v4l: fix build error for et61x251 driver
Date: Fri, 14 Sep 2007 03:53:06 +0200
User-Agent: KMail/1.9.6
Cc: Andreas Herrmann <aherrman@arcor.de>, akpm@linux-foundation.org,
       linux-usb-devel@lists.sourceforge.net, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>
References: <20070913123627.GD10348@devil> <200709140028.34661.luca.risolia@studio.unibo.it> <alpine.LFD.0.999.0709131705070.16478@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0709131705070.16478@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709140353.07087.luca.risolia@studio.unibo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 September 2007 02:09:01 Linus Torvalds wrote:
> On Fri, 14 Sep 2007, Luca Risolia wrote:
> > Hacked-by: Luca Risolia <luca.risolia@studio.unibo.it>
> >
> > On Friday 14 September 2007 00:27:17 Andreas Herrmann wrote:
> > > This fixes a kernel build problem and
> > > should make it into 2.6.23, I think.
> > >
> > >
> > > Regards,
> > >
> > > Andreas
> > >
> > > --
> > >
> > > Get rid of some v4l1 remainders to avoid kernel build errors if
> > > V4L1_COMPAT is not selected:
> > >
> > >   drivers/media/video/et61x251/et61x251_core.c: In et61x251_show_:
> > >   drivers/media/video/et61x251/et61x251_core.c:718: error: implicit
> > >     declaration of to_video_device
> > >
> > > Fix as suggested by  Luca Risolia <luca.risolia@studio.unibo.it>
>
> This patch is really ugly.
>
> Why can't the "to_video_device()" macro be used? Just move it to a place
> where it's usable! IOW, what's wrong with the *much* simpler patch below?

There's nothing wtong in my opinion. I do not know the exact reason why Mauro 
moved "to_video_device()" into CONFIG_VIDEO_V4L1_COMPAT. Pheraps he can give 
more details about this change.


> That "to_video_device()" macro has absolutely _nothing_ to do with
> CONFIG_VIDEO_V4L1_COMPAT, as far as I can tell!
>
> 			Linus
> ---
> diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
> index d62847f..17f8f3a 100644
> --- a/include/media/v4l2-dev.h
> +++ b/include/media/v4l2-dev.h
> @@ -337,6 +337,9 @@ void *priv;
>  	struct class_device class_dev; /* sysfs */
>  };
>
> +/* Class-dev to video-device */
> +#define to_video_device(cd) container_of(cd, struct video_device,
> class_dev) +
>  /* Version 2 functions */
>  extern int video_register_device(struct video_device *vfd, int type, int
> nr); void video_unregister_device(struct video_device *);
> @@ -354,11 +357,9 @@ extern int video_usercopy(struct inode *inode, struct
> file *file, int (*func)(struct inode *inode, struct file *file,
>  				      unsigned int cmd, void *arg));
>
> -
>  #ifdef CONFIG_VIDEO_V4L1_COMPAT
>  #include <linux/mm.h>
>
> -#define to_video_device(cd) container_of(cd, struct video_device,
> class_dev) static inline int __must_check
>  video_device_create_file(struct video_device *vfd,
>  			 struct class_device_attribute *attr)

Best regards
Luca Risolia
