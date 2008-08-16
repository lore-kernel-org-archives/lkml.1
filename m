Return-Path: <linux-kernel-owner+w=401wt.eu-S1755146AbYHPWiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbYHPWiT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 18:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbYHPWiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 18:38:00 -0400
Received: from ns.suse.de ([195.135.220.2]:43801 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbYHPWh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 18:37:59 -0400
Subject: patch uml-memcpy-export-needs-to-follow-host-declaration.patch added to 2.6.25-stable tree
To: jdike@addtoit.com, akpm@linux-foundation.org, gregkh@suse.de,
       jdike@linux.intel.com, linux-kernel@vger.kernel.org,
       nix.or.die@googlemail.com, torvalds@linux-foundation.org,
       user-mode-linux-devel@lists.sourceforge.net
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@suse.de>
Date: Sat, 16 Aug 2008 15:32:43 -0700
In-Reply-To: <20080805201409.GA11792@c2.user-mode-linux.org>
Message-Id: <20080816223757.981DE1454450@imap.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that we have just queued up the patch titled

    Subject:  uml: memcpy export needs to follow host declaration

to the 2.6.25-stable tree.  Its filename is

    uml-memcpy-export-needs-to-follow-host-declaration.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From stable-bounces@linux.kernel.org Tue Aug  5 13:15:05 2008
From: Jeff Dike <jdike@addtoit.com>
Date: Tue, 5 Aug 2008 16:14:09 -0400
Subject:  uml: memcpy export needs to follow host declaration
To: stable@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Message-ID: <20080805201409.GA11792@c2.user-mode-linux.org>
Content-Disposition: inline

From: Jeff Dike <jdike@addtoit.com>

commit 8bfd04b974689f700bbd053ad6e66b0a95fb80c9 upstream

x86_64 defines either memcpy or __memcpy depending on the gcc version, and
it looks like UML needs to follow that in its exporting.

Cc: Gabriel C <nix.or.die@googlemail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/um/sys-x86_64/ksyms.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/um/sys-x86_64/ksyms.c
+++ b/arch/um/sys-x86_64/ksyms.c
@@ -13,5 +13,9 @@ EXPORT_SYMBOL(__down_failed_trylock);
 EXPORT_SYMBOL(__up_wakeup);
 
 /*XXX: we need them because they would be exported by x86_64 */
+#if (__GNUC__ == 4 && __GNUC_MINOR__ >= 3) || __GNUC__ > 4
+EXPORT_SYMBOL(memcpy);
+#else
 EXPORT_SYMBOL(__memcpy);
+#endif
 EXPORT_SYMBOL(csum_partial);


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
