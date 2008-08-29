Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbYH2Tzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbYH2Tzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 15:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbYH2Tz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 15:55:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42261 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751025AbYH2Tz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 15:55:29 -0400
Date: Fri, 29 Aug 2008 12:54:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: aaron@merfinllc.com, mpm@selenic.com, linux-kernel@vger.kernel.org,
       tytso@mit.edu, stable@kernel.org
Subject: Re: drivers/char/random.c line 728 BUG
Message-Id: <20080829125445.9e48b1f1.akpm@linux-foundation.org>
In-Reply-To: <20080829124807.54293904.akpm@linux-foundation.org>
References: <20080826225918.GC5452@merfinllc.com>
	<20080828225924.GD6432@merfinllc.com>
	<20080829124807.54293904.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008 12:48:07 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> We could fix this by moving the assertion inside the lock, but it seems
> safer and saner to revert to the old behaviour wherein
> entropy_store.entropy_count at no time exceeds
> entropy_store.poolinfo->POOLBITS.

The fixed version even generates improved code.

Let's try to avoid repeats:

--- a/drivers/char/random.c~drivers-char-randomc-fix-a-race-which-can-lead-to-a-bogus-bug-fix
+++ a/drivers/char/random.c
@@ -407,7 +407,7 @@ struct entropy_store {
 	/* read-write data: */
 	spinlock_t lock;
 	unsigned add_ptr;
-	int entropy_count;
+	int entropy_count;	/* Must at no time exceed ->POOLBITS! */
 	int input_rotate;
 };
 
_

