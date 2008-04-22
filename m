Return-Path: <linux-kernel-owner+w=401wt.eu-S1763168AbYDVNJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763168AbYDVNJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 09:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761589AbYDVNJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 09:09:24 -0400
Received: from styx.suse.cz ([82.119.242.94]:48338 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754345AbYDVNJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 09:09:23 -0400
From: David Sterba <dsterba@suse.cz>
Subject: [PATCH] fs: use loff_t type instead of long long
To: torvalds@linux-foundation.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
       David Sterba <dsterba@suse.cz>
Date: Tue, 22 Apr 2008 15:09:22 +0200
Message-ID: <20080422130922.11665.24128.stgit@ds.suse.cz>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use offset type consistently.

Signed-off-by: David Sterba <dsterba@suse.cz>
---

 fs/read_write.c |    6 +++---
 fs/seq_file.c   |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 49a9871..f0d1240 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -33,7 +33,7 @@ EXPORT_SYMBOL(generic_ro_fops);
 
 loff_t generic_file_llseek(struct file *file, loff_t offset, int origin)
 {
-	long long retval;
+	loff_t retval;
 	struct inode *inode = file->f_mapping->host;
 
 	mutex_lock(&inode->i_mutex);
@@ -60,7 +60,7 @@ EXPORT_SYMBOL(generic_file_llseek);
 
 loff_t remote_llseek(struct file *file, loff_t offset, int origin)
 {
-	long long retval;
+	loff_t retval;
 
 	lock_kernel();
 	switch (origin) {
@@ -91,7 +91,7 @@ EXPORT_SYMBOL(no_llseek);
 
 loff_t default_llseek(struct file *file, loff_t offset, int origin)
 {
-	long long retval;
+	loff_t retval;
 
 	lock_kernel();
 	switch (origin) {
diff --git a/fs/seq_file.c b/fs/seq_file.c
index 8537702..9943408 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -239,7 +239,7 @@ Eoverflow:
 loff_t seq_lseek(struct file *file, loff_t offset, int origin)
 {
 	struct seq_file *m = (struct seq_file *)file->private_data;
-	long long retval = -EINVAL;
+	loff_t retval = -EINVAL;
 
 	mutex_lock(&m->lock);
 	m->version = file->f_version;

