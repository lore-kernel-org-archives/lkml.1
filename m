Return-Path: <linux-kernel-owner+w=401wt.eu-S1753761AbZILMTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbZILMTO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 08:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbZILMTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 08:19:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:45556 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750887AbZILMTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 08:19:13 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18WtSp4Ca4WnVq/SH3I0vxqwKgoQZ+cVIkA9bHuFl
	jcPfJowGJML6H5
Subject: Re: [tip:sched/core] sched: Keep kthreads at default priority
From: Mike Galbraith <efault@gmx.de>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, mingo@redhat.com,
       hpa@zytor.com, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <200909121348.38528.Martin@lichtvoll.de>
References: <1252486344.28645.18.camel@marge.simson.net>
	 <1252516001.22918.6.camel@laptop>
	 <1252517696.6220.9.camel@marge.simson.net>
	 (sfid-20090909_202324_097104_7D52F860)  <200909121348.38528.Martin@lichtvoll.de>
Content-Type: text/plain
Date: Sat, 12 Sep 2009 14:19:11 +0200
Message-Id: <1252757951.6084.5.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-12 at 13:48 +0200, Martin Steigerwald wrote:
> Am Mittwoch 09 September 2009 schrieb Mike Galbraith:
> > On Wed, 2009-09-09 at 19:06 +0200, Peter Zijlstra wrote:
> > > On Wed, 2009-09-09 at 09:55 -0700, Dmitry Torokhov wrote:
> > > > On Wed, Sep 09, 2009 at 03:37:34PM +0000, tip-bot for Mike Galbraith 
> wrote:
> > > > > diff --git a/kernel/kthread.c b/kernel/kthread.c
> > > > > index eb8751a..5fe7099 100644
> > > > > --- a/kernel/kthread.c
> > > > > +++ b/kernel/kthread.c
> > > > > @@ -16,8 +16,6 @@
> > > > >  #include <linux/mutex.h>
> > > > >  #include <trace/events/sched.h>
> > > > >
> > > > > -#define KTHREAD_NICE_LEVEL (-5)
> > > > > -
> > > >
> > > > Why don't we just redefine it to 0? We may find out later that we'd
> > > > still prefer to have kernel threads have boost.
> > >
> > > Seems sensible, also the traditional reasoning behind this nice level
> > > is that kernel threads do work on behalf of multiple tasks. Its a
> > > kind of prio ceiling thing.
> > 
> > True.  None of our current threads are heavy enough to matter much.
> 
> Does it make sense to have this as a tunable? Where does it matter? Server 
> workloads?

I don't think it should be a knob.  It only makes a difference to
kthreads that are heavy CPU users.  If one pops up as a performance
problem, IMHO, it should be tweaked separately.  Running at default
weight saves a bit of unnecessary math for the common case.

	-Mike

