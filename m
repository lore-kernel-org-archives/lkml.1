Return-Path: <linux-kernel-owner+w=401wt.eu-S1765714AbYARUHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765714AbYARUHw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 15:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763370AbYARUFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 15:05:11 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932196AbYARUFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 15:05:08 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       mtosatti@redhat.com, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 9/10] provide __parainstructions section
Date: Fri, 18 Jan 2008 15:20:24 -0200
Message-Id: <12006768793416-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <12006768732175-git-send-email-gcosta@redhat.com>
References: <12006768251548-git-send-email-gcosta@redhat.com> <12006768362108-git-send-email-gcosta@redhat.com> <1200676842822-git-send-email-gcosta@redhat.com> <12006768473571-git-send-email-gcosta@redhat.com> <12006768521391-git-send-email-gcosta@redhat.com> <1200676857691-git-send-email-gcosta@redhat.com> <12006768631010-git-send-email-gcosta@redhat.com> <12006768683247-git-send-email-gcosta@redhat.com> <12006768732175-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the __parainstructions section to vmlinux.lds.S.
It's needed for the patching system.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86/kernel/vmlinux_64.lds.S |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index 5ae8aa8..5e0300f 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -175,6 +175,14 @@ SECTIONS
   }
   __con_initcall_end = .;
   SECURITY_INIT
+
+  . = ALIGN(8);
+  .parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {
+  __parainstructions = .;
+       *(.parainstructions)
+  __parainstructions_end = .;
+  }
+
   . = ALIGN(8);
   __alt_instructions = .;
   .altinstructions : AT(ADDR(.altinstructions) - LOAD_OFFSET) {
-- 
1.4.4.2

