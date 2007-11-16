Return-Path: <linux-kernel-owner+w=401wt.eu-S934979AbXKPVx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934979AbXKPVx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 16:53:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758563AbXKPVxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 16:53:18 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:53249 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757146AbXKPVxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 16:53:17 -0500
Message-ID: <473E1144.9070404@cosmosbay.com>
Date: Fri, 16 Nov 2007 22:53:08 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] NR_OPEN should be raised a litle bit
Content-Type: multipart/mixed;
 boundary="------------000000030508040504090501"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Fri, 16 Nov 2007 22:53:12 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000000030508040504090501
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Time has come to change NR_OPEN value, some production servers hit the
not so 'ridiculously high value' of 1024*1024 file descriptors per process.

This is safe to raise this value, because alloc_fd_array() uses
vmalloc() for large arrays and vmalloc() returns NULL if a too large
allocation is attempted (or in case of memory shortage)

Moore law implies this limit should be changed every 1-2 years, and it seems
we forgot doing this for ages.

Even on my old notebook, a process can open 1000000 descriptors without any 
problem.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>


--------------000000030508040504090501
Content-Type: text/plain;
 name="nr_open.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nr_open.patch"

diff --git a/include/linux/fs.h b/include/linux/fs.h
index b3ec4a4..6253ddd 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -21,7 +21,7 @@
 
 /* Fixed constants first: */
 #undef NR_OPEN
-#define NR_OPEN (1024*1024)	/* Absolute upper limit on fd num */
+#define NR_OPEN (16*1024*1024)	/* Absolute upper limit on fd num */
 #define INR_OPEN 1024		/* Initial setting for nfile rlimits */
 
 #define BLOCK_SIZE_BITS 10

--------------000000030508040504090501--
