Return-Path: <linux-kernel-owner+w=401wt.eu-S1761526AbYENOMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761526AbYENOMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 10:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbYENOMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 10:12:13 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:52762 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079AbYENOMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 10:12:12 -0400
Date: Wed, 14 May 2008 18:11:58 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [1/1] Export __lock_page_killable()
Message-ID: <20080514141157.GA27047@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

There are users, who would like to use lock_page_killable() in modules,
so far there are no users in kernel, but for consistency it can be
exported without them.

Not that it is particulary needed, but copying page_waitqueue() in
modules is frowned upon and unlikely to be exported either.

As a side note, do we want interruptible and time limited locking for
those who knows what is being done?

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

diff --git a/mm/filemap.c b/mm/filemap.c
index 07e9d92..0a4fea5 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -610,6 +610,7 @@ int __lock_page_killable(struct page *page)
 	return __wait_on_bit_lock(page_waitqueue(page), &wait,
 					sync_page_killable, TASK_KILLABLE);
 }
+EXPORT_SYMBOL(__lock_page_killable);
 
 /**
  * __lock_page_nosync - get a lock on the page, without calling sync_page()


-- 
	Evgeniy Polyakov
