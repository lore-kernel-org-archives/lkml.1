Return-Path: <linux-kernel-owner+w=401wt.eu-S1751571AbXCHM0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbXCHM0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 07:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbXCHM0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 07:26:31 -0500
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:52248 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbXCHM0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 07:26:30 -0500
To: npiggin@suse.de
CC: a.p.zijlstra@chello.nl, miklos@szeredi.hu, akpm@linux-foundation.org,
       mingo@elte.hu, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org, jdike@addtoit.com, hugh@veritas.com,
       torvalds@linux-foundation.org
In-reply-to: <20070308121930.GB22781@wotan.suse.de> (message from Nick Piggin
	on Thu, 8 Mar 2007 13:19:30 +0100)
Subject: Re: [RFC][PATCH] mm: fix page_mkclean() vs non-linear vmas
References: <1173273562.6374.175.camel@twins> <20070307133649.GF18704@wotan.suse.de> <1173275532.6374.183.camel@twins> <1173278067.6374.188.camel@twins> <20070307150102.GH18704@wotan.suse.de> <1173286682.6374.191.camel@twins> <E1HPGg9-00039z-00@dorka.pomaz.szeredi.hu> <1173353824.9438.15.camel@twins> <E1HPH6v-0003CT-00@dorka.pomaz.szeredi.hu> <1173355903.9438.18.camel@twins> <20070308121930.GB22781@wotan.suse.de>
Message-Id: <E1HPHgf-0003HB-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 08 Mar 2007 13:25:37 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > And it doesn't sound too hard to solve: when current algorithm doesn't
> > > seem to be making progress, then it will have to be done the hard way,
> > > searching for for all nonlinear ptes of a page to unmap.
> > 
> > Ah, you see, but that is when you've already lost.
> > 
> > The DoS is about the computational complexity of the reclaim, not if it
> > will ever come out of it with free pages.
> 
> If we really want to, we could limit it to mlock for !root. This is
> a reasonable way to solve the problem, and UML could fall back on
> vma emulated version if they didn't want to use mlock memory...
> 
> Or we could limit the size/number of nonlinear vmas that could be
> created.
> 
> But just quietly, I think there are probably a lot of other ways to
> perform a local DoS anyway ;) 

I aggree, requiring apps to mlock would probably just make things
slightly worse for about 100% of users, without any gain.  There could
be a

  /proc/sys/vm/turn_off_nonlinear_for_paranoid_sysadmin

knob that would unconditionally emulate nonlinear vmas.

Miklos
