Return-Path: <linux-kernel-owner+w=401wt.eu-S1758000AbYDRGq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000AbYDRGq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 02:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbYDRGqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 02:46:50 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:54376 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752023AbYDRGqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 02:46:49 -0400
Subject: Re: [RFC PATCH 1/2] Marker probes in futex.c
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: prasad@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, mathieu.desnoyers@polymtl.ca
In-Reply-To: <y0m1w54cf82.fsf@ton.toronto.redhat.com>
References: <20080415115058.GA6788@in.ibm.com>
	 <20080415115314.GA6975@in.ibm.com> <1208260942.6395.6.camel@twins>
	 <20080415155223.GA6935@in.ibm.com> <1208361092.6395.81.camel@twins>
	 <y0m1w54cf82.fsf@ton.toronto.redhat.com>
Content-Type: text/plain
Date: Fri, 18 Apr 2008 08:46:44 +0200
Message-Id: <1208501204.7115.60.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-17 at 18:02 -0400, Frank Ch. Eigler wrote:
> Peter Zijlstra <a.p.zijlstra@chello.nl> writes:
> 
> > [...]
> >> If we were to log just the futex_ops, just as you had suggested,
> >> "Just log:
> >>  
> >>   futex: <uaddr> wait
> >>   futex: <uaddr> wakeup"
> >> [...]
> >> If you can specifically point me to information you think would be
> >> absolutely unnecessary, I can get them out of the trace_mark().
> >
> > I'm thinking everything is superflous; you're basically logging what
> > strace already gives you
> 
> But we don't want to run strace just for this stuff.  As you probably
> know, strace involves invasive user-space context-switching between
> the target and the tracer.
> 
> > except worse by encoding local variable names and exposing kernel
> > pointers.
> 
> The pointers are probably excessive, the and the names don't really
> matter.

Then what do we do when someone comes along and changes one of those
names; do we go around changing the markers and then requiring all tools
to change as well?

(And no this isn't far fetched; I'm thinking of changing fshared in the
near future).

Sounds like people will complain and generate back pressure against such
changes - something we should avoid. As soon as these markers place a
significant burden on code maintenance I'm against it.

>   What does matter is providing enough information for a
> problem diagnosis tool & person to reconstruct what the kernel must
> have been thinking when it did something noteworthy.

Sure, but then just make a strace like tracer and be done with it - no
need to pollute the futex code with that.

