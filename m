Return-Path: <linux-kernel-owner+w=401wt.eu-S932719AbYDPPvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719AbYDPPvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 11:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765159AbYDPPvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 11:51:39 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:35092 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764578AbYDPPvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 11:51:38 -0400
Subject: Re: [RFC PATCH 1/2] Marker probes in futex.c
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: prasad@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       mathieu.desnoyers@polymtl.ca
In-Reply-To: <20080415155223.GA6935@in.ibm.com>
References: <20080415115058.GA6788@in.ibm.com>
	 <20080415115314.GA6975@in.ibm.com> <1208260942.6395.6.camel@twins>
	 <20080415155223.GA6935@in.ibm.com>
Content-Type: text/plain
Date: Wed, 16 Apr 2008 17:51:32 +0200
Message-Id: <1208361092.6395.81.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-15 at 21:22 +0530, K. Prasad wrote:
> On Tue, Apr 15, 2008 at 02:02:22PM +0200, Peter Zijlstra wrote:
> > On Tue, 2008-04-15 at 17:23 +0530, K. Prasad wrote:
> > 
> > > +	trace_mark(futex_wait_called, "uaddr:%p fshared:%p val:%u "
> > > +			"abs_time:%p bitset:%d",
> > > +			uaddr, fshared, val, abs_time, bitset);
> > 
> > This is some seriuosly ugly looking gunk, why would we want stuff like
> > that scattered across the code?
> > 
> > What is wrong with a few simple hooks like:
> > 
> >   trace_futex_wait(uaddr, fshares, val, abs_time, bitset);
> > 
> > and then deal with that.
> > 
> > Also, you seem to expose way too much futex internals; do you really
> > need that? People will go use this marker crap like ABI and further
> > restrain us from changing the code.
> The idea is to export as much data as possible (considering that the
> cost involved in doing so is less) and use them only when required.
> 
> If we were to log just the futex_ops, just as you had suggested,
> "Just log:
>  
>   futex: <uaddr> wait
>   futex: <uaddr> wakeup"
> it would provide only cursory information about code-flow and not enough
> debug information to help the user solve the issue he's trying to debug.
> 
> Say for e.g. in futex_wait you may want to know if abs_time had a
> non-zero value but the primitive debugging information would end
> up being a handicap from discovering that.
> 
> If you can specifically point me to information you think would be
> absolutely unnecessary, I can get them out of the trace_mark().

I'm thinking everything is superflous; you're basically logging what
strace already gives you; except worse by encoding local variable names
and exposing kernel pointers.

Also get rid of that futex_markers.h thing - its utterly useless and
makes the code less readable.

