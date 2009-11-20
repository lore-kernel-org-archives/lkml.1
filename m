Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbZKTQoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbZKTQoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 11:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbZKTQoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 11:44:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38957 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169AbZKTQkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 11:40:49 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, jkacur@redhat.com,
       Arnd Bergmann <arnd@arndb.de>,
       =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Jamie Lokier <jamie@shareable.org>, Jan Blunck <jblunck@suse.de>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 01/15] Introduce noop_llseek()
Date: Fri, 20 Nov 2009 17:40:31 +0100
Message-Id: <1258735245-25826-2-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258735245-25826-1-git-send-email-jblunck@suse.de>
References: <1258735245-25826-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The noop_llseek() is a llseek() operation that filesystems can use that
don't want to support seeking (leave the file->f_pos untouched) but still
want to let the syscall itself to succeed.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/read_write.c    |    6 ++++++
 include/linux/fs.h |    1 +
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 3ac2898..7a01d11 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -97,6 +97,12 @@ loff_t generic_file_llseek(struct file *file, loff_t offset, int origin)
 }
 EXPORT_SYMBOL(generic_file_llseek);
 
+loff_t noop_llseek(struct file *file, loff_t offset, int origin)
+{
+	return file->f_pos;
+}
+EXPORT_SYMBOL(noop_llseek);
+
 loff_t no_llseek(struct file *file, loff_t offset, int origin)
 {
 	return -ESPIPE;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2620a8c..0a0c1f4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2237,6 +2237,7 @@ extern long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
 
 extern void
 file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping);
+extern loff_t noop_llseek(struct file *file, loff_t offset, int origin);
 extern loff_t no_llseek(struct file *file, loff_t offset, int origin);
 extern loff_t generic_file_llseek(struct file *file, loff_t offset, int origin);
 extern loff_t generic_file_llseek_unlocked(struct file *file, loff_t offset,
-- 
1.6.4.2

