Return-Path: <linux-kernel-owner+w=401wt.eu-S1752728AbZHBMve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbZHBMve (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 08:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbZHBMvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 08:51:33 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47929 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbZHBMvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 08:51:32 -0400
Date: Thu, 30 Jul 2009 11:08:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Eric Miao <eric.y.miao@gmail.com>, Tobias Diedrich <ranma@tdiedrich.de>,
       rpurdie@rpsys.net, lenz@cs.wisc.edu, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.miao@marvell.com
Subject: Re: [Bug #13833] Kernel Oops when trying to suspend with ubifs
	mounted on block2mtd mtd device
Message-ID: <20090730090826.GF1364@ucw.cz>
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <3zAHs5O6maO.A.gfC.QHObKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3zAHs5O6maO.A.gfC.QHObKB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).

I believe I'm experiencing duplicate of this on zaurus.

I'm using (attached patch) to work around.

Legally speaking:

Signed-off-by: Pavel Machek <pavel@ucw.cz>
									Pavel


diff -ur mtd.ofic/mtdcore.c mtd/mtdcore.c
--- mtd.ofic/mtdcore.c	2009-07-15 01:42:06.000000000 +0200
+++ mtd/mtdcore.c	2009-07-21 17:55:45.000000000 +0200
@@ -29,8 +29,8 @@
 static struct class mtd_class = {
 	.name = "mtd",
 	.owner = THIS_MODULE,
-	.suspend = mtd_cls_suspend,
-	.resume = mtd_cls_resume,
+	//	.suspend = mtd_cls_suspend,
+	//.resume = mtd_cls_resume,
 };
 
 /* These are exported solely for the purpose of mtd_blkdevs.c. You
Only in mtd: mtdcore.c~
Binary files mtd.ofic/mtdcore.o and mtd/mtdcore.o differ

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
