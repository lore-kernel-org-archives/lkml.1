Return-Path: <linux-kernel-owner+w=401wt.eu-S1756909AbZBRXWC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909AbZBRXWC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 18:22:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbZBRXVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 18:21:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:43202 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbZBRXVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 18:21:52 -0500
Subject: Re: [PATCH] new irq tracer
From: Peter Zijlstra <peterz@infradead.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>, mingo@elte.hu, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
       fweisbec@gmail.com, compudj@krystal.dyndns.org
In-Reply-To: <20090218222316.GH24507@redhat.com>
References: <20090218195328.GA3112@redhat.com>
	 <1234991725.4799.1.camel@laptop> <20090218213545.GB3112@redhat.com>
	 <1234993580.4799.11.camel@laptop> <20090218220201.GG24507@redhat.com>
	 <1234995035.4799.14.camel@laptop>  <20090218222316.GH24507@redhat.com>
Content-Type: text/plain
Date: Thu, 19 Feb 2009 00:21:38 +0100
Message-Id: <1234999298.4799.42.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-18 at 17:23 -0500, Frank Ch. Eigler wrote:
> Hi -
> 
> On Wed, Feb 18, 2009 at 11:10:35PM +0100, Peter Zijlstra wrote:
> > > > I really am having a difficult time seeing the use in such narrow
> > > > tracers.
> > > 
> > > Part of the problem may come from defining "tracers" as something
> > > limited to ftrace engines.  Once such tracepoints are in the kernel,
> > > more powerful analytical tools may be attached to them.
> > 
> > ftrace graph tracer is by far the most powerful thing I've seen [...]
> 
> Be that as it may, what you suggested required separate correlation of
> data with /proc/interrupts contents.

That was to illustrate that the proposed tracer doesn't add much value.
Its almost 200 lines of code that needs maintenance to provide
information that's mostly already available, seems like the wrong
tradeoff to me.

> > What is limiting are these puny little tracers that have no real value.
> 
> Which limited resource would even puny tracers exhaust?

Usability and maintenance. But loss of the bigger picture is the main
complaint.

> > A much better purpose for these tracepoints would be augmenting data in
> > existing tracers like the graph/function/sched tracer.
> 
> Be more specific.  How would you augment those tracers with e.g.
> individual irq numbers, their disposition status (HANDLED etc.).

With a mixture of creativity and code ;-)

Perhaps by creating a way to provide argument and return values to the
function call data, and registering tracepoints to obtain these.

