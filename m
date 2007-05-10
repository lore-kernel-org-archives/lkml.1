Return-Path: <linux-kernel-owner+w=401wt.eu-S1760535AbXEJJuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760535AbXEJJuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 05:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757380AbXEJJu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 05:50:29 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:47540 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754874AbXEJJu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 05:50:26 -0400
Date: Thu, 10 May 2007 11:48:48 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: NeilBrown <neilb@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 002 of 2] md: Improve the is_mddev_idle test
In-Reply-To: <1070510062231.20403@suse.de>
Message-ID: <Pine.LNX.4.61.0705101143540.32349@yvahk01.tjqt.qr>
References: <20070510161940.20204.patches@notabene> <1070510062231.20403@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 10 2007 16:22, NeilBrown wrote:
>
>diff .prev/drivers/md/md.c ./drivers/md/md.c
>--- .prev/drivers/md/md.c	2007-05-10 15:51:54.000000000 +1000
>+++ ./drivers/md/md.c	2007-05-10 16:05:10.000000000 +1000
>@@ -5095,7 +5095,7 @@ static int is_mddev_idle(mddev_t *mddev)
> 		 *
> 		 * Note: the following is an unsigned comparison.
> 		 */
>-		if ((curr_events - rdev->last_events + 4096) > 8192) {
>+		if ((long)curr_events - (long)rdev->last_events > 4096) {
> 			rdev->last_events = curr_events;
> 			idle = 0;
> 		}

What did really change? Unless I am seriously mistaken,

    curr_events - last_evens + 4096 > 8192

is mathematically equivalent to

    curr_events - last_evens        > 4096

The casting to (long) may however force a signed comparison which turns
things quite upside down, and the comment does not apply anymore.


	Jan
-- 
