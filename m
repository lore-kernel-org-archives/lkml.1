Return-Path: <linux-kernel-owner+w=401wt.eu-S1759997AbZASWNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997AbZASWNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 17:13:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbZASWNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 17:13:14 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48598 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbZASWNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 17:13:13 -0500
Date: Mon, 19 Jan 2009 23:15:08 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: kernel list <linux-kernel@vger.kernel.org>, teheo@novell.com,
       trenn@suse.de, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org
Subject: Re: 2.6.29-rc2: thinkpad dock -- cdrom vs. s2ram
Message-ID: <20090119221508.GA2576@elf.ucw.cz>
References: <20090119202423.GA7070@ucw.cz> <200901192150.59438.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901192150.59438.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-01-19 21:50:58, Rafael J. Wysocki wrote:
> On Monday 19 January 2009, Pavel Machek wrote:
> > Hi!
> > 
> > In 2.6.29 (and probably earlier) kernels, booting in docking station
> > results in undocked s2ram failing.
> > 
> > Problem seems to be that hda (cdrom in dock) is not deregistered
> > during undock, and that hda driver loops spitting error messages at
> > 'too-fast-to-read' rate when suspend with missing hda is attempted.
> 
> What driver do you mean exactly?  Old-IDE I would guess.
> 
> Does this also happen with a PATA/libata driver?

I guess I'm confused. I tried:

--- config.ok	2009-01-19 11:40:42.000000000 +0100
+++ ../b-linux/.config	2009-01-19 22:45:03.000000000 +0100
@@ -1022,7 +1022,7 @@
 # CONFIG_SATA_SIL24 is not set
 CONFIG_ATA_SFF=y
 CONFIG_SATA_SVW=y
-CONFIG_ATA_PIIX=y
+# CONFIG_ATA_PIIX is not set
 # CONFIG_SATA_MV is not set
 # CONFIG_SATA_NV is not set
 # CONFIG_PDC_ADMA is not set
@@ -1058,8 +1058,8 @@
 # CONFIG_PATA_JMICRON is not set
 # CONFIG_PATA_TRIFLEX is not set
 # CONFIG_PATA_MARVELL is not set
-# CONFIG_PATA_MPIIX is not set
-# CONFIG_PATA_OLDPIIX is not set
+CONFIG_PATA_MPIIX=y
+CONFIG_PATA_OLDPIIX=y
 # CONFIG_PATA_NETCELL is not set
 # CONFIG_PATA_NINJA32 is not set
 # CONFIG_PATA_NS87410 is not set

...but cdrom is still detected as hda.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
