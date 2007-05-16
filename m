Return-Path: <linux-kernel-owner+w=401wt.eu-S1762605AbXEPFDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762605AbXEPFDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 01:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756382AbXEPFDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 01:03:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55033 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665AbXEPFDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 01:03:15 -0400
Date: Wed, 16 May 2007 06:03:12 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Manu Abraham <abraham.manu@gmail.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, mchehab@infradead.org
Subject: Re: [PATCH] em28xx and ivtv should depend on PCI
Message-ID: <20070516050312.GI4095@ftp.linux.org.uk>
References: <E1Ho2p6-0003Tt-B7@ZenIV.linux.org.uk> <464A4163.7090509@gmail.com> <20070516012254.GF4095@ftp.linux.org.uk> <d9def9db0705152057w50a2d69eh323c6737a0b158ca@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9def9db0705152057w50a2d69eh323c6737a0b158ca@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 05:57:39AM +0200, Markus Rechberger wrote:
> On 5/16/07, Al Viro <viro@ftp.linux.org.uk> wrote:
> >On Wed, May 16, 2007 at 03:25:23AM +0400, Manu Abraham wrote:
> >> Al Viro wrote:
> >> > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> >> > ---
> >> >  drivers/media/video/em28xx/Kconfig |    2 +-
> >> >  drivers/media/video/ivtv/Kconfig   |    2 +-
> >> >  2 files changed, 2 insertions(+), 2 deletions(-)
> >> >
> >> > diff --git a/drivers/media/video/em28xx/Kconfig
> >b/drivers/media/video/em28xx/Kconfig
> >> > index 3823b62..2c450bd 100644
> >> > --- a/drivers/media/video/em28xx/Kconfig
> >> > +++ b/drivers/media/video/em28xx/Kconfig
> >> > @@ -1,6 +1,6 @@
> >> >  config VIDEO_EM28XX
> >> >  	tristate "Empia EM2800/2820/2840 USB video capture support"
> >> > -	depends on VIDEO_V4L1 && I2C
> >> > +	depends on VIDEO_V4L1 && I2C && PCI
> >>
> >> Err .. why would a USB device need to be depend on PCI ?
> >
> >Because video-buf.c does.  And VIDEO_EM28XX selects it.
> 
> the em28xx does not rely on video-buf, this seems to be a dependency
> derived from another dependency.

        select VIDEO_BUF
        select VIDEO_TUNER
        select VIDEO_TVEEPROM
        select VIDEO_IR
        select VIDEO_SAA711X if VIDEO_HELPER_CHIPS_AUTO
        select VIDEO_TVP5150 if VIDEO_HELPER_CHIPS_AUTO
        ---help---
          This is a video4linux driver for Empia 28xx based TV cards.

          To compile this driver as a module, choose M here: the  
          module will be called em28xx

The first line does it.  It's not a dependency, it's a direct select.
And drivers/media/video/Makefile has
obj-$(CONFIG_VIDEO_BUF)   += video-buf.o
