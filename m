Return-Path: <linux-kernel-owner+w=401wt.eu-S1754441AbXEFU4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbXEFU4P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 16:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754387AbXEFU4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 16:56:14 -0400
Received: from www.osadl.org ([213.239.205.134]:37019 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754348AbXEFU4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 16:56:13 -0400
Subject: [PATCH] x86-64 highres/dyntick support
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: LKML <linux-kernel@vger.kernel.org>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sun, 06 May 2007 22:58:47 +0200
Message-Id: <1178485128.31213.98.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm pleased to announce the first cut of the final x86_64
highres/dyntick support, which I did based on Chris Wright's patch set,
which is again based on Arjan van de Ven's initial work:

http://www.tglx.de/projects/hrtimers/2.6.21-git2-x86-64/patches-2.6.21-git2.patch.bz2

Broken out version:

http://www.tglx.de/projects/hrtimers/2.6.21-git2-x86-64/patches-2.6.21-git2.tar.bz2

It applies on top of 2.6.21-git2 and contains the following patches:

# Andi's x86_64 queue (already in -mm and pending mainline merges)
x86_64-2.6.21-git2.patch 

# Outstanding fixups to highres/dyntick core and i386 
# (-mm and mainline pending)
highres-dyntick-avoid-xtime-lock-contention.patch
acpi-keep-tsc-stable-when-lapic-timer-c2-ok-is-set.patch
clocksource-fix-resume-logic.patch
clockevents-fix-resume-logic.patch

# x86_64 dyntick support
x86-64-untangle-hpet-headers.patch
x86-64-drive-set-rtc-mss.patch
i386-move-pit-setup-to-i8253-h.patch
x86-64-remove-dead-code-tsc-c.patch
x86-64-convert-to-clockevents.patch
x86-64-prepare-idle-for-dyntick.patch
x86-64-enable-highres-dyntick.patch

The x86-64-convert-to-clockevents.patch is rather large, but there is no
way to do this incremental. The clockevents conversion has to be done in
one go. 

The x86-64 clockevents patch set overall summary is:

 22 files changed, 631 insertions(+), 1199 deletions(-)

due to sharing the code of PIT and HPET with i386.

I did not dare to tackle sharing apic.c yet, but there is definitely a
chance to get this done some day when I get bored and do a:
# mkdir arch/x86  :)

I'm going to post the x86_64 set for review to LKML once the outstanding
highres/dyntick fixups have hit mainline resp. -mm

To create a highres / dyntick enabled kernel for x86_64:
http://kernel.org/pub/linux/kernel/v2.6/linux-2.6.21.tar.bz2
http://kernel.org/pub/linux/kernel/v2.6/snapshots/patch-2.6.21-git2.bz2
http://www.tglx.de/projects/hrtimers/2.6.21-git2-x86-64/patches-2.6.21-git2.patch.bz2


Comments, bugreports, patches are welcome as ususal

Thanks,

	tglx


