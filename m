Return-Path: <linux-kernel-owner+w=401wt.eu-S1757659AbYDPBjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659AbYDPBjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 21:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbYDPBj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 21:39:28 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:59318 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbYDPBj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 21:39:27 -0400
Message-ID: <480558CA.7090800@tiscali.nl>
Date: Wed, 16 Apr 2008 03:39:22 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: ralf@linux-mips.org
CC: linux-mips@linux-mips.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/6] MIPS: irixelf: fix test unsigned var < 0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v is unsigned, cast to signed to evaluate the do_brk() return value,
    
Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/arch/mips/kernel/irixelf.c b/arch/mips/kernel/irixelf.c
index 290d8e3..fad2a2a 100644
--- a/arch/mips/kernel/irixelf.c
+++ b/arch/mips/kernel/irixelf.c
@@ -583,15 +583,15 @@ static void irix_map_prda_page(void)
 	unsigned long v;
 	struct prda *pp;
 
 	down_write(&current->mm->mmap_sem);
 	v =  do_brk(PRDA_ADDRESS, PAGE_SIZE);
 	up_write(&current->mm->mmap_sem);
 
-	if (v < 0)
+	if ((long) v < 0)
 		return;
 
 	pp = (struct prda *) v;
 	pp->prda_sys.t_pid  = task_pid_vnr(current);
 	pp->prda_sys.t_prid = read_c0_prid();
 	pp->prda_sys.t_rpid = task_pid_vnr(current);
 

