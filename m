Return-Path: <linux-kernel-owner+w=401wt.eu-S1755877AbYBDDRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbYBDDRa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 22:17:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754367AbYBDDRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 22:17:20 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58821 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754038AbYBDDRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 22:17:19 -0500
Message-ID: <47A68388.2030104@cn.fujitsu.com>
Date: Mon, 04 Feb 2008 11:16:24 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: yoshfuji@linux-ipv6.org
CC: davem@davemloft.net, linux-net@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IPV4: fix compile error building without CONFIG_FS_PROC
References: <47A55846.20709@cn.fujitsu.com>	<47A660A1.5080504@cn.fujitsu.com> <20080204.132518.63717287.yoshfuji@linux-ipv6.org>
In-Reply-To: <20080204.132518.63717287.yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

YOSHIFUJI Hideaki wrote:
> In article <47A660A1.5080504@cn.fujitsu.com> (at Mon, 04 Feb 2008 08:47:29 +0800), Li Zefan <lizf@cn.fujitsu.com> says:
> 
>> compile error building without CONFIG_FS_PROC.
> :
>> The exit method should have no return values...
> 
> Have you really tested this with CONFIG_FS_PROC?
> 
> --yoshfuji
> 
> 

Oops, shame on me, what a silly patch... :( I tested it without CONFIG_PROC_PS,
but didn't test it with CONFIG_PROC_FS.

Now I've tested the new patch both with and without CONFIG_PROC_FS.

---

compile error building without CONFIG_FS_PROC:

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
index 90d1175..8b12667 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -266,6 +266,14 @@ static inline void fib_res_put(struct fib_result *res)
 #ifdef CONFIG_PROC_FS
 extern int __net_init  fib_proc_init(struct net *net);
 extern void __net_exit fib_proc_exit(struct net *net);
+#else
+static inline int fib_proc_init(struct net *net)
+{
+	return 0;
+}
+static inline void fib_proc_exit(struct net *net)
+{
+}
 #endif
 
 #endif  /* _NET_FIB_H */
-- 
1.5.4.rc3
