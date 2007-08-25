Return-Path: <linux-kernel-owner+w=401wt.eu-S1755316AbXHYUu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbXHYUu1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 16:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbXHYUuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 16:50:14 -0400
Received: from ozlabs.org ([203.10.76.45]:45435 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbXHYUuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 16:50:12 -0400
Subject: Re: [patch 1/4] Linux Kernel Markers - Architecture Independent
	Code
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070824162656.GC21226@Krystal>
References: <20070820202704.927923667@polymtl.ca>
	 <20070820202758.850703563@polymtl.ca>
	 <1187656987.19435.163.camel@localhost.localdomain>
	 <20070824162656.GC21226@Krystal>
Content-Type: text/plain
Date: Sun, 26 Aug 2007 06:49:30 +1000
Message-Id: <1188074970.20041.97.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-24 at 12:26 -0400, Mathieu Desnoyers wrote:
> * Rusty Russell (rusty@rustcorp.com.au) wrote:
> > On Mon, 2007-08-20 at 16:27 -0400, Mathieu Desnoyers wrote:
> > > +{
> > > +	struct hlist_head *head;
> > > +	struct hlist_node *node;
> > > +	struct marker_entry *e;
> > > +	size_t len = strlen(name) + 1;
> > > +	u32 hash = jhash(name, len-1, 0);
> > > +
> > > +	head = &marker_table[hash & ((1 << MARKER_HASH_BITS)-1)];
> > > +	hlist_for_each_entry(e, node, head, hlist) {
> > > +		if (!strcmp(name, e->name))
> > > +			return e;
> > > +	}
> > > +	return NULL;
> > > +}
> > 
> > OK, don't understand the strlen, len, len-1 dance here?
> > 
> 
> Let's say we have abc\0 for marker name as name input.
> 
> len = 3 + 1 = 4 (including \0)
> hash is done only on the 3 first chars, excluding the \0 (therefore the
>                                                           len-1 there)
> 
> Actually, it's like this only for a matter of consistency between
> add_marker and remove_marker, which are quite similar, but add_marker
> needs name_len to include the \0 value. It would be odd to change the
> logic between the two functions to one including the \0 and the other
> excluding it.

Sure, but that doesn't really explain why the code does:

	size_t len = strlen(name) + 1;
	u32 hash = jhash(name, len-1, 0);

Rather than:

	u32 hash = jhash(name, strlen(name), 0);

> Thanks for the review,

That's fine, just some light reading...

Cheers,
Rusty.
> 

