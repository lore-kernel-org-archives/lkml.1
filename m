Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbYHJWIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbYHJWIX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 18:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbYHJWIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 18:08:15 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:39891 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbYHJWIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 18:08:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=V57azaNCm/xJeFlFMCbPQFHtbk+44Qs3CEjC87fu9y+pLWoIL7xRbLgnIVaCLfUgAG
         Hh2SelRgfhT0zElQ32f8xdksg9Zx82iJs0m0xDuCzrtOS5OgM188s87ajbaPbm6QMutr
         hW+1LGF4D2YeEIfKABgZX4pvvNZJKHPUoB9rU=
Date: Mon, 11 Aug 2008 00:07:44 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: [PATCH] x86, tsc: fix section mismatch warning
Message-ID: <20080810220740.GA27349@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: vmlinux.o(.text+0x7950): Section mismatch in reference from the function native_calibrate_tsc() to the function .init.text:tsc_read_refs()
The function native_calibrate_tsc() references
the function __init tsc_read_refs().
This is often because native_calibrate_tsc lacks a __init
annotation or the annotation of tsc_read_refs is wrong.

tsc_read_refs is called from native_calibrate_tsc which is not __init
and native_calibrate_tsc cannot be marked __init

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/tsc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 7603c05..46af716 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -104,7 +104,7 @@ __setup("notsc", notsc_setup);
 /*
  * Read TSC and the reference counters. Take care of SMI disturbance
  */
-static u64 __init tsc_read_refs(u64 *pm, u64 *hpet)
+static u64 tsc_read_refs(u64 *pm, u64 *hpet)
 {
 	u64 t1, t2;
 	int i;
-- 
1.5.4.5

