Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943AbYHNGiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbYHNGiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 02:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbYHNGh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 02:37:56 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:38114 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbYHNGhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 02:37:54 -0400
Date: Thu, 14 Aug 2008 00:14:36 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808140614.m7E6EaiX006225@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc3 1/29] mdb: add machine restart/genapic export
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add machine restart and genapic exports for the module based 
build of the debugger.  genapic is exported here rather than 
arch/x86/mach-generic/probes.c because EXPORT_SYMBOL does not
work correctly when used inside of files in this directory in
the 2.6.27 tree.


Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/arch/x86/kernel/reboot.c	2008-08-13 14:22:14.000000000 -0600
+++ b/arch/x86/kernel/reboot.c	2008-08-13 11:56:03.000000000 -0600
@@ -502,6 +502,13 @@
 {
 	machine_ops.restart(cmd);
 }
+#if defined(CONFIG_MDB_MODULE)
+EXPORT_SYMBOL_GPL(machine_restart);
+#endif
+/* export the genapic pointer */
+#if defined(CONFIG_SMP) && defined(CONFIG_MDB_MODULE)
+EXPORT_SYMBOL(genapic);
+#endif
 
 void machine_halt(void)
 {
