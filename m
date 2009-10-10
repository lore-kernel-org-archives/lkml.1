Return-Path: <linux-kernel-owner+w=401wt.eu-S1758495AbZJJXZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758495AbZJJXZU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 19:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758192AbZJJXZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 19:25:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755430AbZJJXZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 19:25:18 -0400
Date: Sun, 11 Oct 2009 01:24:14 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
cc: Jonathan Corbet <corbet@lwn.net>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vincent Sanders <vince@simtec.co.uk>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] sound_core.c: Remove BKL from soundcore_open
Message-ID: <alpine.LFD.2.00.0910110123510.4921@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 030af455d4f54482130c8eccb47fe90aaba8808c Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Sat, 10 Oct 2009 23:39:56 +0200
Subject: [PATCH] This code is already protected by spin_lock, and doesn't require the bkl

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 sound/sound_core.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/sound/sound_core.c b/sound/sound_core.c
index 49c9981..03bb943 100644
--- a/sound/sound_core.c
+++ b/sound/sound_core.c
@@ -576,8 +576,6 @@ static int soundcore_open(struct inode *inode, struct file *file)
 	struct sound_unit *s;
 	const struct file_operations *new_fops = NULL;
 
-	lock_kernel ();
-
 	chain=unit&0x0F;
 	if(chain==4 || chain==5)	/* dsp/audio/dsp16 */
 	{
@@ -637,11 +635,9 @@ static int soundcore_open(struct inode *inode, struct file *file)
 			file->f_op = fops_get(old_fops);
 		}
 		fops_put(old_fops);
-		unlock_kernel();
 		return err;
 	}
 	spin_unlock(&sound_loader_lock);
-	unlock_kernel();
 	return -ENODEV;
 }
 
-- 
1.6.0.6

