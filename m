Return-Path: <linux-kernel-owner+w=401wt.eu-S1757442AbYLJSfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbYLJSfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 13:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756428AbYLJSev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 13:34:51 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:46483 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757943AbYLJSeu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 13:34:50 -0500
Message-ID: <49400B7F.7040607@cosmosbay.com>
Date: Wed, 10 Dec 2008 19:33:35 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "David S. Miller" <davem@davemloft.net>,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [PATCH] replace deprecated RW_LOCK_UNLOCKED in net/dccp/proto.c
References: <alpine.DEB.1.10.0812101314460.11805@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0812101314460.11805@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 10 Dec 2008 19:33:36 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cced netdev

Steven Rostedt a écrit :
> The following patch is in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: cleanups
> 
> 
> Steven Rostedt (1):
>       replace deprecated RW_LOCK_UNLOCKED in net/dccp/proto.c
> 
> ----
>  net/dccp/proto.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> ---------------------------
> commit 3e1de819261b68a48b09719694c7e3579a8e4186
> Author: Steven Rostedt <srostedt@redhat.com>
> Date:   Wed Dec 10 12:49:47 2008 -0500
> 
>     replace deprecated RW_LOCK_UNLOCKED in net/dccp/proto.c
>     
>     Impact: clean up
>     
>     RW_LOCK_UNLOCKED has been deprecated and superseded by
>     __RW_LOCK_UNLOCKED(name).  This patch removes one of the last
>     remaining users of it.
>     
>     Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> 
> diff --git a/net/dccp/proto.c b/net/dccp/proto.c
> index d0bd348..e6e54a7 100644
> --- a/net/dccp/proto.c
> +++ b/net/dccp/proto.c
> @@ -45,7 +45,7 @@ atomic_t dccp_orphan_count = ATOMIC_INIT(0);
>  EXPORT_SYMBOL_GPL(dccp_orphan_count);
>  
>  struct inet_hashinfo __cacheline_aligned dccp_hashinfo = {
> -	.lhash_lock	= RW_LOCK_UNLOCKED,
> +	.lhash_lock	= __RW_LOCK_UNLOCKED(dccp_hashinfo.lhash_lock),
>  	.lhash_users	= ATOMIC_INIT(0),
>  	.lhash_wait = __WAIT_QUEUE_HEAD_INITIALIZER(dccp_hashinfo.lhash_wait),
>  };
> --

Hum... this rwlock doesnt exist anymore on net-next-2.6, all this stuff
was converted to RCU for upcoming 2.6.29

struct inet_hashinfo dccp_hashinfo;
EXPORT_SYMBOL_GPL(dccp_hashinfo);

I guess such a patch wont ease David job when 2.6.29 merge window opens


