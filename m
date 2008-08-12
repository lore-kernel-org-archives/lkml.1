Return-Path: <linux-kernel-owner+w=401wt.eu-S1752544AbYHLVXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbYHLVXm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 17:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbYHLVXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 17:23:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:23038 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbYHLVXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 17:23:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZGuNUHfYQm2R1DTbzxVRAQIVQXKC075570nR/MCxZ0PeG9hvBVm0n5BkZatj+d2//n
         0VAdoUDVEFXkVtSaFi6AixSx3ybwe5UL9yA6TCINewVZzSGpCqWAqmom9T0uhQW8hT+Z
         5WrMOCJ/Twbx8F0AAHNyJFOgTnVXgc3PkR/QA=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: fix 2 section mismatch warnings - map_high()
Date: Tue, 12 Aug 2008 23:23:03 +0200
Message-Id: <1218576186-31442-1-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: vmlinux.o(.text+0x14cf8): Section mismatch in reference from the function map_high() to the function .init.text:init_extra_mapping_uc()
The function map_high() references
the function __init init_extra_mapping_uc().
This is often because map_high lacks a __init
annotation or the annotation of init_extra_mapping_uc is wrong.

WARNING: vmlinux.o(.text+0x14d05): Section mismatch in reference from the function map_high() to the function .init.text:init_extra_mapping_wb()
The function map_high() references
the function __init init_extra_mapping_wb().
This is often because map_high lacks a __init
annotation or the annotation of init_extra_mapping_wb is wrong.

map_high is called only from __init functions (map_*_high)
and calls 2 __init_functions (init_extra_mapping_*)

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/genx2apic_uv_x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index 2cfcbde..2d7e307 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -222,7 +222,7 @@ static __init void map_low_mmrs(void)
 
 enum map_type {map_wb, map_uc};
 
-static void map_high(char *id, unsigned long base, int shift, enum map_type map_type)
+static __init void map_high(char *id, unsigned long base, int shift, enum map_type map_type)
 {
 	unsigned long bytes, paddr;
 
-- 
1.5.4.5

