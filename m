Return-Path: <linux-kernel-owner+w=401wt.eu-S1757629AbZCSQUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629AbZCSQUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 12:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbZCSQUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 12:20:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47572 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbZCSQUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 12:20:34 -0400
Date: Thu, 19 Mar 2009 12:20:30 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: oops in tracepoint_update_probe_range()
In-Reply-To: <20090319160003.GA25000@Krystal>
Message-ID: <alpine.DEB.2.00.0903191219260.16987@gandalf.stny.rr.com>
References: <1237393396.3322.6.camel@localhost.localdomain> <20090318163531.GE21331@elte.hu> <49C1F1DF.2020105@cn.fujitsu.com> <20090319074616.GA17144@elte.hu> <20090319132248.GA20200@Krystal> <alpine.DEB.2.00.0903190933440.16987@gandalf.stny.rr.com>
 <20090319155050.GB21034@elte.hu> <20090319160003.GA25000@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 19 Mar 2009, Mathieu Desnoyers wrote:

> * Ingo Molnar (mingo@elte.hu) wrote:
> > 
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > On Thu, 19 Mar 2009, Mathieu Desnoyers wrote:
> > > > 
> > > > Jaswinder : maybe you have old modules in your /lib/modules/`uname -r`
> > > > directory which have the correct version, but the wrong module.h header ?
> > > 
> > > Isn't there a module versioning that prevents such things?
> > 
> > It can be overriden. In any case, the NULL check we have there now 
> > makes sense.
> > 
> > 	Ingo
> 
> Well, it duplicates the check for begin == end. Actually, if begin !=
> end _and_ being is NULL, this should be a WARN_ON or BUG_ON, because
> the kernel would be trying to load a module with incompatible struct
> module.
> 
> Are we supposed to assume that module.c allows loading modules with
> incompatible struct module at all ? That sounds like we would be trying
> to fix up things broken by the module loader in the first place.

Then it should be WARN_ON, no need to lock up a box hard, and give the 
user in X with no serial, no idea why the box just locked up.

-- Steve

