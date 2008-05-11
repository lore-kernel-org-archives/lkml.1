Return-Path: <linux-kernel-owner+w=401wt.eu-S1759105AbYEKUDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759105AbYEKUDU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 16:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756184AbYEKUDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 16:03:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:48579 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263AbYEKUDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 16:03:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=v1ThuSjMQPKJykLAiXIvzlIn6yviU51lMrNr0DaW9KmBOF55eC9tDqGhMY3/TO4Z9VLakDOzC9wVp7yj+JNU3pd/kz2IyckMYZMET9+WN8NVJoPCUufCvE6BpbLZqkXEHVs6qIqk+6mV6iRkdmc/zYEteafaYAzowFKK/tVqlDA=
Date: Sun, 11 May 2008 22:02:41 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Karsten Keil <kkeil@suse.de>
Subject: [PATCH] isdn/capi: return proper errnos on module init
Message-ID: <20080511200237.GJ19058@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cdebug_init is called from kcapi_init which is module initialization function,
so it must return negative values on errors

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Karsten Keil <kkeil@suse.de>
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
