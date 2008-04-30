Return-Path: <linux-kernel-owner+w=401wt.eu-S1765366AbYD3VLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765366AbYD3VLc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757609AbYD3VLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:11:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55979 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757093AbYD3VLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:11:15 -0400
Date: Wed, 30 Apr 2008 18:10:46 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB fixes for 2.6.26
Message-ID: <20080430181046.1c50fd48@gaivota>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git master

For the following fixes:

   - Several fixes on error handling:
	- don't do symbol_put() if symbol_request() failed;
	- saa7134 and cx88: detach frontend, if tuner or Diseqc attach fails;
	- tuner: Failures at tuner_attach were producing OOPS;
   - Kbuild fixes:
	- cx23885 and soc_camera: fix kbuild dependencies.
   - Other fixes:
	- tea5767: return -EINVAL, instead of EINVAL;

The tea5767, saa7134 and cx88 bugs are very old. The error scenario introduced
by the lack of the compilation of the tuners (a lack of a obj-y += tuners/)
arised those issues and ultimately caused their fixes.

Cheers,
Mauro.

---

 drivers/media/common/tuners/tea5767.c     |    6 +-
 drivers/media/video/Kconfig               |    4 +-
 drivers/media/video/cx23885/Kconfig       |    2 +
 drivers/media/video/cx88/cx88-dvb.c       |  251 +++++++++++++++-------------
 drivers/media/video/em28xx/em28xx-dvb.c   |    1 -
 drivers/media/video/saa7134/saa7134-dvb.c |  140 ++++++++++++-----
 drivers/media/video/tuner-core.c          |   34 ++--
 7 files changed, 257 insertions(+), 181 deletions(-)

Andrew Morton (1):
      V4L/DVB (7800): tuner_symbol_probe(): don't do symbol_put() if symbol_request() failed

Guennadi Liakhovetski (1):
      V4L/DVB (7810): soc_camera: mt9v022 and mt9m001 depend on I2C

Mauro Carvalho Chehab (6):
      V4L/DVB (7801): saa7134: detach frontend, if tuner or Diseqc attach fails
      V4L/DVB (7802): tuner: Failures at tuner_attach were producing OOPS
      V4L/DVB (7804): tea5767: Fix error logic
      V4L/DVB (7805): saa7134: dvb_unregister_frontend() shouldn't be called, if not registered yet
      V4L/DVB (7806): saa7134: dvb_unregister_frontend() shouldn't be called, if not registered yet
      V4L/DVB (7807): cx88: Fix error handling, when dvb_attach() fails

Michael Krufky (1):
      V4L/DVB (7808): cx23885: fix kbuild dependencies

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org
