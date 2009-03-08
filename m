Return-Path: <linux-kernel-owner+w=401wt.eu-S1751971AbZCHLA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbZCHLA4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 07:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbZCHLAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 07:00:47 -0400
Received: from mail-ew0-f177.google.com ([209.85.219.177]:56145 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbZCHLAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 07:00:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=G8NfWx9sK5AosMeNXkzr8HaZdomXtWnOwiawZMT6QOgRmLDvEZPSjh3Hu98DQTgQy8
         KC7XazVkLZJauHfdBye2z6UBc7Hild3R7Tsrub+iW2neUjga2v+cOvHinQYS1K4vKp0d
         KLBQi5JdDLFxbBzT7JG/95m4nGVyiBezH26bA=
Date: Sun, 8 Mar 2009 12:00:40 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       prasad@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [Patch 11/11] ftrace plugin for kernel symbol tracing using HW
	Breakpoint interfaces - v2
Message-ID: <20090308110038.GA5000@nowhere>
References: <20090307045120.039324630@linux.vnet.ibm.com> <20090307050747.GL23959@in.ibm.com> <20090307222955.25A7.A69D9226@jp.fujitsu.com> <20090308100929.GA14133@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090308100929.GA14133@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 08, 2009 at 11:09:29AM +0100, Ingo Molnar wrote:
> 
> * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > Hi
> > 
> > > This patch adds an ftrace plugin to detect and profile memory access over
> > > kernel variables. It uses HW Breakpoint interfaces to 'watch memory
> > > addresses.
> > > 
> > > Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com> 
> > > ---
> > >  kernel/trace/Kconfig          |    6 
> > >  kernel/trace/Makefile         |    1 
> > >  kernel/trace/trace.h          |   16 +
> > >  kernel/trace/trace_ksym.c     |  448 ++++++++++++++++++++++++++++++++++++++++++
> > >  kernel/trace/trace_selftest.c |   36 +++
> > >  5 files changed, 507 insertions(+)
> > 
> > Could you please update Documentation/ftrace.txt?
> > I guess many user interesting this patch. :)
> 
> Yeah, it has become a really nice feature this way. As i told it 
> to K.Prasad before: we need this tracer because the data tracer 
> will likely become the most common usecase of this facility. We 
> will get the hw breakpoints facility tested and used.
> 
> And in fact we can go one step further: it would also be nice to 
> wire it up with the ftrace histogram code: so that we can get 
> usage histograms of kernel symbol read/write activities without 
> the overhead of tracing. (The branch tracer already has this.)
> 
> Especially frequently used variables generate a _lot_ of events.
> 
> 	Ingo

Right, it will even be an occasion to improve and further test
the histogram tracing.
K. Prasad if you need some help on how to use it, don't hesitate to tell.

Frederic.

