Return-Path: <linux-kernel-owner+w=401wt.eu-S1751499AbZHSLHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbZHSLHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 07:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbZHSLHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 07:07:37 -0400
Received: from viefep17-int.chello.at ([62.179.121.37]:52574 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbZHSLHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 07:07:37 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 4/4][RFC] perf_counter: Allow sharing of output channels
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       stephane eranian <eranian@googlemail.com>
In-Reply-To: <20090819105818.GB21150@elte.hu>
References: <20090819091823.916851355@chello.nl>
	 <20090819092023.980284148@chello.nl>  <20090819105818.GB21150@elte.hu>
Content-Type: text/plain
Date: Wed, 19 Aug 2009 13:07:37 +0200
Message-Id: <1250680057.7583.341.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-19 at 12:58 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > Provide the ability to configure a counter to send its output to
> > another (already existing) counter's output stream.
> > 
> > [ compile tested only ]
> 
> very nice!
> 
> two comments:
> 
> > Index: linux-2.6/include/linux/perf_counter.h
> > ===================================================================
> > --- linux-2.6.orig/include/linux/perf_counter.h
> > +++ linux-2.6/include/linux/perf_counter.h
> > @@ -216,6 +216,7 @@ struct perf_counter_attr {
> >  #define PERF_COUNTER_IOC_REFRESH	_IO ('$', 2)
> >  #define PERF_COUNTER_IOC_RESET		_IO ('$', 3)
> >  #define PERF_COUNTER_IOC_PERIOD		_IOW('$', 4, u64)
> > +#define PERF_COUNTER_IOC_SET_OUTPUT	_IO ('$', 5)
> 
> Time to add a new sys_perf_counter_chattr() syscall and deprecate 
> the ioctls?

Could do I guess.. in order to support things like refresh and reset we
need a few new offset fields in the attr struct, but that's doable.

> > @@ -415,6 +416,9 @@ enum perf_callchain_context {
> >  	PERF_CONTEXT_MAX		= (__u64)-4095,
> >  };
> >  
> > +#define PERF_FLAG_FD_NO_GROUP	(1U << 0)
> > +#define PERF_FLAG_FD_OUTPUT	(1U << 1)
> 
> Why not extend the size of perf_counter_attr and add an output_fd 
> parameter? Zero would mean no fd (and this is also backwards 
> compatible behavior).
> 
> FD_NO_GROUP is a bit unclean API as it aliases group_fd to two 
> purposes: the real group_fd and this new output_fd. I think we 
> should move output_fd to the attribute structure.

Yeah, the NO_GROUP thing is ugly..

I'll wait for some more comments before reworking this.

