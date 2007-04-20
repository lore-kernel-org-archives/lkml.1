Return-Path: <linux-kernel-owner+w=401wt.eu-S1754479AbXDTLI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbXDTLI2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 07:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754472AbXDTLI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 07:08:28 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:36378 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474AbXDTLI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 07:08:27 -0400
Date: Fri, 20 Apr 2007 13:08:42 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: akpm@linux-foundation.org, srinivasa@in.ibm.com, ananth@in.ibm.com
Subject: [S390] add arch_trampoline_kprobe.
Message-ID: <20070420110842.GA17147@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Add the missing arch_trampoline_kprobe function for s390 required by
kprobes-the-on-off-knob-thru-debugfs-updated.patch.

Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Srinivasa DS <srinivasa@in.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/kprobes.c |    7 +++++++
 1 files changed, 7 insertions(+)

diff -urpN linux-2.6/arch/s390/kernel/kprobes.c linux-2.6-patched/arch/s390/kernel/kprobes.c
--- linux-2.6/arch/s390/kernel/kprobes.c	2007-04-19 17:12:40.000000000 +0200
+++ linux-2.6-patched/arch/s390/kernel/kprobes.c	2007-04-19 17:12:09.000000000 +0200
@@ -658,6 +658,13 @@ static struct kprobe trampoline_p = {
 	.pre_handler = trampoline_probe_handler
 };
 
+int __kprobes arch_trampoline_kprobe(struct kprobe *p)
+{
+	if (p->addr == (kprobe_opcode_t *)&kretprobe_trampoline)
+		return 1;
+	return 0;
+}
+
 int __init arch_init_kprobes(void)
 {
 	return register_kprobe(&trampoline_p);
