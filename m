Return-Path: <linux-kernel-owner+w=401wt.eu-S1756269AbXHIRya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269AbXHIRya (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 13:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbXHIRyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 13:54:20 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:52953 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbXHIRyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 13:54:18 -0400
Subject: Re: [PATCH] make atomic_t volatile on all architectures
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Chris Snook <csnook@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, ak@suse.de, heiko.carstens@de.ibm.com,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, wensong@linux-vs.org, horms@verge.net.au,
       wjiang@resilience.com, cfriesen@nortel.com, zlynx@acm.org
In-Reply-To: <46BB508B.7050601@redhat.com>
References: <20070808230733.GA17270@shell.boston.redhat.com>
	 <alpine.LFD.0.999.0708082116060.25146@woody.linux-foundation.org>
	 <46BAC2BE.1090106@redhat.com>  <46BB508B.7050601@redhat.com>
Content-Type: text/plain
Organization: IBM Corporation
Date: Thu, 09 Aug 2007 19:57:55 +0200
Message-Id: <1186682275.9669.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-09 at 13:36 -0400, Chuck Ebbert wrote:
> > Fair enough.  Casting to (volatile int *) will give us the behavior
> > people expect when using atomic_t without needing to use inefficient
> > barriers.
> > 
> 
> You can use this forget() macro to make the compiler reread a
> variable:
> 
> #define forget(var) asm volatile ("" : "=m"(var))

You need to specify a "m"(var) input constraint as well. Without it the
compiler might remove the initialization of var. E.g.

void fn(void)
{
	int var = 0;
	forget(var);
	/* now var can have any value. */
}

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


