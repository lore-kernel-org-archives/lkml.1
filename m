Return-Path: <linux-kernel-owner+w=401wt.eu-S1760118AbXGQMMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760118AbXGQMMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 08:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758920AbXGQML7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 08:11:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47920 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758778AbXGQML5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 08:11:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Joseph Fannin <jfannin@gmail.com>
Subject: Re: Hibernating To Swap Considered Harmful
Date: Tue, 17 Jul 2007 13:52:58 +0200
User-Agent: KMail/1.9.5
Cc: david@lang.hm, Oliver Neukum <oliver@neukum.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
References: <200707121453.49616.rjw@sisk.pl> <Pine.LNX.4.64.0707162338370.19248@asgard.lang.hm> <20070717072601.GA21633@nineveh.local>
In-Reply-To: <20070717072601.GA21633@nineveh.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707171352.59642.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 17 July 2007 09:26, Joseph Fannin wrote:
> On Mon, Jul 16, 2007 at 11:42:08PM -0700, david@lang.hm wrote:
> > On Tue, 17 Jul 2007, Joseph Fannin wrote:
> 
> > >root is free to "dd if=/dev/random of=/dev/mem".  Root owned
> > >daemons which do bad things are bugs.
> >
> > in this case it would be more like
> >
> > dd if=/block0 of=/dev/sda1 count=1 bs=4096 skip=5000
> > dd if=/block1 of=/dev/sda1 count=1 bs=4096 skip=5050
> > dd if=/block2 of=/dev/sda1 count=1 bs=4096 skip=5400
> > etc
> >
> > to write the blocks to the raw parition in the right place
> 
> What I meant by that was that root is allowed to shoot himself in the
> foot.  Nothing stops root from opening a swap/hibernate file, which
> would put it in cache, and cause it to be inconsistant if a
> hibernation image was written to it behind the kernel's back.
> 
> That would be a very stupid thing to do, however.  There's no reason
> to open that file, unless you know *exactly* what you are doing, in
> which case the onus is on you to get it right.
> 
> But you have a point.  The swap file could be very fragmented.  It
> might often be so, even.
> 
> Still, is this better than exporting the kernel's swap internals
> (which has never been a public interface before)?
> 
> Does it make the interface that writing hibernation images to swap
> imposes any better?
> 
> Even if hibernation files are no less complicated to support than
> hibernating to swap files (which isn't a forgone conclusion) , there
> are plenty of reasons writing hibernation images to swap doesn't make
> sense.
> 
> 
> > >Again, supporting swap files (*which is not optional*) requires the
> > >very same support.
> >
> > in the kexec model why would the second kernel care about swap files at
> > all? (unles it chooses to write to them, in which case it is exactly the
> > same support, but unless it writes to them it doesn't need to care)
> 
> My point is that no extra work is required to write hibernation images
> to dedicated files than to write hibernation images to swap files.

This is not true, because for writing into swap files we can use some existing
code and for writing to "dedicated" files some new code needs to be written,
tested etc. (I think there is code like that in tuxonice, though).

> If swap files are to be supported, then, there's no technical reason
> not to support dedicated hibernation files.

Yes there is, we need some more code for that in the kernel.

> Dedicated hibernation files are better, and there's no reason not to
> implement them.

I won't argue that they are not better.  For many people hibernation to swap
files/partitions is sufficient, though.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
