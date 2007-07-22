Return-Path: <linux-kernel-owner+w=401wt.eu-S932528AbXGVXBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528AbXGVXBr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 19:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762856AbXGVXBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 19:01:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46592 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762681AbXGVXBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 19:01:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Subject: Re: [linux-pm] Re: Hibernation considerations
Date: Mon, 23 Jul 2007 01:09:21 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>, nigel@suspend2.net,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Miklos Szeredi <miklos@szeredi.hu>, miltonm@bga.com,
       ying.huang@intel.com, linux-kernel@vger.kernel.org, david@lang.hm,
       linux-pm@lists.linux-foundation.org
References: <Pine.LNX.4.44L0.0707221116060.15224-100000@netrider.rowland.org> <200707230842.22121.nigel@nigel.suspend2.net>
In-Reply-To: <200707230842.22121.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707230109.23071.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday, 23 July 2007 00:42, Nigel Cunningham wrote:
> Hi Alan.
> 
> On Monday 23 July 2007 01:26:23 Alan Stern wrote:
> > On Sun, 22 Jul 2007, Nigel Cunningham wrote:
> > 
> > > Hi.
> > > 
> > > On Sunday 22 July 2007 02:13:56 Jeremy Maitin-Shepard wrote:
> > > > It seems that you could still potentially get a failure to freeze if one
> > > > FUSE process depends on another, and the one that is frozen second just
> > > > happens to be waiting on the one that is frozen first when it is frozen.
> > > > I admit that this situation is unlikely, and perhaps acceptable.
> > > > 
> > > > A larger concern is that it seems that freezing FUSE processes at all
> > > > _will_ generate deadlocks if a non-synchronous or memory-map-supporting
> > > > filesystem is loopback mounted from a FUSE filesystem.  In that case, if
> > > > you attempt to sync or free memory once FUSE is frozen, you are sure to
> > > > get a deadlock.
> > > 
> > > Ok. So then (in response to Alan too), how about keeping a tree of mounts, 
> > > akin to the device tree, and working from the deepest nodes up? (In 
> > > conjunction with what I already suggested)?
> > 
> > Face it, Nigel, this is a losing battle.  You can try to come up with
> > ever-more complex schemes to try and force FUSE into the freezer's
> > framework, but it just won't fit.  Or if it does, the next filesystem
> > to come along will require an even more baroque type of special-case 
> > handling.
> 
> It does seem to be a losing battle, but I'm wondering whether that's really 
> because it's an intractable problem, or because people have given up on it 
> before its time. We are talking about a computer system, so things should be 
> predictable.
>  
> > The general problem is that task A may be in an unfreezable state,
> > waiting for task B to do something, while task B is already frozen.  
> > Since there's no reasonable way to determine that A really is waiting
> > for B, you're just stuck.  (To make matters worse, A may not even
> > realize which task it is waiting for; it may know only that it's
> > waiting for somebody to do something!)  A and B could be user tasks, 
> > kernel threads, or one of each.
> 
> I guess I want to persist because all of these issues aren't utterly 
> unsolvable. It's just that we don't have the infrastructure yet to figure out 
> the solutions to these issues trivially. Take, for example, the locking 
> issue. If we could call some function to say "What process holds this lock?", 
> then task A could know that it's waiting on task B and put that information 
> somewhere. We could then use the information to freeze task B before task A.
> 
>  
> > The only thing to do is what Rafael has been working on: unfreeze
> > things, hope the tasks sort themselves out, and try again.
> 
> That's what I'm questioning. Is there a more reliable way and we've just given 
> up too quickly?

Well, there probably is one, but it likely would require us to make changes
that wouldn't be accepted by some people and thus would never be merged.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
