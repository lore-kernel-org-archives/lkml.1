Return-Path: <linux-kernel-owner+w=401wt.eu-S1758691AbYEHGIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691AbYEHGIx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 02:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754201AbYEHGIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 02:08:45 -0400
Received: from mga07.intel.com ([143.182.124.22]:4174 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753501AbYEHGIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 02:08:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,453,1204531200"; 
   d="scan'208";a="243693784"
Subject: Re: volanoMark regression with kernel 2.6.26-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
In-Reply-To: <1210186728.6525.12.camel@lappy.programming.kicks-ass.net>
References: <1210039590.3453.18.camel@ymzhang>
	 <20080507091748.GB30645@elte.hu>
	 <1210181657.6525.7.camel@lappy.programming.kicks-ass.net>
	 <1210186728.6525.12.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain
Date: Thu, 08 May 2008 14:07:30 +0800
Message-Id: <1210226850.3453.119.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-05-07 at 20:58 +0200, Peter Zijlstra wrote:
> On Wed, 2008-05-07 at 19:34 +0200, Peter Zijlstra wrote:
> > On Wed, 2008-05-07 at 11:17 +0200, Ingo Molnar wrote:
> > > * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> > > 
> > > > Comparing with 2.6.25, volanoMark has big regression with kernel 
> > > > 2.6.26-rc1. It's about 50% on my 8-core stoakley, 16-core tigerton, 
> > > > and Itanium Montecito.
> > > > 
> > > > With bisect, I located below patch.
> > > 
> > > thanks Yanmin, i've queued up your patch that reverts this change.
> > 
> > Is this really needed now that GROUP_SCHED defaults to 'n' ?
> > 
> > Yanmin, this is with GROUP_SCHED=y, right or is this without?
> 
> Its a long shot, but does the below help?
I tested it on 8-core stoakley. The result is equal to the one of pure 2.6.26-rc1.

> 
> ---
> Subject: sched: fixup SMP load-balance 
> 
> Keeping the aggregate on the first cpu of the sched domain has two problems:
>  - it could collide between different sched domains on different cpus
>  - it could slow things down because of the remote accesses
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/sched.h |    1 
>  kernel/sched.c        |  113 +++++++++++++++++++++++---------------------------
>  kernel/sched_fair.c   |   12 ++---
>  3 files changed, 60 insertions(+), 66 deletions(-)


