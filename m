Return-Path: <linux-kernel-owner+w=401wt.eu-S1759885AbYD3HLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759885AbYD3HLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 03:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756725AbYD3HLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 03:11:13 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:19056 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105AbYD3HLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 03:11:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tigUxWc1bhdHg2HGhxqsX05UZeURM5D9U28ahcvTJ5RDloO6Q0hxXUvpkJBMl1Z6lETJHFtQHvfyaSLr5wcQFDNIepqnul9+E7GePEMhux/3pcNnYDz5WGljbv1sB8BX6t4YvauJuyz1+P+pWGzaKQEKtEBWLeP+31e4gziSaNk=
Message-ID: <461039140804300011v5454a169ldbd17ebefa2391d@mail.gmail.com>
Date: Wed, 30 Apr 2008 08:11:08 +0100
From: "Jaime Velasco" <jsagarribay@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] video: fix build bugs in drivers/media/video/stk-webcam.c
Cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080429131824.GA4742@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080429131824.GA4742@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/4/29 Ingo Molnar <mingo@elte.hu>:
>
>  x86.git randconfig testing found these build bugs in current -git:
>
>   drivers/media/video/stk-webcam.c: In function 'stk_create_sysfs_files':
>   drivers/media/video/stk-webcam.c:340: error: implicit declaration of function 'video_device_create_file'
>   drivers/media/video/stk-webcam.c: In function 'stk_remove_sysfs_files':
>   [...]
>   drivers/media/video/stk-webcam.c: In function 'v4l_stk_mmap':
>   drivers/media/video/stk-webcam.c:846: error: 'VM_WRITE' undeclared (first use in this function)
>   [...]
>
>  config at:
>
>   http://redhat.com/~mingo/misc/config-Tue_Apr_29_15_00_47_CEST_2008.bad
>
>  the reason was a missing include file, and a dependency on a deprecated
>  (but still in use) VIDEO_V4L1_COMPAT API.
>
>  Signed-off-by: Ingo Molnar <mingo@elte.hu>

Acked-by: Jaime Velasco Juan <jsagarribay@gmail.com>

For the record, this bug was found in march, but it seems
I forgot to CC: the patch to Mauro, Sorry about that.

http://marc.info/?l=linux-video&m=120594964524615&w=2

Regards,
Jaime

>  ---
>   drivers/media/video/Kconfig      |    1 +
>   drivers/media/video/stk-webcam.c |    1 +
>   2 files changed, 2 insertions(+)
>
>  Index: linux/drivers/media/video/Kconfig
>  ===================================================================
>  --- linux.orig/drivers/media/video/Kconfig
>  +++ linux/drivers/media/video/Kconfig
>  @@ -835,6 +835,7 @@ config USB_ZR364XX
>   config USB_STKWEBCAM
>         tristate "USB Syntek DC1125 Camera support"
>         depends on VIDEO_V4L2 && EXPERIMENTAL
>  +       select VIDEO_V4L1_COMPAT
>         ---help---
>           Say Y here if you want to use this type of camera.
>           Supported devices are typically found in some Asus laptops,
>  Index: linux/drivers/media/video/stk-webcam.c
>  ===================================================================
>  --- linux.orig/drivers/media/video/stk-webcam.c
>  +++ linux/drivers/media/video/stk-webcam.c
>  @@ -28,6 +28,7 @@
>   #include <linux/errno.h>
>   #include <linux/slab.h>
>   #include <linux/kref.h>
>  +#include <linux/mm.h>
>
>   #include <linux/usb.h>
>   #include <linux/vmalloc.h>
>
