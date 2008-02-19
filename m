Return-Path: <linux-kernel-owner+w=401wt.eu-S1762417AbYBSWP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762417AbYBSWP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762303AbYBSWOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:14:18 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:14811 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762289AbYBSWOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:14:17 -0500
Date: Tue, 19 Feb 2008 14:13:30 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jonathan Lim <jlim@sgi.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Provide u64 version of jiffies_to_usecs() in
Message-Id: <20080219141330.9c5dfb76.randy.dunlap@oracle.com>
In-Reply-To: <200802192159.m1JLxRva003071@sabah.engr.sgi.com>
References: <20080219132525.a81e8264.randy.dunlap@oracle.com>
	<200802192159.m1JLxRva003071@sabah.engr.sgi.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008 13:59:27 -0800 (PST) Jonathan Lim wrote:

> On Tue Feb 19 13:25:25 2008, randy.dunlap@oracle.com wrote:
> > 
> > > +u64 inline jiffies_64_to_usecs(const u64 j)
> > > +{
> > > +	u64 tmp = j*HZ_TO_USEC_NUM + HZ_TO_USEC_DEN-1;
> > > +	do_div(tmp, HZ_TO_USEC_DEN);
> > 
> > do_div() is:
> >  * The semantics of do_div() are:
> >  *
> >  * uint32_t do_div(uint64_t *n, uint32_t base)
> > 
> > Maybe you want div64_64().
> > 
> > > +	return tmp;
> > > +}
> > > +EXPORT_SYMBOL(jiffies_64_to_usecs);
> > > +
> 
> In include/asm-generic/div64.h, div64_64(uint64_t dividend, uint64_t divisor)
> just returns (dividend / divisor).  Isn't this the same as what I had before
> in jiffies_64_to_usecs(), except that the arguments are of type u64?

but the (linker) problem is with X86_32, so don't look at
asm-generic/div64.h.  Look at lib/div64.c.

Or use div64() with the correct parameter types.

---
~Randy
