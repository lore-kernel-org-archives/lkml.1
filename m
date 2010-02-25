Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758875Ab0BYKLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 05:11:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:47752 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758829Ab0BYKLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 05:11:03 -0500
Date: Thu, 25 Feb 2010 10:10:35 GMT
From: tip-bot for Thadeu Lima de Souza Cascardo 
	<cascardo@holoscopio.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       cascardo@holoscopio.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, cascardo@holoscopio.com
In-Reply-To: <1265758732-19320-1-git-send-email-cascardo@holoscopio.com>
References: <1265758732-19320-1-git-send-email-cascardo@holoscopio.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86: Do not reserve brk for DMI if it's not going to be used
Message-ID: <tip-e808bae2407a087bfd40200a27587898e5a9909d@git.kernel.org>
Git-Commit-ID: e808bae2407a087bfd40200a27587898e5a9909d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 10:10:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e808bae2407a087bfd40200a27587898e5a9909d
Gitweb:     http://git.kernel.org/tip/e808bae2407a087bfd40200a27587898e5a9909d
Author:     Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
AuthorDate: Tue, 9 Feb 2010 21:38:45 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Feb 2010 10:28:18 +0100

x86: Do not reserve brk for DMI if it's not going to be used

This will save 64K bytes from memory when loading linux if DMI is
disabled, which is good for embedded systems.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
LKML-Reference: <1265758732-19320-1-git-send-email-cascardo@holoscopio.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/setup.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 3499b4f..cb42109 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -121,7 +121,9 @@
 unsigned long max_low_pfn_mapped;
 unsigned long max_pfn_mapped;
 
+#ifdef CONFIG_DMI
 RESERVE_BRK(dmi_alloc, 65536);
+#endif
 
 unsigned int boot_cpu_id __read_mostly;
 
