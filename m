Return-Path: <linux-kernel-owner+w=401wt.eu-S1765844AbZDBWtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765844AbZDBWtr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 18:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363AbZDBWth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 18:49:37 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:60304 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759575AbZDBWtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 18:49:36 -0400
Date: Fri, 3 Apr 2009 07:44:56 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       niv@us.ibm.com, dvhltc@us.ibm.com, dhowells@redhat.com,
       kernel@wantstofly.org, matthew@wil.cx
Subject: Re: [PATCH] v3 RCU: the bloatwatch edition
Message-ID: <20090402224455.GA13777@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Ingo Molnar <mingo@elte.hu>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, niv@us.ibm.com, dvhltc@us.ibm.com,
	dhowells@redhat.com, kernel@wantstofly.org, matthew@wil.cx
References: <20090203183426.GA14409@linux.vnet.ibm.com> <20090329203118.GA14005@linux.vnet.ibm.com> <20090402223605.GB19007@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402223605.GB19007@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 12:36:05AM +0200, Ingo Molnar wrote:
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > This patch is a version of RCU designed for (!SMP && EMBEDDED) 
> > provided as a proof of concept of a small-footprint RCU 
> > implementation. In particular, the implementation of 
> > synchronize_rcu() is extremely lightweight and high performance.  
> > It passes rcutorture testing in each of the four relevant 
> > configurations (combinations of NO_HZ and PREEMPT) on x86.  This 
> > saves about 900 bytes compared to Classic RCU, and a couple 
> > kilobytes compared to Hierarchical RCU:
> 
> Andrew, what do you think?
> 
> A worry is yet another RCU variant - we already have 3.
> 
> A trick we could use would be to put it into Documentation/rcu/, 
> linked in via some clever Makefile magic and only usable if a 
> ultra-embedded developer does a build with something like 
> CONFIG_RCU_TINY=y. That way there's no real maintenance and testing 
> overhead.
> 
> It _does_ have documentation value beyond the ~900 bytes: it's the 
> simplest and smallest possible still-working UP RCU implementation 
> so it would be easy to teach RCU concepts via that, gradually.
> 
A similar argument could have been used for tiny-shmem when it was first
integrated. As this is hiding behind CONFIG_EMBEDDED, most users are not
going to run in to it, so the confusion of 1 more RCU variant is not
likely to be a problem for those that aren't actively seeking it out.

So, personally I think it is a good idea, and I have no reservations
about default enabling it for a number of more constrained SH platforms.
