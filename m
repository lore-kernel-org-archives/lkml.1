Return-Path: <linux-kernel-owner+w=401wt.eu-S935889AbYBCGAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935889AbYBCGAl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 01:00:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbYBCGAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 01:00:31 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51303 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbYBCGAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 01:00:30 -0500
Message-ID: <47A55846.20709@cn.fujitsu.com>
Date: Sun, 03 Feb 2008 13:59:34 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-net@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] IPV4: fix compile error building without CONFIG_FS_PROC
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


compile error building without CONFIG_FS_PROC.

net/ipv4/fib_frontend.c: In function 'fib_net_init':
net/ipv4/fib_frontend.c:1032: error: implicit declaration of function 'fib_proc_
init'
net/ipv4/fib_frontend.c: In function 'fib_net_exit':
net/ipv4/fib_frontend.c:1047: error: implicit declaration of function 'fib_proc_
exit'

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

---
 include/net/ip_fib.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 90d1175..af5e985 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -267,5 +267,13 @@ static inline void fib_res_put(struct fib_result *res)
 extern int __net_init  fib_proc_init(struct net *net);
 extern void __net_exit fib_proc_exit(struct net *net);
 #endif
+static inline int fib_proc_init(struct net *net)
+{
+	return 0;
+}
+static inline int fib_proc_exit(struct net *net)
+{
+	return 0;
+}
 
 #endif  /* _NET_FIB_H */
-- 
1.5.4.rc3
