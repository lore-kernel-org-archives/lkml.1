Return-Path: <linux-kernel-owner+w=401wt.eu-S1753181AbZK3UHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbZK3UHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 15:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025AbZK3UHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 15:07:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057AbZK3UHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 15:07:36 -0500
Message-ID: <4B1425FD.1030705@redhat.com>
Date: Mon, 30 Nov 2009 18:07:25 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090902 Fedora/3.0-3.7.b3.el6 Thunderbird/3.0b3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Stefan Lippers-Hollmann <s.L-H@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [GIT PULL for 2.6.32] V4L/DVB updates
References: <4B103CE1.8050303@redhat.com> <200911272240.02930.s.L-H@gmx.de>
In-Reply-To: <200911272240.02930.s.L-H@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Em 27-11-2009 19:40, Stefan Lippers-Hollmann escreveu:
> Please consider cherry picking the following two patches from Hans 
> Verkuil [1]:
> - add the missing s2250-loader.h
> - s2250 mutex patch	
> 
> or revert the patch which broke compiling go7007-usb (imho it would be 
> better to re-add the 2 externs [2], than throwing away the needed mutex 
> conversion, but it would be an option)
> Commit:	fd9a40da1db372833e1af6397d2f6c94ceff3dad
> 		V4L/DVB (12859): go7007: semaphore -> mutex conversion
> 
> or mark CONFIG_VIDEO_GO7007_USB_S2250_BOARD as BROKEN, as it fails to 
> compile since the afforementioned patch was merged on september 19th (this 
> is a 2.6.31 --> 2.6.32 regression) [2,3].

Please pull from:
       	ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus

It is basically the same pull request as before with two more patches added,
in order to fix the staging/g07007 compilation/work.

The two new patches are:
      staging/go7007: Fix compilation by re-adding the missing s2250-loader.h
      staging/go7007: fix mutex function usage for s2250

(I replaced the subjects for a more adequate one, to explicitly say that those are fixes)

Thanks!
Mauro

---

 MAINTAINERS                                |    7 +++++++
 drivers/media/common/ir-functions.c        |    2 +-
 drivers/media/dvb/dvb-usb/cxusb.c          |   10 +++++++++-
 drivers/media/dvb/siano/Kconfig            |    2 +-
 drivers/media/radio/radio-gemtek-pci.c     |    2 --
 drivers/media/video/davinci/vpif_display.c |    1 -
 drivers/media/video/em28xx/em28xx-cards.c  |    2 +-
 drivers/media/video/mx1_camera.c           |    1 +
 drivers/media/video/mx3_camera.c           |    1 +
 drivers/media/video/sh_mobile_ceu_camera.c |    7 +++++--
 drivers/media/video/soc_camera.c           |   17 ++++++++++++-----
 drivers/media/video/videobuf-dma-contig.c  |    1 +
 drivers/staging/go7007/s2250-board.c       |    4 ++--
 drivers/staging/go7007/s2250-loader.h      |   24 ++++++++++++++++++++++++
 14 files changed, 65 insertions(+), 16 deletions(-)
 create mode 100644 drivers/staging/go7007/s2250-loader.h
Alan Cox (1):
      V4L/DVB (13530): Fix wrong parameter order in memset

Antti Palosaari (1):
      V4L/DVB (13366): em28xx: fix Reddo DVB-C USB TV Box GPIO

Geert Uytterhoeven (1):
      V4L/DVB (13412): SMS_SIANO_MDTV should depend on HAS_DMA

Guennadi Liakhovetski (2):
      V4L/DVB (13343): v4l: add more missing linux/sched.h includes
      V4L/DVB (13344): soc-camera: properly initialise the device object when reusing

Hans Verkuil (3):
      V4L/DVB (13321): radio-gemtek-pci: fix double mutex_lock
      V4L/DVB (13371): davinci: remove stray duplicate config pointer
      V4L/DVB (13481): sh_mobile_ceu_camera: fix compile warning

Kuninori Morimoto (1):
      V4L/DVB (13345): soc-camera: sh_mobile_ceu_camera: call pm_runtime_disable

Mauro Carvalho Chehab (1):
      staging/go7007: Fix compilation by re-adding the missing s2250-loader.h

Olivier Lorin (1):
      V4L/DVB (13372a): MAINTAINERS: addition of gspca_gl860 driver

Pete Eberlein (1):
      V4L/DVB (13372): staging/go7007: fix mutex function usage for s2250

Robert Lowery (1):
      V4L/DVB (13436): cxusb: Fix hang on DViCO FusionHDTV DVB-T Dual Digital 4 (rev 1)

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

