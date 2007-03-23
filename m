Return-Path: <linux-kernel-owner+w=401wt.eu-S933859AbXCWRx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933859AbXCWRx3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 13:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933890AbXCWRx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 13:53:29 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:40673 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933911AbXCWRx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 13:53:27 -0400
X-Originating-Ip: 74.109.98.130
Date: Fri, 23 Mar 2007 13:50:12 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, mike.mclagan@linux.org
Subject: [PATCH] Delete unused header file linux/if_wanpipe_common.h.
Message-ID: <Pine.LNX.4.64.0703231343530.7168@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Delete the unreferenced header file include/linux/if_wanpipe_common.h,
as well as the reference to it in the Doc file.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  there is a related header file, linux/if_wanpipe.h, that is unused
in the source tree but is still exported to userspace.  if that file
is also unnecessary, i can resubmit the patch to take out both of
them.


 Documentation/networking/wan-router.txt |    1
 include/linux/if_wanpipe_common.h       |   58 ----------------------
 2 files changed, 59 deletions(-)

diff --git a/Documentation/networking/wan-router.txt b/Documentation/networking/wan-router.txt
index 653978d..07dd6d9 100644
--- a/Documentation/networking/wan-router.txt
+++ b/Documentation/networking/wan-router.txt
@@ -250,7 +250,6 @@ PRODUCT COMPONENTS AND RELATED FILES
 	sdladrv.h	SDLA support module API definitions
 	sdlasfm.h	SDLA firmware module definitions
 	if_wanpipe.h	WANPIPE Socket definitions
-	if_wanpipe_common.h	WANPIPE Socket/Driver common definitions.
 	sdlapci.h	WANPIPE PCI definitions


diff --git a/include/linux/if_wanpipe_common.h b/include/linux/if_wanpipe_common.h
deleted file mode 100644
index 6e5461d..0000000
--- a/include/linux/if_wanpipe_common.h
+++ /dev/null
@@ -1,58 +0,0 @@
-/*****************************************************************************
-* if_wanipe_common.h   Sangoma Driver/Socket common area definitions.
-*
-* Author:       Nenad Corbic <ncorbic@sangoma.com>
-*
-* Copyright:    (c) 2000 Sangoma Technologies Inc.
-*
-*               This program is free software; you can redistribute it and/or
-*               modify it under the terms of the GNU General Public License
-*               as published by the Free Software Foundation; either version
-*               2 of the License, or (at your option) any later version.
-* ============================================================================
-* Jan 13, 2000  Nenad Corbic      Initial version
-*****************************************************************************/
-
-
-#ifndef _WANPIPE_SOCK_DRIVER_COMMON_H
-#define _WANPIPE_SOCK_DRIVER_COMMON_H
-
-typedef struct {
-	struct net_device *slave;
-	atomic_t packet_sent;
-	atomic_t receive_block;
-	atomic_t command;
-	atomic_t disconnect;
-	atomic_t driver_busy;
-	long common_critical;
-	struct timer_list *tx_timer;
-	struct sock *sk;		/* Wanpipe Sock bind's here */
-	int (*func)(struct sk_buff *skb, struct net_device *dev,
-		    struct sock *sk);
-
-	struct work_struct wanpipe_work;    /* deferred keventd work */
-	unsigned char rw_bind;			  /* Sock bind state */
-	unsigned char usedby;
-	unsigned char state;
-	unsigned char svc;
-	unsigned short lcn;
-	void *mbox;
-} wanpipe_common_t;
-
-
-enum {
-	WANSOCK_UNCONFIGURED,	/* link/channel is not configured */
-	WANSOCK_DISCONNECTED,	/* link/channel is disconnected */
-	WANSOCK_CONNECTING,		/* connection is in progress */
-	WANSOCK_CONNECTED,		/* link/channel is operational */
-	WANSOCK_LIMIT,		/* for verification only */
-	WANSOCK_DUALPORT,		/* for Dual Port cards */
-	WANSOCK_DISCONNECTING,
-	WANSOCK_BINDED,
-	WANSOCK_BIND_LISTEN,
-	WANSOCK_LISTEN
-};
-
-#endif
-
-
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
