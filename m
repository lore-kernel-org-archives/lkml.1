Return-Path: <linux-kernel-owner+w=401wt.eu-S1754959AbZCFJ5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbZCFJ5E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 04:57:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbZCFJ4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 04:56:49 -0500
Received: from smtp-out.google.com ([216.239.45.13]:45021 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbZCFJ4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 04:56:48 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=PNey+ymLHXELWzNZUUcnY8+tr4ztavYvzPtoWynXPnrDmf9AeXWaD44RYDqz+rGA9
	82cALCb9PkwvdpQ43Odlw==
Date: Fri, 6 Mar 2009 01:56:26 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] lockdep: initialize lockdep debugging statistics
In-Reply-To: <1236328083.5187.1213.camel@laptop>
Message-ID: <alpine.DEB.2.00.0903060149540.26215@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903050222160.30401@chino.kir.corp.google.com>  <alpine.DEB.2.00.0903050223240.30401@chino.kir.corp.google.com>  <1236250159.4228.186.camel@laptop> <20090305110522.GI32407@elte.hu>  <alpine.DEB.2.00.0903051355010.25505@chino.kir.corp.google.com>
 <1236328083.5187.1213.camel@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Mar 2009, Peter Zijlstra wrote:

> I'm a bit slow, please use more words and explain this to me.
> 
> Before replying please read:
> 
> ea435467500612636f8f4fb639ff6e76b2496e4b
> 
> and stare at the output of:
> 
> git grep "define[ \t]*ATOMIC_INIT\>"
> 

Peter, this is purely a matter of good software engineering practices.  I 
hadn't realized you were so passionate about avoiding initialization of 
global atomic_t variables, even though it usually suffices.

I assume you wouldn't object to removing all such cases in the kernel.

	$ grep -r "atomic_t.*= ATOMIC_INIT(0)" * | wc -l
	104

Unless David Miller has any input, I'll happily defer to your 
maintainership of lockdep in this matter.  Thanks for looking at the 
patch.
