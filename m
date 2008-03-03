Return-Path: <linux-kernel-owner+w=401wt.eu-S1753787AbYCCR1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbYCCR1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759892AbYCCRPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:15:53 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759818AbYCCRPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:15:52 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 43/52] adapt voyager's setup_trampoline
Date: Mon,  3 Mar 2008 14:13:11 -0300
Message-Id: <1204564400-17636-44-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-43-git-send-email-gcosta@redhat.com>
References: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
 <1204564400-17636-2-git-send-email-gcosta@redhat.com>
 <1204564400-17636-3-git-send-email-gcosta@redhat.com>
 <1204564400-17636-4-git-send-email-gcosta@redhat.com>
 <1204564400-17636-5-git-send-email-gcosta@redhat.com>
 <1204564400-17636-6-git-send-email-gcosta@redhat.com>
 <1204564400-17636-7-git-send-email-gcosta@redhat.com>
 <1204564400-17636-8-git-send-email-gcosta@redhat.com>
 <1204564400-17636-9-git-send-email-gcosta@redhat.com>
 <1204564400-17636-10-git-send-email-gcosta@redhat.com>
 <1204564400-17636-11-git-send-email-gcosta@redhat.com>
 <1204564400-17636-12-git-send-email-gcosta@redhat.com>
 <1204564400-17636-13-git-send-email-gcosta@redhat.com>
 <1204564400-17636-14-git-send-email-gcosta@redhat.com>
 <1204564400-17636-15-git-send-email-gcosta@redhat.com>
 <1204564400-17636-16-git-send-email-gcosta@redhat.com>
 <1204564400-17636-17-git-send-email-gcosta@redhat.com>
 <1204564400-17636-18-git-send-email-gcosta@redhat.com>
 <1204564400-17636-19-git-send-email-gcosta@redhat.com>
 <1204564400-17636-20-git-send-email-gcosta@redhat.com>
 <1204564400-17636-21-git-send-email-gcosta@redhat.com>
 <1204564400-17636-22-git-send-email-gcosta@redhat.com>
 <1204564400-17636-23-git-send-email-gcosta@redhat.com>
 <1204564400-17636-24-git-send-email-gcosta@redhat.com>
 <1204564400-17636-25-git-send-email-gcosta@redhat.com>
 <1204564400-17636-26-git-send-email-gcosta@redhat.com>
 <1204564400-17636-27-git-send-email-gcosta@redhat.com>
 <1204564400-17636-28-git-send-email-gcosta@redhat.com>
 <1204564400-17636-29-git-send-email-gcosta@redhat.com>
 <1204564400-17636-30-git-send-email-gcosta@redhat.com>
 <1204564400-17636-31-git-send-email-gcosta@redhat.com>
 <1204564400-17636-32-git-send-email-gcosta@redhat.com>
 <1204564400-17636-33-git-send-email-gcosta@redhat.com>
 <1204564400-17636-34-git-send-email-gcosta@redhat.com>
 <1204564400-17636-35-git-send-email-gcosta@redhat.com>
 <1204564400-17636-36-git-send-email-gcosta@redhat.com>
 <1204564400-17636-37-git-send-email-gcosta@redhat.com>
 <1204564400-17636-38-git-send-email-gcosta@redhat.com>
 <1204564400-17636-39-git-send-email-gcosta@redhat.com>
 <1204564400-17636-40-git-send-email-gcosta@redhat.com>
 <1204564400-17636-41-git-send-email-gcosta@redhat.com>
 <1204564400-17636-42-git-send-email-gcosta@redhat.com>
 <1204564400-17636-43-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make setup_trampoline non-static. This way, it won't conflict
with the extern declaration in smp.h

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/mach-voyager/voyager_smp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index 0ab236e..9ff687a 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -429,7 +429,7 @@ void __init smp_store_cpu_info(int id)
 }
 
 /* set up the trampoline and return the physical address of the code */
-static __u32 __init setup_trampoline(void)
+unsigned long __init setup_trampoline(void)
 {
 	/* these two are global symbols in trampoline.S */
 	extern const __u8 trampoline_end[];
-- 
1.5.0.6

