Return-Path: <linux-kernel-owner+w=401wt.eu-S1755131AbZG2AgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbZG2AgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 20:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754950AbZG2AgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 20:36:16 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:34495 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271AbZG2AgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 20:36:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AT0scAI5T3I7WZ7nF6xpAOTti1HDD7/KdbNxZhpjVeqNI1Sr6fo91fqJ5kXWKpP5Ni
         bHfp/xWjQRKuWDYVQbX4xZFIbwKMniB9pM7+e97/VxPwiurIGWxxlcCQ4hvr7aAgH9Iv
         hEbZLc9BcR8Hq+uBQOVWhe0BimslbksFvYFfE=
Date: Wed, 29 Jul 2009 02:36:09 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: prasad@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Anton Blanchard <anton@samba.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 5/5] perfcounter: Add support for kernel hardware
	breakpoints
Message-ID: <20090729003607.GC5104@nowhere>
References: <c62985530907240702h2b2de14bw2f0d475f46067e4e@mail.gmail.com> <1248445569.6987.74.camel@twins> <20090724174723.GA11985@nowhere> <1248519416.5780.12.camel@laptop> <20090725141918.GA5295@nowhere> <1248538972.5780.25.camel@laptop> <20090725235702.GA5082@in.ibm.com> <1248684817.6987.1573.camel@twins> <20090728010349.GB5147@nowhere> <1248765877.6987.2754.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248765877.6987.2754.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 09:24:37AM +0200, Peter Zijlstra wrote:
> On Tue, 2009-07-28 at 03:03 +0200, Frederic Weisbecker wrote:
> > > Thirdly, we can multiplex perf counters beyond their hardware maximum,
> > > something you simply cannot do for a debug interface.
> > 
> > 
> > Again, I'm stuck in what you mean by multiplexing here :-)
> 
> If you'd create say 16 breakpoint counters, we'd RR them over the 4
> available hardware breakpoints (or less when others are taken by someone
> else).
> 
> Since its all statistics anyway, we can simply scale the event counts up
> by the time-share they received.
>

Aah, ok I understand now.
But I fear it may kill the accuracy of the breakpoints statistics.
It's fine for a theoretical linear rate of breakpoint events.
But what happens if we are profiling something much more unstable
with a rain of hits in a small window of memory between large timeframes?
If we have a breakpoint inside this window of memory and this breakpoint
is not plugged, waiting for its turn in the RR, we loose this rain of events.

