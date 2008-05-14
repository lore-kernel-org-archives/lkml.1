Return-Path: <linux-kernel-owner+w=401wt.eu-S1750963AbYENU3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750963AbYENU3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 16:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbYENU2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 16:28:49 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:38361 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbYENU2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 16:28:48 -0400
Date: Wed, 14 May 2008 23:27:09 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Graf Yang <graf.yang@analog.com>, Bryan Wu <cooloney@kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [2.6 patch] irnet_irda.c must #include <asm/unaligned.h>
Message-ID: <20080514202709.GB21795@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile error caused by
commit 332223831e86b2e17b48b4afafad07d8e3b73861
(irda: Fix a misalign access issue. (v2)):

<--  snip  -->

...
  CC      net/irda/irnet/irnet_irda.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/net/irda/irnet/irnet_irda.c: In function ‘irnet_discovery_indication’:
/home/bunk/linux/kernel-2.6/git/linux-2.6/net/irda/irnet/irnet_irda.c:1676: error: implicit declaration of function ‘get_unaligned’
make[4]: *** [net/irda/irnet/irnet_irda.o] Error 1

<--  snip  -->

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
41881ccc5581fe2e27ca15b942c9f79e28b45276 diff --git a/net/irda/irnet/irnet_irda.c b/net/irda/irnet/irnet_irda.c
index a3ec002..cf9a4b5 100644
--- a/net/irda/irnet/irnet_irda.c
+++ b/net/irda/irnet/irnet_irda.c
@@ -10,6 +10,7 @@
 
 #include "irnet_irda.h"		/* Private header */
 #include <linux/seq_file.h>
+#include <asm/unaligned.h>
 
 /*
  * PPP disconnect work: we need to make sure we're in

