Return-Path: <linux-kernel-owner+w=401wt.eu-S1032731AbXFIBae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032731AbXFIBae (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 21:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbXFIBaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 21:30:24 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:3413 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753196AbXFIBaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 21:30:23 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: jlayton@redhat.com (Jeff Layton)
Subject: Re: [PATCH] RFC: have tcp_recvmsg() check kthread_should_stop() and treat it as if it were signalled
Cc: linux-kernel@vger.kernel.org, linux-cifs-client@lists.samba.org,
       linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org
Organization: Core
In-Reply-To: <20070608123527.9b4cdafe.jlayton@redhat.com>
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1HwpmG-0008LW-00@gondolin.me.apana.org.au>
Date: Sat, 09 Jun 2007 11:30:04 +1000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please cc networking patches to netdev@vger.kernel.org.

Jeff Layton <jlayton@redhat.com> wrote:
> 
> The following patch is a first stab at removing this need. It makes it
> so that in tcp_recvmsg() we also check kthread_should_stop() at any
> point where we currently check to see if the task was signalled. If
> that returns true, then it acts as if it were signalled and returns to
> the calling function.

This just doesn't seem to fit.  Why should networking care about kthreads?

Perhaps you can get kthread_stop to send a signal instead?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
