Return-Path: <linux-kernel-owner+w=401wt.eu-S1757316AbYEMCzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbYEMCzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 22:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbYEMCzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 22:55:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44814 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444AbYEMCzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 22:55:05 -0400
Date: Mon, 12 May 2008 23:54:45 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Michael Krufky" <mkrufky@linuxtv.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Guennadi Liakhovetski" <g.liakhovetski@pengutronix.de>,
       "Mike Isely" <isely@pobox.com>
Subject: Re: [patch] video: build fix for drivers/media/video/pvrusb2/
Message-ID: <20080512235445.3a56cea0@gaivota>
In-Reply-To: <37219a840805110534r4865623y6f9510554e2716ac@mail.gmail.com>
References: <20080511072137.GA16772@elte.hu>
	<37219a840805110534r4865623y6f9510554e2716ac@mail.gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 May 2008 08:34:06 -0400
"Michael Krufky" <mkrufky@linuxtv.org> wrote:

> On Sun, May 11, 2008 at 3:21 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > x86.git testing found the following build failure:
> >
> >  drivers/built-in.o: In function `pvr2_dvb_feed_thread':
> >  pvrusb2-dvb.c:(.text+0x127e78): undefined reference to `dvb_dmx_swfilter'
> >  drivers/built-in.o: In function `pvr2_dvb_adapter_exit':
> >  pvrusb2-dvb.c:(.text+0x128357): undefined reference to `dvb_net_release'
> >  pvrusb2-dvb.c:(.text+0x12836f): undefined reference to `dvb_dmxdev_release'
> >  [...]
> >
> > with this config:
> >
> >  http://redhat.com/~mingo/misc/config-Sun_May_11_07_06_35_CEST_2008.bad
> >
> > the reason for the missing symbols is this combination:
> >
> >  CONFIG_VIDEO_PVRUSB2=y
> >  CONFIG_DVB_CORE=m
> >
> > i.e. pvrusb2 is built-in, dvb-core is modular.
> >
> > This patch solves the problem by adding a dependency on DVB_CORE - this
> > is used by other drivers such as au0828 as well. This way the pvrusb2
> > driver can still be built, but if dvb-core is a module then it will
> > correctly be a module as well and cannot be built-in.
> >
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > ---
> >  drivers/media/video/pvrusb2/Kconfig |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > Index: linux/drivers/media/video/pvrusb2/Kconfig
> > ===================================================================
> > --- linux.orig/drivers/media/video/pvrusb2/Kconfig
> > +++ linux/drivers/media/video/pvrusb2/Kconfig
> > @@ -1,6 +1,6 @@
> >  config VIDEO_PVRUSB2
> >        tristate "Hauppauge WinTV-PVR USB2 support"
> > -       depends on VIDEO_V4L2 && I2C
> > +       depends on VIDEO_V4L2 && I2C && DVB_CORE
> >        select FW_LOADER
> >        select MEDIA_TUNER
> >        select VIDEO_TVEEPROM
> >
> 
> Ingo,
> 
> VIDEO_PVRUSB2 should not depend on DVB_CORE unless VIDEO_PVRUSB2_DVB
> is selected, which already depends on DVB_CORE.
> 
> For example, if a user has VIDEO_PVRUSB2_DVB not selected, then your
> patch would generate a false dependency on DVB_CORE.

Maybe we can make pvrusb2 dependent of VIDEO_MEDIA. This is a DVB_CORE ||
VIDEO_DEV. So, pvrusb should be 'm' in this case. 
> 
> Regards,
> 
> Mike Krufky




Cheers,
Mauro
