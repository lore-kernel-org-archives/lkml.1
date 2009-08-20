Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033AbZHTKYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbZHTKYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 06:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbZHTKY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 06:24:29 -0400
Received: from viefep13-int.chello.at ([62.179.121.33]:27674 "EHLO
	viefep13-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780AbZHTKY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 06:24:29 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 4/4][RFC] perf_counter: Allow sharing of output channels
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: eranian@gmail.com
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
In-Reply-To: <7c86c4470908200313l112a8ff6q836d618d7ce6fcc8@mail.gmail.com>
References: <20090819091823.916851355@chello.nl>
	 <20090819092023.980284148@chello.nl>
	 <19083.61914.571806.395197@cargo.ozlabs.ibm.com>
	 <1250686586.8282.12.camel@twins>
	 <7c86c4470908200313l112a8ff6q836d618d7ce6fcc8@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 20 Aug 2009 12:24:32 +0200
Message-Id: <1250763872.8282.165.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-20 at 12:13 +0200, stephane eranian wrote:
> On Wed, Aug 19, 2009 at 2:56 PM, Peter Zijlstra<a.p.zijlstra@chello.nl> wrote:
> > On Wed, 2009-08-19 at 22:36 +1000, Paul Mackerras wrote:
> >> Peter Zijlstra writes:
> >>
> >> > Provide the ability to configure a counter to send its output to
> >> > another (already existing) counter's output stream.
> >>
> >> What sort of thing might this be useful for?
> >
> > Some people complained that its tedious to mmap() for every counter and
> > would like to share the mmap() output buffer between counters.
> >
> 
> > This saves on address space and mlock budget and I guess fd management
> > logic.
> >
> Interesting to see, you seem to have changed your mind on this.

Lets say I haven't quite made up my mind yet, but people seem to want
it.

> I recall pointing this out in my early comments.

Yeah :-)

> But anyway, here are some more comments:
> 
>    - how does this work with the remapped counts?
>      Probably only see the count for the target, i.e., output,  event

Ah, right you are, we'd have to allow mmap() of the first page but no
data section.

>    - if samples from multiple events end up in the same buffer, how do
> I tell them apart,
>      i.e., how do I know sample X came from event A, sample X from event B?
>      This may be useful to detect patterns.

PERF_SAMPLE_ID?


