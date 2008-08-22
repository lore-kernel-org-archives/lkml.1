Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbYHVBkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbYHVBkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 21:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbYHVBkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 21:40:32 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:28315 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751740AbYHVBkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 21:40:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=BMcXL1Tk7CR2U8c/NIvb/dgMKQwfXG1vlr3X0dCqSM539IVKwxo0fqU4/g6vDrCxFXpJEjmxVY3TvMUHjG0uJAs3VOFzABq77/ScEcZyP6KSahLFa/hID7y8fBdsMYd4tuUGafKUcyYZH270+NgULyULTccdgx8n4NE/VqwZZ5s=  ;
X-YMail-OSG: p7OtRbUVM1lPeMEaA56EF1xTsN_ZiPooQvy7GY6zcSj1LODxgKRlzCXvBN9S94TGtWe7CxaT.wC9N141HxOljr1p0lPvRlB43QD_crXqGXcQ0sCGFSyX7QldSTqmGCQC7A67PxcSvMerHFzoD6Fz_Ej7
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [ANNOUNCE] mdb: Merkey's Linux Kernel Debugger  2.6.27-rc4 released
Date: Fri, 22 Aug 2008 11:40:24 +1000
User-Agent: KMail/1.9.5
Cc: jmerkey@wolfmountaingroup.com, paulmck@linux.vnet.ibm.com,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>
References: <200808210250.m7L2obNX028353@wolfmountaingroup.com> <200808212337.38626.nickpiggin@yahoo.com.au> <48AD7705.2000404@s5r6.in-berlin.de>
In-Reply-To: <48AD7705.2000404@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808221140.25029.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 August 2008 00:09, Stefan Richter wrote:
> Nick Piggin wrote:
> > On Thursday 21 August 2008 22:26, jmerkey@wolfmountaingroup.com wrote:
> >> It's simple to reproduce.  Take away the volatile declaration for the
> >> rlock_t structure in mdb-ia32.c (rlock_t debug_lock) in all code
> >> references and watch the thing lock up in SMP with multiple processors
> >> in the debugger each stuck with their own local copy of debug_lock.
> >
> > You should disable preempt before getting the processor id. Can't see any
> > other possible bugs, but you should be able to see from the disassembly
> > pretty easily.
>
> debug_lock() is AFAICS only called from contexts which have preemption
> disabled.  Last time around I recommended to Jeff to document this
> requirement on the calling context.

I'm not talking about where debug_lock gets called, I'm talking about
where the processor id is derived that eventually filters down to
debug_lock.

> But even though preemption is disabled, debug_lock() is still incorrect
> as I mentioned in my other post a minute ago.  It corrupts its .flags
> and .count members.  (Or maybe it coincidentally doesn't as long as
> volatile is around.)

I don't think so. And flags should only be restored by the processor
that saved it because the spinlock should disable preemption, right?
