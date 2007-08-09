Return-Path: <linux-kernel-owner+w=401wt.eu-S939216AbXHIP76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939216AbXHIP76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 11:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935614AbXHIP7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 11:59:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:42095 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbXHIP7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 11:59:43 -0400
In-Reply-To: <46BB31A6.4080507@redhat.com>
References: <20070809132442.GA13042@shell.boston.redhat.com> <20070809143255.GA8424@linux.vnet.ibm.com> <46BB2A5A.5090006@redhat.com> <20070809150445.GB8424@linux.vnet.ibm.com> <46BB31A6.4080507@redhat.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <3bfabd7472d6f019aa1880b14013f7a1@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: wjiang@resilience.com, rpjday@mindspring.com, wensong@linux-vs.org,
       heiko.carstens@de.ibm.com, linux-kernel@vger.kernel.org, ak@suse.de,
       netdev@vger.kernel.org, paulmck@linux.vnet.ibm.com, horms@verge.net.au,
       akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       jesper.juhl@gmail.com, torvalds@linux-foundation.org,
       schwidefsky@de.ibm.com, davem@davemloft.net, cfriesen@nortel.com,
       zlynx@acm.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 1/24] make atomic_read() behave consistently on alpha
Date: Thu, 9 Aug 2007 17:50:32 +0200
To: Chris Snook <csnook@redhat.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> We can't have split stores because we don't use atomic64_t on 32-bit 
> architectures.

That's not true; the compiler is free to split all stores
(and reads) from memory however it wants.  It is debatable
whether "volatile" would prevent this as well, certainly
it is unsafe if you want to be portable.  GCC will do its
best to not split volatile memory accesses, but bugs in
this area do happen a lot (because the compiler code for
volatile isn't as well exercised as most other compiler
code, and because it is simply a hard subject; and there
is no real formalised model for what GCC should do).

The only safe way to get atomic accesses is to write
assembler code.  Are there any downsides to that?  I don't
see any.


Segher

