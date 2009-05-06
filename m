Return-Path: <linux-kernel-owner+w=401wt.eu-S1755679AbZEFScL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679AbZEFScL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 14:32:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758959AbZEFSbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 14:31:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46969 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755690AbZEFSbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 14:31:37 -0400
Date: Wed, 6 May 2009 11:24:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: dhowells@redhat.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, niv@us.ibm.com, dvhltc@us.ibm.com,
       lethal@linux-sh.org, kernel@wantstofly.org, matthew@wil.cx
Subject: Re: [PATCH] v4 RCU: the bloatwatch edition
Message-Id: <20090506112459.5edd0902.akpm@linux-foundation.org>
In-Reply-To: <20090506120909.GR25203@elte.hu>
References: <20090502163423.GA1633@linux.vnet.ibm.com>
	<12234.1241558327@redhat.com>
	<20090506120909.GR25203@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 May 2009 14:09:09 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * David Howells <dhowells@redhat.com> wrote:
> 
> > Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > This patch is a version of RCU designed for (!SMP && EMBEDDED)
> > > provided as a proof of concept of a small-footprint RCU implementation.
> > > In particular, the implementation of synchronize_rcu() is extremely
> > > lightweight and high performance.  It passes rcutorture testing in each
> > > of the four relevant configurations (combinations of NO_HZ and PREEMPT)
> > > on x86.  This saves about 900 bytes compared to Classic RCU, and a
> > > couple kilobytes compared to Hierarchical RCU (updated to 2.6.29):
> > > ...
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > Acked-by: David Howells <dhowells@redhat.com>
> 
> i'm wondering what Andrew thinks - he had objections, right?
> 

More like "concerns".  It's unobvious to me that the modest .text
savings justify the costs of an additional RCU implementation.  Where
those costs include

- additional maintenance work and

- the reduced code reliability which comes from fragmenting the
  tester base.  This will mostly affect users of the less popular RCU
  implementations.


But hey, maybe I'm wrong.  And maybe I'm right, but we'll merge it anyway ;)
