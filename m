Return-Path: <linux-kernel-owner+w=401wt.eu-S1752146AbZCSQA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbZCSQA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 12:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbZCSQAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 12:00:11 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:36244 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750804AbZCSQAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 12:00:09 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiIFAD8DwklMQW1W/2dsb2JhbACBT9ILg3wG
Date: Thu, 19 Mar 2009 12:00:03 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Steven Rostedt <rostedt@goodmis.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: oops in tracepoint_update_probe_range()
Message-ID: <20090319160003.GA25000@Krystal>
References: <1237393396.3322.6.camel@localhost.localdomain> <20090318163531.GE21331@elte.hu> <49C1F1DF.2020105@cn.fujitsu.com> <20090319074616.GA17144@elte.hu> <20090319132248.GA20200@Krystal> <alpine.DEB.2.00.0903190933440.16987@gandalf.stny.rr.com> <20090319155050.GB21034@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090319155050.GB21034@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:55:58 up 19 days, 12:22,  2 users,  load average: 0.42, 0.35,
	0.39
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Thu, 19 Mar 2009, Mathieu Desnoyers wrote:
> > > 
> > > Jaswinder : maybe you have old modules in your /lib/modules/`uname -r`
> > > directory which have the correct version, but the wrong module.h header ?
> > 
> > Isn't there a module versioning that prevents such things?
> 
> It can be overriden. In any case, the NULL check we have there now 
> makes sense.
> 
> 	Ingo

Well, it duplicates the check for begin == end. Actually, if begin !=
end _and_ being is NULL, this should be a WARN_ON or BUG_ON, because
the kernel would be trying to load a module with incompatible struct
module.

Are we supposed to assume that module.c allows loading modules with
incompatible struct module at all ? That sounds like we would be trying
to fix up things broken by the module loader in the first place.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
