Return-Path: <linux-kernel-owner+w=401wt.eu-S1759892AbZBLR3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892AbZBLR3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 12:29:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757211AbZBLR32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 12:29:28 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55750 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbZBLR32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 12:29:28 -0500
Subject: Re: [patch] rt: res_counter fix, v2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: balbir@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@tglx.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
In-Reply-To: <20090212165833.GB6298@balbir.in.ibm.com>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <20090212005032.GA4788@nowhere> <20090212021257.GB4697@nowhere>
	 <20090212101650.GA1096@elte.hu> <20090212102113.GA10031@elte.hu>
	 <20090212194644.98d275cf.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090212112854.GD31613@elte.hu>  <20090212165833.GB6298@balbir.in.ibm.com>
Content-Type: text/plain
Date: Thu, 12 Feb 2009 18:29:09 +0100
Message-Id: <1234459749.10603.35.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-12 at 22:28 +0530, Balbir Singh wrote:

> > _nort() will just turn them into NOPs in essence.
> > 
> > The question is, are these local IRQ flags manipulations really needed
> > in this code, and if yes, why?
> 
> We needed the local IRQ flags, since these counters are updated from
> page fault context and from reclaim context with lru_lock held with
> IRQ's disabled. I've been thinking about replacing the spin lock with
> seq lock, but have not gotten to it yet.

Ah, in that case we can get away with _nort I think, as both those
contexts are preemptable on -rt.

