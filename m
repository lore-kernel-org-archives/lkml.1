Return-Path: <linux-kernel-owner+w=401wt.eu-S1753280AbXGWWCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbXGWWCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 18:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750710AbXGWWCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 18:02:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51616 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739AbXGWWCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 18:02:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Subject: Re: [linux-pm] Re: Hibernation considerations
Date: Tue, 24 Jul 2007 00:10:34 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>, nigel@suspend2.net,
       Paul Mackerras <paulus@samba.org>, david@lang.hm,
       Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       miltonm@bga.com, ying.huang@intel.com,
       linux-pm@lists.linux-foundation.org,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
References: <Pine.LNX.4.44L0.0707231120380.3545-100000@iolanthe.rowland.org> <200707240755.01820.nigel@nigel.suspend2.net>
In-Reply-To: <200707240755.01820.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707240010.35639.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 23 July 2007 23:55, Nigel Cunningham wrote:
> Hi.
> 
> On Tuesday 24 July 2007 01:23:15 Alan Stern wrote:
> > On Mon, 23 Jul 2007, Nigel Cunningham wrote:
> > 
> > > Take a step back for a second.
> > > 
> > > The problem we're facing now is that we're getting some userspace threads, 
> > > used in processing I/O, that are functioning as exceptions to the "freeze 
> > > userspace, then freezeable kernel threads" rule. They are only exceptions 
> > > because of that role in processing I/O - because they're de facto kernel 
> > > threads. So, if we orient our thinking more in terms of I/O processing and 
> > > less in terms of the userspace/kernelspace distinction, we'll have a 
> > > solution:
> > > 
> > > 1) Freeze processes that aren't fs related (ie stop them generating I/O).
> > 
> > The problem here is that with things like FUSE, _every_ process is 
> > potentially fs related.  Nothing prevents a FUSE thread from doing IPC 
> > with any other thread.
> 
> Yes, but the fuse thread is going to know what other thread it's doing IPC 
> with, so it can get that thread flagged too.

Yes, but that thread may do IPC with yet another one and so on.

> > > 2) Flush pending I/O.
> > > 3) Freeze filesystems in reverse order of dependency, the primary purpose 
> > > being to stop them generating further I/O on their metadata.
> > > 
> > > Locks that are being held are only being held because work is being done. 
> If 
> > > we progressively focus on threads in terms of their create/process work 
> > > dependencies, we'll see that the problem isn't at all intractable.
> > 
> > As has been mentioned before, keeping track of all that dependency 
> > information would be very fragile and time-consuming.
> 
> I disagree. It's at least going to be less fragile and time-consuming then 
> maintaining new/extra code for kexec.

Well, I think the issue is real, so we need to find a solution (the simpler,
the better) and that need not be related to kexec. ;-)

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
