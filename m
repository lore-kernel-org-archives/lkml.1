Return-Path: <linux-kernel-owner+w=401wt.eu-S1752609AbXCMSMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbXCMSMB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 14:12:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbXCMSMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 14:12:01 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:54927 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752609AbXCMSMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 14:12:00 -0400
Date: Tue, 13 Mar 2007 19:11:47 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Oliver Neukum <oneukum@suse.de>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [1/6] 2.6.21-rc3: known regressions
Message-ID: <20070313181147.GA12224@elf.ucw.cz>
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org> <20070313124957.GR18731@stusta.de> <45F6A240.3090601@drzeus.cx> <200703131436.15586.oneukum@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703131436.15586.oneukum@suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Subject    : mmc card reader no longer works
> > > References : http://lkml.org/lkml/2007/2/27/91
> > > Submitter  : Pavel Machek <pavel@ucw.cz>
> > > Handled-By : Oliver Neukum <oneukum@suse.de>
> > > Status     : unknown
> > > 
> > 
> > First I heard of this. The error report is a bit thin so Pavel will need to
> > elaborate a bit more.
> 
> The device is a USB serial device. USB serial was known to have issues
> in the version this happened. As far as I know the bug has not been
> replicated after this bugs were fixed.

Ahha, now I see where the confusion comes from.

No, the reader is not a serial device, it is reader build-in x60. USB
serial device (siemens sx1) has separate problem.

Device is 

15:00.2 Generic system peripheral [0805]: Ricoh Co Ltd R5C822
SD/SDIO/MMC/MS/MSPro Host Adapter (rev 18)

root@amd:~# ls -al /dev/mmc
brw-r--r-- 1 root root 251, 0 Nov  5 16:57 /dev/mmc
...

...anything else I should try? Card is obviously detected, but I can't
access it..

Uhuh. User error, lets close the report.

mmc changed the major to 

236 mmc

... while it was something else in 2.6.20. Can we get stable device
allocation for mmc?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
