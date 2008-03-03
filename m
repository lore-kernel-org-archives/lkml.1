Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbYCCOn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbYCCOn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 09:43:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753606AbYCCOnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 09:43:49 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37134 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbYCCOnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 09:43:49 -0500
Date: Mon, 3 Mar 2008 12:49:09 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       jikos@suse.cz, jack@suse.cz
Subject: wmb() confusion in system.h
Message-ID: <20080303114909.GA23816@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Comment says wmb is a nop, but it is implemented as lock addl
below... Should it be compiled to nop if we know we are running on
"good" Intel cpu?

At least remove confusing comment for now.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/include/asm-x86/system.h b/include/asm-x86/system.h
index 9cff02f..428d947 100644
--- a/include/asm-x86/system.h
+++ b/include/asm-x86/system.h
@@ -296,16 +296,7 @@ void default_idle(void);
  */
 #ifdef CONFIG_X86_32
 /*
- * For now, "wmb()" doesn't actually do anything, as all
- * Intel CPU's follow what Intel calls a *Processor Order*,
- * in which all writes are seen in the program order even
- * outside the CPU.
- *
- * I expect future Intel CPU's to have a weaker ordering,
- * but I'd also expect them to finally get their act together
- * and add some real memory barriers if so.
- *
- * Some non intel clones support out of order store. wmb() ceases to be a
+ * Some non-Intel clones support out of order store. wmb() ceases to be a
  * nop for these.
  */
 #define mb() alternative("lock; addl $0,0(%%esp)", "mfence", X86_FEATURE_XMM2)

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
