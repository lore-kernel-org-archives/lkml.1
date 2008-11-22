Return-Path: <linux-kernel-owner+w=401wt.eu-S1760485AbYKVRmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760485AbYKVRmx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 12:42:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759520AbYKVRiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 12:38:07 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58501 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759384AbYKVRiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 12:38:05 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH 29/32] xen_play_dead() is __cpuinit
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1L3wQm-0006eU-Ml@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 22 Nov 2008 17:38:04 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/x86/xen/smp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -362,7 +362,7 @@ static void xen_cpu_die(unsigned int cpu)
 		alternatives_smp_switch(0);
 }
 
-static void xen_play_dead(void)
+static void __cpuinit xen_play_dead(void) /* used only with CPU_HOTPLUG */
 {
 	play_dead_common();
 	HYPERVISOR_vcpu_op(VCPUOP_down, smp_processor_id(), NULL);
