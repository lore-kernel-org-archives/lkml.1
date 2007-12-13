Return-Path: <linux-kernel-owner+w=401wt.eu-S1761849AbXLMGsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761849AbXLMGsd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 01:48:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758700AbXLMGic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:38:32 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56661 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbXLMGia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:38:30 -0500
Date: Wed, 12 Dec 2007 22:35:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 31/36] Revert "Fix SMP poweroff hangs"
Message-ID: <20071213063525.GF25301@kroah.com>
References: <20071213062511.265908583@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="revert-fix-smp-poweroff-hangs.patch"
In-Reply-To: <20071213063308.GA25301@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Greg Kroah-Hartman <gregkh@suse.de>

This reverts the following changeset in 2.6.22.10 that caused a lot of
reported problems.

	From: Mark Lord <lkml@rtr.ca>

	commit 4047727e5ae33f9b8d2b7766d1994ea6e5ec2991 from upstream

	We need to disable all CPUs other than the boot CPU (usually 0) before
	attempting to power-off modern SMP machines.  This fixes the
	hang-on-poweroff issue on my MythTV SMP box, and also on Thomas Gleixner's
	new toybox.

	Signed-off-by: Mark Lord <mlord@pobox.com>
	Acked-by: Thomas Gleixner <tglx@linutronix.de>
	Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
	Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
	Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
	Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

There still is a remaining shutdown problem in 2.6.22 with old APM based
systems, but this fix is not the correct one

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 kernel/sys.c |    2 --
 1 file changed, 2 deletions(-)

--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -31,7 +31,6 @@
 #include <linux/cn_proc.h>
 #include <linux/getcpu.h>
 #include <linux/task_io_accounting_ops.h>
-#include <linux/cpu.h>
 
 #include <linux/compat.h>
 #include <linux/syscalls.h>
@@ -866,7 +865,6 @@ EXPORT_SYMBOL_GPL(kernel_halt);
 void kernel_power_off(void)
 {
 	kernel_shutdown_prepare(SYSTEM_POWER_OFF);
-	disable_nonboot_cpus();
 	printk(KERN_EMERG "Power down.\n");
 	machine_power_off();
 }

-- 
