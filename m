Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbZIUNkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbZIUNkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 09:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756141AbZIUNkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 09:40:52 -0400
Received: from sh.osrg.net ([192.16.179.4]:44694 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756082AbZIUNkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 09:40:47 -0400
Date: Mon, 21 Sep 2009 22:39:42 +0900
To: lmb@suse.de
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, neilb@suse.de,
       hch@infradead.org, James.Bottomley@suse.de, lars.ellenberg@linbit.com,
       linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com,
       akpm@linux-foundation.org, bart.vanassche@gmail.com, davej@redhat.com,
       gregkh@suse.de, kosaki.motohiro@jp.fujitsu.com, kyle@moffetthome.net,
       torvalds@linux-foundation.org, nab@linux-iscsi.org, knikanth@suse.de,
       philipp.reisner@linbit.com, sam@ravnborg.org
Subject: Re: [GIT PULL] DRBD for 2.6.32
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090919220232.GB31849@suse.de>
References: <20090918200803.GM23126@kernel.dk>
	<20090919141334N.fujita.tomonori@lab.ntt.co.jp>
	<20090919220232.GB31849@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090921223815U.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 21 Sep 2009 22:39:47 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Sep 2009 00:02:32 +0200
Lars Marowsky-Bree <lmb@suse.de> wrote:

> On 2009-09-19T14:14:30, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > I guess that Christoph is worry about adding another user interface
> > for kinda device management; once we merge this, we can't fix it (for
> > the raid unification).
> 
> Why can't it be fixed?
> 
> Either
> 
> a) there's going to be a transition period during which the "old"
> interface is supported but depreciated and scheduled to be removed (all
> driving the new unified same back-end),

We should avoid removing the existing interface. Once we merge drbd, I
don't think that it's a good idea to remove the drbd user interface.


> or b) there's going to be a new kernel which requires new user-space
> tools sharp.
> 
> In either case, dm/md are affected by this, so a third interface doesn't
> really make much difference. The refactoring needs to happen in the
> back-end anyway, and that actually becomes easier when all concurrent
> implementations are present and can be reworked at the same time.

I don't think so. It's much easier to implement something that
supports fewer user interfaces.


> > BTW, DM already has something like drbd? I thought that there is a
> > talk about that new target at LinuxCon.
> 
> dm-replicator is nowhere near as usable as DRBD, and not upstream yet

I don't think usability at this point is important. The design
matters. dm-replicator is built on the existing framework.

And my question is, if drbd and dm-replicator will provide similar
features, then why do we need both in mainline?


> either. (Further, it's another independent implementation, pursued
> instead of unifying any of the existing ones or helping to merge drbd -
> don't get me started on my thoughts of that.)

Again, dm-replicator is built on the existing framework instead of
adding another 'multiple (virtual) devices' framework into mainline.
