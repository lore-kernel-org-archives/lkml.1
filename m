Return-Path: <linux-kernel-owner+w=401wt.eu-S1751598AbXA2PKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598AbXA2PKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 10:10:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbXA2PKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 10:10:04 -0500
Received: from ns1.suse.de ([195.135.220.2]:39194 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598AbXA2PKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 10:10:01 -0500
Date: Mon, 29 Jan 2007 16:12:18 +0100
From: Andrea Arcangeli <andrea@suse.de>
To: Andrea Gelmini <gelma@gelma.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: VM: Fix nasty and subtle race in shared mmap'ed page writeback
Message-ID: <20070129151218.GH8030@opteron.random>
References: <Pine.LNX.4.64.0701032031400.3661@woody.osdl.org> <20070103214121.997be3e6.akpm@osdl.org> <459C98BF.5080409@yahoo.com.au> <20070104131612.GC28470@gelma.net> <459DE3C6.20302@yahoo.com.au> <20070110135453.GH7947@gelma.net> <1168507298.26496.18.camel@twins> <20070112003955.GH4553@gelma.net> <1169457039.2639.17.camel@taijtu> <20070129140844.GE8271@gelma.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070129140844.GE8271@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 29, 2007 at 03:08:44PM +0100, Andrea Gelmini wrote:
> On Mon, Jan 22, 2007 at 10:10:39AM +0100, Peter Zijlstra wrote:
> > On Fri, 2007-01-12 at 01:39 +0100, Andrea Gelmini wrote:
> > > Hi,
> > > 	I can't do the test 'till next week.
> > > 
> > > Thanks a lot for your time,
> > > Gelma
> > 
> > Have you ever gotten around to testing this?
> 
> well, I spent some time doing more deeply test.
> DB corruption happens anyway, even with the kernel that seems to work
> (I say seems because it needs much more effort to get corruption).
> I'm trying to understand it.
> I will work more over it next week.

I'm a bit skeptical that bdb would really be the only thing able to
reproduce a longstanding MAP_SHARED corruption. bdb may be using mmap
a lot but there are tons of other apps using MAP_SHARED a lot too, so
while not impossible I rate it not very probable that a vm race is to
blame for bdb troubles.

bdb is quite a complex piece of code (I once almost fallen in the trap
of depending on it myself), and if you use threads you exercise even
more of its complexity (more than you probably should). So if you're
using threads, the first thing I'd be looking at would be locking bugs
in userland. Also make sure it's properly linked with NPTL at compile
time (compile it yourself if you have no other way to make sure), and
that the locking is working right. If really this is a kernel issue
with 2.6.18 and previous (just ignore the 2.6.19 release), perhaps we
should look at the futex instead of the dirty bits ;).

Not very helpful I know, but just sharing my feelings on the bdb
troubles mentioned here.
