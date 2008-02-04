Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbYBDAso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbYBDAso (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 19:48:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228AbYBDAsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 19:48:33 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49810 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754225AbYBDAsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 19:48:32 -0500
Message-ID: <47A660A1.5080504@cn.fujitsu.com>
Date: Mon, 04 Feb 2008 08:47:29 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-net@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] IPV4: fix compile error building without CONFIG_FS_PROC
References: <47A55846.20709@cn.fujitsu.com>
In-Reply-To: <47A55846.20709@cn.fujitsu.com>
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

The exit method should have no return values...

---
 include/net/ip_fib.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 90d1175..69393e3 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -267,5 +267,12 @@ static inline void fib_res_put(struct fib_result *res)
 extern int __net_init  fib_proc_init(struct net *net);
 extern void __net_exit fib_proc_exit(struct net *net);
 #endif
+static inline int fib_proc_init(struct net *net)
+{
+	return 0;
+}
+static inline void fib_proc_exit(struct net *net)
+{
+}
 
 #endif  /* _NET_FIB_H */
-- 
1.5.4.rc3

