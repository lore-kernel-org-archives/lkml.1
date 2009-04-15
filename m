Return-Path: <linux-kernel-owner+w=401wt.eu-S1754985AbZDOQ1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbZDOQ1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 12:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbZDOQ1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 12:27:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62094 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbZDOQ1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 12:27:35 -0400
Date: Wed, 15 Apr 2009 12:27:33 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>
Subject: Re: [PATCH 1/4] tracing/events: fix compile for modules disabled
In-Reply-To: <20090415160755.GE5989@nowhere>
Message-ID: <alpine.DEB.2.00.0904151227102.31828@gandalf.stny.rr.com>
References: <20090415031511.128139334@goodmis.org> <20090415031604.688830915@goodmis.org> <20090415160755.GE5989@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Wed, 15 Apr 2009, Frederic Weisbecker wrote:
> > +#else
> > +static int trace_module_notify(struct notifier_block *self,
> > +			       unsigned long val, void *data)
> 
> 
> 
> I don't remember when you register the module notifier but
> I guess it is on init time, then you can set this func as __init
> if !CONFIG_MODULES.
> 
> 
> > +{
> > +	return 0;
> > +}
> > +#endif /* CONFIG_MODULES */
> >  
> >  struct notifier_block trace_module_nb = {
> >  	.notifier_call = trace_module_notify,
> 
> 
> And then you can set this struct as __initdata_or_module, so
> that you can safely register this module notifier whatever
> config you have, and without consuming any space on the off case.

Good point. I'll update that.

-- Steve

