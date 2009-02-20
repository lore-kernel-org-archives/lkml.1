Return-Path: <linux-kernel-owner+w=401wt.eu-S1756200AbZBTE6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200AbZBTE6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 23:58:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbZBTE5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 23:57:52 -0500
Received: from byss.tchmachines.com ([208.76.80.75]:56025 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbZBTE5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 23:57:51 -0500
Date: Thu, 19 Feb 2009 20:57:49 -0800
From: Josh Hunt <josh@scalex86.org>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, kiran@scalex86.org
Subject: Clocksource with rating 0 marked unstable twice
Message-ID: <20090220045749.GC8151@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a system with TSCs which are known to be unsynchronized.
During TSC initialization it is marked as unstable, but later on in
the boot the clocksource watchdog code also marks it unstable.  This
seems a bit redundant as both set the rating to 0.

<dmesg snippet>
[    0.000000] Marking TSC unstable due to TSCs unsynchronized
...
[    4.740022] Clocksource tsc unstable (delta = 4380394573887 ns)
</dmesg snippet>

I can think of two solutions, both modifying clocksource_register
when rating is 0:

1. Do not call clocksource_check_watchdog. This way the clocksource
is not put on the watchdog list.

2. Do not enqueue the clocksource or do any registering.  Is there a
good reason to keep around a clocksource which has a rating of 0?

Which of these would be better?  I can provide a patch for either.

Thanks
Josh
