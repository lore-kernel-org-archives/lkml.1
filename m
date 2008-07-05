Return-Path: <linux-kernel-owner+w=401wt.eu-S1755044AbYGEWqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbYGEWqT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 18:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbYGEWqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 18:46:11 -0400
Received: from smtp.wifcom.cz ([89.185.251.8]:39679 "EHLO wifcom.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751689AbYGEWqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 18:46:10 -0400
Date: Sun, 6 Jul 2008 00:46:35 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [regression] Re: 2.6.26-rc6: pcmcia stopped working
Message-ID: <20080705224631.GA32546@elf.ucw.cz>
References: <20080622224022.GA2066@elf.ucw.cz> <20080625220946.GA1587@elf.ucw.cz> <20080625221529.GA1600@elf.ucw.cz> <200807051448.40466.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807051448.40466.bzolnier@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > Hmm, hitting sysrq-w produces no blocked task until I eject pcmcia
> > > > card. Backtrace there is:
> > > > 
> > > > Greg, I believe some traces lead to sysfs, can you help here?
> > > 
> > > ide_unregister() does not complete :-(.
> > > 
> > >         device_unregister(&hwif->gendev);
> > > +       printk("ide_unregister: waiting for rel_comp\n");
> > >         wait_for_completion(&hwif->gendev_rel_comp);
> > > 
> > > ...that wait_for_completion never returns.
> 
> [...]
> 
> Thanks for narrowing it down to wait_for_completion() call,
> it was an useful hint.

Thanks for a patch, I'll test it soon. Here are two really trivial
patches... maybe too trivial?

---

Small whitespace fixes for drivers/ide.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 380fa0c..df70d36 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -617,7 +617,7 @@ static inline u8 probe_for_drive (ide_dr
 	return drive->present;
 }
 
-static void hwif_release_dev (struct device *dev)
+static void hwif_release_dev(struct device *dev)
 {
 	ide_hwif_t *hwif = container_of(dev, ide_hwif_t, gendev);
 
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index c758dcb..846bcfb 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -1,6 +1,6 @@
 /*
  *  Copyright (C) 1994-1998	    Linus Torvalds & authors (see below)
- *  Copyrifht (C) 2003-2005, 2007   Bartlomiej Zolnierkiewicz
+ *  Copyright (C) 2003-2005, 2007   Bartlomiej Zolnierkiewicz
  */
 
 /*


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
