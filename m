Return-Path: <linux-kernel-owner+w=401wt.eu-S1030888AbXAZQxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030888AbXAZQxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:53:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030879AbXAZQxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:53:34 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:35589 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030885AbXAZQxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:53:21 -0500
Date: Fri, 26 Jan 2007 17:53:16 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: heiko.carstens@de.ibm.com
Subject: [S390] kretprobe_trampoline_holder() in wrong section.
Message-ID: <20070126165316.GT11609@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

[S390] kretprobe_trampoline_holder() in wrong section.

kretprobe_trampoline_holder() is in kprobes section but used to
register a kprobe in arch_init_kprobes(). Hence register_kprobe()
and therefore arch_init_kprobes() will fail.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/kprobes.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -urpN linux-2.6/arch/s390/kernel/kprobes.c linux-2.6-patched/arch/s390/kernel/kprobes.c
--- linux-2.6/arch/s390/kernel/kprobes.c	2007-01-26 17:27:47.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/kprobes.c	2007-01-26 17:28:06.000000000 +0100
@@ -356,7 +356,7 @@ no_kprobe:
  *	- When the probed function returns, this probe
  *		causes the handlers to fire
  */
-void __kprobes kretprobe_trampoline_holder(void)
+void kretprobe_trampoline_holder(void)
 {
 	asm volatile(".global kretprobe_trampoline\n"
 		     "kretprobe_trampoline: bcr 0,0\n");
