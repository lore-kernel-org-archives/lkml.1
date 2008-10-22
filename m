Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175AbYJVNFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbYJVNFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 09:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbYJVNFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 09:05:45 -0400
Received: from mail.gmx.net ([213.165.64.20]:44385 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752043AbYJVNFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 09:05:44 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18A7Bl+PPMAOE5Pdqa0X9xyIndkt2B40TOFmvk+Sg
	cFepfHcVClZkS9
Subject: Re: [PATCH 0/4] pending scheduler updates
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081022124240.GD25536@elte.hu>
References: <20081017172701.047939625@chello.nl>
	 <20081020120538.GD10594@elte.hu>
	 <20081021173529.GG11679@linux.vnet.ibm.com>
	 <20081022094019.GG12453@elte.hu>
	 <1224669821.6871.16.camel@marge.simson.net>
	 <1224671528.7511.11.camel@marge.simson.net> <20081022121007.GG8095@elte.hu>
	 <1224679082.12294.15.camel@marge.simson.net>
	 <20081022124240.GD25536@elte.hu>
Content-Type: text/plain; charset=utf-8
Date: Wed, 22 Oct 2008 15:05:12 +0200
Message-Id: <1224680712.15904.21.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-22 at 14:42 +0200, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > > > With that patch, pgsql+oltp scales perfectly.
> > > 
> > > hm, tempting.
> > 
> > I disagree.  Postgres's scaling problem is trivially corrected by 
> > twiddling knobs (or whatnot). [...]
> 
> okay, then we need to document it a bit more: what knobs need twiddling 
> to make it scale perfectly?

Twiddle sched_wakeup_granularity_ns or just turn FAIR_SLEEPERS off for
best pgsql+oltp scalability.﻿  Pgsql+oltp collapse is delicate.  It
doesn't take much to send it one way or the other.  Cut preempt a wee
bit, and it can snap right into shape.

I think we need to penalize sleepers a wee bit as load climbs in general
though, everybody begins to like preemption less as load increases.
Mysql+oltp improves as well, and it loves preempt at modest load.

	-Mike

