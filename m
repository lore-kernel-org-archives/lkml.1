Return-Path: <linux-kernel-owner+w=401wt.eu-S1760228AbZAGCxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760228AbZAGCxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 21:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757438AbZAGCxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 21:53:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46237 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758169AbZAGCxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 21:53:06 -0500
Date: Tue, 6 Jan 2009 21:53:03 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       roel.kluin@gmail.com, pq@iki.fi, srostedt@redhat.com
Subject: Re: [PATCH 3/3] tracing/ftrace: fix a memory leak in stat tracing
In-Reply-To: <20090106145157.124e910f.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0901062152290.25237@gandalf.stny.rr.com>
References: <20090106223337.677427397@goodmis.org> <20090106223405.703770821@goodmis.org> <20090106145157.124e910f.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Jan 2009, Andrew Morton wrote:

> On Tue, 06 Jan 2009 17:33:40 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> >  static int stat_seq_show(struct seq_file *s, void *v)
> >  {
> > -	struct trace_stat_list *l = list_entry(v, struct trace_stat_list, list);
> > -	return current_tracer.stat_show(s, l->stat);
> > +	struct trace_stat_list *entry =
> > +		list_entry(v, struct trace_stat_list, list);
> > +
> > +	return current_tracer.stat_show(s, entry->stat);
> >  }
> 
> Rather than jumping through weird 80-column hoops, one can just do:
> 
> 	struct trace_stat_list *entry;
> 
> 	...
> 
> 	entry = list_entry(v, struct trace_stat_list, list);

OK, this is Frederics work. I'll submit a separate clean up patch.

-- Steve

