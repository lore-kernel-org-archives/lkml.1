Return-Path: <linux-kernel-owner+w=401wt.eu-S1757721AbZEVUDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721AbZEVUDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 16:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756259AbZEVUDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 16:03:10 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:36048 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165AbZEVUDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 16:03:09 -0400
From: "Michael S. Zick" <mszick@morethan.org>
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Date: Fri, 22 May 2009 15:03:06 -0500
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200905221350.50027.mszick@morethan.org> <adak5499c0b.fsf@cisco.com>
In-Reply-To: <adak5499c0b.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905221503.08586.mszick@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri May 22 2009, Roland Dreier wrote:
> 
>  > Unless you have interrupts enabled, then you have two contexts.
>  > Only xchg is "naturally" atomic.
> 
> Isn't the lock prefix about consistency between multiple processors?
> The x86 architecture always handles interrupts on instruction
> boundaries.  I'm guessing you're worried about definitions like
> 
> static inline void atomic_inc(atomic_t *v)
> {
> 	asm volatile(LOCK_PREFIX "incl %0"
> 		     : "+m" (v->counter));
> }
> 
> which compiles to just "incl" (with no lock prefix) on uniprocessor
> kernels; but the IA-32 architecture guarantees that the incl instruction
> cannot be interrupted between reading the old value and writing the new
> value.
> 

Not prior to P-4, and since then only "may" be done atomically,
see reference post in my earlier reply.

PS: And yes, that was where I spotted the usage first.  ;)

Mike
>  - R.
> 
> 


