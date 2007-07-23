Return-Path: <linux-kernel-owner+w=401wt.eu-S1759895AbXGWMT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759895AbXGWMT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 08:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754429AbXGWMTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 08:19:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49162 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754539AbXGWMTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 08:19:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [linux-pm] Re: Hibernation considerations
Date: Mon, 23 Jul 2007 14:27:44 +0200
User-Agent: KMail/1.9.5
Cc: nigel@nigel.suspend2.net, stern@rowland.harvard.edu, nigel@suspend2.net,
       jbms@cmu.edu, miltonm@bga.com, ying.huang@intel.com,
       linux-kernel@vger.kernel.org, david@lang.hm,
       linux-pm@lists.linux-foundation.org
References: <Pine.LNX.4.44L0.0707221116060.15224-100000@netrider.rowland.org> <200707231408.32051.rjw@sisk.pl> <E1ICwoE-0004q8-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1ICwoE-0004q8-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707231427.45672.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 23 July 2007 14:14, Miklos Szeredi wrote:
> > On Monday, 23 July 2007 12:24, Miklos Szeredi wrote:
> > > > > The only thing to do is what Rafael has been working on: unfreeze
> > > > > things, hope the tasks sort themselves out, and try again.
> > > > 
> > > > That's what I'm questioning. Is there a more reliable way and we've
> > > > just given up too quickly?
> > > 
> > > There obviously _are_ more reliable ways.  A trivial one seems to be
> > > to just not require user tasks to finish syscalls.
> > > 
> > > Yeah, stopping user processes outside the kernel is convenient, but
> > > there's no fundamental reason why it is the only place where those
> > > tasks can be stopped.
> > 
> > The reason is that we want them to "park" in safe places, ie. where there
> > are no locks held etc.  Thus, these safe places need to be chosen somehow
> > and since they are not marked throughout the code, we choose the obvious
> > one. :-)
> 
> Why shouldn't locks be held?
> 
> No locks which are required for suspend must be held, sure.  But
> otherwise holding locks doesn't matter at all.
> 
> And I'm not saying that is trivial to do, but it might not be too hard
> either.
> 
> Rafael, can you please tell, what happened to that patch, that did not
> wait for tasks in uninterruptible sleep to be frozen?
> 
> That seemed like a magnificent approach compared to anything that has
> been proposed since.

Well, the freezer have failed to freeze tasks for a couple of times in my
test setup and I've had a couple of hangs.

I have an idea how to improve it, but that still requires some pending freezer
patches to go first.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
