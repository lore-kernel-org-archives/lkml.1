Return-Path: <linux-kernel-owner+w=401wt.eu-S1757408AbZDXNAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408AbZDXNAY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 09:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755745AbZDXNAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 09:00:07 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:51221 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbZDXNAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 09:00:06 -0400
Date: Fri, 24 Apr 2009 08:59:07 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Replace conditional test with is_power_of_2().
Message-ID: <alpine.LFD.2.00.0904240856420.6102@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  yes, i know the word "tachnique" is misspelled there.  that's not
part of this patch so i'm not fixing it here.


diff --git a/kernel/kfifo.c b/kernel/kfifo.c
index bc41ad0..04a1748 100644
--- a/kernel/kfifo.c
+++ b/kernel/kfifo.c
@@ -74,7 +74,7 @@ struct kfifo *kfifo_alloc(unsigned int size, gfp_t gfp_mask, spinlock_t *lock)
 	 * round up to the next power of 2, since our 'let the indices
 	 * wrap' tachnique works only in this case.
 	 */
-	if (size & (size - 1)) {
+	if (!is_power_of_2(size)) {
 		BUG_ON(size > 0x80000000);
 		size = roundup_pow_of_two(size);
 	}

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
