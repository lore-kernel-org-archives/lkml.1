Return-Path: <linux-kernel-owner+w=401wt.eu-S1758424AbZBRVvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424AbZBRVvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 16:51:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760044AbZBRVqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 16:46:35 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51873 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760039AbZBRVqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 16:46:34 -0500
Subject: Re: [PATCH] new irq tracer
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Baron <jbaron@redhat.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       acme@ghostprotocols.net, fweisbec@gmail.com, fche@redhat.com,
       compudj@krystal.dyndns.org
In-Reply-To: <20090218213545.GB3112@redhat.com>
References: <20090218195328.GA3112@redhat.com>
	 <1234991725.4799.1.camel@laptop>  <20090218213545.GB3112@redhat.com>
Content-Type: text/plain
Date: Wed, 18 Feb 2009 22:46:20 +0100
Message-Id: <1234993580.4799.11.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-18 at 16:35 -0500, Jason Baron wrote:
> On Wed, Feb 18, 2009 at 10:15:25PM +0100, Peter Zijlstra wrote:
> > On Wed, 2009-02-18 at 14:53 -0500, Jason Baron wrote:
> > > hi,
> > > 
> > > Using a copule of tracepoints i've implemented an 'irq tracer' which has
> > > the following column format:
> > > 
> > > [time][irq][action][handled][cpu][length]
> > > 
> > > for example on my system:
> > > 
> > > [ 1038.927248381]     28     eth0      1        3     0.000002745
> > > [ 1038.927544688]     28     eth0      1        3     0.000002520
> > > [ 1038.927593609]     28     eth0      1        3     0.000002509
> > > [ 1038.974087675]     29     ahci      1        1     0.000013135
> > > [ 1038.974288475]     29     ahci      1        1     0.000005542
> > > [ 1038.974414324]     29     ahci      1        1     0.000007953
> > > 
> > > I think this patch is useful in understanding irq system behavior, and
> > > for tracking down irq driver handlers that are firing too often or
> > > spending too much time handling an irq. This approach could be extended
> > > to the timer irq and for softirqs...
> > 
> > The function graph tracer can already do this, it has a special section
> > to recognize irq entry function, and already measures time spend.
> > 
> > I guess with Steve's new triggers (probes or whatever they ended up
> > being called) you could limit it to just IRQ entry points.
> > 
> 
> i did look at the graph tracer first. While it does measure irq related
> functions, it does not give this level of detail concerning which irq #,
> which irq handler is involved, and whether or not the irq was handled
> successfully or not. So I believe this tracepoints add a level of detail
> that the graph tracer does not have. Furthermore, this patch requires 2
> tracepoints, not instrumentation for all kernel functions.

How useful is that return value?

Much of the other data is already available, /proc/interrupts will
happily tell you the source of your interrupt storm. The irq-off latency
tracer will tell you if stuff takes too much time, the graph tracer can
tell you what is taking how much time.

I really am having a difficult time seeing the use in such narrow
tracers.

