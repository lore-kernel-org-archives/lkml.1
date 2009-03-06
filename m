Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbZCFKTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbZCFKTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 05:19:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbZCFKT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 05:19:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:57668 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbZCFKT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 05:19:26 -0500
Subject: Re: [patch 2/2] lockdep: initialize lockdep debugging statistics
From: Peter Zijlstra <peterz@infradead.org>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0903060149540.26215@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903050222160.30401@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0903050223240.30401@chino.kir.corp.google.com>
	 <1236250159.4228.186.camel@laptop> <20090305110522.GI32407@elte.hu>
	 <alpine.DEB.2.00.0903051355010.25505@chino.kir.corp.google.com>
	 <1236328083.5187.1213.camel@laptop>
	 <alpine.DEB.2.00.0903060149540.26215@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 11:19:16 +0100
Message-Id: <1236334756.6326.106.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 01:56 -0800, David Rientjes wrote:
> 
> Peter, this is purely a matter of good software engineering practices. 

For complex types I would agree, but atomic_t is assumed to be just
another int - just with special ops. For such things we can hold that
memset('0') will properly initialize them to their 0 value.

>  I 
> hadn't realized you were so passionate about avoiding initialization of 
> global atomic_t variables, 

Given that static/global storage is properly initialized to 0, and the
above, it seems to be redundant.

> I assume you wouldn't object to removing all such cases in the kernel.
> 
>         $ grep -r "atomic_t.*= ATOMIC_INIT(0)" * | wc -l
>         104

Only IFF all those cases are for static/global storage. Otherwise you
have to ensure 0-ness by either using __GFP_ZERO or explicit
initialization.

