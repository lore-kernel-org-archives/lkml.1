Return-Path: <linux-kernel-owner+w=401wt.eu-S1753521AbZI3AJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbZI3AJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 20:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbZI3AJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 20:09:40 -0400
Received: from exprod6og102.obsmtp.com ([64.18.1.183]:55339 "HELO
	exprod6og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752047AbZI3AJj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 20:09:39 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] libfs: move EXPORT_SYMBOL for d_alloc_name
Date: Tue, 29 Sep 2009 20:09:42 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901D42AFF@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] libfs: move EXPORT_SYMBOL for d_alloc_name
Thread-Index: AcpBYk9B2ylJ7Oi3Qveknd0LTzLelA==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>
X-OriginalArrivalTime: 30 Sep 2009 00:09:42.0114 (UTC) FILETIME=[4EFACC20:01CA4162]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EXPORT_SYMBOL for d_alloc_name is in fs/libfs.c but the function
is in fs/dcache.c.  Move the EXPORT_SYMBOL to the line immediately
after the closing function brace line in fs/dcache.c as mentioned
in Documentation/CodingStyle.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/fs/dcache.c b/fs/dcache.c
index a100fa3..953173a 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -978,6 +978,7 @@ struct dentry *d_alloc_name(struct dentry *parent, const char *name)
 	q.hash = full_name_hash(q.name, q.len);
 	return d_alloc(parent, &q);
 }
+EXPORT_SYMBOL(d_alloc_name);
 
 /* the caller must hold dcache_lock */
 static void __d_instantiate(struct dentry *dentry, struct inode *inode)
diff --git a/fs/libfs.c b/fs/libfs.c
index 219576c..6e8d17e 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -848,7 +848,6 @@ EXPORT_SYMBOL(simple_write_end);
 EXPORT_SYMBOL(simple_dir_inode_operations);
 EXPORT_SYMBOL(simple_dir_operations);
 EXPORT_SYMBOL(simple_empty);
-EXPORT_SYMBOL(d_alloc_name);
 EXPORT_SYMBOL(simple_fill_super);
 EXPORT_SYMBOL(simple_getattr);
 EXPORT_SYMBOL(simple_link); 
