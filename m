Return-Path: <linux-kernel-owner+w=401wt.eu-S933301AbZJJPiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933301AbZJJPiQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 11:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932994AbZJJPiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 11:38:13 -0400
Received: from www.tglx.de ([62.245.132.106]:55475 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932948AbZJJPiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 11:38:10 -0400
Message-Id: <20091010153349.569964989@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 10 Oct 2009 15:36:21 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Alessio Igor Bogani <abogani@texware.it>, Greg KH <gregkh@suse.de>
Subject: [patch 12/28] nvram: Drop the bkl from non-generic nvram_llseek()
References: <20091010153314.827301943@linutronix.de>
Content-Disposition: inline;
	filename=nvram-drop-the-bkl-from-non-generic-nvram_llseek.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop the bkl from nvram_llseek() as it obviously protects nothing.
The file offset is safe in essence.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Alessio Igor Bogani <abogani@texware.it>
Cc: Greg KH <gregkh@suse.de>
LKML-Reference: <1255116426-7270-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/char/nvram.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux-2.6-tip/drivers/char/nvram.c
===================================================================
--- linux-2.6-tip.orig/drivers/char/nvram.c
+++ linux-2.6-tip/drivers/char/nvram.c
@@ -38,7 +38,6 @@
 #define NVRAM_VERSION	"1.3"
 
 #include <linux/module.h>
-#include <linux/smp_lock.h>
 #include <linux/nvram.h>
 
 #define PC		1
@@ -214,7 +213,6 @@ void nvram_set_checksum(void)
 
 static loff_t nvram_llseek(struct file *file, loff_t offset, int origin)
 {
-	lock_kernel();
 	switch (origin) {
 	case 0:
 		/* nothing to do */
@@ -226,7 +224,7 @@ static loff_t nvram_llseek(struct file *
 		offset += NVRAM_BYTES;
 		break;
 	}
-	unlock_kernel();
+
 	return (offset >= 0) ? (file->f_pos = offset) : -EINVAL;
 }
 


