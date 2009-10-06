Return-Path: <linux-kernel-owner+w=401wt.eu-S1757580AbZJFRl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580AbZJFRl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 13:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758050AbZJFRl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 13:41:56 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:48031 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757412AbZJFRlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 13:41:55 -0400
Date: Tue, 06 Oct 2009 13:40:44 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Dirk Hohndel <hohndel@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc3
In-reply-to: <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain>
Message-id: <alpine.LFD.2.00.0910061311460.7229@localhost.localdomain>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain>
 <alpine.LFD.2.00.0910052140100.309@localhost.localdomain>
 <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com>
 <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
 <20091006144449.GA23078@elte.hu>
 <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain>
 <20091006153632.GA29795@elte.hu>
 <alpine.LFD.2.01.0910060843560.3432@localhost.localdomain>
 <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both Ingo and Dirk clarified and amplified my original request,
that it be easy to trivially tell the difference between stuff
_based on_ on 2.6.X, and stuff _based on_ the following merge window.

I fully understand non-linear development, I undersatnd
and use CONFIG_LOCALVERSION_AUTO, but that isn't sufficient
to solve the problem I have in my use case.

In my use-case, I develop on my desktop with a backing git tree.

When I want to do builds, I throw a tar-ball over the wall
to a remote compute engine to chew on the tree for a few hours.

The compute engine runs a relatively time-consuming serialized
script to discover all of the interesting configs to build.
It then stores those configs in a unique place associated
with that release.  It doesn't have a backing git tree,
so it uses the info in the Makefile -- 2.6.X.

Then the compute engine builds each config, and stores the
output in the same place -- 2.6.X.  On a typical build error,
I fix, send a new tar file, and unless I've changed Kconfig,
I kick off the builds without re-generating all the config files.

Even if I could get it, I generally don't want an exact -g1234
to identify the release, because 90% of the time I want to re-use
the config files that I've already built for the snapshot
the tree is based on without the repeating the time-consuming config
re-generation step.

My big problem today is that is that the new 2.6.X results
overwrites my reference configs for the real 2.6.X.

This means that if I have a development tree that is based
on the real 2.6.X (I almost always do), as soon as I build
a merge window kernel, I've lost all the golden configs
that I may want to re-use for my branch that is based
on the real 2.6.X

This also means that I've overwritten all of the
reference build results.

Maybe this use-case is stupid and simple-minded, but I'm
sure there are more stupid and more simple-minded use cases
out there that would benefit from immediately knowing the
difference in the Makefile between something based on 2.6.X
and something based on the following merge window.

thanks for listening.

-Len




