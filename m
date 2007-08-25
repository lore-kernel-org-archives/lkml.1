Return-Path: <linux-kernel-owner+w=401wt.eu-S1759599AbXHYV0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759599AbXHYV0o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 17:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbXHYV0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 17:26:25 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:36612 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751915AbXHYV0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 17:26:16 -0400
Date: Sat, 25 Aug 2007 17:26:14 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] Linux Kernel Markers - Architecture Independent Code
Message-ID: <20070825212614.GA15461@Krystal>
References: <20070820202704.927923667@polymtl.ca> <20070820202758.850703563@polymtl.ca> <1187656987.19435.163.camel@localhost.localdomain> <20070824162656.GC21226@Krystal> <1188074970.20041.97.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1188074970.20041.97.camel@localhost.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:26:00 up 26 days, 21:44,  4 users,  load average: 0.02, 0.12, 0.14
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Rusty Russell (rusty@rustcorp.com.au) wrote:
> On Fri, 2007-08-24 at 12:26 -0400, Mathieu Desnoyers wrote:
> > * Rusty Russell (rusty@rustcorp.com.au) wrote:
> > > On Mon, 2007-08-20 at 16:27 -0400, Mathieu Desnoyers wrote:
> > > > +{
> > > > +	struct hlist_head *head;
> > > > +	struct hlist_node *node;
> > > > +	struct marker_entry *e;
> > > > +	size_t len = strlen(name) + 1;
> > > > +	u32 hash = jhash(name, len-1, 0);
> > > > +
> > > > +	head = &marker_table[hash & ((1 << MARKER_HASH_BITS)-1)];
> > > > +	hlist_for_each_entry(e, node, head, hlist) {
> > > > +		if (!strcmp(name, e->name))
> > > > +			return e;
> > > > +	}
> > > > +	return NULL;
> > > > +}
> > > 
> > > OK, don't understand the strlen, len, len-1 dance here?
> > > 
> > 
> > Let's say we have abc\0 for marker name as name input.
> > 
> > len = 3 + 1 = 4 (including \0)
> > hash is done only on the 3 first chars, excluding the \0 (therefore the
> >                                                           len-1 there)
> > 
> > Actually, it's like this only for a matter of consistency between
> > add_marker and remove_marker, which are quite similar, but add_marker
> > needs name_len to include the \0 value. It would be odd to change the
> > logic between the two functions to one including the \0 and the other
> > excluding it.
> 
> Sure, but that doesn't really explain why the code does:
> 
> 	size_t len = strlen(name) + 1;
> 	u32 hash = jhash(name, len-1, 0);
> 
> Rather than:
> 
> 	u32 hash = jhash(name, strlen(name), 0);
> 

Yup, good point. Fixed.

Thanks,

Mathieu

> > Thanks for the review,
> 
> That's fine, just some light reading...
> 
> Cheers,
> Rusty.
> > 
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
