Return-Path: <linux-kernel-owner+w=401wt.eu-S1754313AbZAIFcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbZAIFcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 00:32:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbZAIFci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 00:32:38 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57159 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751670AbZAIFci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 00:32:38 -0500
Message-ID: <4966E13D.70204@cn.fujitsu.com>
Date: Fri, 09 Jan 2009 13:31:41 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] idr: fix wrong kernel-doc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idr_get_new_above() and ida_get_new_above() return an id in the range of
@staring_id ... 0x7fffffff, not 0 ... 0x7fffffff.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 lib/idr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index 1c4f928..6b7cfa6 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -292,7 +292,7 @@ static int idr_get_new_above_int(struct idr *idp, void *ptr, int starting_id)
  * and go back to the idr_pre_get() call.  If the idr is full, it will
  * return -ENOSPC.
  *
- * @id returns a value in the range 0 ... 0x7fffffff
+ * @id returns a value in the range @starting_id ... 0x7fffffff
  */
 int idr_get_new_above(struct idr *idp, void *ptr, int starting_id, int *id)
 {
@@ -723,7 +723,7 @@ EXPORT_SYMBOL(ida_pre_get);
  * and go back to the ida_pre_get() call.  If the ida is full, it will
  * return -ENOSPC.
  *
- * @p_id returns a value in the range 0 ... 0x7fffffff.
+ * @p_id returns a value in the range @starting_id ... 0x7fffffff.
  */
 int ida_get_new_above(struct ida *ida, int starting_id, int *p_id)
 {
-- 
1.5.4.rc3

