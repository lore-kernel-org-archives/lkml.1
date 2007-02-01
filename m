Return-Path: <linux-kernel-owner+w=401wt.eu-S1751682AbXBAPfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbXBAPfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 10:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbXBAPfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 10:35:43 -0500
Received: from styx.suse.cz ([82.119.242.94]:34342 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751751AbXBAPfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 10:35:42 -0500
Date: Thu, 1 Feb 2007 16:35:56 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/10] X86_64: local_irq_disable() is redundant after
 local_irq_save()
In-Reply-To: <Pine.LNX.4.64.0702011609090.13648@jikos.suse.cz>
Message-ID: <Pine.LNX.4.64.0702011615300.13648@jikos.suse.cz>
References: <Pine.LNX.4.64.0702011609090.13648@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

X86_64: local_irq_disable() is redundant after local_irq_save()

arch/x86_64/kernel/time.c::hpet_calibrate_tsc() contains
local_irq_disable() call after local_irq_save(). This looks
redundant.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

---

 arch/x86_64/kernel/time.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86_64/kernel/time.c b/arch/x86_64/kernel/time.c
index 5cc76d0..1a8afdc 100644
--- a/arch/x86_64/kernel/time.c
+++ b/arch/x86_64/kernel/time.c
@@ -683,7 +683,6 @@ static unsigned int __init hpet_calibrate_tsc(void)
 	unsigned long flags;
 
 	local_irq_save(flags);
-	local_irq_disable();
 
 	read_hpet_tsc(&hpet_start, &tsc_start);
 
