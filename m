Return-Path: <linux-kernel-owner+w=401wt.eu-S1757725AbZLPOhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725AbZLPOhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 09:37:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762183AbZLPOhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 09:37:13 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:59843 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758216AbZLPOgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 09:36:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=FCmyHeiMP6UreJDqTc7oSxDvvjL80DZTM3HdCqvhkncWlPrbNRoI/P2vDAyaVYj3IT
         hAca/t/+33CsQZinE3fiVboGwtre88p/CzmhuVt3ZaQ6s5F18KRoivJIxKR+Z5/wj1+T
         fUX68586DjhvI33SdWf5xSA7nDiYiBgz1qiFw=
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Karsten Keil <isdn@linux-pingi.de>,
       "David S. Miller" <davem@davemloft.net>,
       Andreas Eversberg <andreas@eversberg.eu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/5] mISDN: use DECLARE_COMPLETION_ONSTACK for non-constant completion
Date: Wed, 16 Dec 2009 22:36:00 +0800
Message-Id: <1260974161-6934-5-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1260974161-6934-4-git-send-email-yong.zhang0@gmail.com>
References: <1260974161-6934-1-git-send-email-yong.zhang0@gmail.com>
 <1260974161-6934-2-git-send-email-yong.zhang0@gmail.com>
 <1260974161-6934-3-git-send-email-yong.zhang0@gmail.com>
 <1260974161-6934-4-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The _ONSTACK variant should be used for on-stack completion,
otherwise it will break lockdep.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Eversberg <andreas@eversberg.eu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 drivers/isdn/mISDN/l1oip_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/mISDN/l1oip_core.c b/drivers/isdn/mISDN/l1oip_core.c
index 7e5f30d..f1e8af5 100644
--- a/drivers/isdn/mISDN/l1oip_core.c
+++ b/drivers/isdn/mISDN/l1oip_core.c
@@ -661,7 +661,7 @@ l1oip_socket_thread(void *data)
 	size_t recvbuf_size = 1500;
 	int recvlen;
 	struct socket *socket = NULL;
-	DECLARE_COMPLETION(wait);
+	DECLARE_COMPLETION_ONSTACK(wait);
 
 	/* allocate buffer memory */
 	recvbuf = kmalloc(recvbuf_size, GFP_KERNEL);
-- 
1.6.3.3

