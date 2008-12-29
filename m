Return-Path: <linux-kernel-owner+w=401wt.eu-S1752540AbYL2PFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbYL2PFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 10:05:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbYL2PEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 10:04:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:45089 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbYL2PEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 10:04:53 -0500
Subject: [PATCH] x86_64: apic.c declare pic_mode before they get used
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 29 Dec 2008 20:32:52 +0530
Message-Id: <1230562972.26564.1.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, avoid sparse warning

In asm/mpspec.h moved out pic_mode from CONFIG_X86_32 as it is common for both 32 and 64 bit.

Fixes this sparse warning for x86_64:
arch/x86/kernel/apic.c:128:5: warning: symbol 'pic_mode' was not declared. Should it be static?

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/mpspec.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 91885c2..62d14ce 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -6,13 +6,13 @@
 #include <asm/mpspec_def.h>
 
 extern int apic_version[MAX_APICS];
+extern int pic_mode;
 
 #ifdef CONFIG_X86_32
 #include <mach_mpspec.h>
 
 extern unsigned int def_to_bigsmp;
 extern u8 apicid_2_node[];
-extern int pic_mode;
 
 #ifdef CONFIG_X86_NUMAQ
 extern int mp_bus_id_to_node[MAX_MP_BUSSES];
-- 
1.5.5.1



