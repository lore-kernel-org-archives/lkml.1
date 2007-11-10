Return-Path: <linux-kernel-owner+w=401wt.eu-S1763201AbXKJBnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763201AbXKJBnI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 20:43:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755369AbXKJBm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 20:42:57 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:57764 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbXKJBm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 20:42:56 -0500
Message-ID: <47350C92.80505@cosmosbay.com>
Date: Sat, 10 Nov 2007 02:42:42 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: 
References: <617E1C2C70743745A92448908E030B2A02E9A31C@scsmsx411.amr.corp.intel.com>
In-Reply-To: <617E1C2C70743745A92448908E030B2A02E9A31C@scsmsx411.amr.corp.intel.com>
Content-Type: multipart/mixed;
 boundary="------------040101090409020109010808"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Sat, 10 Nov 2007 02:42:50 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040101090409020109010808
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Luck, Tony a écrit :
> Just pulled latest git tree from Linus and a few ia64 configurations
> (anything with CONFIG_NUMA=y) won't build.
> 
> The offending commit appears to be:
> 
>     230140cffa7feae90ad50bf259db1fa07674f3a7
> 
> Here's the error messages from the compiler:
> 
>   CC [M]  drivers/infiniband/core/cma.o
> In file included from include/net/tcp.h:35,
>                  from drivers/infiniband/core/cma.c:40:
> include/net/inet_hashtables.h: In function `inet_ehash_locks_alloc':
> include/net/inet_hashtables.h:165: error: implicit declaration of
> function `vmalloc'
> include/net/inet_hashtables.h:165: warning: assignment makes pointer
> from integer without a cast
> include/net/inet_hashtables.h: In function `inet_ehash_locks_free':
> include/net/inet_hashtables.h:186: error: implicit declaration of
> function `vfree'
> make[3]: *** [drivers/infiniband/core/cma.o] Error 1
> 

Hi Tony

Seems an include is missing.

Could you please apply this patch ?

Thank you

[NET] adds a missing include <linux/vmalloc.h>

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>


--------------040101090409020109010808
Content-Type: text/plain;
 name="include.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="include.patch"

diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index 8461cda..469216d 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -23,6 +23,7 @@
 #include <linux/spinlock.h>
 #include <linux/types.h>
 #include <linux/wait.h>
+#include <linux/vmalloc.h>
 
 #include <net/inet_connection_sock.h>
 #include <net/inet_sock.h>

--------------040101090409020109010808--
