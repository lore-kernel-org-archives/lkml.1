Return-Path: <linux-kernel-owner+w=401wt.eu-S969094AbXEIGa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969094AbXEIGa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 02:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934722AbXEIGaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 02:30:07 -0400
Received: from adicia.telenet-ops.be ([195.130.132.56]:39801 "EHLO
	adicia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934664AbXEIGaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 02:30:05 -0400
Date: Wed, 9 May 2007 08:30:02 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCHES] V4L/DVB updates
In-Reply-To: <1177706435.5163.49.camel@localhost>
Message-ID: <Pine.LNX.4.64.0705090804310.12497@anakin>
References: <1177706435.5163.49.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007, Mauro Carvalho Chehab wrote:
> A short changelog:
> 
>    - New drivers:
>         ivtv driver for Hauppauge PVR series and similar boards;

Can we please have proper Kconfig dependencies instead of

| #ifdef CONFIG_LIRC_I2C
| #  error "This driver is not compatible with the LIRC I2C kernel configuration
| #endif /* CONFIG_LIRC_I2C */
| 
| #ifndef CONFIG_PCI
| #  error "This driver requires kernel PCI support."
| #endif /* CONFIG_PCI */

in drivers/media/video/ivtv/ivtv-driver.h? Especially a dependency on
CONFIG_PCI would be nice (CONFIG_LIRC_I2C doesn't exist in mainline?).

| drivers/media/video/video-buf.c: In function 'videobuf_queue_pci':
| drivers/media/video/video-buf.c:399: error: 'pci_map_sg' undeclared (first use in this function)

Probably some new driver does a select VIDEO_BUF, which overrides that
VIDEO_BUF depends on PCI?

Thanks!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
