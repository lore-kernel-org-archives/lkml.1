Return-Path: <linux-kernel-owner+w=401wt.eu-S1757391AbYFXBqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391AbYFXBqy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 21:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757299AbYFXBqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 21:46:07 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34082 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920AbYFXBqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 21:46:04 -0400
Message-ID: <486051B3.4070903@np.css.fujitsu.com>
Date: Tue, 24 Jun 2008 10:45:23 +0900
From: Kentaro Makita <k-makita@np.css.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@ZenIV.linux.org.uk, harvey.harrison@gmail.com
Subject: [RESEND][PATCH -mm 2/2] vfs: add cond_resched_lock while scanning
 dentry LRU lists
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o add cond_resched_lock(&dcache_lock) while scanning LRU lists on superblocks
  in __shrink_dcache_sb()

Signed-off-by: Kentaro Makita <k-makita@np.css.fujitsu.com>
---
 fs/dcache.c |    1 +
 1 files changed, 1 insertion(+)

Index: b/fs/dcache.c
===================================================================
--- a/fs/dcache.c	2008-06-05 11:48:57.000000000 +0900
+++ b/fs/dcache.c	2008-06-05 11:49:19.000000000 +0900
@@ -484,6 +484,7 @@ restart:
 				if (--cnt == 0)
 					break;
 			}
+			cond_resched_lock(&dcache_lock);
 		}
 	}
 	while (!list_empty(&tmp)) {









