Return-Path: <linux-kernel-owner+w=401wt.eu-S1762278AbYEKVQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762278AbYEKVQn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 17:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759241AbYEKVHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 17:07:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34272 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759257AbYEKVHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 17:07:10 -0400
Date: Sun, 11 May 2008 23:07:07 +0200
From: Karsten Keil <kkeil@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] isdn/capi: return proper errnos on module init
Message-ID: <20080511210707.GA25600@pingi.kke.suse.de>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Marcin Slusarz <marcin.slusarz@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cdebug_init is called from kcapi_init which is module initialization function,
so it must return negative values on errors

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Acked-by: Karsten Keil <kkeil@suse.de>
---
compile tested only
---
 drivers/isdn/capi/capiutil.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/capi/capiutil.c b/drivers/isdn/capi/capiutil.c
--- a/drivers/isdn/capi/capiutil.c
+++ b/drivers/isdn/capi/capiutil.c
@@ -948,17 +948,17 @@ int __init cdebug_init(void)
 {
 	g_cmsg= kmalloc(sizeof(_cmsg), GFP_KERNEL);
 	if (!g_cmsg)
-		return ENOMEM;
+		return -ENOMEM;
 	g_debbuf = kmalloc(sizeof(_cdebbuf), GFP_KERNEL);
 	if (!g_debbuf) {
 		kfree(g_cmsg);
-		return ENOMEM;
+		return -ENOMEM;
 	}
 	g_debbuf->buf = kmalloc(CDEBUG_GSIZE, GFP_KERNEL);
 	if (!g_debbuf->buf) {
 		kfree(g_cmsg);
 		kfree(g_debbuf);
-		return ENOMEM;;
+		return -ENOMEM;;
 	}
 	g_debbuf->size = CDEBUG_GSIZE;
 	g_debbuf->buf[0] = 0;
-- 

