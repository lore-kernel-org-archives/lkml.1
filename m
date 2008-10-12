Return-Path: <linux-kernel-owner+w=401wt.eu-S1756209AbYJLIvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbYJLIvS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 04:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbYJLIvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 04:51:07 -0400
Received: from vana.vc.cvut.cz ([147.32.240.58]:51669 "EHLO vana.vc.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbYJLIvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 04:51:06 -0400
Date: Sun, 12 Oct 2008 10:51:03 +0200
From: Petr Vandrovec <petr@vandrovec.name>
To: linux-kernel@vger.kernel.org
Cc: thomas.petazzoni@free-electrons.com
Subject: [PATCH] Fix early panic on amd64 due to typo in supported CPU section
Message-ID: <20081012085103.GA30082@vana.vc.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that I forgot to CC LKML on that one...
						Petr

----- Forwarded message from Petr Vandrovec <petr@vandrovec.name> -----

Date: Sun, 12 Oct 2008 10:01:26 +0200
From: Petr Vandrovec <petr@vandrovec.name>
To: thomas.petazzoni@free-electrons.com
Cc: mingo@elte.hu, tglx@linutronix.de, torvalds@linux-foundation.org
Subject: [PATCH] Fix early panic on amd64 due to typo in supported CPU section

Do not crash when enumerating supported CPU architectures

SECURITY_INIT somehow ended up in x86_cpu_dev.init section.  That caused printk
in code which prints supported architectures to hit #GP due to non-canonical
address being used.

Signed-off-by: Petr Vandrovec <petr@vandrovec.name>

diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index 201e81a..46e0544 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -172,8 +172,8 @@ SECTIONS
   .x86_cpu_dev.init : AT(ADDR(.x86_cpu_dev.init) - LOAD_OFFSET) {
 	*(.x86_cpu_dev.init)
   }
-  SECURITY_INIT
   __x86_cpu_dev_end = .;
+  SECURITY_INIT
 
   . = ALIGN(8);
   .parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {

----- End forwarded message -----
