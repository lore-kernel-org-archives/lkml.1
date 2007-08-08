Return-Path: <linux-kernel-owner+w=401wt.eu-S936379AbXHHXZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936379AbXHHXZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 19:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757095AbXHHXZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 19:25:26 -0400
Received: from alephnull.demon.nl ([83.160.184.112]:47049 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759431AbXHHXZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 19:25:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:in-reply-to:user-agent;
	b=dUxqWP7jU/a4TKTQBNq7fXd8QtWP08ETJeEzXSjpUb8g9l8h27Qv7pRK9cnph
	tUWZonsL4x2YJZOvlQdUYNb5w==
Date: Thu, 9 Aug 2007 01:25:21 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Chris Snook <csnook@redhat.com>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       schwidefsky@de.ibm.com, wensong@linux-vs.org, horms@verge.net.au,
       wjiang@resilience.com, cfriesen@nortel.com, zlynx@acm.org
Subject: Re: [PATCH] make atomic_t volatile on all architectures
Message-ID: <20070808232521.GC8460@xi.wantstofly.org>
References: <20070808230733.GA17270@shell.boston.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070808230733.GA17270@shell.boston.redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2007 at 07:07:33PM -0400, Chris Snook wrote:

> From: Chris Snook <csnook@redhat.com>
> 
> Some architectures currently do not declare the contents of an atomic_t to be
> volatile.  This causes confusion since atomic_read() might not actually read
> anything if an optimizing compiler re-uses a value stored in a register, which
> can break code that loops until something external changes the value of an
> atomic_t.  Avoiding such bugs requires using barrier(), which causes re-loads
> of all registers used in the loop, thus hurting performance instead of helping
> it, particularly on architectures where it's unnecessary.  Since we generally
> want to re-read the contents of an atomic variable on every access anyway,
> let's standardize the behavior across all architectures and avoid the
> performance and correctness problems of requiring the use of barrier() in
> loops that expect atomic_t variables to change externally.  This is relevant
> even on non-smp architectures, since drivers may use atomic operations in
> interrupt handlers.
> 
> Signed-off-by: Chris Snook <csnook@redhat.com>

Documentation/atomic_ops.txt would need updating:

	[...]

	One very important aspect of these two routines is that they DO NOT
	require any explicit memory barriers.  They need only perform the
	atomic_t counter update in an SMP safe manner.
