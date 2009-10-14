Return-Path: <linux-kernel-owner+w=401wt.eu-S934376AbZJNPPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934376AbZJNPPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932672AbZJNPPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:15:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:45323 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760722AbZJNPPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:15:44 -0400
Date: Wed, 14 Oct 2009 15:14:47 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
In-Reply-To: <20091010153349.196074920@linutronix.de>
References: <20091010153349.196074920@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86: Remove BKL from microcode
Message-ID: <tip-ac06ea2cd06291e63951b51dd7c9a23e6a1f2683@git.kernel.org>
Git-Commit-ID: ac06ea2cd06291e63951b51dd7c9a23e6a1f2683
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 15:14:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ac06ea2cd06291e63951b51dd7c9a23e6a1f2683
Gitweb:     http://git.kernel.org/tip/ac06ea2cd06291e63951b51dd7c9a23e6a1f2683
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 10 Oct 2009 09:35:48 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 14 Oct 2009 17:04:48 +0200

x86: Remove BKL from microcode

cycle_lock_kernel() in microcode_open() is a worthless exercise as
there is nothing to wait for. Remove it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <20091010153349.196074920@linutronix.de>

---
 arch/x86/kernel/microcode_core.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 378e9a8..2bcad39 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -73,7 +73,6 @@
 #include <linux/platform_device.h>
 #include <linux/miscdevice.h>
 #include <linux/capability.h>
-#include <linux/smp_lock.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
@@ -201,7 +200,6 @@ static int do_microcode_update(const void __user *buf, size_t size)
 
 static int microcode_open(struct inode *unused1, struct file *unused2)
 {
-	cycle_kernel_lock();
 	return capable(CAP_SYS_RAWIO) ? 0 : -EPERM;
 }
 
