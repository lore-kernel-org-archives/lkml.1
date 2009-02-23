Return-Path: <linux-kernel-owner+w=401wt.eu-S1753875AbZBWIp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbZBWIp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 03:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZBWIpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 03:45:18 -0500
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:39050 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbZBWIpR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 03:45:17 -0500
Date: 23 Feb 2009 09:45:10 +0100
From: krzysztof.h1@poczta.fm
Subject: =?UTF-8?q?Re:_Re:_[Linux-fbdev-devel]_[PATCH]_fb:_hide_cursor_in_graphics_mode?=
To: Risto Suominen <risto.suominen@gmail.com>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>, adaplas@pol.net,
       Andrew Morton <akpm@linux-foundation.org>, geert@linux-m68k.org,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: TEXT/plain; CHARSET=ISO-8859-2
Content-Transfer-Encoding: 8BIT
X-ORIGINATE-IP: 83.17.101.58
IMPORTANCE: Normal
X-MSMAIL-PRIORITY: Normal
X-PRIORITY: 3
X-Mailer: PSE3
Message-Id: <20090223084511.1CA9A36FDC8@f44.poczta.interia.pl>
X-EMID: 2e740acc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Risto Suominen napisa³(a):
> Krzysztof, my patch is basically the same as yours. I already tried
> to send it to Xorg mailing list, but did not receive any feedback.
> 

Right. One should set zero the xoffset also (can be non-zero on some cards).

The Xfbdev is incorrectly designed as it uses settings read from one
console to apply them to another console. It breaks if someone uses two 
graphics  cards and the target console is on a different card then a 
current one.

I have to find out what how the problem above affects a HW cursor.

Regards,
Krzysztof

> If virtual resolution is higher than the screen (as in atyfb), and
> yoffset
> given by the framebuffer driver happens to be non-zero (fbcon changes it
> on-
> the-fly), Xfbdev places its image starting above the displayed part of
> the
> framebuffer. This patch makes sure that the whole picture is visible.
> 
> Signed-off-by: Risto Suominen >Risto.Suominen@gmail.com>
> ---
> The testing is done on version 1.1.1 and linux kernel version 2.6.18.
> 
> --- a/hw/kdrive/fbdev/fbdev.c.org       2006-07-05 21:31:39.000000000
> +0300
> +++ b/hw/kdrive/fbdev/fbdev.c   2009-01-18 15:42:06.000000000 +0200
> @@ -215,6 +215,8 @@ fbdevScreenInitialize (KdScreenInfo *scr
> 
>      /* Now get the new screeninfo */
>      ioctl (priv->fd, FBIOGET_VSCREENINFO, >priv->var);
> +    /* We can get anything into yoffset if fbcon is active */
> +    priv->var.yoffset = 0;
>      depth = priv->var.bits_per_pixel;
>      gray = priv->var.grayscale;
> 
> 



----------------------------------------------------------------------
Promocja w Speak Up. Angielski 50% gratis! 
Liczba miejsc ograniczona. Sprawd¼!>> http://link.interia.pl/f205c


