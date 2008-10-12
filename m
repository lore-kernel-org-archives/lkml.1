Return-Path: <linux-kernel-owner+w=401wt.eu-S1758308AbYJLJjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758308AbYJLJjk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 05:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756841AbYJLJj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 05:39:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:9454 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbYJLJj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 05:39:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GhAKEc2WDVreSA9rlOtQscbTOhyaGxcDFtW6FWh+8Jz0uZGGuhBgcE/pipOgUG91r6
         l9GkEltczW+sw7+PDsSN/zY95sU6w14+OGSP9cu6GBx5/tuWqL5Ic7lvdcxIaiapNDEy
         0eloaKxLFGTzB8ELPwQVoarWMK32gghgR7+KM=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/7] x86, xsave: fix section mismatch warning - setup_xstate_init
Date: Sun, 12 Oct 2008 11:38:44 +0200
Message-Id: <1223804330-10881-2-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1223804330-10881-1-git-send-email-marcin.slusarz@gmail.com>
References: <1223804330-10881-1-git-send-email-marcin.slusarz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

setup_xstate_init calls __init function (alloc_bootmem) and is called only
from __init function (xsave_cntxt_init), so mark it static __init

WARNING: vmlinux.o(.text+0x8f7b): Section mismatch in reference from the function setup_xstate_init() to the function .init.text:__alloc_bootmem()
The function setup_xstate_init() references
the function __init __alloc_bootmem().
This is often because setup_xstate_init lacks a __init
annotation or the annotation of __alloc_bootmem is wrong.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/xsave.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 07713d6..ed5274a 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -272,7 +272,7 @@ void __cpuinit xsave_init(void)
 /*
  * setup the xstate image representing the init state
  */
-void setup_xstate_init(void)
+static void __init setup_xstate_init(void)
 {
 	init_xstate_buf = alloc_bootmem(xstate_size);
 	init_xstate_buf->i387.mxcsr = MXCSR_DEFAULT;
-- 
1.5.6.4

