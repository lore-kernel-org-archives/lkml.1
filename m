Return-Path: <linux-kernel-owner+w=401wt.eu-S1759472AbYABPKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472AbYABPKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 10:10:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758804AbYABPKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 10:10:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279AbYABPKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 10:10:23 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080101231517.GA15303@Chamillionaire.breakpoint.cc>
References: <20080101231517.GA15303@Chamillionaire.breakpoint.cc>
To: torvalds@osdl.org, akpm@linux-foundation.org
CC: Sebastian Siewior <sebastian@breakpoint.cc>, dhowells@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] KEYS: fix macro
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 02 Jan 2008 15:10:12 +0000
Message-ID: <30714.1199286612@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sebastian Siewior <sebastian@breakpoint.cc>

Commit 664cceb0093b755739e56572b836a99104ee8a75 changed the
parameters of the function make_key_ref(). The macros that
are used in case CONFIG_KEY is not defined did not change.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
Acked-by: David Howells <dhowells@redhat.com>
---

I found this while compile testing some files with a broken .config
file. Currently there is no user of make_key_ref() that does not select
CONFIG_KEY via Kconfig. However you may want to include this patch in
your new batch :)

 include/linux/key.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/key.h b/include/linux/key.h
index fcdbd5e..a70b8a8 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -290,7 +290,7 @@ extern void key_init(void);
 #define key_get(k) 			({ NULL; })
 #define key_put(k)			do { } while(0)
 #define key_ref_put(k)			do { } while(0)
-#define make_key_ref(k)			({ NULL; })
+#define make_key_ref(k, p)			({ NULL; })
 #define key_ref_to_ptr(k)		({ NULL; })
 #define is_key_possessed(k)		0
 #define alloc_uid_keyring(u,c)		0
-- 
1.5.3.7
