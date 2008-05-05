Return-Path: <linux-kernel-owner+w=401wt.eu-S1759870AbYEESYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759870AbYEESYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755565AbYEESXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:23:15 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:54704 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755372AbYEESXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:23:01 -0400
Date: Mon, 5 May 2008 21:21:54 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Paul Menage <menage@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make cgroup_seqfile_release() static
Message-ID: <20080505182154.GF17139@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup_seqfile_release() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
f08ef145219300d3279c37d22f29a22fcbcdd138 diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b9d467d..ea4b8f1 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1560,7 +1560,7 @@ static int cgroup_seqfile_show(struct seq_file *m, void *arg)
 	return cft->read_seq_string(state->cgroup, cft, m);
 }
 
-int cgroup_seqfile_release(struct inode *inode, struct file *file)
+static int cgroup_seqfile_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *seq = file->private_data;
 	kfree(seq->private);

