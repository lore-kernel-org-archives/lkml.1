Return-Path: <linux-kernel-owner+w=401wt.eu-S1753506AbYHPWfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbYHPWfp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 18:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbYHPWfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 18:35:37 -0400
Received: from ns1.suse.de ([195.135.220.2]:43560 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbYHPWfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 18:35:37 -0400
Subject: patch uml-deal-with-host-time-going-backwards.patch added to 2.6.25-stable tree
To: jdike@addtoit.com, akpm@linux-foundation.org, gregkh@suse.de,
       jdike@linux.intel.com, linux-kernel@vger.kernel.org, nix@esperi.org.uk,
       torvalds@linux-foundation.org,
       user-mode-linux-devel@lists.sourceforge.net
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@suse.de>
Date: Sat, 16 Aug 2008 15:32:36 -0700
In-Reply-To: <20080805201406.GA11786@c2.user-mode-linux.org>
Message-Id: <20080816223532.57AA21454450@imap.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that we have just queued up the patch titled

    Subject: uml: deal with host time going backwards

to the 2.6.25-stable tree.  Its filename is

    uml-deal-with-host-time-going-backwards.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From stable-bounces@linux.kernel.org Tue Aug  5 13:14:23 2008
From: Jeff Dike <jdike@addtoit.com>
Date: Tue, 5 Aug 2008 16:14:06 -0400
Subject: uml: deal with host time going backwards
To: stable@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Message-ID: <20080805201406.GA11786@c2.user-mode-linux.org>
Content-Disposition: inline

From: Jeff Dike <jdike@addtoit.com>

commit 06e1e4ffbd1932e288839b3140cda6b8141eb684 upstream

Protection against the host's time going backwards (eg, ntp activity on
the host) by keeping track of the time at the last tick and if it's
greater than the current time, keep time stopped until the host catches
up.

Cc: Nix <nix@esperi.org.uk>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/um/os-Linux/time.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/um/os-Linux/time.c
+++ b/arch/um/os-Linux/time.c
@@ -106,6 +106,10 @@ static void deliver_alarm(void)
 	unsigned long long this_tick = os_nsecs();
 	int one_tick = UM_NSEC_PER_SEC / UM_HZ;
 
+	/* Protection against the host's time going backwards */
+	if ((last_tick != 0) && (this_tick < last_tick))
+		this_tick = last_tick;
+
 	if (last_tick == 0)
 		last_tick = this_tick - one_tick;
 
@@ -148,6 +152,9 @@ static int after_sleep_interval(struct t
 		start_usecs = usec;
 
 	start_usecs -= skew / UM_NSEC_PER_USEC;
+	if (start_usecs < 0)
+		start_usecs = 0;
+
 	tv = ((struct timeval) { .tv_sec  = start_usecs / UM_USEC_PER_SEC,
 				 .tv_usec = start_usecs % UM_USEC_PER_SEC });
 	interval = ((struct itimerval) { { 0, usec }, tv });


Patches currently in stable-queue which might be from jdike@addtoit.com are

queue-2.6.25/uml-fix-build-when-slob-is-enabled.patch
queue-2.6.25/uml-fix-bad-ntp-interaction-with-clock.patch
queue-2.6.25/uml-physical-memory-shouldn-t-include-initial-stack.patch
queue-2.6.25/uml-track-and-make-up-lost-ticks.patch
queue-2.6.25/uml-missed-kmalloc-in-pcap_user.c.patch
queue-2.6.25/uml-deal-with-host-time-going-backwards.patch
queue-2.6.25/uml-deal-with-inaccessible-address-space-start.patch
queue-2.6.25/uml-missing-export-of-csum_partial-on-uml-amd64.patch
queue-2.6.25/uml-memcpy-export-needs-to-follow-host-declaration.patch
queue-2.6.25/uml-stub-needs-to-tolerate-sigwinch.patch
queue-2.6.25/uml-work-around-broken-host-ptrace_sysemu.patch
queue-2.6.25/uml-fix-gcc-ices-and-unresolved-externs.patch
queue-2.6.25/uml-fix-boot-crash.patch
