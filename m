Return-Path: <linux-kernel-owner+w=401wt.eu-S1753502AbZKICVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbZKICVs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 21:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbZKICVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 21:21:47 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36862 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165AbZKICVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 21:21:46 -0500
Date: Mon, 9 Nov 2009 13:21:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>
Subject: linux-next: net tree build failure
Message-Id: <20091109132151.0e0ec7bc.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next build (x86_64 allmodconfig) failed like this:

net/appletalk/ddp.c: In function 'atalk_compat_ioctl':
net/appletalk/ddp.c:1866: error: implicit declaration of function 'compat_ptr'

Caused by commit 206602217747382488fcae68351673cc9103debc
("appletalk: handle SIOCATALKDIFADDR compat ioctl").

I applied this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 9 Nov 2009 13:11:26 +1100
Subject: [PATCH] net/appletalk: using compat_ptr needs inclusion of linux/compat.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 net/appletalk/ddp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index b631cc7..73ca4d5 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -56,6 +56,7 @@
 #include <linux/if_arp.h>
 #include <linux/smp_lock.h>
 #include <linux/termios.h>	/* For TIOCOUTQ/INQ */
+#include <linux/compat.h>
 #include <net/datalink.h>
 #include <net/psnap.h>
 #include <net/sock.h>
-- 
1.6.5.2


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
