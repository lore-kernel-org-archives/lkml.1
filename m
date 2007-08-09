Return-Path: <linux-kernel-owner+w=401wt.eu-S1759562AbXHIET3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759562AbXHIET3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 00:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbXHIETS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 00:19:18 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47870 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751293AbXHIETR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 00:19:17 -0400
Date: Wed, 8 Aug 2007 21:18:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chris Snook <csnook@redhat.com>
cc: akpm@linux-foundation.org, ak@suse.de, heiko.carstens@de.ibm.com,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, schwidefsky@de.ibm.com, wensong@linux-vs.org,
       horms@verge.net.au, wjiang@resilience.com, cfriesen@nortel.com,
       zlynx@acm.org
Subject: Re: [PATCH] make atomic_t volatile on all architectures
In-Reply-To: <20070808230733.GA17270@shell.boston.redhat.com>
Message-ID: <alpine.LFD.0.999.0708082116060.25146@woody.linux-foundation.org>
References: <20070808230733.GA17270@shell.boston.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 8 Aug 2007, Chris Snook wrote:
> 
> Some architectures currently do not declare the contents of an atomic_t to be
> volatile.  This causes confusion since atomic_read() might not actually read
> anything if an optimizing compiler re-uses a value stored in a register, which
> can break code that loops until something external changes the value of an
> atomic_t.

I'd be *much* happier with "atomic_read()" doing the "volatile" instead.

The fact is, volatile on data structures is a bug. It's a wart in the C 
language. It shouldn't be used. 

Volatile accesses in *code* can be ok, and if we have "atomic_read()" 
expand to a "*(volatile int *)&(x)->value", then I'd be ok with that.

But marking data structures volatile just makes the compiler screw up 
totally, and makes code for initialization sequences etc much worse.

		Linus
