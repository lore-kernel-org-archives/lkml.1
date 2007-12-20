Return-Path: <linux-kernel-owner+w=401wt.eu-S1759259AbXLTIrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259AbXLTIrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 03:47:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbXLTIq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 03:46:57 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:36682 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbXLTIq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 03:46:57 -0500
Date: Thu, 20 Dec 2007 11:47:07 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mm: fix exit_mmap BUG() on a.out binary exit
Message-ID: <20071220084707.GB28578@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem was introduced by commit "mm: variable length argument
support" (b6a2fea39318e43fee84fa7b0b90d68bed92d2ba)
as it didn't update fs/binfmt_aout.c like other binfmt's.

I noticed that on alpha when accidentally launched old OSF/1
Acrobat Reader binary. Obviously, other architectures are affected
as well.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
---
 fs/binfmt_aout.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
index e176d19..7596e1e 100644
--- a/fs/binfmt_aout.c
+++ b/fs/binfmt_aout.c
@@ -319,7 +319,6 @@ static int load_aout_binary(struct linux_binprm * bprm, struct pt_regs * regs)
 	current->mm->free_area_cache = current->mm->mmap_base;
 	current->mm->cached_hole_size = 0;
 
-	current->mm->mmap = NULL;
 	compute_creds(bprm);
  	current->flags &= ~PF_FORKNOEXEC;
 #ifdef __sparc__
