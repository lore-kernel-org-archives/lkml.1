Return-Path: <linux-kernel-owner+w=401wt.eu-S1758118AbXEITF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118AbXEITF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 15:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756488AbXEITFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 15:05:21 -0400
Received: from assei1bl6.telenet-ops.be ([195.130.133.68]:39951 "EHLO
	assei1bl6.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756424AbXEITFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 15:05:19 -0400
Date: Wed, 9 May 2007 21:05:15 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Rechberger Markus <mrechberger@gmail.com>
Subject: Re: [GIT PATCHES] V4L/DVB updates
In-Reply-To: <1178706473.9614.31.camel@localhost>
Message-ID: <Pine.LNX.4.64.0705092103550.13222@anakin>
References: <1177706435.5163.49.camel@localhost> <Pine.LNX.4.64.0705090804310.12497@anakin>
 <1178706473.9614.31.camel@localhost>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463808512-911022371-1178737515=:13222"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463808512-911022371-1178737515=:13222
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 9 May 2007, Mauro Carvalho Chehab wrote:
> Em Qua, 2007-05-09 às 08:30 +0200, Geert Uytterhoeven escreveu:
> > On Fri, 27 Apr 2007, Mauro Carvalho Chehab wrote:
> > > A short changelog:
> > > 
> > >    - New drivers:
> > >         ivtv driver for Hauppauge PVR series and similar boards;
> > 
> > Can we please have proper Kconfig dependencies instead of
> > 
> > | #ifdef CONFIG_LIRC_I2C
> > | #  error "This driver is not compatible with the LIRC I2C kernel configuration
> > | #endif /* CONFIG_LIRC_I2C */
> > | 
> > | #ifndef CONFIG_PCI
> > | #  error "This driver requires kernel PCI support."
> > | #endif /* CONFIG_PCI */
> > 
> > in drivers/media/video/ivtv/ivtv-driver.h? Especially a dependency on
> > CONFIG_PCI would be nice (CONFIG_LIRC_I2C doesn't exist in mainline?).
> > 
> > | drivers/media/video/video-buf.c: In function 'videobuf_queue_pci':
> > | drivers/media/video/video-buf.c:399: error: 'pci_map_sg' undeclared (first use in this function)
> > 
> > Probably some new driver does a select VIDEO_BUF, which overrides that
> > VIDEO_BUF depends on PCI?
> 
> Can you check if the following patch would fix it? VIDEO_BUF is selected
> by several PCI-dependent devices. The only non-PCI device wrongly
> selecting VIDEO_BUF seems to be em28xx.

Yes, it fixed the issues (after manual application of the last chunk,
which didn't apply cleanly). Thanks!

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
---1463808512-911022371-1178737515=:13222--
