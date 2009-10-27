Return-Path: <linux-kernel-owner+w=401wt.eu-S1753965AbZJ0LkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbZJ0LkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 07:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877AbZJ0LkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 07:40:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:56997 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753868AbZJ0LkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 07:40:06 -0400
Date: Tue, 27 Oct 2009 11:39:36 GMT
From: tip-bot for Feng Tang <feng.tang@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       mjg59@srcf.ucam.org, tglx@linutronix.de, feng.tang@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, tglx@linutronix.de, feng.tang@intel.com
In-Reply-To: <20091020125402.028d66d5@feng-desktop>
References: <20091020125402.028d66d5@feng-desktop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Make EFI RTC function depend on 32bit again
Message-ID: <tip-772be899bc022ef2b911c3611b487d417e3269c3@git.kernel.org>
Git-Commit-ID: 772be899bc022ef2b911c3611b487d417e3269c3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  772be899bc022ef2b911c3611b487d417e3269c3
Gitweb:     http://git.kernel.org/tip/772be899bc022ef2b911c3611b487d417e3269c3
Author:     Feng Tang <feng.tang@intel.com>
AuthorDate: Tue, 20 Oct 2009 12:54:02 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 27 Oct 2009 12:35:48 +0100

x86: Make EFI RTC function depend on 32bit again

The EFI RTC functions are only available on 32 bit. commit 7bd867df
(x86: Move get/set_wallclock to x86_platform_ops) removed the 32bit
dependency which leads to boot crashes on 64bit EFI systems.

Add the dependency back. 
Solves: http://bugzilla.kernel.org/show_bug.cgi?id=14466

Tested-by: Matthew Garrett <mjg59@srcf.ucam.org>
Signed-off-by: Feng Tang <feng.tang@intel.com>
LKML-Reference: <20091020125402.028d66d5@feng-desktop>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/efi.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/efi.c b/arch/x86/kernel/efi.c
index ad5bd98..cdcfb12 100644
--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -454,8 +454,10 @@ void __init efi_init(void)
 	if (add_efi_memmap)
 		do_add_efi_memmap();
 
+#ifdef CONFIG_X86_32
 	x86_platform.get_wallclock = efi_get_time;
 	x86_platform.set_wallclock = efi_set_rtc_mmss;
+#endif
 
 	/* Setup for EFI runtime service */
 	reboot_type = BOOT_EFI;
