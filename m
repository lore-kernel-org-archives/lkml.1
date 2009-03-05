Return-Path: <linux-kernel-owner+w=401wt.eu-S1754943AbZCEV54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbZCEV54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 16:57:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbZCEV5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 16:57:47 -0500
Received: from smtp-out.google.com ([216.239.45.13]:46183 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbZCEV5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 16:57:47 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=mNKEISPWyJmGtE6aSRZFdM8ZmJsi/g4szQbjeZ/eKOyuOODTeiwNxKzZ1910MjgZ4
	Lb4pQeHOsyIa0FM5Rr2Dw==
Date: Thu, 5 Mar 2009 13:57:18 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] lockdep: initialize lockdep debugging statistics
In-Reply-To: <20090305110522.GI32407@elte.hu>
Message-ID: <alpine.DEB.2.00.0903051355010.25505@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903050222160.30401@chino.kir.corp.google.com> <alpine.DEB.2.00.0903050223240.30401@chino.kir.corp.google.com> <1236250159.4228.186.camel@laptop> <20090305110522.GI32407@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Mar 2009, Ingo Molnar wrote:

> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Thu, 2009-03-05 at 02:29 -0800, David Rientjes wrote:
> > > The CONFIG_DEBUG_LOCKDEP statistics need to be initialized with
> > > ATOMIC_INIT(0) since they are of type atomic_t.
> > 
> > And how does ATOMIC_INIT(0) differ from the global/static 
> > storage being initialized to 0?
> > 
> > All I can see this doing it moving the variables from bss to 
> > data for some compilers.
> 

It's actually the opposite for gcc 4.1.1, the debugging symbols are now in 
bss.

> ok, i dropped it for now.
> 

It shouldn't be dropped, the initialization is necessary because we can't 
rely on atomic_t's implementation.
