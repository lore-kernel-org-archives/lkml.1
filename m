Return-Path: <linux-kernel-owner+w=401wt.eu-S1756571AbYJLLL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbYJLLL1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 07:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbYJLLLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 07:11:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60667 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbYJLLLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 07:11:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] Fix CIFS compilation with CONFIG_KEYS unset
Date: Sun, 12 Oct 2008 13:15:36 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "Steve French" <smfrench@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810121315.37203.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Fix CIFS compilation with CONFIG_KEYS unset

If CONFIG_KEYS is unset, fs/cifs/sess.c doesn't build due to key_revoke()
being undefined.  Fix that.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/linux/key.h |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/include/linux/key.h
===================================================================
--- linux-2.6.orig/include/linux/key.h
+++ linux-2.6/include/linux/key.h
@@ -300,6 +300,7 @@ extern void key_init(void);
 #define key_serial(k)			0
 #define key_get(k) 			({ NULL; })
 #define key_put(k)			do { } while(0)
+#define key_revoke(k)			do { } while(0)
 #define key_ref_put(k)			do { } while(0)
 #define make_key_ref(k, p)			({ NULL; })
 #define key_ref_to_ptr(k)		({ NULL; })
