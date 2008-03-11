Return-Path: <linux-kernel-owner+w=401wt.eu-S1757229AbYCKORa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229AbYCKORa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 10:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750699AbYCKORV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 10:17:21 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:63722 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751819AbYCKORU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 10:17:20 -0400
Message-ID: <47D6946C.2050407@trash.net>
Date: Tue, 11 Mar 2008 15:17:16 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Ram Pai <linuxram@us.ibm.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       davem@davemloft.net
Subject: Re: [RFC PATCH] ipv4: compilation error fix with CONFIG_PROC_FS	disabled
References: <1205172664.15345.96.camel@ram.us.ibm.com>
In-Reply-To: <1205172664.15345.96.camel@ram.us.ibm.com>
Content-Type: multipart/mixed;
 boundary="------------030503000406090802030803"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030503000406090802030803
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Ram Pai wrote:
> Fixes compilation errors while compiling the kernel with CONFIG_PROC_FS
> disabled.


Please always include the compiler message when fixing compilation
warnings or errors.

This one is already fixed differently in current -git:



--------------030503000406090802030803
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

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

--------------030503000406090802030803--
