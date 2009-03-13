Return-Path: <linux-kernel-owner+w=401wt.eu-S1756166AbZCMIOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbZCMIOL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 04:14:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbZCMIMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 04:12:15 -0400
Received: from gw.goop.org ([64.81.55.164]:34786 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752282AbZCMIMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 04:12:12 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 01/24] xen: disable preempt for leave_lazy_mmu
Date: Fri, 13 Mar 2009 01:11:37 -0700
Message-Id: <1236931920-6861-2-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236931920-6861-1-git-send-email-jeremy@goop.org>
References: <1236931920-6861-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

xen_mc_flush() requires preemption to be disabled for its own sanity,
so disable it while we're flushing.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/mmu.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 185b547..eceff87 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1812,8 +1812,10 @@ __init void xen_post_allocator_init(void)
 
 static void xen_leave_lazy_mmu(void)
 {
+	preempt_disable();
 	xen_mc_flush();
 	paravirt_leave_lazy_mmu();
+	preempt_enable();
 }
 
 const struct pv_mmu_ops xen_mmu_ops __initdata = {
-- 
1.6.0.6

