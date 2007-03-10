Return-Path: <linux-kernel-owner+w=401wt.eu-S2993158AbXCJCaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993158AbXCJCaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 21:30:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993159AbXCJCaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 21:30:19 -0500
Received: from smtp.osdl.org ([65.172.181.24]:57535 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993158AbXCJCaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 21:30:18 -0500
Date: Fri, 9 Mar 2007 18:30:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <kees@outflux.net>
Cc: arjan@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: maps protection
Message-Id: <20070309183006.7ff23eff.akpm@linux-foundation.org>
In-Reply-To: <20070308205525.GJ6805@outflux.net>
References: <20070307012234.GN9621@outflux.net>
	<20070306175609.267bd7a9.akpm@linux-foundation.org>
	<20070307021335.GR9621@outflux.net>
	<20070306185942.585e7cd1.akpm@linux-foundation.org>
	<20070307031429.GU9621@outflux.net>
	<1173241331.3236.10.camel@laptopd505.fenrus.org>
	<20070308205525.GJ6805@outflux.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 8 Mar 2007 12:55:25 -0800 Kees Cook <kees@outflux.net> wrote:
> On Tue, Mar 06, 2007 at 08:22:11PM -0800, Arjan van de Ven wrote:
> > > [Adding Cc:lkml]
> > 
> > > How about using a reduced check, as is done for fd and environ?  This 
> > > would allow root-running system monitors to still do their job.  
> > > Effectively, this changes the test from "is ptracing" to just "can 
> > > ptrace".
> > > 
> > > If this still isn't considered safe, I'll add the maps_protect file...
> > 
> > btw I consider it an information leak that any user can see which
> > files/libraries any other user and root has mmap'd. (and with glibc's
> > stdio mmap feature that goes even beyond direct mmap to fopen()'d).
> > 
> > If root or some other user wants to watch
> > hillary-vs-obama-in-the-mud.avi, no other user has ANY business even
> > seeing that. So at minimum it's a privacy issue showing the filenames...
> 
> So, what's the state of this?  Is the reduced "allowed to ptrace" check 
> good enough for inclusion?  What is needed for some form of this patch 
> to be included?  I'm happy to try new approaches if I can get some 
> further input.

I just don't know what it will break - we're changing things so that user A
cannot monitor user B's memory maps.  I feel that it's sure to break
various people's fancy custom system activity monitoring/logging setups,
and the sort of users who will be affected are, alas, the sort of people
who won't run a kernel with this change in it for another couple of years
yet.

> Another suggestion was to make this an ELF header toggle, and I'm 
> generally against that idea.  If a toggle is needed, I'd rather it be a 
> system-wide one.

A global /proc knob probably isn't too bad.

Do we actually need to disable the whole interface?  If all you're
concerned about is the pathname then perhaps the knob could cause that
pathname to be replaced with "<hidden>".  That'll cause things to
break less seriously and still allows somewhat useful info to be gathered.

