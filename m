Return-Path: <linux-kernel-owner+w=401wt.eu-S1758954AbYEHGoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758954AbYEHGoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 02:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756509AbYEHGoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 02:44:07 -0400
Received: from viefep32-int.chello.at ([62.179.121.50]:46853 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973AbYEHGoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 02:44:04 -0400
Subject: Re: volanoMark regression with kernel 2.6.26-rc1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
In-Reply-To: <1210224012.3453.105.camel@ymzhang>
References: <1210039590.3453.18.camel@ymzhang>
	 <20080507091748.GB30645@elte.hu>
	 <1210181657.6525.7.camel@lappy.programming.kicks-ass.net>
	 <1210224012.3453.105.camel@ymzhang>
Content-Type: text/plain
Date: Thu, 08 May 2008 08:43:35 +0200
Message-Id: <1210229015.13978.170.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-08 at 13:20 +0800, Zhang, Yanmin wrote:
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
> With GROUP_SCHED=y.
> 
> I remember a similiar patch was merged into 2.6.25-rc1 and I found the similiar volanoMark
> regression, then you reverted it. Why to add it back to 2.6.26-rc1?

The only thing similar is that it tries to to SMP load balancing for
groups, other than that there is nothing similar - its a total rewrite
with a whole different approach.

And we _need_ an SMP load-balancer for groups - otherwise group
scheduling is just not complete.

