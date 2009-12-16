Return-Path: <linux-kernel-owner+w=401wt.eu-S935329AbZLPTAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935329AbZLPTAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 14:00:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935287AbZLPTAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 14:00:32 -0500
Received: from d112.x-mailer.de ([212.162.53.3]:59462 "EHLO d112a3.x-mailer.de"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S935273AbZLPTA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 14:00:26 -0500
From: Karsten Keil <keil@b1-systems.de>
To: Yong Zhang <yong.zhang0@gmail.com>
Subject: Re: [PATCH 4/5] mISDN: use DECLARE_COMPLETION_ONSTACK for non-constant completion
Date: Wed, 16 Dec 2009 20:00:20 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.27.37-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Andreas Eversberg <andreas@eversberg.eu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
References: <1260974161-6934-1-git-send-email-yong.zhang0@gmail.com> <1260974161-6934-4-git-send-email-yong.zhang0@gmail.com> <1260974161-6934-5-git-send-email-yong.zhang0@gmail.com>
In-Reply-To: <1260974161-6934-5-git-send-email-yong.zhang0@gmail.com>
Organization: B1-systems
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <200912162000.20642.keil@b1-systems.de>
X-Info: valid message
X-Info: original Date
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The _ONSTACK variant should be used for on-stack completion,
otherwise it will break lockdep.
 
Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Acked-by: Karsten Keil <keil@b1-systems.de>
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

