Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbZCUUbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbZCUUbh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 16:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbZCUUb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 16:31:28 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:35897 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbZCUUb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 16:31:27 -0400
Date: Sat, 21 Mar 2009 21:33:26 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trace/ring_buffer: fix section mismatch warning
Message-ID: <20090321203326.GA11182@uranus.ravnborg.org>
References: <20090321124139.4ca216d9@osiris.boeblingen.de.ibm.com> <20090321143911.GA25729@elte.hu> <20090321160102.7b5a9675@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090321160102.7b5a9675@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 21, 2009 at 04:01:02PM +0100, Heiko Carstens wrote:
> On Sat, 21 Mar 2009 15:39:11 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> > > Section mismatch in reference from the function 
> > > ring_buffer_alloc() to the function .cpuinit.text:rb_cpu_notify() 
> > > The function ring_buffer_alloc() references the function __cpuinit 
> > > rb_cpu_notify(). This is often because ring_buffer_alloc lacks a 
> > > __cpuinit annotation or the annotation of rb_cpu_notify is wrong.
> > > 
> > > This is a false positive since rb_cpu_notify gets only referenced 
> > > if CONFIG_HOTPLUG_CPU=y. To get rid of the warning annotate 
> > > ring_buffer_alloc with __ref.
> > > 
> > > Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> > > ---
> > >  kernel/trace/ring_buffer.c |    2 +-
> > 
> > Frederic has beaten you to it narrowly:
> > 
> > 09c9e84: tracing/ring-buffer: don't annotate rb_cpu_notify with __cpuinit
> 
> Btw. that was the only section mismatch warning I got on linux-next
> with an allyesconfig on s390. We probably could enable the verbose
> section mismatch warnings at compile time?
> 
> Sam?

When I get a bit more time (and a properly working setup again)
I will enable the verbose version.
But until I can dedicate enough time to support it I am not the
one to make it more verbose.

That may be in the timeframe of 2.6.30 but I'm not sure.

	Sam
