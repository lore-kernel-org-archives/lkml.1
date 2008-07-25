Return-Path: <linux-kernel-owner+w=401wt.eu-S1756714AbYGYAPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbYGYAPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 20:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbYGYAP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 20:15:27 -0400
Received: from nelson.telenet-ops.be ([195.130.133.66]:38738 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbYGYAP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 20:15:26 -0400
Date: Fri, 25 Jul 2008 02:15:24 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Philippe De Muyter <phdm@macqel.be>
cc: Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: video/fb: cleanup FB_MAJOR usage
In-Reply-To: <200807242325.m6ONP5hG015643@hera.kernel.org>
Message-ID: <Pine.LNX.4.64.0807250213520.9222@anakin>
References: <200807242325.m6ONP5hG015643@hera.kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2008, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5bb49fcd501aa9fd3d321a22b7c01d9b0db7ab36
> Commit:     5bb49fcd501aa9fd3d321a22b7c01d9b0db7ab36
> Parent:     cba603bf514c101bf48f6adf393c3d00ed457a57
> Author:     Philippe De Muyter <phdm@macqel.be>
> AuthorDate: Wed Jul 23 21:31:50 2008 -0700
> Committer:  Linus Torvalds <torvalds@linux-foundation.org>
> CommitDate: Thu Jul 24 10:47:41 2008 -0700
> 
>     video/fb: cleanup FB_MAJOR usage
>     
>     Currently, linux/major.h defines a GRAPHDEV_MAJOR (29) that nobody uses,
>     and linux/fb.h defines the real FB_MAJOR (also 29), that only fbmem.c
>     needs.  Drop GRAPHDEV_MAJOR from major.h, move FB_MAJOR definition from
>     fb.h to major.h, and fix fbmem.c to use major.h's definition.

<linux/fb.h> is exported to userspace, so this may affect userspace
applications.

>     Signed-off-by: Philippe De Muyter <phdm@macqel.be>
>     Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
>     Cc: "Antonino A. Daplas" <adaplas@pol.net>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---
>  drivers/video/fbmem.c |    1 +
>  include/linux/fb.h    |    1 -
>  include/linux/major.h |    2 +-
>  3 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
> index 6b48780..5d84b34 100644
> --- a/drivers/video/fbmem.c
> +++ b/drivers/video/fbmem.c
> @@ -35,6 +35,7 @@
>  #include <linux/device.h>
>  #include <linux/efi.h>
>  #include <linux/fb.h>
> +#include <linux/major.h>
>  
>  #include <asm/fb.h>
>  
> diff --git a/include/linux/fb.h b/include/linux/fb.h
> index a084d13..3b8870e 100644
> --- a/include/linux/fb.h
> +++ b/include/linux/fb.h
> @@ -8,7 +8,6 @@ struct dentry;
>  
>  /* Definitions of frame buffers						*/
>  
> -#define FB_MAJOR		29
>  #define FB_MAX			32	/* sufficient for now */
>  
>  /* ioctls
> diff --git a/include/linux/major.h b/include/linux/major.h
> index 0cb9805..53d5faf 100644
> --- a/include/linux/major.h
> +++ b/include/linux/major.h
> @@ -53,7 +53,7 @@
>  #define STL_SIOMEMMAJOR		28
>  #define ACSI_MAJOR		28
>  #define AZTECH_CDROM_MAJOR	29
> -#define GRAPHDEV_MAJOR		29   /* SparcLinux & Linux/68k /dev/fb */
> +#define FB_MAJOR		29   /* /dev/fb* framebuffers */
>  #define CM206_CDROM_MAJOR	32
>  #define IDE2_MAJOR		33
>  #define IDE3_MAJOR		34

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
