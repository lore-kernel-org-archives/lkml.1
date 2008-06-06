Return-Path: <linux-kernel-owner+w=401wt.eu-S1764327AbYFFINK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764327AbYFFINK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 04:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbYFFIM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 04:12:56 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55860 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbYFFIMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 04:12:54 -0400
Date: Fri, 6 Jun 2008 09:42:36 +0200
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Daniel.Rahn@novell.com
Subject: [patch] correctly report NR_BANKS in mce_64.c
Message-ID: <20080606074236.GA13151@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Rahn <Daniel.Rahn@novell.com>

attached is a no-brainer that makes kernel correctly report
NR_BANKS for MCE. We are right now limited to NR_BANKS==6, but the
error message will use the available number of banks instead of the
defined maximum.

For a Nehalem based system it will print:

"MCE: warning: using only 9 banks"

while the correct message would be

"MCE: warning: using only 6 banks"

Signed-off-by: Pavel Machek <pavel@suse.cz>


diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
index e07e8c0..2fb868e 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -445,8 +445,8 @@ static void mce_init(void *dummy)
 	rdmsrl(MSR_IA32_MCG_CAP, cap);
 	banks = cap & 0xff;
 	if (banks > NR_BANKS) {
-		printk(KERN_INFO "MCE: warning: using only %d banks\n", banks);
 		banks = NR_BANKS;
+		printk(KERN_INFO "MCE: warning: using only %d banks\n", banks);
 	}
 	/* Use accurate RIP reporting if available. */
 	if ((cap & (1<<9)) && ((cap >> 16) & 0xff) >= 9)

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
