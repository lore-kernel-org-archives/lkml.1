Return-Path: <linux-kernel-owner+w=401wt.eu-S1757083AbYLEC6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083AbYLEC6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 21:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbYLEC63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 21:58:29 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33787 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbYLEC63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 21:58:29 -0500
Date: Fri, 5 Dec 2008 04:09:38 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, Alasdair G Kergon <agk@redhat.com>,
       Andi Kleen <andi-suse@firstfloor.org>, Milan Broz <mbroz@redhat.com>
Subject: Re: Device loses barrier support (was: Fixed patch for simple barriers.)
Message-ID: <20081205030938.GA6703@one.firstfloor.org>
References: <20081204145810.GR6703@one.firstfloor.org> <Pine.LNX.4.64.0812041139200.2434@hs20-bc2-1.build.redhat.com> <20081204174838.GS6703@one.firstfloor.org> <Pine.LNX.4.64.0812041401210.23079@hs20-bc2-1.build.redhat.com> <20081204221551.GV6703@one.firstfloor.org> <Pine.LNX.4.64.0812041756550.29638@hs20-bc2-1.build.redhat.com> <20081205004849.GX6703@one.firstfloor.org> <Pine.LNX.4.64.0812041948400.14114@hs20-bc2-1.build.redhat.com> <20081205013739.GZ6703@one.firstfloor.org> <Pine.LNX.4.64.0812042036540.25436@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812042036540.25436@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The only one offender is "md". 

I'm not sure. It wouldn't surprise me if it can happen with other setups
too. Perhaps Chris knows more.

> It is less overhead to change "md" to play 
> nice and be reliable than to double-submit requests in all the places that 
> needs write ordering.

They do that already anyways.

> 
> > > * the filesystems developed hacks to work around this issue, the hacks 
> > > involve not submitting more requests after the barrier request, 
> > 
> > I suspect the reason the file systems did it this way is that
> > it was a much simpler change than to rewrite the transaction
> > manager for this.
> 
> It could be initial reason. But this unreliability also disallows any 
> improvement in filesystems. No one can write asynchronous transaction 
> manager because of that evil EOPNOTSUPP.

Doesn't seem right. It would be a simple state machine
to handle it fully asynchronous. Alternatively you could
always use empty barriers.

But we can worry about that when some in tree file system
actually tries to do that.

-Andi

-- 
ak@linux.intel.com
