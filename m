Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475Ab0ASPOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab0ASPOE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 10:14:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753037Ab0ASPOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 10:14:00 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:45814 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751873Ab0ASPOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 10:14:00 -0500
Date: Tue, 19 Jan 2010 10:13:59 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Oliver Neukum <oliver@neukum.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [RFC][PATCH] PM: Force GFP_NOIO during suspend/resume
 (was: Re: Memory allocations in .suspend became very unreliable)
In-Reply-To: <201001182159.25585.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1001191012160.1437-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jan 2010, Rafael J. Wysocki wrote:

> On Monday 18 January 2010, Alan Stern wrote:
> > On Mon, 18 Jan 2010, Oliver Neukum wrote:
> > 
> > > Am Montag, 18. Januar 2010 00:00:23 schrieb Rafael J. Wysocki:
> > > > On Sunday 17 January 2010, Benjamin Herrenschmidt wrote:
> > > > > On Sun, 2010-01-17 at 14:27 +0100, Rafael J. Wysocki wrote:
> > > > ...
> > > > > However, it's hard to deal with the case of allocations that have
> > > > > already started waiting for IOs. It might be possible to have some VM
> > > > > hook to make them wakeup, re-evaluate the situation and get out of that
> > > > > code path but in any case it would be tricky.
> > > > 
> > > > In the second version of the patch I used an rwsem that made us wait for these
> > > > allocations to complete before we changed gfp_allowed_mask.
> > > 
> > > This will be a very, very hot semaphore. What's the impact on performance?
> > 
> > Can it be replaced with something having lower overhead, such as SRCU?
> 
> I'm not sure about that.  In principle SRCU shouldn't be used if the reader can
> sleep unpredictably long and the memory allocation sutiation is one of these.

I don't think this matters.  Each SRCU usage has its own domain, and
different domains don't affect one another.  So the only thing that
would be blocked by a long-sleeping reader would be the suspend process
itself, and obviously you won't mind that.

Alan Stern

