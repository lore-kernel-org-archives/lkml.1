Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbZHZVVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbZHZVVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 17:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbZHZVVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 17:21:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56011 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799AbZHZVVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 17:21:15 -0400
Date: Wed, 26 Aug 2009 17:21:15 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Li Zefan <lizf@cn.fujitsu.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/profile: Fix profile_disable vs module_unload
In-Reply-To: <20090826195345.GB5298@Krystal>
Message-ID: <alpine.DEB.2.00.0908261627390.11291@gandalf.stny.rr.com>
References: <4A94D3A8.1090902@cn.fujitsu.com> <1251269207.7538.1217.camel@twins> <1251270092.7538.1226.camel@twins> <4A94DFF4.5030301@cn.fujitsu.com> <alpine.DEB.2.00.0908261012020.23885@gandalf.stny.rr.com> <20090826164624.GA21456@Krystal>
 <alpine.DEB.2.00.0908261343010.11291@gandalf.stny.rr.com> <20090826180114.GA29130@Krystal> <20090826181758.GA30248@Krystal> <alpine.DEB.2.00.0908261544590.11291@gandalf.stny.rr.com> <20090826195345.GB5298@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 26 Aug 2009, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:

> > Anyway, this prevents your tracepoints from doing the odd things of 
> > loading a probe before it exists. Well you can, but then you prevent the 
> > unload of the module that registered it. Fine, I chucked out that patch.
> > 
> 
> you should try adding the required tracepoint_synchronize_unregister()
> call to ftrace_profile_disable_##call in ftrace.h. I expect this will
> fix your problem.

Just did, and it did not solve the bug.

> 
> Note that this is a bit slow to call it at each unregistration. Ideally,
> a module containing tracepoint probes should call this synchronization
> primitive only once at module unload.

The bug looks like it is registering a probe, but not unregistering it 
before leaving the module. But when the module is loaded again, it now has 
a bad function to call when the tracepoint is hit.

-- Steve
