Return-Path: <linux-kernel-owner+w=401wt.eu-S967844AbXEHMOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967844AbXEHMOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 08:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967562AbXEHMOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 08:14:44 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:50671 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967651AbXEHMOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 08:14:43 -0400
Date: Tue, 8 May 2007 16:13:42 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Anton Vorontsov <cbou@mail.ru>
Cc: akpm@linux-foundation.org, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: + git-battery-fix.patch added to -mm tree
Message-ID: <20070508121341.GA21072@2ka.mipt.ru>
References: <200705081001.l48A1KUK020833@shell0.pdx.osdl.net> <20070508111924.GA16785@zarina>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070508111924.GA16785@zarina>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Tue, 08 May 2007 16:13:50 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 03:19:24PM +0400, Anton Vorontsov (cbou@mail.ru) wrote:
> On Tue, May 08, 2007 at 03:01:20AM -0700, akpm@linux-foundation.org wrote:
> > 
> > The patch titled
> >      git-battery-fix
> > has been added to the -mm tree.  Its filename is
> >      git-battery-fix.patch
> 
> Andrew, much thanks for fixing that. That error triggered by some
> refactors in drivers/base/... I suppose I have to setup -mm tree in
> addition to Linus', to test -mm builds from time to time for the
> purpose of catching these changes myself.
> 
> Though, this error happened indeed because nobody cares about
> find_bus function nowdays...
> 
> I want ask Greg KH and Evgeniy Polyakov: could you together settle
> preferred way of accessing bus types? Should we really use
> find_bus/bus_find, or Evgeniy would just export w1 bus type? In
> later case, I'll remove un-"if 0" find_bus patch, and will
> prepare another which will export w1 bus type.
> 
> I do not have any preference, both solutions will work.

There is one small problem with any of such approach, and this problem
is called Adrian Bunk :)
Eventually he will remove whatever changes you did if there are no
in-kernel users.
But since find bus users are now going into the tree, it is possible to
make a lot of people happy, who remove ifdef around find_bus() in own
embedded trees.

So, my vote is for exporting generic find_bus in mainline with related
to w1 and battery status changes.

-- 
	Evgeniy Polyakov
