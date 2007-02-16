Return-Path: <linux-kernel-owner+w=401wt.eu-S1423095AbXBPD4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423095AbXBPD4I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 22:56:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161734AbXBPD4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 22:56:08 -0500
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:64623 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161731AbXBPD4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 22:56:07 -0500
Date: Thu, 15 Feb 2007 22:56:03 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@redhat.com>,
       systemtap@sources.redhat.com, ltt-dev@shafik.org
Subject: Re: [PATCH] Linux Kernel Markers Documentation
Message-ID: <20070216035603.GB16075@Krystal>
References: <1171224207118-git-send-email-mathieu.desnoyers@polymtl.ca> <20070214231201.20918c6b.akpm@linux-foundation.org> <20070216013348.GC12736@Krystal> <20070215174500.2b1b3bb9.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070215174500.2b1b3bb9.randy.dunlap@oracle.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 22:54:45 up 13 days, 18:02,  5 users,  load average: 1.04, 1.06, 1.06
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

* Randy Dunlap (randy.dunlap@oracle.com) wrote:
> so is the MARK() supposed to be:
>   MARK(subsystem, event, ...
> 
> Please make the 2 doc. lines above match the parameters...
> or the parameters match the text.
> 

Fixing the paragraph below.

> > +- "%d %s %p[struct task_struct]" is the formatted string for (printk-style).
> > +- someint is an integer.
> > +- somestring is a char pointer.
> > +- current is a pointer to a struct task_struct.
> > +
> > +The expression %p[struct task_struct] is a suggested marker definition
> > +standard that could eventually be used for pointer type checking in
> > +sparse. The brackets contain the type to which the pointer refer.
>                                                               refers.
> 
> > +
> > +#define SUBSYSTEM_EVENT_FORMAT "%d %s %p[struct task_struct]"
> 
> Is SUBSYSTEM_EVENT_FORMAT used implicitly below?  or elsewhere?
> 

Yes, error follows.

> > +void probe_subsystem_event(const char *format, ...)
> > +{
> > +	va_list ap;
> > +	/* Declare args */
> > +	unsigned int value;
> > +	const char *mystr;
> > +	struct task_struct *task;
> > +
> > +	/* Assign args */
> > +	va_start(ap, format);
> > +	value = va_arg(ap, typeof(value));
> > +	mystr = va_arg(ap, typeof(mystr));
> > +	task = va_arg(ap, typeof(task));
> > +
> > +	/* Call tracer */
> > +	trace_subsystem_event(value, mystr, task);
> > +
> > +	/* Or call printk */
> > +	vprintk(format, ap);
> > +
> > +	/* or count, check rights... */
> > +	
> > +	va_end(ap);
> > +}
> > +
> > +static int __init probe_init(void)
> > +{
> > +	int result;
> > +	result = marker_set_probe("subsystem_event",
> > +			FS_CLOSE_FORMAT,
> > +			probe_fs_close);
> 
> Do FS_CLOSE_FORMAT and probe_fs_close() need to be defined here?
> I.e., is this a complete example?
> 

should be SUBSYSTEM_EVENT_FORMAT. Will fix, thanks.

Regards,

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Candidate, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
