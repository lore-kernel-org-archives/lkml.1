Return-Path: <linux-kernel-owner+w=401wt.eu-S1758293AbXIKP0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293AbXIKP0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 11:26:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbXIKPZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 11:25:54 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:33581 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbXIKPZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 11:25:53 -0400
Date: Tue, 11 Sep 2007 17:26:45 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MMC updates
Message-ID: <20070911172645.16a3a31d@poseidon.drzeus.cx>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-linus

to receive the following updates:

 drivers/mmc/host/at91_mci.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

Anti Sullin (1):
      bug in AT91 MCI suspend routines

diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
index bfebd2f..955ea60 100644
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -941,7 +941,7 @@ static int __exit at91_mci_remove(struct platform_device *pdev)
 
        host = mmc_priv(mmc);
 
-       if (host->present != -1) {
+       if (host->board->det_pin) {
                device_init_wakeup(&pdev->dev, 0);
                free_irq(host->board->det_pin, host);
                cancel_delayed_work(&host->mmc->detect);
@@ -972,7 +972,7 @@ static int at91_mci_suspend(struct platform_device *pdev, pm_message_t state)
        struct at91mci_host *host = mmc_priv(mmc);
        int ret = 0;
 
-       if (device_may_wakeup(&pdev->dev))
+       if (host->board->det_pin && device_may_wakeup(&pdev->dev))
                enable_irq_wake(host->board->det_pin);
 
        if (mmc)
@@ -987,7 +987,7 @@ static int at91_mci_resume(struct platform_device *pdev)
        struct at91mci_host *host = mmc_priv(mmc);
        int ret = 0;
 
-       if (device_may_wakeup(&pdev->dev))
+       if (host->board->det_pin && device_may_wakeup(&pdev->dev))
                disable_irq_wake(host->board->det_pin);
 
        if (mmc)


-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
