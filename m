Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbYAXJUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbYAXJUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 04:20:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbYAXJTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 04:19:47 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:59885 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbYAXJTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 04:19:46 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Josh Boyer <jwboyer@gmail.com>, Wolfgang Denk <wd@denx.de>
Subject: [PATCH] sysctl:  Kill binary sysctl KERN_PPC_L2CR
References: <20080123140352.e19900d7.akpm@linux-foundation.org>
Date: Thu, 24 Jan 2008 02:18:34 -0700
In-Reply-To: <20080123140352.e19900d7.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 23 Jan 2008 14:03:52 -0800")
Message-ID: <m1sl0ninth.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> From: Stefan Roese <sr@denx.de>
> Subject: ppc: 4xx: sysctl table check failed: /kernel/l2cr .1.31 Missing strategy
>
> I'm seeing this error message when booting an recent arch/ppc kernel on
> 4xx platforms (tested on Ocotea and other 4xx platforms). Booting NFS
> rootfs still works fine, but this message kind of makes me "nervous".
> This is not seen on 4xx arch/powerpc platforms. Here the bootlog:

Because the data field was never filled and a binary sysctl handler
was never written this sysctl has never been usable through the
sys_sysctl interface.  So just remove the binary sysctl number.
Making the kernel sanity checks happy.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/ppc/kernel/ppc_htab.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/ppc/kernel/ppc_htab.c b/arch/ppc/kernel/ppc_htab.c
index aa07b63..9ed36dd 100644
--- a/arch/ppc/kernel/ppc_htab.c
+++ b/arch/ppc/kernel/ppc_htab.c
@@ -436,7 +436,6 @@ int proc_dol2crvec(ctl_table *table, int write, struct file *filp,
  */
 static ctl_table htab_ctl_table[]={
 	{
-		.ctl_name	= KERN_PPC_L2CR,
 		.procname	= "l2cr",
 		.mode		= 0644,
 		.proc_handler	= &proc_dol2crvec,
-- 
1.5.3.rc6.17.g1911

