Return-Path: <linux-kernel-owner+w=401wt.eu-S1754318AbZA1HmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318AbZA1HmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 02:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbZA1Hl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 02:41:58 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:61245 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbZA1Hl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 02:41:57 -0500
Date: Wed, 28 Jan 2009 16:26:19 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       nishimura@mxp.nes.nec.co.jp
Subject: [PATCH] migration: migrate_vmas should check "vma"
Message-Id: <20090128162619.2205befd.nishimura@mxp.nes.nec.co.jp>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

migrate_vmas() should check "vma" not "vma->vm_next" for for-loop condition.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
---
 mm/migrate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 2bb4e1d..a9eff3f 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1129,7 +1129,7 @@ int migrate_vmas(struct mm_struct *mm, const nodemask_t *to,
  	struct vm_area_struct *vma;
  	int err = 0;
 
- 	for(vma = mm->mmap; vma->vm_next && !err; vma = vma->vm_next) {
+	for (vma = mm->mmap; vma && !err; vma = vma->vm_next) {
  		if (vma->vm_ops && vma->vm_ops->migrate) {
  			err = vma->vm_ops->migrate(vma, to, from, flags);
  			if (err)
