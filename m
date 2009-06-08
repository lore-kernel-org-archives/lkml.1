Return-Path: <linux-kernel-owner+w=401wt.eu-S1752850AbZFHRzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbZFHRzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 13:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbZFHRzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 13:55:35 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:36662 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750853AbZFHRzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 13:55:35 -0400
X-Trace: 208684911/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.38.33/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.38.33
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq0GAI/tLEpQKSYh/2dsb2JhbACBT4xtAb9vhAoF
X-IronPort-AV: E=Sophos;i="4.41,325,1241391600"; 
   d="scan'208";a="208684911"
Date: Mon, 8 Jun 2009 18:44:48 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Arjan van de Ven <arjan@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH] latencytop: note task_struct bloat
Message-ID: <Pine.LNX.4.64.0906081841580.7100@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add belated comment to LATENCYTOP help text, making clear that this is a
much more expensive option than you might think: along with the options
it selects, it may add more than 4000 bytes to each struct task_struct
(on 64-bit; more than 2000 on 32-bit), effectively quadrupling the size
of an otherwise lean task_struct (in fact, slab on x86_64 fits only 1
in two pages, whereas it fits 5 in two pages without LATENCYTOP=y).

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---

 lib/Kconfig.debug |    4 ++++
 1 file changed, 4 insertions(+)

--- 2.6.30-rc8/lib/Kconfig.debug	2009-05-16 10:26:16.000000000 +0100
+++ linux/lib/Kconfig.debug	2009-06-08 18:30:50.000000000 +0100
@@ -826,6 +826,10 @@ config LATENCYTOP
 	  Enable this option if you want to use the LatencyTOP tool
 	  to find out which userspace is blocking on what kernel operations.
 
+	  Note: enabling this option may add more than 4000 bytes to each
+	  task_struct on a 64-bit kernel (more than 2000 bytes to task_struct
+	  on a 32-bit kernel), multiplying its memory usage by 4 or even 5.
+
 config SYSCTL_SYSCALL_CHECK
 	bool "Sysctl checks"
 	depends on SYSCTL_SYSCALL
