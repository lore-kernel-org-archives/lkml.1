Return-Path: <linux-kernel-owner+w=401wt.eu-S1754264AbYIYOT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbYIYOT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 10:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbYIYOTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 10:19:49 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:58848 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208AbYIYOTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 10:19:48 -0400
Date: Thu, 25 Sep 2008 07:18:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org,
       akpm@linux-foundation.org, manfred@colorfullife.com,
       dipankar@in.ibm.com, josht@linux.vnet.ibm.com, schamp@sgi.com,
       niv@us.ibm.com, dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, penberg@cs.helsinki.fi,
       andi@firstfloor.org, tglx@linutronix.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH, RFC] v6 scalable classic RCU implementation
Message-ID: <20080925141809.GB6725@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080825000738.GA24339@linux.vnet.ibm.com> <20080830004935.GA28548@linux.vnet.ibm.com> <20080905152930.GA8124@linux.vnet.ibm.com> <20080915160221.GA9660@linux.vnet.ibm.com> <20080923235340.GA12166@linux.vnet.ibm.com> <20080925072915.GB20249@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080925072915.GB20249@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 09:29:15AM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Attached is an updated patch to Classic RCU that applies a hierarchy, 
> > greatly reducing the contention on the top-level lock for large 
> > machines.  This passes 10-hour concurrent rcutorture and 
> > online-offline testing on 128-CPU ppc64 without dynticks enabled, and 
> > exposes some timekeeping bugs in presence of dynticks (exciting 
> > working on a system where "sleep 1" hangs until interrupted...).
> 
> i'm wondering about those timekeeping bugs. Do you have an idea what's 
> it about and does it affect mainline?

Sad to say, they do affect mainline -- I can reproduce these problems
in 2.6.27-rc7.  Thomas has given me a couple of fixes that got rid of
earlier problems in which jiffies would stop counting, and I believe
has located the cause of at least one other problem.

							Thanx, Paul
