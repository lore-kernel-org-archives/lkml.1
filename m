Return-Path: <linux-kernel-owner+w=401wt.eu-S1756489AbZFHOAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489AbZFHOAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 10:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbZFHOAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 10:00:30 -0400
Received: from stinky.trash.net ([213.144.137.162]:36356 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbZFHOA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 10:00:28 -0400
Message-ID: <4A2D197D.4060804@trash.net>
Date: Mon, 08 Jun 2009 16:00:29 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Jesper Dangaard Brouer <hawk@comx.dk>
CC: "David S. Miller" <davem@davemloft.net>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, urs.thuermann@volkswagen.de,
       oliver.hartkopp@volkswagen.de, wg@grandegger.com,
       vladislav.yasevich@hp.com, sri@us.ibm.com, linux-sctp@vger.kernel.org,
       Trond.Myklebust@netapp.com, linux-nfs@vger.kernel.org,
       netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 0/5] We must use rcu_barrier() on module unload
References: <20090608130959.10052.54590.stgit@localhost>
In-Reply-To: <20090608130959.10052.54590.stgit@localhost>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Dangaard Brouer wrote:
> If an unloadable module uses RCU callbacks, it need to use
> rcu_barrier() so that the module may be safely unloaded.
> 
> While hacking on a netfilter module of my own, I learned the
> importance of calling rcu_barrier() instead of only a
> synchronize_rcu() on module unload (iif using any call_rcu()
> callbacks).  synchronize_rcu() does wait for a grace period to
> elapse, but it does not wait for the callbacks to complete.
> 
> ...
> I have made a patch for each individual module, so objections can be
> made on a per module basis.  I have Cc'ed all of the patches to the
> maintainers of each module (according to the MAINTAINERS file).

Acked-by: Patrick McHardy <kaber@trash.net> for patches 1 and 2, good
catch.
