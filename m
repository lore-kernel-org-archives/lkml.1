Return-Path: <linux-kernel-owner+w=401wt.eu-S1761988AbXEJMyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761988AbXEJMyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 08:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759442AbXEJMyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 08:54:33 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:37693 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756823AbXEJMyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 08:54:32 -0400
Date: Thu, 10 May 2007 14:52:45 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Neil Brown <neilb@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 002 of 2] md: Improve the is_mddev_idle test
In-Reply-To: <17986.60947.483379.159313@notabene.brown>
Message-ID: <Pine.LNX.4.61.0705101450210.32349@yvahk01.tjqt.qr>
References: <20070510161940.20204.patches@notabene> <1070510062231.20403@suse.de>
 <Pine.LNX.4.61.0705101143540.32349@yvahk01.tjqt.qr> <17986.60947.483379.159313@notabene.brown>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 10 2007 20:04, Neil Brown wrote:
>> >-		if ((curr_events - rdev->last_events + 4096) > 8192) {
>> >+		if ((long)curr_events - (long)rdev->last_events > 4096) {
>> > 			rdev->last_events = curr_events;
>> > 			idle = 0;
>> > 		}
>> 
>/* sync IO will cause sync_io to increase before the disk_stats
> * as sync_io is counted when a request starts, and 
> * disk_stats is counted when it completes.
> * So resync activity will cause curr_events to be smaller than
> * when there was no such activity.
> * non-sync IO will cause disk_stat to increase without
> * increasing sync_io so curr_events will (eventually)
> * be larger than it was before.  Once it becomes
> * substantially larger, the test below will cause
> * the array to appear non-idle, and resync will slow
> * down.
> * If there is a lot of outstanding resync activity when
> * we set last_event to curr_events, then all that activity
> * completing might cause the array to appear non-idle
> * and resync will be slowed down even though there might
> * not have been non-resync activity.  This will only
> * happen once though.  'last_events' will soon reflect
> * the state where there is little or no outstanding
> * resync requests, and further resync activity will
> * always make curr_events less than last_events.
> *
> */
>
>Does that read at all well?

It is a more verbose explanation of your patch description, yes.


	Jan
-- 
