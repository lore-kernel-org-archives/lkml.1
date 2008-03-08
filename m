Return-Path: <linux-kernel-owner+w=401wt.eu-S1760707AbYCHEiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760707AbYCHEiZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 23:38:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754987AbYCHEiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 23:38:15 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:53215 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbYCHEiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 23:38:14 -0500
Date: Fri, 7 Mar 2008 22:37:37 -0600
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, Matt Reimer <mreimer@vpop.net>
Subject: [W1] ds1wm: testers please, msleep not udelay
Message-ID: <20080308043728.GA23298@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 07 Mar 2008 22:38:03 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm working on some patches to the one wire system I just need to
split them into small logical patches.  I don't have the hardware to
test this ds1wm change.  I wouldn't expect the delay here to be
critical, and on a handheld platform, I wouldn't think busywaiting for
such a long time to be a good idea.  I also wouldn't expect putting
off reading the battery status a timer tick to matter much, so why not
sleep?

So, if someone would try out the patch and report back or tell me why
it's wrong I would appreciate it.  If it looks good I'll submit the
patch with the rest of the one wire changes I'm working on.

Index: drivers/w1/masters/ds1wm.c
===================================================================
RCS file: /home/david/kernel/k/spacedout/patches/linux/drivers/w1/masters/ds1wm.c,v
retrieving revision 1.3
retrieving revision 1.4
diff -u -p -r1.3 -r1.4
--- drivers/w1/masters/ds1wm.c	2 Feb 2008 18:37:24 -0000	1.3
+++ drivers/w1/masters/ds1wm.c	15 Feb 2008 03:42:36 -0000	1.4
@@ -159,8 +159,10 @@ static int ds1wm_reset(struct ds1wm_data
 	 *     625 us - 60 us - 240 us - 100 ns = 324.9 us
 	 *
 	 * We'll wait a bit longer just to be sure.
+	 * Was udelay(500), but if it is going to busywait the cpu that long,
+	 * might as well come back later.
 	 */
-	udelay(500);
+	msleep(1);
 
 	ds1wm_write_register(ds1wm_data, DS1WM_INT_EN,
 		DS1WM_INTEN_ERBF | DS1WM_INTEN_ETMT | DS1WM_INTEN_EPD |

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)
