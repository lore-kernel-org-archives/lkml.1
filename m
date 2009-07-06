Return-Path: <linux-kernel-owner+w=401wt.eu-S1755001AbZGFCca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001AbZGFCca (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 22:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbZGFCcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 22:32:16 -0400
Received: from thunk.org ([69.25.196.29]:42602 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753973AbZGFCcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 22:32:15 -0400
Date: Sun, 5 Jul 2009 22:31:13 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jesper Dangaard Brouer <hawk@comx.dk>
Cc: "David S. Miller" <davem@davemloft.net>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, dougthompson@xmission.com,
       bluesmoke-devel@lists.sourceforge.net, axboe@kernel.dk,
       Patrick McHardy <kaber@trash.net>, christine.caulfield@googlemail.com,
       Trond.Myklebust@netapp.com, linux-wireless@vger.kernel.org,
       johannes@sipsolutions.net, yoshfuji@linux-ipv6.org,
       shemminger@linux-foundation.org, linux-nfs@vger.kernel.org,
       bfields@fieldses.org, neilb@suse.de, linux-ext4@vger.kernel.org,
       adilger@sun.com, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 01/10] ext4: Use rcu_barrier() on module unload.
Message-ID: <20090706023113.GE6706@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jesper Dangaard Brouer <hawk@comx.dk>,
	"David S. Miller" <davem@davemloft.net>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	dougthompson@xmission.com, bluesmoke-devel@lists.sourceforge.net,
	axboe@kernel.dk, Patrick McHardy <kaber@trash.net>,
	christine.caulfield@googlemail.com, Trond.Myklebust@netapp.com,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	yoshfuji@linux-ipv6.org, shemminger@linux-foundation.org,
	linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de,
	linux-ext4@vger.kernel.org, adilger@sun.com,
	netfilter-devel@vger.kernel.org
References: <20090623150330.22490.87327.stgit@localhost> <20090623150358.22490.24818.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623150358.22490.24818.stgit@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 05:03:59PM +0200, Jesper Dangaard Brouer wrote:
> The ext4 module uses rcu_call() thus it should use rcu_barrier()on
> module unload.
> 
> The kmem cache ext4_pspace_cachep is sometimes free'ed using
> call_rcu() callbacks.  Thus, we must wait for completion of call_rcu()
> before doing kmem_cache_destroy().
> 
> I have difficult determining if no new call_rcu() callbacks can be envoked.
> Would the maintainer please verify this?

Yes, that's correct.  Thanks; I've included this in the ext4 patch
queue.

						- Ted
