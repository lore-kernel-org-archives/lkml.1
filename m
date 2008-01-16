Return-Path: <linux-kernel-owner+w=401wt.eu-S1753339AbYAPRq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbYAPRq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 12:46:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbYAPRqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 12:46:48 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:28532 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbYAPRqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 12:46:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=vbIaTbwq1WuL4Vx6cCExOgh08hZmy5yZ37zwiJcM2qJBawlYpDoPBO1gQes3LN30z/T7XgJsOakbHLCnsgkYmFX+vqNZK4yBQ7MvYa+IL9UTzagS4aHv4rRHqHE1hsi1BgWPAakmmdv6DN3AbxKQ3eoQeecMlG6USMODCLbk36Q=
Message-ID: <19f34abd0801160946j2fe1c75ap3617dd125c81008f@mail.gmail.com>
Date: Wed, 16 Jan 2008 18:46:46 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: [BISECTED] Re: psmouse.c: GlidePoint at isa0060/serio1/input0 lost sync at byte 1
Cc: linux-input@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "William Pettersson" <william.pettersson@gmail.com>
In-Reply-To: <20080116104024.ZZRA012@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0711141226n60323630rdc4833db0bfb2eeb@mail.gmail.com>
	 <19f34abd0801071224kb9cb121u244b00b274231db0@mail.gmail.com>
	 <d120d5000801110647k4b1fa49ene974898baf745aec@mail.gmail.com>
	 <478CFB56.1030700@gmail.com>
	 <20080115154142.ZZRA012@mailhub.coreip.homeip.net>
	 <20080116104024.ZZRA012@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Jan 16, 2008 4:42 PM, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> Ok, how about this one to begin with?
>
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---
>  drivers/input/mouse/alps.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux/drivers/input/mouse/alps.c
> ===================================================================
> --- linux.orig/drivers/input/mouse/alps.c
> +++ linux/drivers/input/mouse/alps.c
> @@ -54,7 +54,7 @@ static const struct alps_model_info alps
>         { { 0x20, 0x02, 0x0e }, 0xf8, 0xf8, ALPS_PASS | ALPS_DUALPOINT }, /* XXX */
>         { { 0x22, 0x02, 0x0a }, 0xf8, 0xf8, ALPS_PASS | ALPS_DUALPOINT },
>         { { 0x22, 0x02, 0x14 }, 0xff, 0xff, ALPS_PASS | ALPS_DUALPOINT }, /* Dell Latitude D600 */
> -       { { 0x73, 0x02, 0x50 }, 0xcf, 0xff, ALPS_FW_BK_1 } /* Dell Vostro 1400 */
> +       { { 0x73, 0x02, 0x50 }, 0xcf, 0xcf, ALPS_FW_BK_1 } /* Dell Vostro 1400 */
>  };
>
>  /*

I have now tried this patch. I don't see a sync error now, but the
button still does not work as expected. Now the scroll down button
acts like a middle button instead of scrolling down.

I am sorry for the confusion; on my laptop it looks like a single
button, but in fact it can be pressed in four different ways (up,
down, left, and right). In 2.6.23, pressing left or right, I get the
traditional paste functionality. Pressing up or down, it acts like a
scroll wheel (up or down). In 2.6.24-rc1, it is the scrolling up/down
that causes the lost sync (but the left/right works correctly).

Vegard
