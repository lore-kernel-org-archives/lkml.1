Return-Path: <linux-kernel-owner+w=401wt.eu-S1756914AbXKGEpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914AbXKGEpZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 23:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755136AbXKGEpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 23:45:13 -0500
Received: from lixom.net ([66.141.50.11]:52338 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754510AbXKGEpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 23:45:12 -0500
Date: Tue, 6 Nov 2007 22:54:31 -0600
From: Olof Johansson <olof@lixom.net>
To: paulus@samba.org
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [POWERPC] Remove sysctl warning about writable directory
Message-ID: <20071107045431.GA24266@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Getting this when booting 2.6.24-rc2:

sysctl table check failed: /kernel .1 Writable sysctl directory
Call Trace:
[c000000002047b60] [c00000000000e204] .show_stack+0x54/0x1f0 (unreliable)
[c000000002047c10] [c00000000006ea50] .set_fail+0x60/0x90
[c000000002047ca0] [c00000000006ef64] .sysctl_check_table+0x4e4/0x730
[c000000002047d80] [c000000000055860] .register_sysctl_table+0x80/0x120
[c000000002047e20] [c0000000005de924] .register_powersave_nap_sysctl+0x14/0x30
[c000000002047e90] [c0000000005d58c8] .kernel_init+0x1f8/0x450
[c000000002047f90] [c000000000023bac] .kernel_thread+0x4c/0x68


Signed-off-by: Olof Johansson <olof@lixom.net>

diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
index abd2957..c3cf0e8 100644
--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -122,7 +122,7 @@ static ctl_table powersave_nap_sysctl_root[] = {
 	{
 		.ctl_name	= CTL_KERN,
 		.procname	= "kernel",
-		.mode		= 0755,
+		.mode		= 0555,
 		.child		= powersave_nap_ctl_table,
 	},
 	{}
