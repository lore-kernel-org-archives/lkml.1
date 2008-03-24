Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbYCXFYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbYCXFYB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 01:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754567AbYCXFXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 01:23:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48901
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752018AbYCXFXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 01:23:52 -0400
Date: Sun, 23 Mar 2008 22:23:51 -0700 (PDT)
Message-Id: <20080323.222351.231321659.davem@davemloft.net>
To: linuxram@us.ibm.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [RFC PATCH] ipv4: compilation error fix with CONFIG_PROC_FS
 disabled
From: David Miller <davem@davemloft.net>
In-Reply-To: <1205172664.15345.96.camel@ram.us.ibm.com>
References: <1205172664.15345.96.camel@ram.us.ibm.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ram Pai <linuxram@us.ibm.com>
Date: Mon, 10 Mar 2008 11:11:03 -0700

> Fixes compilation errors while compiling the kernel with CONFIG_PROC_FS
> disabled.
> 
> Signed-off-by: Ram Pai <linuxram@us.ibm.com>

In the current tree, fib_proc_{init,exit}() are delcared
as do-nothing inline functions in include/net/ip_fib.h

That was made by the following 2.6.25 changeset, which I'll
queue up for 2.6.24-stable if necessary.

commit cc8274f50f2ad9a97a837451f63a0a3e65f7f490
Author: Li Zefan <lizf@cn.fujitsu.com>
Date:   Tue Feb 5 02:54:16 2008 -0800

    [IPV4]: Fix compile error building without CONFIG_FS_PROC
    
    compile error building without CONFIG_FS_PROC:
    
    net/ipv4/fib_frontend.c: In function 'fib_net_init':
    net/ipv4/fib_frontend.c:1032: error: implicit declaration of function 'fib_proc_
    init'
    net/ipv4/fib_frontend.c: In function 'fib_net_exit':
    net/ipv4/fib_frontend.c:1047: error: implicit declaration of function 'fib_proc_
    exit'
    
    Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

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
