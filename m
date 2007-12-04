Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbXLDN4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbXLDN4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 08:56:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754467AbXLDNyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 08:54:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754458AbXLDNyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 08:54:36 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 1/10] Wipe out traditional opt from x86_64 Makefile
Date: Tue,  4 Dec 2007 09:09:55 -0200
Message-Id: <11967666111489-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11967666042130-git-send-email-gcosta@redhat.com>
References: <11967666042130-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Among other things, using -traditional as a gcc option stops us from
using macro token pasting, which is a feature we heavily rely on.

There was still a use of -traditional in arch/x86/kernel/Makefile_64,
which this patch removes.

I don't see any problems building kernels in my x86_64 box without
-traditional.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/kernel/Makefile_64 |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/Makefile_64 b/arch/x86/kernel/Makefile_64
index 5a88890..da0b1e5 100644
--- a/arch/x86/kernel/Makefile_64
+++ b/arch/x86/kernel/Makefile_64
@@ -4,7 +4,6 @@
 
 extra-y 	:= head_64.o head64.o init_task.o vmlinux.lds
 CPPFLAGS_vmlinux.lds += -Ux86_64
-EXTRA_AFLAGS	:= -traditional
 
 obj-y	:= process_64.o signal_64.o entry_64.o traps_64.o irq_64.o \
 		ptrace_64.o time_64.o ioport_64.o ldt_64.o setup_64.o i8259_64.o sys_x86_64.o \
-- 
1.4.4.2

