Return-Path: <linux-kernel-owner+w=401wt.eu-S1758730AbXGWMPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730AbXGWMPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 08:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058AbXGWMPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 08:15:36 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:48968 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112AbXGWMPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 08:15:36 -0400
To: rjw@sisk.pl
CC: miklos@szeredi.hu, nigel@nigel.suspend2.net, stern@rowland.harvard.edu,
       nigel@suspend2.net, jbms@cmu.edu, miltonm@bga.com, ying.huang@intel.com,
       linux-kernel@vger.kernel.org, david@lang.hm,
       linux-pm@lists.linux-foundation.org
In-reply-to: <200707231408.32051.rjw@sisk.pl>
Subject: Re: [linux-pm] Re: Hibernation considerations
References: <Pine.LNX.4.44L0.0707221116060.15224-100000@netrider.rowland.org> <200707230842.22121.nigel@nigel.suspend2.net> <E1ICv5g-0003oN-00@dorka.pomaz.szeredi.hu> <200707231408.32051.rjw@sisk.pl>
Message-Id: <E1ICwoE-0004q8-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 23 Jul 2007 14:14:42 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Monday, 23 July 2007 12:24, Miklos Szeredi wrote:
> > > > The only thing to do is what Rafael has been working on: unfreeze
> > > > things, hope the tasks sort themselves out, and try again.
> > > 
> > > That's what I'm questioning. Is there a more reliable way and we've
> > > just given up too quickly?
> > 
> > There obviously _are_ more reliable ways.  A trivial one seems to be
> > to just not require user tasks to finish syscalls.
> > 
> > Yeah, stopping user processes outside the kernel is convenient, but
> > there's no fundamental reason why it is the only place where those
> > tasks can be stopped.
> 
> The reason is that we want them to "park" in safe places, ie. where there
> are no locks held etc.  Thus, these safe places need to be chosen somehow
> and since they are not marked throughout the code, we choose the obvious
> one. :-)

Why shouldn't locks be held?

No locks which are required for suspend must be held, sure.  But
otherwise holding locks doesn't matter at all.

And I'm not saying that is trivial to do, but it might not be too hard
either.

Rafael, can you please tell, what happened to that patch, that did not
wait for tasks in uninterruptible sleep to be frozen?

That seemed like a magnificent approach compared to anything that has
been proposed since.

Miklos
