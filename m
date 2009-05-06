Return-Path: <linux-kernel-owner+w=401wt.eu-S1758976AbZEFTCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976AbZEFTCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 15:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758627AbZEFTCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 15:02:19 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:41448 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759554AbZEFTCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 15:02:17 -0400
Date: Wed, 6 May 2009 12:02:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, dhowells@redhat.com,
       linux-kernel@vger.kernel.org, niv@us.ibm.com, dvhltc@us.ibm.com,
       lethal@linux-sh.org, kernel@wantstofly.org, matthew@wil.cx
Subject: Re: [PATCH] v4 RCU: the bloatwatch edition
Message-ID: <20090506190216.GE6771@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090502163423.GA1633@linux.vnet.ibm.com> <20090506112459.5edd0902.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506112459.5edd0902.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 11:24:59AM -0700, Andrew Morton wrote:
> On Wed, 6 May 2009 14:09:09 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * David Howells <dhowells@redhat.com> wrote:
> > 
> > > Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > > 
> > > > This patch is a version of RCU designed for (!SMP && EMBEDDED)
> > > > provided as a proof of concept of a small-footprint RCU implementation.
> > > > In particular, the implementation of synchronize_rcu() is extremely
> > > > lightweight and high performance.  It passes rcutorture testing in each
> > > > of the four relevant configurations (combinations of NO_HZ and PREEMPT)
> > > > on x86.  This saves about 900 bytes compared to Classic RCU, and a
> > > > couple kilobytes compared to Hierarchical RCU (updated to 2.6.29):
> > > > ...
> > > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > 
> > > Acked-by: David Howells <dhowells@redhat.com>
> > 
> > i'm wondering what Andrew thinks - he had objections, right?
> > 
> 
> More like "concerns".  It's unobvious to me that the modest .text
> savings justify the costs of an additional RCU implementation.  Where
> those costs include
> 
> - additional maintenance work and
> 
> - the reduced code reliability which comes from fragmenting the
>   tester base.  This will mostly affect users of the less popular RCU
>   implementations.
> 
> But hey, maybe I'm wrong.  And maybe I'm right, but we'll merge it anyway ;)

;-)

How about if acceptance of Tiny RCU happens at the same time as Classic
RCU is dropped?  That would be a large net decrease in code size and
complexity.

							Thanx, Paul
