Return-Path: <linux-kernel-owner+w=401wt.eu-S1752789AbZHXQNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbZHXQNx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 12:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbZHXQNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 12:13:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48940 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbZHXQNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 12:13:52 -0400
Date: Mon, 24 Aug 2009 12:13:47 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/profile: Fix profile_disable vs module_unload
In-Reply-To: <1251106058.7538.149.camel@twins>
Message-ID: <alpine.DEB.2.00.0908241213060.7587@gandalf.stny.rr.com>
References: <4A9214E3.2070807@cn.fujitsu.com>  <1251093660.7538.119.camel@twins> <4A923197.4040708@cn.fujitsu.com>  <1251097012.7538.123.camel@twins>  <20090824092455.GA25267@elte.hu> <1251106058.7538.149.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 24 Aug 2009, Peter Zijlstra wrote:
> > > > > 
> > > > > 
> > > > > Hrmm, feel fragile, why don't we check if all a modules tracepoints are
> > > > > unused on unload?
> > > > > 
> > > > 
> > > > I don't think it's fragile. We are profiling via a module's
> > > > tracepoint, so we should pin the module, via module_get().
> > > > If event->profile_enable() has been calld, we should make
> > > > sure it's profile_disable() will be called.
> > > 
> > > What I call fragile is that everyone registering a tracepoint 
> > > callback will now apparently need to worry about modules, _that_ 
> > > is fragile.
> > > 
> > > Either make module unload look at tracepoint users, or place the 
> > > try_get_module() in the registration hooks so that regular users 
> > > don't need to worry about it.
> > 
> > The bug found by Li needs to be fixed obviously.
> > 
> > I tend to agree with you that this does not appear to be the best 
> > place to do it: so you suggest to implicitly increase the module 
> > refcount on callback registr instead? (and releasing it when 
> > unregistering)
> > 
> > Same end result, slightly cleaner place to bump the refcount.
> 
> Yes, because the user of tracepoints should never need to care about
> modules.

I also agree with Peter on this.

-- Steve

