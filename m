Return-Path: <linux-kernel-owner+w=401wt.eu-S1754700AbYHPWg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbYHPWg4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 18:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbYHPWgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 18:36:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46795 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423AbYHPWgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 18:36:46 -0400
Subject: patch uml-fix-boot-crash.patch added to 2.6.25-stable tree
To: jdike@addtoit.com, gregkh@suse.de, jdike@linux.intel.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       user-mode-linux-devel@lists.sourceforge.net
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@suse.de>
Date: Sat, 16 Aug 2008 15:32:40 -0700
In-Reply-To: <20080805201410.GA11796@c2.user-mode-linux.org>
Message-Id: <20080816223644.966A91454450@imap.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that we have just queued up the patch titled

    Subject: uml: Fix boot crash

to the 2.6.25-stable tree.  Its filename is

    uml-fix-boot-crash.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From stable-bounces@linux.kernel.org Tue Aug  5 13:14:58 2008
From: Jeff Dike <jdike@addtoit.com>
Date: Tue, 5 Aug 2008 16:14:10 -0400
Subject: uml: Fix boot crash
To: stable@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Message-ID: <20080805201410.GA11796@c2.user-mode-linux.org>
Content-Disposition: inline

From: Jeff Dike <jdike@addtoit.com>

commit 7c1fed03b9fa32d4323d5caa6a9c7dcdd7eba767 upstream

My copying of linux/init.h didn't go far enough.  The definition of
__used singled out gcc minor version 3, but didn't care what the major
version was.  This broke when unit-at-a-time was added and gcc started
throwing out initcalls.

This results in an early boot crash when ptrace tries to initialize a
process with an empty, uninitialized register set.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/um/include/init.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/um/include/init.h
+++ b/arch/um/include/init.h
@@ -45,6 +45,8 @@ typedef void (*exitcall_t)(void);
 # define __section(S) __attribute__ ((__section__(#S)))
 #endif
 
+#if __GNUC__ == 3
+
 #if __GNUC_MINOR__ >= 3
 # define __used			__attribute__((__used__))
 #else
@@ -52,6 +54,12 @@ typedef void (*exitcall_t)(void);
 #endif
 
 #else
+#if __GNUC__ == 4
+# define __used			__attribute__((__used__))
+#endif
+#endif
+
+#else
 #include <linux/compiler.h>
 #endif
 /* These are for everybody (although not all archs will actually


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
