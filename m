Return-Path: <linux-kernel-owner+w=401wt.eu-S1760651AbYDUMgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760651AbYDUMgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 08:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757182AbYDUMew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 08:34:52 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:62076 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759640AbYDUMev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 08:34:51 -0400
Message-ID: <480C89E7.8000606@de.ibm.com>
Date: Mon, 21 Apr 2008 14:34:47 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, ltp-list@lists.sourceforge.net,
       ltp-coverage@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [RFC PATCH 6/8] seq_file: add function to write binary data
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

seq_write() can be used to construct seq_files containing arbitrary
data. Required by the gcov-profiling interface to synthesize binary
profiling data files.

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
---
 fs/seq_file.c            |   12 ++++++++++++
 include/linux/seq_file.h |    1 +
 2 files changed, 13 insertions(+)

Index: linux-2.6.25/fs/seq_file.c
===================================================================
--- linux-2.6.25.orig/fs/seq_file.c
+++ linux-2.6.25/fs/seq_file.c
@@ -483,6 +483,18 @@ int seq_puts(struct seq_file *m, const c
 }
 EXPORT_SYMBOL(seq_puts);
 
+int seq_write(struct seq_file *m, const void *s, size_t len)
+{
+	if (m->count + len < m->size) {
+		memcpy(m->buf + m->count, s, len);
+		m->count += len;
+		return 0;
+	}
+	m->count = m->size;
+	return -1;
+}
+EXPORT_SYMBOL(seq_write);
+
 struct list_head *seq_list_start(struct list_head *head, loff_t pos)
 {
 	struct list_head *lh;
Index: linux-2.6.25/include/linux/seq_file.h
===================================================================
--- linux-2.6.25.orig/include/linux/seq_file.h
+++ linux-2.6.25/include/linux/seq_file.h
@@ -37,6 +37,7 @@ int seq_release(struct inode *, struct f
 int seq_escape(struct seq_file *, const char *, const char *);
 int seq_putc(struct seq_file *m, char c);
 int seq_puts(struct seq_file *m, const char *s);
+int seq_write(struct seq_file *m, const void *s, size_t len);
 
 int seq_printf(struct seq_file *, const char *, ...)
 	__attribute__ ((format (printf,2,3)));





