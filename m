Return-Path: <linux-kernel-owner+w=401wt.eu-S1760331AbXIOBmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760331AbXIOBmQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 21:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753447AbXIOBmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 21:42:03 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:26700 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbXIOBmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 21:42:02 -0400
Date: Fri, 14 Sep 2007 18:40:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Wilder <dwilder@us.ibm.com>, linux-kernel@vger.kernel.org,
       SystemTAP <systemtap@sources.redhat.com>
Subject: Re: [PATCH 1/2] Trace code and documentation
Message-Id: <20070914184017.426e26b3.randy.dunlap@oracle.com>
In-Reply-To: <20070914180840.579627ab.akpm@linux-foundation.org>
References: <46E9CB14.7060000@us.ibm.com>
	<20070914180840.579627ab.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Sep 2007 18:08:40 -0700 Andrew Morton wrote:

> > Trace - Provides tracing primitives
> > 
> > ...
> >
> > +config TRACE
> > +	bool "Trace setup and control"
> > +	select RELAY
> > +	select DEBUG_FS
> > +	help
> > +	  This option provides support for the setup, teardown and control
> > +	  of tracing channels from kernel code.  It also provides trace
> > +	  information and control to userspace via a set of debugfs control
> > +	  files.  If unsure, say N.
> > +
> 
> select is evil - you really want to avoid using it.

I checked when I reviewed(?) this patch.  There are a few other
places that select also (IIRC, the blktrace code does), but most of
them use depends on.

> The problem is where you select a symbol whose dependencies aren't met. 
> Kconfig resolves this incompatibility by just not selecting the thing you
> wanted, iirc.  So your CONFIG_SYSFS=n, CONFIG_TRACE=y kernel won't build.
> 
> > +/*
> > + * Based on blktrace code, Copyright (C) 2006 Jens Axboe <axboe@suse.de>
> 
> So can we migrate blktrace to using this?

> > +static ssize_t sub_size_read(struct file *filp, char __user *buffer,
> > +			     size_t count, loff_t *ppos)
> > +{
> > +	struct trace_info *trace = filp->private_data;
> > +	char buf[32];
> > +
> > +	snprintf(buf, sizeof(buf), "%u\n",
> > +		 (unsigned int)trace->rchan->subbuf_size);
> 
> Use %tu to print a size_t, rather than the typecast.

Eh?
Use %zu to print a size_t.  Use %tu to print a ptrdiff_t.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
