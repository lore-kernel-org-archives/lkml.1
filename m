Return-Path: <linux-kernel-owner+w=401wt.eu-S1756983AbZCRLjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983AbZCRLjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 07:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755356AbZCRLjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 07:39:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:55736 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975AbZCRLjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 07:39:10 -0400
Subject: Re: [PATCH 0/3] dma-debug: add additional checks
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Ingo Molnar <mingo@redhat.com>,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090318112324.GB32233@elte.hu>
References: <1237223130-26519-1-git-send-email-joerg.roedel@amd.com>
	 <20090317120112.GP6159@amd.com> <20090318093847.GC5879@elte.hu>
	 <20090318112324.GB32233@elte.hu>
Content-Type: text/plain
Date: Wed, 18 Mar 2009 12:38:47 +0100
Message-Id: <1237376327.5069.253.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-18 at 12:23 +0100, Ingo Molnar wrote:
> another -tip testbox started triggering:
> 
>   BUG: MAX_LOCKDEP_ENTRIES too low!
> 
> it triggers due to CONFIG_DMA_API_DEBUG=y. Config attached.


I still have this laying about.. could be we're just at the limit due to
lock bloat in the kernel, could be dma_api_debug is doing something
all-together iffy

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 71b567f..3e1cc47 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -793,6 +793,7 @@ register_lock_class(struct lockdep_map *lock, unsigned int subclass, int force)
 
 		printk("BUG: MAX_LOCKDEP_KEYS too low!\n");
 		printk("turning off the locking correctness validator.\n");
+		dump_stack();
 		return NULL;
 	}
 	class = lock_classes + nr_lock_classes++;
@@ -856,6 +857,7 @@ static struct lock_list *alloc_list_entry(void)
 
 		printk("BUG: MAX_LOCKDEP_ENTRIES too low!\n");
 		printk("turning off the locking correctness validator.\n");
+		dump_stack();
 		return NULL;
 	}
 	return list_entries + nr_list_entries++;
@@ -1682,6 +1684,7 @@ cache_hit:
 
 		printk("BUG: MAX_LOCKDEP_CHAINS too low!\n");
 		printk("turning off the locking correctness validator.\n");
+		dump_stack();
 		return 0;
 	}
 	chain = lock_chains + nr_lock_chains++;
@@ -2524,6 +2527,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 		debug_locks_off();
 		printk("BUG: MAX_LOCKDEP_SUBCLASSES too low!\n");
 		printk("turning off the locking correctness validator.\n");
+		dump_stack();
 		return 0;
 	}
 
@@ -2620,6 +2624,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 		debug_locks_off();
 		printk("BUG: MAX_LOCK_DEPTH too low!\n");
 		printk("turning off the locking correctness validator.\n");
+		dump_stack();
 		return 0;
 	}
 


