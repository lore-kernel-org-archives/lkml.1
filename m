Return-Path: <linux-kernel-owner+w=401wt.eu-S1758865AbXIRVyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865AbXIRVyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 17:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755693AbXIRVyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 17:54:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:39958 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919AbXIRVyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 17:54:08 -0400
From: Andi Kleen <ak@suse.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 3/3] Time to make CONFIG_PARAVIRT non-experimental.
Date: Tue, 18 Sep 2007 23:52:24 +0200
User-Agent: KMail/1.9.1
Cc: virtualization@lists.linux-foundation.org,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anthony Liguori <aliguori@us.ibm.com>,
       Chris Wright <chrisw@sous-sol.org>
References: <1189747054.7262.34.camel@localhost.localdomain> <200709181257.41530.ak@suse.de> <1190151272.7262.175.camel@localhost.localdomain>
In-Reply-To: <1190151272.7262.175.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709182352.25118.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 September 2007 23:34, Rusty Russell wrote:
> On Tue, 2007-09-18 at 12:57 +0200, Andi Kleen wrote:
> > On Friday 14 September 2007 07:21, Rusty Russell wrote:
> > > It's pretty widely used,
> >
> > Is it? By whom?
>
> Hi Andi,
>
> 	Please stop asking for facts!  It's was easy claim to make, and hard to
> disprove 8)
>
> > > and the distributions will turn it on.
> >
> > That's no reason to make it default y. Please undo that. default y
> > is near always a bad idea.
>
> How about a "select" based on Xen, lguest or VMI?  There's no other
> reason to enable it, after all.

I did an patch to do that recently because  the current setup
is indeed unobvious.

But I had to drop it again because 
it ended up with Kconfig warnings. about undefined symbols
on x86-64. The problem is that lguest
is visible in Kconfig for all architectures and it warns
if you select something that doesn't exist on all architectures.

The only workaround would have been to define PARAVIRT
for all architectures, which I considered too ugly.

I think Sam stated recently he wanted to remove that warning
but it needed some infrastructure work.

> > Also I would still consider it experimental.
>
> After 9 months in mainline and three kernel versions, 

Well it changed a lot each release.

> I'd hope not. 
> It's been pretty damn stable (ok, you broke it once, but maybe that's
> because you consider it experimental).

Is there a significant user base? 

At least the Xen port seems to have specific requirements
and essentially only work on xen-unstable (?) [or at least
some very new Xen version] which probably very few
people use.

-Andi

