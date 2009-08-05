Return-Path: <linux-kernel-owner+w=401wt.eu-S934203AbZHEKzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934203AbZHEKzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 06:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934059AbZHEKzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 06:55:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:57643 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934196AbZHEKzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 06:55:46 -0400
Date: Wed, 5 Aug 2009 10:55:14 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090801075435.769301745@openvz.org>
References: <20090801075435.769301745@openvz.org>
Subject: [tip:x86/apic] x86, ioapic: Throw BUG instead of NULL dereference
Message-ID: <tip-a7428cd2ef77734465e36bceb43290e37e2a97c6@git.kernel.org>
Git-Commit-ID: a7428cd2ef77734465e36bceb43290e37e2a97c6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 05 Aug 2009 10:55:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a7428cd2ef77734465e36bceb43290e37e2a97c6
Gitweb:     http://git.kernel.org/tip/a7428cd2ef77734465e36bceb43290e37e2a97c6
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Sat, 1 Aug 2009 11:48:00 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 5 Aug 2009 10:30:50 +0200

x86, ioapic: Throw BUG instead of NULL dereference

Instead of plain NULL deref we better throw error
message with a backtrace. Actually we need more
gracious error handling here. Meanwhile leave it
as is.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: yinghai@kernel.org
LKML-Reference: <20090801075435.769301745@openvz.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/io_apic.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index ffd8fdf..2a145d3 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -503,6 +503,10 @@ static void add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pin
 	}
 
 	entry = get_one_free_irq_2_pin(node);
+	if (!entry) {
+		printk(KERN_ERR "can not alloc irq_pin_list\n");
+		BUG_ON(1);
+	}
 	entry->apic = apic;
 	entry->pin = pin;
 
