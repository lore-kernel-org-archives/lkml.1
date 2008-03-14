Return-Path: <linux-kernel-owner+w=401wt.eu-S1758689AbYCNS0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689AbYCNS0p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 14:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755103AbYCNS0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 14:26:37 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:38274 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597AbYCNS0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 14:26:36 -0400
Date: Fri, 14 Mar 2008 11:24:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Cc: kvm-devel@lists.sourceforge.net, avi@qumranet.com,
       tglx <tglx@linutronix.de>, mingo <mingo@redhat.com>,
       hpa <hpa@zytor.com>
Subject: [PATCH] x86: kvmclock needs to include apic.h
Message-Id: <20080314112457.a7bc2358.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

kvmclock needs to #include apic.h to prevent a build error:

next-20080314/arch/x86/kernel/kvmclock.c:142: error: implicit declaration of function 'setup_secondary_APIC_clock'
elan1.out:make[2]: *** [arch/x86/kernel/kvmclock.o] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/kernel/kvmclock.c |    1 +
 1 file changed, 1 insertion(+)

--- next-20080314.orig/arch/x86/kernel/kvmclock.c
+++ next-20080314/arch/x86/kernel/kvmclock.c
@@ -20,6 +20,7 @@
 #include <linux/kvm_para.h>
 #include <asm/arch_hooks.h>
 #include <asm/msr.h>
+#include <asm/apic.h>
 #include <linux/percpu.h>
 
 #define KVM_SCALE 22
