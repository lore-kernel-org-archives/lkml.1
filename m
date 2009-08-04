Return-Path: <linux-kernel-owner+w=401wt.eu-S1755577AbZHDORO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbZHDORO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:17:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755571AbZHDORL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:17:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:55148 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755527AbZHDORJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:17:09 -0400
Date: Tue, 4 Aug 2009 14:16:29 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090801075435.769301745@openvz.org>
References: <20090801075435.769301745@openvz.org>
Subject: [tip:x86/apic] x86, ioapic: Throw BUG instead of NULL dereference
Message-ID: <tip-460ba8dfa8decb3885256fc4cbb3d2ee46a6466f@git.kernel.org>
Git-Commit-ID: 460ba8dfa8decb3885256fc4cbb3d2ee46a6466f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 04 Aug 2009 14:16:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  460ba8dfa8decb3885256fc4cbb3d2ee46a6466f
Gitweb:     http://git.kernel.org/tip/460ba8dfa8decb3885256fc4cbb3d2ee46a6466f
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Sat, 1 Aug 2009 11:48:00 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 4 Aug 2009 16:11:54 +0200

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
 
