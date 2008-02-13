Return-Path: <linux-kernel-owner+w=401wt.eu-S1765867AbYBMQKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765867AbYBMQKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 11:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755557AbYBMQKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 11:10:19 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755060AbYBMQKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 11:10:17 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Fix up parse error in linker script
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Wed, 13 Feb 2008 16:10:08 +0000
Message-ID: <20080213161008.8791.57543.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up parse error in FRV linker script, presumably introduced through changes
to the INIT_TEXT and EXIT_TEXT macros.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/kernel/vmlinux.lds.S |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)


diff --git a/arch/frv/kernel/vmlinux.lds.S b/arch/frv/kernel/vmlinux.lds.S
index ef7527b..17725a5 100644
--- a/arch/frv/kernel/vmlinux.lds.S
+++ b/arch/frv/kernel/vmlinux.lds.S
@@ -105,11 +105,9 @@ SECTIONS
 	SCHED_TEXT
 	LOCK_TEXT
 #ifdef CONFIG_DEBUG_INFO
-	*(
 	INIT_TEXT
 	EXIT_TEXT
-	.exitcall.exit
-	)
+	*(.exitcall.exit)
 #endif
 	*(.fixup)
 	*(.gnu.warning)

