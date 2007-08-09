Return-Path: <linux-kernel-owner+w=401wt.eu-S936518AbXHIFFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936518AbXHIFFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 01:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbXHIFFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 01:05:06 -0400
Received: from 207.47.19.6.static.nextweb.net ([207.47.19.6]:36768 "EHLO
	ex1.resilience.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbXHIFFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 01:05:04 -0400
Date: Thu, 9 Aug 2007 12:59:20 +0800
From: Jerry Jiang <wjiang@resilience.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Snook <csnook@redhat.com>, akpm@linux-foundation.org, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       schwidefsky@de.ibm.com, wensong@linux-vs.org, horms@verge.net.au,
       cfriesen@nortel.com, zlynx@acm.org
Subject: Re: [PATCH] make atomic_t volatile on all architectures
Message-Id: <20070809125920.37eb6e6d.wjiang@resilience.com>
In-Reply-To: <alpine.LFD.0.999.0708082116060.25146@woody.linux-foundation.org>
References: <20070808230733.GA17270@shell.boston.redhat.com>
	<alpine.LFD.0.999.0708082116060.25146@woody.linux-foundation.org>
Organization: Resilience
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Aug 2007 05:04:55.0421 (UTC) FILETIME=[D37CB2D0:01C7DA42]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2007 21:18:25 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Wed, 8 Aug 2007, Chris Snook wrote:
> > 
> > Some architectures currently do not declare the contents of an atomic_t to be
> > volatile.  This causes confusion since atomic_read() might not actually read
> > anything if an optimizing compiler re-uses a value stored in a register, which
> > can break code that loops until something external changes the value of an
> > atomic_t.
> 
> I'd be *much* happier with "atomic_read()" doing the "volatile" instead.
> 
> The fact is, volatile on data structures is a bug. It's a wart in the C 
> language. It shouldn't be used. 

Why? It's a wart! Is it due to unclear C standard on volatile related point?

Why the *volatile-accesses-in-code* is acceptable, does C standard make it clear?

-- Jerry

> 
> Volatile accesses in *code* can be ok, and if we have "atomic_read()" 
> expand to a "*(volatile int *)&(x)->value", then I'd be ok with that.
> 
> But marking data structures volatile just makes the compiler screw up 
> totally, and makes code for initialization sequences etc much worse.
> 
> 		Linus
