Return-Path: <linux-kernel-owner+w=401wt.eu-S1752610AbZIFF07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbZIFF07 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 01:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbZIFF06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 01:26:58 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52399 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbZIFF05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 01:26:57 -0400
Date: Sun, 6 Sep 2009 07:26:53 +0200
From: Pavel Machek <pavel@ucw.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.miao@marvell.com,
       utx@penguin.cz
Subject: Zaurus suspend saga
Message-ID: <20090906052653.GB1324@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Even with mtd regression fixed, spitz will still not suspend/resume
correctly.

I got hint that SPI suspend may be responsible...

With 2.6.31-rc7:

with corgi_enter_suspend stubbed out and parts of spitz_should_wakeup
disabled, it suspends/resumes ok. 

spitz_pm.c parts -- yes it controls wakeup, but it only seems to read GPIOs? 

spitz_should_wakeup: printks do not signal this triggers, perhaps
change is not strictly neccessary.

sharpsl_fatal_check seems to trigger, sending machine to sleep :-(.

fatal reads invalid values -- -108 -- probably because spi is not ready?

is spi suspend/resume required? yes.; and yes spi is resumed too late
 in the sequence. Or perhaps fatal battery check is way too early.

Could someone confirm that simply removing sharpsl_fatal_check() fixes
zaurus suspend on 2.6.31? 

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
