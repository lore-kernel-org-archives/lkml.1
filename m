Return-Path: <linux-kernel-owner+w=401wt.eu-S1758854AbXIUNvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854AbXIUNvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 09:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbXIUNvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 09:51:09 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:59217 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbXIUNvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 09:51:08 -0400
Date: Fri, 21 Sep 2007 09:45:53 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 1/4] Linux Kernel Markers - Architecture Independent Code
Message-ID: <20070921134553.GF13129@Krystal>
References: <20070918211324.161373216@polymtl.ca> <20070918211459.193904061@polymtl.ca> <20070921005837.GA4951@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070921005837.GA4951@goodmis.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:45:48 up 53 days, 14:04,  4 users,  load average: 0.48, 0.69, 0.71
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Tue, Sep 18, 2007 at 05:13:25PM -0400, Mathieu Desnoyers wrote:
> > +/*
> > + * Sets the probe callback corresponding to one marker.
> > + */
> > +static int set_marker(struct marker_entry **entry,
> > +			struct __mark_marker *elem)
> > +{
> > +	int ret;
> > +	BUG_ON(strcmp((*entry)->name, elem->name) != 0);
> 
> Can you switch this at least to WARN_ON?  Killing a system with X
> running where the user just sees a freeze is not that nice. But a nasty
> message in dmesg is very noticable.
> 
Sure.

> -- Steve
> 
> > +
> > +	if ((*entry)->format) {
> > +		if (strcmp((*entry)->format, elem->format) != 0) {
> > +			printk(KERN_NOTICE
> > +				"Format mismatch for probe %s "
> > +				"(%s), marker (%s)\n",
> > +				(*entry)->name,
> > +				(*entry)->format,
> > +				elem->format);
> > +			return -EPERM;
> > +		}
> > +	} else {
> > +		ret = marker_set_format(entry, elem->format);
> > +		if (ret)
> > +			return ret;
> > +	}
> > +	elem->call = (*entry)->probe;
> > +	elem->pdata = (*entry)->pdata;
> > +	_immediate_set(elem->state, 1);
> > +	return 0;
> > +}

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
