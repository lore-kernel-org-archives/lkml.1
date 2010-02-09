Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab0BIXoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 18:44:18 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:46781 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab0BIXoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 18:44:17 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-kernel@vger.kernel.org
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Yinghai Lu <yinghai@kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH] x86: do not reserve brk for DMI if it's not going to be used
Date: Tue,  9 Feb 2010 21:38:45 -0200
Message-Id: <1265758732-19320-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will save 65536 bytes from memory when loading linux, which is good
for embedded systems.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
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
 
-- 
1.6.6.1

