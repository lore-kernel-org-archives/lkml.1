Return-Path: <linux-kernel-owner+w=401wt.eu-S1753372Ab0ADNCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab0ADNCo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 08:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358Ab0ADNCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 08:02:43 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40317 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab0ADNCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 08:02:43 -0500
Subject: Re: volano ~30% regression with 2.6.33-rc1 & -rc2
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Arjan van de Ven <arjan@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <1262609854.9734.56.camel@marge.simson.net>
References: <1262592958.22471.104.camel@minggr.sh.intel.com>
	 <20100104044024.5390ff1c@infradead.org>
	 <1262609854.9734.56.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Jan 2010 14:02:03 +0100
Message-ID: <1262610123.6408.120.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-04 at 13:57 +0100, Mike Galbraith wrote:
> On Mon, 2010-01-04 at 04:40 -0800, Arjan van de Ven wrote:
> > On Mon, 04 Jan 2010 16:15:58 +0800
> > Lin Ming <ming.m.lin@intel.com> wrote:
> > 
> > > Mike & Peter,
> > > 
> > > Compared with 2.6.32, volano has ~30% regression with 2.6.33-rc1 &
> > > -rc2. Testing machine: Tigerton Xeon, 16cpus(4P/4Core), 16G memory
> > 
> > did this show up only on this cpu?
> > (since this is a multi-core-without-shared-cache cpu, it could be that
> > we get the topology wrong and think cores share cache where they don't)
> 
> My fault for using PREFER_SIBLING I guess.  However, I do wonder why in
> the heck we set that at the CPU domain level.  Siblings lie northward.

Ah, PREFER_SIBLING means prefer sibling domain, not sibling thread. Its
set at the CPU (really socket) level so make tasks spread over sockets
first, so that there is no competition for the socket wide resources.

Your change is sane, but we really want a more extensive sched domain
tree in the near future, reflecting the full machine topology.

