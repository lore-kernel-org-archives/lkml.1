Return-Path: <linux-kernel-owner+w=401wt.eu-S1751977AbZLWA6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbZLWA6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 19:58:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbZLWA6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 19:58:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47976 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844AbZLWA6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 19:58:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: [Regression, 2.6.32->33-rc1] Commit 9f15226e755 breaks resume on Toshiba Portege R500
Date: Wed, 23 Dec 2009 01:58:42 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc1-tst; KDE/4.3.3; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912230158.42161.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas,

Unfortunately your commit 9f15226e75583547aaf542c6be4bdac1060dd425
(x86, ucode-amd: Ensure ucode update on suspend/resume after CPU off/online
cycle) breaks resume from suspend to RAM on my Toshiba Portege R500 (an attempt
to resume causes a hard hang with 100% CPU load, reproducible 100% of the
time).  This has been found by bisection and confirmed by reverting this commit
on top of 2.6.33-rc1.

Strangely enough, the box doesn't even have an AMD CPU, there's an Intel Core2
Duo in it, so I suspect some missing check somewhere.

If I have the time, I'll look deeper into this tomorrow.

[BTW, I can't recall seeing this patch before.  That very well may be my fault,
but please make sure that CCs of suspend-related patches are sent to me in
future.]

Rafael
