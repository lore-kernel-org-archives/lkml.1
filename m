Return-Path: <linux-kernel-owner+w=401wt.eu-S1752343AbXKJK2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbXKJK2h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 05:28:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbXKJK23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 05:28:29 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:56979 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbXKJK23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 05:28:29 -0500
Message-ID: <473586FA.4080402@cosmosbay.com>
Date: Sat, 10 Nov 2007 11:24:58 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, davem@davemloft.net, apw@shadowen.org
Subject: Re: [PATCH](resend) 2.6.24-rc2-git1 Build fails in selinux/hooks.
References: <20071110094149.GA25923@linux.vnet.ibm.com>
In-Reply-To: <20071110094149.GA25923@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Sat, 10 Nov 2007 11:25:08 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kamalesh Babulal a écrit :
> Hi,
> 
> The 2.6.24-rc2-git1 kernel build fails, with following error
> 
>   CC      security/selinux/hooks.o
> In file included from include/net/tcp.h:35,
>                  from security/selinux/hooks.c:52:
> include/net/inet_hashtables.h: In function 'inet_ehash_locks_alloc':
> include/net/inet_hashtables.h:165: error: implicit declaration of function 'vmalloc'
> include/net/inet_hashtables.h:165: warning: assignment makes pointer from integer without a cast
> include/net/inet_hashtables.h: In function 'inet_ehash_locks_free':
> include/net/inet_hashtables.h:186: error: implicit declaration of function 'vfree'
> make[2]: *** [security/selinux/hooks.o] Error 1
> make[1]: *** [security/selinux] Error 2
> make: *** [security] Error 2
> 
> The commit 230140cffa7feae90ad50bf259db1fa07674f3a7 ([INET]: Remove per
> bucket rwlock in tcp/dccp ehash table.) caused this build
> failure.
> 
> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> --
> diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
> index 8461cda..469216d 100644
> --- a/include/net/inet_hashtables.h
> +++ b/include/net/inet_hashtables.h
> @@ -23,6 +23,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/types.h>
>  #include <linux/wait.h>
> +#include <linux/vmalloc.h>
>  
>  #include <net/inet_connection_sock.h>
>  #include <net/inet_sock.h>
> 

Yes, same patch was posted some hours ago, but Tony didnt acknowledged it.

http://marc.info/?l=linux-kernel&m=119465902731847&w=2

Thank you
