Return-Path: <linux-kernel-owner+w=401wt.eu-S1755474AbXKKH5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbXKKH5n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 02:57:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbXKKH5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 02:57:36 -0500
Received: from mail-xgw2.externet.hu ([212.40.96.184]:42004 "EHLO
	mail-xgw2.externet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbXKKH5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 02:57:35 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Nov 2007 02:57:34 EST
To: mikulas@artax.karlin.mff.cuni.cz
CC: a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, wfg@mail.ustc.edu.cn, miklos@szeredi.hu
In-reply-to: <Pine.LNX.4.64.0711110135450.18189@artax.karlin.mff.cuni.cz>
	(message from Mikulas Patocka on Sun, 11 Nov 2007 01:38:27 +0100
	(CET))
Subject: Re: Temporary lockup on loopback block device
References: <Pine.LNX.4.64.0711102025440.17691@artax.karlin.mff.cuni.cz> 
 <20071110145444.a6993df1.akpm@linux-foundation.org> <1194735752.5828.1.camel@lappy> <Pine.LNX.4.64.0711110135450.18189@artax.karlin.mff.cuni.cz>
Message-Id: <E1Ir7al-0004Tm-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sun, 11 Nov 2007 08:50:51 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Arguably we just have the wrong backing-device here, and what we should do
> > > is to propagate the real backing device's pointer through up into the
> > > filesystem.  There's machinery for this which things like DM stacks use.
> > > 
> > > I wonder if the post-2.6.23 changes happened to make this problem go away.
> > 
> > The per BDI dirty stuff in 24 should make this work, I just checked and
> > loopback thingies seem to have their own BDI, so all should be well.
> 
> This is not only about loopback (I think the lockup can happen even 
> without loopback) --- the main problem is:
> 
> Why are there over-limit dirty pages that no one is writing?

Please do a sysrq-t, and cat /proc/vmstat during the hang.  Those
will show us what exactly is happening.

I've seen this type of hang many times, and I agree with Peter, that
it's probably about loopback, and is fixed in 2.6.24-rc.

Thanks,
Miklos


