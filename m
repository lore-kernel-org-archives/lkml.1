Return-Path: <linux-kernel-owner+w=401wt.eu-S932350AbZHUOnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350AbZHUOnx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 10:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932340AbZHUOnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 10:43:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:56614 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932339AbZHUOnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 10:43:50 -0400
Date: Fri, 21 Aug 2009 14:43:18 GMT
From: tip-bot for Amerigo Wang <amwang@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu,
       amwang@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, amwang@redhat.com,
       mingo@elte.hu
In-Reply-To: <20090821083709.5098.52505.sendpatchset@localhost.localdomain>
References: <20090821083709.5098.52505.sendpatchset@localhost.localdomain>
Subject: [tip:x86/urgent] x86: Fix an incorrect argument of reserve_bootmem()
Message-ID: <tip-3e0e1e9c5a327d4dba8490d83ef55c0564e6e8a7@git.kernel.org>
Git-Commit-ID: 3e0e1e9c5a327d4dba8490d83ef55c0564e6e8a7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 21 Aug 2009 14:43:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3e0e1e9c5a327d4dba8490d83ef55c0564e6e8a7
Gitweb:     http://git.kernel.org/tip/3e0e1e9c5a327d4dba8490d83ef55c0564e6e8a7
Author:     Amerigo Wang <amwang@redhat.com>
AuthorDate: Fri, 21 Aug 2009 04:34:45 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 21 Aug 2009 16:40:31 +0200

x86: Fix an incorrect argument of reserve_bootmem()

This line looks suspicious, because if this is true, then the
'flags' parameter of function reserve_bootmem_generic() will be
unused when !CONFIG_NUMA. I don't think this is what we want.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: akpm@linux-foundation.org
LKML-Reference: <20090821083709.5098.52505.sendpatchset@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/init_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 6176fe8..ea56b8c 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -796,7 +796,7 @@ int __init reserve_bootmem_generic(unsigned long phys, unsigned long len,
 		return ret;
 
 #else
-	reserve_bootmem(phys, len, BOOTMEM_DEFAULT);
+	reserve_bootmem(phys, len, flags);
 #endif
 
 	if (phys+len <= MAX_DMA_PFN*PAGE_SIZE) {
