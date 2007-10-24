Return-Path: <linux-kernel-owner+w=401wt.eu-S1755833AbXJXJFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbXJXJFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 05:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbXJXJE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 05:04:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50697 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbXJXJEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 05:04:54 -0400
Message-Id: <20071024081405.094887000@nick.local0.net>
References: <20071024081305.906617000@nick.local0.net>
User-Agent: quilt/0.46-14
Date: Wed, 24 Oct 2007 18:13:06 +1000
From: npiggin@nick.local0.net
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 1/5] wait: use lock bitops for __wait_on_bit_lock
Content-Disposition: inline; filename=wait_bit-use-lock-bitops.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nick Piggin <npiggin@suse.de>

---
 kernel/wait.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/kernel/wait.c
===================================================================
--- linux-2.6.orig/kernel/wait.c
+++ linux-2.6/kernel/wait.c
@@ -195,7 +195,7 @@ __wait_on_bit_lock(wait_queue_head_t *wq
 			if ((ret = (*action)(q->key.flags)))
 				break;
 		}
-	} while (test_and_set_bit(q->key.bit_nr, q->key.flags));
+	} while (test_and_set_bit_lock(q->key.bit_nr, q->key.flags));
 	finish_wait(wq, &q->wait);
 	return ret;
 }

-- 

