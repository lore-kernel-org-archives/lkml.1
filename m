Return-Path: <linux-kernel-owner+w=401wt.eu-S1757841AbYJPWGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841AbYJPWGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 18:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbYJPWGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 18:06:04 -0400
Received: from vms042pub.verizon.net ([206.46.252.42]:51988 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856AbYJPWGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 18:06:03 -0400
Date: Thu, 16 Oct 2008 18:05:30 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 1/2] x86: allow module driver to register idle notifier
In-reply-to: <20081011083347.GA31918@elte.hu>
X-X-Sender: lenb@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Andy Henroid <andrew.d.henroid@intel.com>,
       Len Brown <len.brown@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>
Message-id: <alpine.LFD.1.10.0810161803230.3026@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
 <e8b529091b2ab65f5a4783e292c2b472e309116e.1223706853.git.len.brown@intel.com>
 <20081011083347.GA31918@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

needed if the i7300_idle driver is to be a module.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/kernel/process_64.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index e12e0e4..3e3d503 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -62,6 +62,13 @@ void idle_notifier_register(struct notifier_block *n)
 {
 	atomic_notifier_chain_register(&idle_notifier, n);
 }
+EXPORT_SYMBOL_GPL(idle_notifier_register);
+
+void idle_notifier_unregister(struct notifier_block *n)
+{
+	atomic_notifier_chain_unregister(&idle_notifier, n);
+}
+EXPORT_SYMBOL_GPL(idle_notifier_unregister);
 
 void enter_idle(void)
 {
-- 
1.6.0.2.532.g84ed4c

