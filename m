Return-Path: <linux-kernel-owner+w=401wt.eu-S1754326AbZLAWls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbZLAWls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 17:41:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbZLAWls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 17:41:48 -0500
Received: from smtp-out.google.com ([216.239.33.17]:26842 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbZLAWlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 17:41:47 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=LXNgxmoQAuMjbX1S/tsjGHVDiRoGY+xH5OGj4bztbBOqEgD5pLk2y+OgZEMEw2yNu
	xfoJ0yBNFZgbt/SmANPtA==
Date: Tue, 1 Dec 2009 14:41:44 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Matt Mackall <mpm@selenic.com>
cc: Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>
Subject: Re: lockdep complaints in slab allocator
In-Reply-To: <1259626875.29740.193.camel@calx>
Message-ID: <alpine.DEB.2.00.0912011436420.27500@chino.kir.corp.google.com>
References: <84144f020911192249l6c7fa495t1a05294c8f5b6ac8@mail.gmail.com> <1258729748.4104.223.camel@laptop> <1259002800.5630.1.camel@penberg-laptop> <1259003425.17871.328.camel@calx> <4B0ADEF5.9040001@cs.helsinki.fi> <1259080406.4531.1645.camel@laptop>
 <20091124170032.GC6831@linux.vnet.ibm.com> <1259082756.17871.607.camel@calx> <1259086459.4531.1752.camel@laptop> <1259090615.17871.696.camel@calx> <84144f020911241307u14cd2cf0h614827137e42378e@mail.gmail.com> <1259103315.17871.895.camel@calx>
 <alpine.DEB.2.00.0911251356130.11347@chino.kir.corp.google.com> <alpine.DEB.2.00.0911271127130.20368@router.home> <alpine.DEB.2.00.0911301512250.12038@chino.kir.corp.google.com> <1259626875.29740.193.camel@calx>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009, Matt Mackall wrote:

> And it's not even something that -most- of embedded devices will want to
> use, so it can't be keyed off CONFIG_EMBEDDED anyway. If you've got even
> 16MB of memory, you probably want to use a SLAB-like allocator (ie not
> SLOB). But there are -millions- of devices being shipped that don't have
> that much memory, a situation that's likely to continue until you can
> fit a larger Linux system entirely in a <$1 microcontroller-sized device
> (probably 5 years off still).
> 

What qualifying criteria can we use to automatically select slob for a 
kernel or the disqualifying criteria to automatically select slub as a 
default, then?  It currently depends on CONFIG_EMBEDDED, but it still 
requires the user to specifically chose the allocator over another.  Could 
we base this decision on another config option enabled for systems with 
less than 16MB?

> This thread is annoying. The problem that triggered this thread is not
> in SLOB/SLUB/SLQB, nor even in our bog-standard 10yo deep-maintenance
> known-to-work SLAB code. The problem was a FALSE POSITIVE from lockdep
> on code that PREDATES lockdep itself. There is nothing in this thread to
> indicate that there is a serious problem maintaining multiple
> allocators. In fact, considerably more time has been spent (as usual)
> debating non-existent problems than fixing real ones.
> 

We could move the discussion on the long-term maintainable aspects of 
multiple slab allocators to a new thread if you'd like.
