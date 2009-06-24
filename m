Return-Path: <linux-kernel-owner+w=401wt.eu-S1762026AbZFXUJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762026AbZFXUJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 16:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbZFXUJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 16:09:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56086 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbZFXUJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 16:09:16 -0400
Subject: [PATCH] audit: inode watches depend on CONFIG_AUDIT not
 CONFIG_AUDIT_SYSCALL
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org, linux-audit@redhat.com
Cc: viro@ZenIV.linux.org.uk
Content-Type: text/plain
Date: Wed, 24 Jun 2009 16:09:01 -0400
Message-Id: <1245874141.11046.11.camel@dhcp235-23.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even though one cannot make use of the audit watch code without
CONFIG_AUDIT_SYSCALL the spaghetti nature of the audit code means that
the audit rule filtering requires that it at least be compiled.

Thus build the audit_watch code when we build auditfilter like it was
before cfcad62c74abfef83762dc05a556d21bdf3980a2

Clearly this is a point of potential future cleanup..

Reported-by: Frans Pop <elendil@planet.nl>
Signed-off-by: Eric Paris <eparis@redhat.com>
---
 kernel/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index da75001..780c8dc 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -69,8 +69,8 @@ obj-$(CONFIG_IKCONFIG) += configs.o
 obj-$(CONFIG_RESOURCE_COUNTERS) += res_counter.o
 obj-$(CONFIG_STOP_MACHINE) += stop_machine.o
 obj-$(CONFIG_KPROBES_SANITY_TEST) += test_kprobes.o
-obj-$(CONFIG_AUDIT) += audit.o auditfilter.o
-obj-$(CONFIG_AUDITSYSCALL) += auditsc.o audit_watch.o
+obj-$(CONFIG_AUDIT) += audit.o auditfilter.o audit_watch.o
+obj-$(CONFIG_AUDITSYSCALL) += auditsc.o
 obj-$(CONFIG_GCOV_KERNEL) += gcov/
 obj-$(CONFIG_AUDIT_TREE) += audit_tree.o
 obj-$(CONFIG_KPROBES) += kprobes.o

