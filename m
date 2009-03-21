Return-Path: <linux-kernel-owner+w=401wt.eu-S1760022AbZCUPXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760022AbZCUPXR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 11:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753822AbZCUPUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 11:20:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41659 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756278AbZCUPUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 11:20:34 -0400
Date: Sat, 21 Mar 2009 16:20:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trace/ring_buffer: fix section mismatch warning
Message-ID: <20090321152027.GA1073@elte.hu>
References: <20090321124139.4ca216d9@osiris.boeblingen.de.ibm.com> <20090321143911.GA25729@elte.hu> <20090321160102.7b5a9675@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090321160102.7b5a9675@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

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

There's still too many warnings in general on other platforms - but 
as long as it's per arch we could in fact propagate the warnings to 
build failures.

	Ingo
