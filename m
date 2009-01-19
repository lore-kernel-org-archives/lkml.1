Return-Path: <linux-kernel-owner+w=401wt.eu-S1759546AbZASKKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759546AbZASKKp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 05:10:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757462AbZASKKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 05:10:36 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:46711 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757277AbZASKKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 05:10:36 -0500
Date: Mon, 19 Jan 2009 21:10:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] creds: suppress warning in get_cred
Message-Id: <20090119211031.934b4c19.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the usual way to force a conversion from a const pointer to a
non-const one and gets rid of this warning:

include/linux/cred.h: In function 'get_cred':
include/linux/cred.h:188: warning: passing argument 1 of 'get_new_cred' discards qualifiers from pointer target type

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/cred.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/cred.h b/include/linux/cred.h
index 3282ee4..ed38227 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -12,6 +12,7 @@
 #ifndef _LINUX_CRED_H
 #define _LINUX_CRED_H
 
+#include <linux/types.h>
 #include <linux/capability.h>
 #include <linux/key.h>
 #include <asm/atomic.h>
@@ -185,7 +186,7 @@ static inline struct cred *get_new_cred(struct cred *cred)
  */
 static inline const struct cred *get_cred(const struct cred *cred)
 {
-	return get_new_cred((struct cred *) cred);
+	return get_new_cred((struct cred *)(uintptr_t)cred);
 }
 
 /**
-- 
1.6.0.5

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
