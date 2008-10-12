Return-Path: <linux-kernel-owner+w=401wt.eu-S1752807AbYJLEL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbYJLEL6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 00:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbYJLELs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 00:11:48 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:58528 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705AbYJLELq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 00:11:46 -0400
Date: Sun, 12 Oct 2008 07:10:50 +0300
From: Adrian Bunk <bunk@kernel.org>
To: David Howells <dhowells@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>,
       linux-cifs-client@lists.samba.org
Subject: [2.6 patch] add key_revoke() dummy for KEYS=n
Message-ID: <20081012041050.GB31153@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following build error with CONFIG_KEYS=n, caused by
commit dfd15c46a6c2cafb006183c0c14f07e59eee4ac0
(cifs: explicitly revoke SPNEGO key after session setup):

<--  snip  -->

...
  CC [M]  fs/cifs/sess.o
fs/cifs/sess.c: In function 'CIFS_SessSetup':
fs/cifs/sess.c:628: error: implicit declaration of function 'key_revoke'
make[3]: *** [fs/cifs/sess.o] Error 1

<--  snip  -->


Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

diff --git a/include/linux/key.h b/include/linux/key.h
index c45c962..1b70e35 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -299,6 +299,7 @@ extern void key_init(void);
 #define key_validate(k)			0
 #define key_serial(k)			0
 #define key_get(k) 			({ NULL; })
+#define key_revoke(k)			do { } while(0)
 #define key_put(k)			do { } while(0)
 #define key_ref_put(k)			do { } while(0)
 #define make_key_ref(k, p)			({ NULL; })

