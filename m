Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbYFQKlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbYFQKlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 06:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbYFQKlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 06:41:00 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41684 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbYFQKk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 06:40:59 -0400
Date: Tue, 17 Jun 2008 11:36:02 +0200
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, benh@kernel.crashing.org,
       jgarzik@pobox.com
Subject: sata_svw data corruption, strange problems
Message-ID: <20080617093602.GA28140@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I see strange problems on machine with sata_svw. The machine seems to
corrupt data every few days (ext3 error, dir index corrupted), and has
some other very strange problems (keyboard misbehaves, pulling out
SATA disk cures it, see
https://bugzilla.novell.com/show_bug.cgi?id=400772 ).

Then I got to the comment 

        writeb(dmactl | ATA_DMA_START, mmio + ATA_DMA_CMD);
        /* There is a race condition in certain SATA controllers that
can
           be seen when the r/w command is given to the controller
before the
           host DMA is started. On a Read command, the controller
would initiate
           the command to the drive even before it sees the DMA
start. When there
           are very fast drives connected to the controller, or when
the data request
           hits in the drive cache, there is the possibility that the
drive returns a part
           or all of the requested data to the controller before the
DMA start is issued.
           In this case, the controller would become confused as to
what to do with the data.
           In the worst case when all the data is returned back to the
controller, the
           controller could hang. In other cases it could return
partial data returning
           in data corruption. This problem has been seen in PPC
systems and can also appear
           on an system with very fast disks, where the SATA
controller is sitting behind a
           number of bridges, and hence there is significant latency
between the r/w command
           and the start command. */
        /* issue r/w command if the access is to ATA*/
        if (qc->tf.protocol == ATA_PROT_DMA)

...and that would certainly explain what we are seeing. Are
serverworks controllers broken by design?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
