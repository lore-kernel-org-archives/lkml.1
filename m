Return-Path: <linux-kernel-owner+w=401wt.eu-S1753871AbYFRPFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbYFRPFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 11:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbYFRPFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 11:05:37 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:24404 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbYFRPFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 11:05:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=EjL+cHudiwiaBjkRKM9cSN3PW4S3zj7qTu0ruTOXqQZFPbvYaMb7qIg1TW6ScLLeSG
         mZKm94r8BmrZ+jPi08rcQKV3Nl/gQGXn+Zm/ImpNR4L1EYh1qQVIILRyVl2zbdi2sqSi
         WOyKQ5M6lslqKiO/qlVaiwU1MyArkC3WoVzk0=
Date: Thu, 19 Jun 2008 00:04:14 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] add kernel-doc for simple_read_from_buffer and
	memory_read_from_buffer
Message-ID: <20080618150412.GA9533@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add kernel-doc comments describing simple_read_from_buffer and
memory_read_from_buffer.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/libfs.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

Index: 2.6-git/fs/libfs.c
===================================================================
--- 2.6-git.orig/fs/libfs.c
+++ 2.6-git/fs/libfs.c
@@ -512,6 +512,20 @@ void simple_release_fs(struct vfsmount *
 	mntput(mnt);
 }
 
+/**
+ * simple_read_from_buffer - copy data from the buffer to user space
+ * @to: the user space buffer to read to
+ * @count: the maximum number of bytes to read
+ * @ppos: the current position in the buffer
+ * @from: the buffer to read from
+ * @available: the size of the buffer
+ *
+ * The simple_read_from_buffer() function reads up to @count bytes from the
+ * buffer @from at offset @ppos into the user space address starting at @to.
+ *
+ * On success, the number of bytes read is returned and the offset @ppos is
+ * advanced by this number, or negative value is returned on error.
+ **/
 ssize_t simple_read_from_buffer(void __user *to, size_t count, loff_t *ppos,
 				const void *from, size_t available)
 {
@@ -528,6 +542,20 @@ ssize_t simple_read_from_buffer(void __u
 	return count;
 }
 
+/**
+ * memory_read_from_buffer - copy data from the buffer
+ * @to: the kernel space buffer to read to
+ * @count: the maximum number of bytes to read
+ * @ppos: the current position in the buffer
+ * @from: the buffer to read from
+ * @available: the size of the buffer
+ *
+ * The memory_read_from_buffer() function reads up to @count bytes from the
+ * buffer @from at offset @ppos into the kernel space address starting at @to.
+ *
+ * On success, the number of bytes read is returned and the offset @ppos is
+ * advanced by this number, or negative value is returned on error.
+ **/
 ssize_t memory_read_from_buffer(void *to, size_t count, loff_t *ppos,
 				const void *from, size_t available)
 {
