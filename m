Return-Path: <linux-kernel-owner+w=401wt.eu-S935178AbXEIF4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935178AbXEIF4o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 01:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935050AbXEIF4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 01:56:33 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:39256 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934647AbXEIF4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 01:56:32 -0400
Message-ID: <46416255.3060105@drzeus.cx>
Date: Wed, 09 May 2007 07:55:33 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=_hera.drzeus.cx-7137-1178690185-0001-2"
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] MMC updates
References: <4640E17E.7090909@drzeus.cx>
In-Reply-To: <4640E17E.7090909@drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-7137-1178690185-0001-2
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit

Pierre Ossman wrote:
> Linus, please pull from
> 
>         git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-linus
> 

fsck! I pushed the wrong branch :/

This fix should have been in the last commit.

Sorry,
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

--=_hera.drzeus.cx-7137-1178690185-0001-2
Content-Type: text/x-patch; name="spinfix.patch"; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="spinfix.patch"

commit 3b9a6d78eb439016728c598a1373b50328f5e9fe
Author: Pierre Ossman <drzeus@drzeus.cx>
Date:   Wed May 9 07:53:28 2007 +0200

    mmc: fix wrong call to spinlock
    
    Fix silly typo in spinlock calls.
    
    Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index b6c1670..7385acf 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -501,9 +501,9 @@ void mmc_detect_change(struct mmc_host *host, unsigned long delay)
 {
 #ifdef CONFIG_MMC_DEBUG
 	unsigned long flags;
-	spin_lock_irqsave(host->lock, flags);
+	spin_lock_irqsave(&host->lock, flags);
 	BUG_ON(host->removed);
-	spin_unlock_irqrestore(host->lock, flags);
+	spin_unlock_irqrestore(&host->lock, flags);
 #endif
 
 	mmc_schedule_delayed_work(&host->detect, delay);

--=_hera.drzeus.cx-7137-1178690185-0001-2--
