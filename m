Return-Path: <linux-kernel-owner+w=401wt.eu-S1946376AbXBILxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946376AbXBILxb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 06:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946388AbXBILxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 06:53:31 -0500
Received: from ozlabs.org ([203.10.76.45]:41943 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946376AbXBILxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 06:53:30 -0500
Subject: Re: [PATCH 1/10] lguest: Don't rely on last-linked fallthru when
	no paravirt handler
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@muc.de>
Cc: virtualization@lists.osdl.org,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>
In-Reply-To: <200702091031.20249.ak@muc.de>
References: <1171012296.2718.26.camel@localhost.localdomain>
	 <1171012458.2718.30.camel@localhost.localdomain>
	 <200702091031.20249.ak@muc.de>
Content-Type: text/plain
Date: Fri, 09 Feb 2007 22:52:46 +1100
Message-Id: <1171021966.2718.82.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-09 at 10:31 +0100, Andi Kleen wrote:
> On Friday 09 February 2007 10:14, Rusty Russell wrote:
> 
> > +unhandled_paravirt:
> > +	/* Nothing wanted us: try to die with dignity (impossible trap). */ 
> > +	movl	$0x1F, %edx
> > +	pushl	$0
> > +	jmp	early_fault
> 
> Please print a real message with early_printk

If we make it thought early_fault, this will do just that.

Given this is a "never happens" situation, however... if you're actually
under Xen or lguest, you won't make it that far (lguest, at least, will
kill you on the cr2 load in early_fault, but it doesn't matter because
we won't get anywhere with early_printk anyway).

Actually, if we did BUG() here at least lguest would print something...
I wonder what Xen would do...

Rusty.


