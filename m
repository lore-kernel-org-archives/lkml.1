Return-Path: <linux-kernel-owner+w=401wt.eu-S1760151AbYGKUex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760151AbYGKUex (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 16:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755336AbYGKUep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 16:34:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57548 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755892AbYGKUep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 16:34:45 -0400
Date: Fri, 11 Jul 2008 22:34:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [patch] x86, xen, vdso: fix build error, add sysctl_vsyscall32
Message-ID: <20080711203435.GA29286@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit c187263834465c2beededb4d19e7f6bab18cc757
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Jul 11 22:34:26 2008 +0200

    x86, xen, vdso: fix build error, add sysctl_vsyscall32
    
    Xen recently tried to make use of sysctl_vsyscall32, with this result:
    
     arch/x86/xen/built-in.o: In function `xen_enable_syscall':
     (.cpuinit.text+0xdb): undefined reference to `sysctl_vsyscall32'
    
    turns out when sysctl_vsyscall32 use was introduced, the variable
    was not defined anywhere.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/vdso/vdso32-setup.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index 0bce542..0645fe9 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -377,6 +377,8 @@ __initcall(sysenter_setup);
 /* Register vsyscall32 into the ABI table */
 #include <linux/sysctl.h>
 
+int sysctl_vsyscall32;
+
 static ctl_table abi_table2[] = {
 	{
 		.procname	= "vsyscall32",
