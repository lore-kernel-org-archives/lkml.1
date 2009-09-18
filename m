Return-Path: <linux-kernel-owner+w=401wt.eu-S1752739AbZIRHHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbZIRHHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 03:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750950AbZIRHHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 03:07:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43216 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750836AbZIRHHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 03:07:32 -0400
Date: Fri, 18 Sep 2009 00:05:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>,
       "lee.schermerhorn@hp.com" <lee.schermerhorn@hp.com>, stable@kernel.org
Subject: Re: aim7 scalability issue on 4 socket machine
Message-Id: <20090918000542.268934e1.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0909180742500.14561@sister.anvils>
References: <1253179879.2606.37.camel@ymzhang>
	<1253180411.8497.1.camel@twins>
	<Pine.LNX.4.64.0909171122180.25864@sister.anvils>
	<1253239339.2606.40.camel@ymzhang>
	<20090917195909.3a00ef83.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0909180742500.14561@sister.anvils>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Sep 2009 07:53:58 +0100 (BST) Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:

> On Thu, 17 Sep 2009, Andrew Morton wrote:
> > On Fri, 18 Sep 2009 10:02:19 +0800 "Zhang, Yanmin" <yanmin_zhang@linux.intel.com> wrote:
> > > > 
> > > > So, Yanmin, please retest with http://lkml.org/lkml/2009/9/13/25
> > > > and let us know if that works as well for you - thanks.
> > > I tested Lee's patch and it does fix the issue.
> 
> Thanks for checking and reporting back, Yanmin.
> 
> > 
> > Do we think we should cook up something for -stable?
> 
> Gosh, I laughed at Lee (sorry!) for suggesting it for -stable:
> is stable really for getting a better number out of a benchmark?
> 
> I'd have thought the next release is the right place for that; but
> I've no problem if you guys and the stable guys agree it's appropriate.
> 
> > 
> > Either this is a regression or the workload is particularly obscure. 
> 
> I've not cross-checked descriptions, but assume Lee was actually
> testing on exactly the same kind of upcoming Nehalem as Yanmin, and
> that machine happens to have characteristics which show up badly here.
> 
> > 
> > aim7 is sufficiently non-obscure to make me wonder what's happened here?
> 
> Not a regression, just the onward march of new hardware, I think.
> Could easily be other such things in other places with other tests.
> 

Well, it comes down to the question "what is -stable for".

If you take it as "bugfixed version of the 2.6.x kernel" then no,
speedups aren't appropriate.

If you consider -stable to be "something distros, etc will use" then
yes, perhaps we serve those consumers better by including fairly major
efficiency improvements.

I suspect most consumers of -stable would prefer the latter approach,
as long as we don't go nuts.
