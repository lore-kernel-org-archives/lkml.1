Return-Path: <linux-kernel-owner+w=401wt.eu-S1755979AbXIVW3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbXIVW3S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 18:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbXIVW3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 18:29:07 -0400
Received: from www.osadl.org ([213.239.205.134]:35550 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753410AbXIVW3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 18:29:06 -0400
Message-Id: <20070922220347.586903979@linutronix.de>
User-Agent: quilt/0.46-1
Date: Sat, 22 Sep 2007 22:29:04 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [patch 0/2] suspend/resume regression fixes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, it took me quite a while to realize the real root cause of the
VAIO - and probably many other machines - suspend/resume regressions,
which were unearthed by the dyntick / clockevents patches.

We disable a lot of ACPI/BIOS functionality during suspend, but we
keep the lower idle C-states functionality active across
suspend/resume. It seems that this causes trouble with certain BIOSes,
but I assume that the problem is more wide spread and just not
surfacing due to the various scenarios in which a machine goes into
suspend/resume. I spent some quality time to figure out a set of debug
mechanisms, which did not influence the problem. So it is quite likely
that a lot of machines might be affected by this, but due to the
configuration, interrupt scenarios, .... the problem just does
not show up. 

My final enlightment was, when I removed the ACPI processor module,
which controls the lower idle C-states, right before resume; this
worked fine all the time even without all the workaround hacks.

I really hope that this two patches finally set an end to the "jinxed
VAIO heisenbug series", which started when we removed the periodic
tick with the clockevents/dyntick patches.

Venki, can you please add the analogous fix to the cpuidle patch set ?

Thanks,

	tglx
-- 

