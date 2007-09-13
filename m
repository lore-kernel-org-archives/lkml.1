Return-Path: <linux-kernel-owner+w=401wt.eu-S1765521AbXIMW3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765521AbXIMW3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 18:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756904AbXIMW3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 18:29:00 -0400
Received: from as1.cineca.com ([130.186.84.251]:45379 "EHLO as1.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753227AbXIMW27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 18:28:59 -0400
From: Luca Risolia <luca.risolia@studio.unibo.it>
Reply-To: luca.risolia@studio.unibo.it
To: Andreas Herrmann <aherrman@arcor.de>
Subject: Re: [PATCH] v4l: fix build error for et61x251 driver
Date: Fri, 14 Sep 2007 00:28:34 +0200
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       linux-usb-devel@lists.sourceforge.net, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
References: <20070913123627.GD10348@devil> <200709131707.16666.luca.risolia@studio.unibo.it> <20070913222717.GC5764@devil>
In-Reply-To: <20070913222717.GC5764@devil>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709140028.34661.luca.risolia@studio.unibo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hacked-by: Luca Risolia <luca.risolia@studio.unibo.it>

On Friday 14 September 2007 00:27:17 Andreas Herrmann wrote:
> This fixes a kernel build problem and
> should make it into 2.6.23, I think.
>
>
> Regards,
>
> Andreas
>
> --
>
> Get rid of some v4l1 remainders to avoid kernel build errors if
> V4L1_COMPAT is not selected:
>
>   drivers/media/video/et61x251/et61x251_core.c: In et61x251_show_:
>   drivers/media/video/et61x251/et61x251_core.c:718: error: implicit
>     declaration of to_video_device
>
> Fix as suggested by  Luca Risolia <luca.risolia@studio.unibo.it>
>
> Signed-off-by: Andreas Herrmann <aherrman@arcor.de>
> ---
>  drivers/media/video/et61x251/et61x251_core.c |   24
> ++++++++++++++++-------- 1 files changed, 16 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/media/video/et61x251/et61x251_core.c
> b/drivers/media/video/et61x251/et61x251_core.c index 585bd1f..a3ee968
> 100644
> --- a/drivers/media/video/et61x251/et61x251_core.c
> +++ b/drivers/media/video/et61x251/et61x251_core.c
> @@ -715,7 +715,8 @@ static ssize_t et61x251_show_reg(struct class_device*
> cd, char* buf) if (mutex_lock_interruptible(&et61x251_sysfs_lock))
>  		return -ERESTARTSYS;
>
> -	cam = video_get_drvdata(to_video_device(cd));
> +	cam = video_get_drvdata(container_of(cd, struct video_device,
> +					     class_dev));
>  	if (!cam) {
>  		mutex_unlock(&et61x251_sysfs_lock);
>  		return -ENODEV;
> @@ -739,7 +740,8 @@ et61x251_store_reg(struct class_device* cd, const char*
> buf, size_t len) if (mutex_lock_interruptible(&et61x251_sysfs_lock))
>  		return -ERESTARTSYS;
>
> -	cam = video_get_drvdata(to_video_device(cd));
> +	cam = video_get_drvdata(container_of(cd, struct video_device,
> +					     class_dev));
>  	if (!cam) {
>  		mutex_unlock(&et61x251_sysfs_lock);
>  		return -ENODEV;
> @@ -771,7 +773,8 @@ static ssize_t et61x251_show_val(struct class_device*
> cd, char* buf) if (mutex_lock_interruptible(&et61x251_sysfs_lock))
>  		return -ERESTARTSYS;
>
> -	cam = video_get_drvdata(to_video_device(cd));
> +	cam = video_get_drvdata(container_of(cd, struct video_device,
> +					     class_dev));
>  	if (!cam) {
>  		mutex_unlock(&et61x251_sysfs_lock);
>  		return -ENODEV;
> @@ -803,7 +806,8 @@ et61x251_store_val(struct class_device* cd, const char*
> buf, size_t len) if (mutex_lock_interruptible(&et61x251_sysfs_lock))
>  		return -ERESTARTSYS;
>
> -	cam = video_get_drvdata(to_video_device(cd));
> +	cam = video_get_drvdata(container_of(cd, struct video_device,
> +					     class_dev));
>  	if (!cam) {
>  		mutex_unlock(&et61x251_sysfs_lock);
>  		return -ENODEV;
> @@ -839,7 +843,8 @@ static ssize_t et61x251_show_i2c_reg(struct
> class_device* cd, char* buf) if
> (mutex_lock_interruptible(&et61x251_sysfs_lock))
>  		return -ERESTARTSYS;
>
> -	cam = video_get_drvdata(to_video_device(cd));
> +	cam = video_get_drvdata(container_of(cd, struct video_device,
> +					     class_dev));
>  	if (!cam) {
>  		mutex_unlock(&et61x251_sysfs_lock);
>  		return -ENODEV;
> @@ -865,7 +870,8 @@ et61x251_store_i2c_reg(struct class_device* cd, const
> char* buf, size_t len) if (mutex_lock_interruptible(&et61x251_sysfs_lock))
>  		return -ERESTARTSYS;
>
> -	cam = video_get_drvdata(to_video_device(cd));
> +	cam = video_get_drvdata(container_of(cd, struct video_device,
> +					     class_dev));
>  	if (!cam) {
>  		mutex_unlock(&et61x251_sysfs_lock);
>  		return -ENODEV;
> @@ -897,7 +903,8 @@ static ssize_t et61x251_show_i2c_val(struct
> class_device* cd, char* buf) if
> (mutex_lock_interruptible(&et61x251_sysfs_lock))
>  		return -ERESTARTSYS;
>
> -	cam = video_get_drvdata(to_video_device(cd));
> +	cam = video_get_drvdata(container_of(cd, struct video_device,
> +					     class_dev));
>  	if (!cam) {
>  		mutex_unlock(&et61x251_sysfs_lock);
>  		return -ENODEV;
> @@ -934,7 +941,8 @@ et61x251_store_i2c_val(struct class_device* cd, const
> char* buf, size_t len) if (mutex_lock_interruptible(&et61x251_sysfs_lock))
>  		return -ERESTARTSYS;
>
> -	cam = video_get_drvdata(to_video_device(cd));
> +	cam = video_get_drvdata(container_of(cd, struct video_device,
> +					     class_dev));
>  	if (!cam) {
>  		mutex_unlock(&et61x251_sysfs_lock);
>  		return -ENODEV;


