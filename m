Return-Path: <linux-kernel-owner+w=401wt.eu-S1752392Ab0ADNPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab0ADNPd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 08:15:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685Ab0ADNPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 08:15:31 -0500
Received: from mail.gmx.net ([213.165.64.20]:50538 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750738Ab0ADNPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 08:15:31 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18Yi+QbRIsY/zIDWEpFAI8W2IazUentL6G5hxgLZo
	PAbuMYqLetftcO
Subject: Re: volano ~30% regression with 2.6.33-rc1 & -rc2
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arjan van de Ven <arjan@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <1262610123.6408.120.camel@laptop>
References: <1262592958.22471.104.camel@minggr.sh.intel.com>
	 <20100104044024.5390ff1c@infradead.org>
	 <1262609854.9734.56.camel@marge.simson.net>
	 <1262610123.6408.120.camel@laptop>
Content-Type: text/plain
Date: Mon, 04 Jan 2010 14:15:27 +0100
Message-Id: <1262610927.9734.64.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-04 at 14:02 +0100, Peter Zijlstra wrote:
> On Mon, 2010-01-04 at 13:57 +0100, Mike Galbraith wrote:
> > On Mon, 2010-01-04 at 04:40 -0800, Arjan van de Ven wrote:
> > > On Mon, 04 Jan 2010 16:15:58 +0800
> > > Lin Ming <ming.m.lin@intel.com> wrote:
> > > 
> > > > Mike & Peter,
> > > > 
> > > > Compared with 2.6.32, volano has ~30% regression with 2.6.33-rc1 &
> > > > -rc2. Testing machine: Tigerton Xeon, 16cpus(4P/4Core), 16G memory
> > > 
> > > did this show up only on this cpu?
> > > (since this is a multi-core-without-shared-cache cpu, it could be that
> > > we get the topology wrong and think cores share cache where they don't)
> > 
> > My fault for using PREFER_SIBLING I guess.  However, I do wonder why in
> > the heck we set that at the CPU domain level.  Siblings lie northward.
> 
> Ah, PREFER_SIBLING means prefer sibling domain, not sibling thread. Its
> set at the CPU (really socket) level so make tasks spread over sockets
> first, so that there is no competition for the socket wide resources.

WRT the regression, would you prefer only the sched_fair.c hunk, and
maybe plunking the topology hunk in sched_devel, or both lines in one
patch, since ramp-up gain remains unrealized half of the time on Nehalem
and ilk.

> Your change is sane, but we really want a more extensive sched domain
> tree in the near future, reflecting the full machine topology.

Yeah.

	-Mike

