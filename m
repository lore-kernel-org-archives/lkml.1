Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab0BHK14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 05:27:56 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48783 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755333Ab0BHK1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 05:27:54 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH] mtrr: kill over the top warn
To: linux-kernel@vger.kernel.org, mingo@elte.hu
Date: Mon, 08 Feb 2010 10:03:17 +0000
Message-ID: <20100208100239.2568.2940.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes bugzilla: http://bugzilla.kernel.org/show_bug.cgi?id=12558
Fixes bugzilla: http://bugzilla.kernel.org/show_bug.cgi?id=12317

(and if this really needed to be a warn you'd be responding to the bugs left
in bugzilla from it...)

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 arch/x86/kernel/cpu/mtrr/generic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 4d75584..163e59e 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -464,7 +464,7 @@ static void generic_get_mtrr(unsigned int reg, unsigned long *base,
 		tmp |= ~((1<<(hi - 1)) - 1);
 
 		if (tmp != mask_lo) {
-			WARN_ONCE(1, KERN_INFO "mtrr: your BIOS has set up an incorrect mask, fixing it up.\n");
+			printk(KERN_WARNING "mtrr: your BIOS has configured an incorrect mask, fixing it.\n");
 			mask_lo = tmp;
 		}
 	}

