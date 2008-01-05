Return-Path: <linux-kernel-owner+w=401wt.eu-S1753984AbYAEHMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbYAEHMo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 02:12:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbYAEHMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 02:12:36 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:4945 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751743AbYAEHMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 02:12:35 -0500
Date: Sat, 5 Jan 2008 18:12:05 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Christian Kujau <lists@nerdbynature.de>,
       linux-kernel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Davide Libenzi <davidel@xmailserver.org>
Subject: Re: 2.6.24-rc6: possible recursive locking detected
Message-ID: <20080105071205.GA28936@gondor.apana.org.au>
References: <alpine.DEB.0.999999.0801032349190.4821@sheep.housecafe.de> <200801040006.47979.rjw@sisk.pl> <20080104083049.GC22803@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080104083049.GC22803@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2008 at 09:30:49AM +0100, Ingo Molnar wrote:
>
> > > [ 1310.670986] =============================================
> > > [ 1310.671690] [ INFO: possible recursive locking detected ]
> > > [ 1310.672097] 2.6.24-rc6 #1
> > > [ 1310.672421] ---------------------------------------------
> > > [ 1310.672828] FahCore_a0.exe/3692 is trying to acquire lock:
> > > [ 1310.673238]  (&q->lock){++..}, at: [<c011544b>] __wake_up+0x1b/0x50
> > > [ 1310.673869]
> > > [ 1310.673870] but task is already holding lock:
> > > [ 1310.674567]  (&q->lock){++..}, at: [<c011544b>] __wake_up+0x1b/0x50
> > > [ 1310.675267]
> > > [ 1310.675268] other info that might help us debug this:
> > > [ 1310.675952] 5 locks held by FahCore_a0.exe/3692:
> > > [ 1310.676334]  #0:  (rcu_read_lock){..--}, at: [<c038b620>] net_rx_action+0x60/0x1b0
> > > [ 1310.677251]  #1:  (rcu_read_lock){..--}, at: [<c0388d60>] netif_receive_skb+0x100/0x470
> > > [ 1310.677924]  #2:  (rcu_read_lock){..--}, at: [<c03a7fb2>] ip_local_deliver_finish+0x32/0x210
> > > [ 1310.678460]  #3:  (clock-AF_INET){-.-?}, at: [<c038164e>] sock_def_readable+0x1e/0x80
> > > [ 1310.679250]  #4:  (&q->lock){++..}, at: [<c011544b>] __wake_up+0x1b/0x50

The net part might just be a red herring, since the problem is that
__wake_up is somehow reentering itself.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
