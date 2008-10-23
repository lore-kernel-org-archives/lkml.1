Return-Path: <linux-kernel-owner+w=401wt.eu-S1757025AbYJWUkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025AbYJWUkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 16:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbYJWUk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 16:40:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49209
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752088AbYJWUk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 16:40:28 -0400
Date: Thu, 23 Oct 2008 13:40:05 -0700 (PDT)
Message-Id: <20081023.134005.83296775.davem@davemloft.net>
To: johannes@sipsolutions.net
Cc: adobriyan@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: How do I printk <type> correctly?
From: David Miller <davem@davemloft.net>
In-Reply-To: <1224774806.6002.42.camel@johannes.berg>
References: <20081023114133.GA30187@x200.localdomain>
	<1224774806.6002.42.camel@johannes.berg>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Thu, 23 Oct 2008 17:13:26 +0200

> > u64 SHOULD be printed with %llu/%llx, (unsigned long long):
> > 
> > 	printk("%llu", (unsigned long long)u64_var);
> > 
> > s64 SHOULD be printed with %lld/%llx, (long long):
> > 
> > 	printk("%lld", (long long)s64_var);
> 
> out of curiosity, why are there platforms that use an "unsigned long"
> for u64?

Because that type is large enough.

> An "unsigned long long" is 64-bits too even on 64-bit platforms, so
> why the difference? Are there any differences like alignment on some
> platforms?

I invite you to go make that change and then try to fixup all the
resulting build warnings.  Some of us already made an attempt at
some point in the past. :-/

But it's just papering over the core problem, that we can't extend
gcc's automatic printf format type checking easily.

Even if we make u64 the same type everywhere, things like sector_t
and other types which do have to vary by architecture will need
to be casted.
