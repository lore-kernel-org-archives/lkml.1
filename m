Return-Path: <linux-kernel-owner+w=401wt.eu-S1758907AbXJLPlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758907AbXJLPlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 11:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750845AbXJLPk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 11:40:57 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:47211 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbXJLPk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 11:40:56 -0400
Date: Fri, 12 Oct 2007 16:40:43 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] frv: Remove duplicate output of .exit.data
Message-ID: <Pine.LNX.4.64N.0710121633480.21684@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 When CONFIG_DEBUG_INFO is unset the input .exit.data sections are copied 
twice to vmlinux.  Remove the copy made to .init.text and keep one in 
.data only.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 It looks like an accidental mistake to me.  It applies to current Linus's 
2.6.23.

 Please consider,

  Maciej

patch-mips-2.6.23-rc5-20070904-frv-exit-data-0
diff -up --recursive --new-file linux-mips-2.6.23-rc5-20070904.macro/arch/frv/kernel/vmlinux.lds.S linux-mips-2.6.23-rc5-20070904/arch/frv/kernel/vmlinux.lds.S
--- linux-mips-2.6.23-rc5-20070904.macro/arch/frv/kernel/vmlinux.lds.S	2007-09-04 04:55:18.000000000 +0000
+++ linux-mips-2.6.23-rc5-20070904/arch/frv/kernel/vmlinux.lds.S	2007-10-11 22:53:09.000000000 +0000
@@ -30,7 +30,6 @@ SECTIONS
 #ifndef CONFIG_DEBUG_INFO
 	*(.init.text)
 	*(.exit.text)
-	*(.exit.data)
 	*(.exitcall.exit)
 #endif
   }
