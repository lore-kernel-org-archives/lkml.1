Return-Path: <linux-kernel-owner+w=401wt.eu-S1761352AbXGJG2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761352AbXGJG2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 02:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbXGJG2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 02:28:04 -0400
Received: from waste.org ([66.93.16.53]:53648 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674AbXGJG2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 02:28:03 -0400
Date: Tue, 10 Jul 2007 01:27:36 -0500
From: Matt Mackall <mpm@selenic.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: maps2-add-proc-pid-pagemap-interface.patch
Message-ID: <20070710062736.GF11115@waste.org>
References: <1183894381.6005.324.camel@localhost.localdomain> <20070709223101.GW11115@waste.org> <1184041730.6005.480.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184041730.6005.480.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 02:28:50PM +1000, Rusty Russell wrote:
> On Mon, 2007-07-09 at 17:31 -0500, Matt Mackall wrote:
> > > And how about "cpu_to_le16(1) == 1" instead of "ntohl(1) != 1"?
> > 
> > Why?
> 
> Using a networking macro to detect endianness is old school: we have the
> nice explicit macros these days...
> 
> > > > +	while (pm.count > 0 && vma) {
> > > > +		if (!ptrace_may_attach(task)) {
> > > > +			ret = -EIO;
> > > > +			goto out_mm;
> > > > +		}
> > > 
> > > You already checked ptrace_may_attach() earlier in this function; do you
> > > need to do that again?
> > 
> > I think so. Consider exec(). This whole area is full of interesting
> > traps and it pays to be paranoid.
> 
> I don't think normal ptraces get cut on exec, so I'm not sure why this
> should be different.

They absolutely do, if UID changes. Consider ptracing a shell
launching a setuid binary. For something more closely analogous,
consider opening /proc/pid/mem on the same shell...

-- 
Mathematics is the supreme nostalgia of our time.
