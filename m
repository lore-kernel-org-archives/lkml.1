Return-Path: <linux-kernel-owner+w=401wt.eu-S1760100AbXJLVAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760100AbXJLVAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 17:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756554AbXJLVAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 17:00:31 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:49156 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112AbXJLVAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 17:00:31 -0400
Date: Fri, 12 Oct 2007 23:00:27 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nicolas Pitre <nico@cam.org>, LKML <linux-kernel@vger.kernel.org>,
       Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [GIT PULL] MMC updates
Message-ID: <20071012230027.606a705b@poseidon.drzeus.cx>
In-Reply-To: <alpine.LFD.0.9999.0710121603080.19446@xanadu.home>
References: <20071010212149.0073ee08@poseidon.drzeus.cx>
	<alpine.LFD.0.999.0710112228200.6887@woody.linux-foundation.org>
	<20071012215513.1a4dfc7d@poseidon.drzeus.cx>
	<alpine.LFD.0.9999.0710121603080.19446@xanadu.home>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, let's see if we can finally sort this out.

Please pull/cherry-pick from:

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-linus

to receive the following update:

 drivers/mmc/core/host.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Pierre Ossman (1):
      mmc: use correct unregister function for led trigger

diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 64fbc97..c65d203 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -143,7 +143,7 @@ void mmc_remove_host(struct mmc_host *host)
 
        device_del(&host->class_dev);
 
-       led_trigger_unregister(host->led);
+       led_trigger_unregister_simple(host->led);
 
        spin_lock(&mmc_host_lock);
        idr_remove(&mmc_host_idr, host->index);

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
