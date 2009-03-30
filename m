Return-Path: <linux-kernel-owner+w=401wt.eu-S1758027AbZC3UXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027AbZC3UXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 16:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755870AbZC3UXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 16:23:42 -0400
Received: from smtp-out.google.com ([216.239.45.13]:33911 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbZC3UXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 16:23:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=GeCB+2X7h7h8tUxoT7cSSAZapN/tMbWFIUXs3ko5Bp0B25eSg8hlk43IS91kdYNRm
	2pq8KbQO47SPi+WuFSpIw==
Date: Mon, 30 Mar 2009 13:22:55 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Martin Bligh <mbligh@google.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] slub: scan partial list for free slabs when
 thrashing
In-Reply-To: <alpine.DEB.1.10.0903301033380.13333@qirst.com>
Message-ID: <alpine.DEB.2.00.0903301317120.21074@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903292241300.15813@chino.kir.corp.google.com> <alpine.DEB.2.00.0903292242510.15813@chino.kir.corp.google.com> <alpine.DEB.2.00.0903292243050.15813@chino.kir.corp.google.com> <alpine.DEB.1.10.0903301033380.13333@qirst.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Mar 2009, Christoph Lameter wrote:

> > Whenever a cpu cache satisfies a fastpath allocation, a fastpath counter
> > is incrememted.  This counter is cleared whenever the slowpath is
> > invoked.  This tracks how many fastpath allocations the cpu slab has
> > fulfilled before it must be refilled.
> 
> That adds fastpath overhead and it shows for small objects in your tests.
> 

Indeed, which is unavoidable in this case.  The only other way of tracking 
the "thrashing history" I can think of would be bitshifting a 1 for 
slowpath and 0 for fastpath, for example, into an unsigned long.  That, 
however, requires a hamming weight calculation in the slowpath and doesn't 
scale nearly as well as simply an incrementing a counter.

If there's other approaches on tracking such instances, I'd be interested 
to hear them.

Btw, is cl@linux.com your new email address or are all 
linux-foundation.org emails going to eventually migrate to the new domain?
