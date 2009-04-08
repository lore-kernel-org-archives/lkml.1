Return-Path: <linux-kernel-owner+w=401wt.eu-S935107AbZDHSom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935107AbZDHSom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 14:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934695AbZDHSoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 14:44:10 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:46758 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935155AbZDHSoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 14:44:09 -0400
Date: Wed, 8 Apr 2009 11:44:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Paul Mundt <lethal@linux-sh.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       niv@us.ibm.com, dvhltc@us.ibm.com, dhowells@redhat.com,
       kernel@wantstofly.org, matthew@wil.cx, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] v3 RCU: the bloatwatch edition
Message-ID: <20090408184404.GG6745@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090203183426.GA14409@linux.vnet.ibm.com> <20090329203118.GA14005@linux.vnet.ibm.com> <20090402223605.GB19007@elte.hu> <20090402224455.GA13777@linux-sh.org> <20090408163838.GB14449@elte.hu> <20090408165528.GA16317@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408165528.GA16317@linux-sh.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 09, 2009 at 01:55:29AM +0900, Paul Mundt wrote:
> On Wed, Apr 08, 2009 at 06:38:38PM +0200, Ingo Molnar wrote:
> > 
> > * Paul Mundt <lethal@linux-sh.org> wrote:
> > 
> > > On Fri, Apr 03, 2009 at 12:36:05AM +0200, Ingo Molnar wrote:
> > > > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > > > > This patch is a version of RCU designed for (!SMP && EMBEDDED) 
> > > > > provided as a proof of concept of a small-footprint RCU 
> > > > > implementation. In particular, the implementation of 
> > > > > synchronize_rcu() is extremely lightweight and high performance.  
> > > > > It passes rcutorture testing in each of the four relevant 
> > > > > configurations (combinations of NO_HZ and PREEMPT) on x86.  This 
> > > > > saves about 900 bytes compared to Classic RCU, and a couple 
> > > > > kilobytes compared to Hierarchical RCU:
> > > > 
> > > > Andrew, what do you think?
> > > > 
> > > > A worry is yet another RCU variant - we already have 3.
> > > > 
> > > > A trick we could use would be to put it into Documentation/rcu/, 
> > > > linked in via some clever Makefile magic and only usable if a 
> > > > ultra-embedded developer does a build with something like 
> > > > CONFIG_RCU_TINY=y. That way there's no real maintenance and testing 
> > > > overhead.
> > > > 
> > > > It _does_ have documentation value beyond the ~900 bytes: it's the 
> > > > simplest and smallest possible still-working UP RCU implementation 
> > > > so it would be easy to teach RCU concepts via that, gradually.
> > > 
> > > A similar argument could have been used for tiny-shmem when it was 
> > > first integrated. As this is hiding behind CONFIG_EMBEDDED, most 
> > > users are not going to run in to it, so the confusion of 1 more 
> > > RCU variant is not likely to be a problem for those that aren't 
> > > actively seeking it out.
> > > 
> > > So, personally I think it is a good idea, and I have no 
> > > reservations about default enabling it for a number of more 
> > > constrained SH platforms.
> > 
> > but at least tiny-shmem is now nicely hidden in mm/shmem.c, in an 
> > unintrusive !CONFIG_SHMEM branch. There's no CONFIG_TINY_SHMEM 
> > option anymore - it's all done in the !CONFIG_SHMEM case.
> > 
> Now it is, yes, but it was not originally, and it was still useful when
> it was split out. If we are going to tolerate multiple RCU
> implementations in the kernel, then I see no reason to not include
> tiny-RCU in the same category. Even in the case where some of the other
> RCU variants go away, tiny-RCU remains a viable option for simple
> platforms that are more concerned about memory than anything else, so
> it's always a valid alternative.
> 
> If in the future things are more consolidated and the config option goes
> away then great, but that hardly seems like a sane prerequisite for
> merging it. CONFIG_EMBEDDED handles this just fine. You don't need to
> enable it if you don't wish to, but it's certainly measurable enough to
> be useful for those of us that have no problems enabling it ;-)

>From a kernel-size viewpoint:

  788 kernel/rcuclassic.c
  190 include/linux/rcuclassic.h
  978 total

  288 kernel/rcutiny.c
   68 include/linux/rcutiny.h
  356 total

Almost a 3x decrease in lines of code.  So, Seems to me that dropping
rcuclassic (as rcutree proves itself) and taking up rcutiny instead is
a good step forward.  ;-)

							Thanx, Paul
