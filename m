Return-Path: <linux-kernel-owner+w=401wt.eu-S1030339AbXEAKag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030339AbXEAKag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423569AbXEAKaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:30:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423461AbXEAKaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:30:17 -0400
Subject: [GFS2] Uncomment sprintf_symbol calling code [34/34]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, Robert Peterson <rpeterso@redhat.com>
In-Reply-To: <1178013376.5462.127.camel@quoit.chygwyn.com>
References: <1178013376.5462.127.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 01 May 2007 11:25:43 +0100
Message-Id: <1178015143.5462.198.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 37fde8ca6c60ea61f5e9d7cb877c25ac60e74167 Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Tue, 1 May 2007 09:51:39 +0100
Subject: [PATCH] [GFS2] Uncomment sprintf_symbol calling code

Now that the patch from -mm has gone upstream, we can uncomment the code
in GFS2 which uses sprintf_symbol.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Robert Peterson <rpeterso@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 7988715..1815429 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1763,22 +1763,10 @@ void gfs2_gl_hash_clear(struct gfs2_sbd *sdp, int wait)
 static void gfs2_print_symbol(struct glock_iter *gi, const char *fmt,
                               unsigned long address)
 {
-/* when sprint_symbol becomes available in the new kernel, replace this */
-/* function with:
 	char buffer[KSYM_SYMBOL_LEN];
 
 	sprint_symbol(buffer, address);
 	print_dbg(gi, fmt, buffer);
-*/
-	char buffer[256];
-
-	if (gi) {
-		memset(buffer, 0, sizeof(buffer));
-		sprintf(buffer, "0x%08lx", address);
-		print_dbg(gi, fmt, buffer);
-	}
-	else
-		print_symbol(fmt, address);
 }
 
 /**
-- 
1.5.1.2



