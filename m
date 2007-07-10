Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbXGJE3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbXGJE3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 00:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751020AbXGJE3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 00:29:10 -0400
Received: from ozlabs.org ([203.10.76.45]:39797 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbXGJE3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 00:29:09 -0400
Subject: Re: maps2-add-proc-pid-pagemap-interface.patch
From: Rusty Russell <rusty@rustcorp.com.au>
To: Matt Mackall <mpm@selenic.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070709223101.GW11115@waste.org>
References: <1183894381.6005.324.camel@localhost.localdomain>
	 <20070709223101.GW11115@waste.org>
Content-Type: text/plain
Date: Tue, 10 Jul 2007 14:28:50 +1000
Message-Id: <1184041730.6005.480.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-09 at 17:31 -0500, Matt Mackall wrote:
> > And how about "cpu_to_le16(1) == 1" instead of "ntohl(1) != 1"?
> 
> Why?

Using a networking macro to detect endianness is old school: we have the
nice explicit macros these days...

> > > +	while (pm.count > 0 && vma) {
> > > +		if (!ptrace_may_attach(task)) {
> > > +			ret = -EIO;
> > > +			goto out_mm;
> > > +		}
> > 
> > You already checked ptrace_may_attach() earlier in this function; do you
> > need to do that again?
> 
> I think so. Consider exec(). This whole area is full of interesting
> traps and it pays to be paranoid.

I don't think normal ptraces get cut on exec, so I'm not sure why this
should be different.  You could argue it would be more correct to check
at the open, in fact.

Cheers,
Rusty.

