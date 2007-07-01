Return-Path: <linux-kernel-owner+w=401wt.eu-S1758459AbXGAUUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459AbXGAUUV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 16:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754822AbXGAUUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 16:20:06 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:46802 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754397AbXGAUUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 16:20:04 -0400
Date: Sun, 1 Jul 2007 22:20:31 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] kernel/relay.c: make functions static
Message-ID: <20070701202031.GB10869@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes some needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch has been sent on:
- 4 Apr 2007

 kernel/relay.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- linux-2.6.21-rc5-mm3/kernel/relay.c.old	2007-04-03 01:33:49.000000000 +0200
+++ linux-2.6.21-rc5-mm3/kernel/relay.c	2007-04-03 01:36:07.000000000 +0200
@@ -79,7 +79,7 @@
  *
  *	Caller should already have grabbed mmap_sem.
  */
-int relay_mmap_buf(struct rchan_buf *buf, struct vm_area_struct *vma)
+static int relay_mmap_buf(struct rchan_buf *buf, struct vm_area_struct *vma)
 {
 	unsigned long length = vma->vm_end - vma->vm_start;
 	struct file *filp = vma->vm_file;
@@ -143,7 +143,7 @@
  *
  *	Returns channel buffer if successful, %NULL otherwise.
  */
-struct rchan_buf *relay_create_buf(struct rchan *chan)
+static struct rchan_buf *relay_create_buf(struct rchan *chan)
 {
 	struct rchan_buf *buf = kzalloc(sizeof(struct rchan_buf), GFP_KERNEL);
 	if (!buf)
@@ -173,7 +173,7 @@
  *
  *	Should only be called from kref_put().
  */
-void relay_destroy_channel(struct kref *kref)
+static void relay_destroy_channel(struct kref *kref)
 {
 	struct rchan *chan = container_of(kref, struct rchan, kref);
 	kfree(chan);
@@ -183,7 +183,7 @@
  *	relay_destroy_buf - destroy an rchan_buf struct and associated buffer
  *	@buf: the buffer struct
  */
-void relay_destroy_buf(struct rchan_buf *buf)
+static void relay_destroy_buf(struct rchan_buf *buf)
 {
 	struct rchan *chan = buf->chan;
 	unsigned int i;
@@ -208,7 +208,7 @@
  *	rchan_buf_struct and the channel buffer.  Should only be called from
  *	kref_put().
  */
-void relay_remove_buf(struct kref *kref)
+static void relay_remove_buf(struct kref *kref)
 {
 	struct rchan_buf *buf = container_of(kref, struct rchan_buf, kref);
 	buf->chan->cb->remove_buf_file(buf->dentry);
@@ -221,11 +221,10 @@
  *
  *	Returns 1 if the buffer is empty, 0 otherwise.
  */
-int relay_buf_empty(struct rchan_buf *buf)
+static int relay_buf_empty(struct rchan_buf *buf)
 {
 	return (buf->subbufs_produced - buf->subbufs_consumed) ? 0 : 1;
 }
-EXPORT_SYMBOL_GPL(relay_buf_empty);
 
 /**
  *	relay_buf_full - boolean, is the channel buffer full?

