Return-Path: <linux-kernel-owner+w=401wt.eu-S1760873AbYGKUvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760873AbYGKUvw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 16:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbYGKUvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 16:51:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:48980 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbYGKUvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 16:51:43 -0400
Date: Fri, 11 Jul 2008 13:51:43 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [patch 2/17] Add a WARN() macro that acts like WARN_ON()+printk
Message-ID: <20080711135143.23e26a7c@infradead.org>
In-Reply-To: <20080711121949.ec5db301.akpm@linux-foundation.org>
References: <20080708093800.274504ba@infradead.org>
	<20080708094023.260a31bb@infradead.org>
	<20080711121949.ec5db301.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2008 12:19:49 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 8 Jul 2008 09:40:23 -0700 Arjan van de Ven
> <arjan@infradead.org> wrote:
> 
> > From: Arjan van de Ven <arjan@linux.intel.com>
> > 
> > Add a WARN() macro that acts like WARN_ON(), with the added feature
> > that it takes a printk like argument that is printed as part of the
> > warning message.
> > 
> 
> Apart from a little whitespace tweak, this is identical to what I
> already had.
> 
> > +#define WARN_ONCE(condition, format...)
> > ({			\
> > +	static int
> > __warned;					\
> > +	int __ret_warn_once
> > = !!(condition);			\
> > +								\
> > +	if
> > (unlikely(__ret_warn_once))				\
> > +		if (WARN(!__warned, format))
> > 			\
> > +			__warned =
> > 1;				\
> > +	unlikely(__ret_warn_once);				\
> > +})
> 
> Except it adds this operation, without describing it at all in the
> changelog.
> 
> Is this some brainfart, or am I missing something?  I can see some
> sense in a WARN_ONCE(format...), but not in a WARN_ONCE() which takes
> a `condition' and should be called WARN_ON_ONCE(), which we already
> have.

WARN_ON_ONCE() doesn't take printk arguments. So WARN_ONCE() is
WAR_ON_ONCE() with printk arguments...


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
