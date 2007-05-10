Return-Path: <linux-kernel-owner+w=401wt.eu-S1760346AbXEJAzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760346AbXEJAzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 20:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757675AbXEJAzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 20:55:05 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:7492 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757544AbXEJAzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 20:55:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=h/72oY+oYLXFeSqDMoG0QcurqiNkpPL4gEZ9NnWm43bn3vIVDOP5xchplaNP8t/b7jQHrzzcUdn1l8cHJXsc0/TJkzWRL8l2u3MFnuvhusycEqNNxcclcn0GBYYZYubKwqU/E/3guzPchH7T6IbIIc6a59gVLxWO2cUZFqMsGkc=
Message-ID: <86802c440705091755y4bc72d4budb8e1d513d304c32@mail.gmail.com>
Date: Wed, 9 May 2007 17:55:02 -0700
From: yhlu <yhlu.kernel@gmail.com>
To: "Gerd Hoffmann" <kraxel@redhat.com>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for relocatable bzImage
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>, vgoyal@in.ibm.com,
       "Jeff Garzik" <jeff@garzik.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>, "Andi Kleen" <ak@suse.de>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <46417F0B.1080405@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4634483E.9030307@goop.org>
	 <86802c440705081500x682ee098y7d51f7bb98dbcff6@mail.gmail.com>
	 <4640F4B3.30408@goop.org> <4640FB2C.2060300@zytor.com>
	 <86802c440705081541v7d0773cek2c5fae1854b68bbc@mail.gmail.com>
	 <46410403.4050802@zytor.com>
	 <m17irivkhy.fsf@ebiederm.dsl.xmission.com>
	 <46413087.2020505@zytor.com>
	 <m1tzumu10k.fsf@ebiederm.dsl.xmission.com>
	 <46417F0B.1080405@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/9/07, Gerd Hoffmann <kraxel@redhat.com> wrote:
> Refine SCREEN_INFO sanity check for vgacon initialization.
>
> Checking video mode field only to see whenever SCREEN_INFO is
> initialized is not enougth, in some cases it is zero although
> a vga card is present.  Lets additionally check cols and lines.
>
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Andi Kleen <ak@suse.de>
> Cc: Alan <alan@lxorguk.ukuu.org.uk>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  drivers/video/console/vgacon.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> Index: vanilla-2.6.21-git11/drivers/video/console/vgacon.c
> ===================================================================
> --- vanilla-2.6.21-git11.orig/drivers/video/console/vgacon.c
> +++ vanilla-2.6.21-git11/drivers/video/console/vgacon.c
> @@ -368,9 +368,14 @@ static const char *vgacon_startup(void)
>  #endif
>         }
>
> +       /* SCREEN_INFO initialized? */
> +       if ((ORIG_VIDEO_MODE  == 0) &&
> +           (ORIG_VIDEO_LINES == 0) &&
> +           (ORIG_VIDEO_COLS  == 0))
> +               goto no_vga;
> +
>         /* VGA16 modes are not handled by VGACON */
> -       if ((ORIG_VIDEO_MODE == 0x00) ||        /* SCREEN_INFO not initialized */
> -           (ORIG_VIDEO_MODE == 0x0D) ||        /* 320x200/4 */
> +       if ((ORIG_VIDEO_MODE == 0x0D) ||        /* 320x200/4 */
>             (ORIG_VIDEO_MODE == 0x0E) ||        /* 640x200/4 */
>             (ORIG_VIDEO_MODE == 0x10) ||        /* 640x350/4 */
>             (ORIG_VIDEO_MODE == 0x12) ||        /* 640x480/4 */
>
it works.

YH
