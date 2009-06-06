Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbZFFJOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbZFFJOP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 05:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbZFFJOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 05:14:00 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35764 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbZFFJN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 05:13:59 -0400
Date: Sat, 6 Jun 2009 10:12:15 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH 1/6] headers_check fix: arm, hwcap.h
Message-ID: <20090606091215.GB30463@flint.arm.linux.org.uk>
References: <1244118232.5172.26.camel@ht.satnam> <1244118476.5172.29.camel@ht.satnam> <20090604125306.GC24491@flint.arm.linux.org.uk> <20090604201649.GC13892@uranus.ravnborg.org> <20090605204805.GA22367@flint.arm.linux.org.uk> <1244278211.2475.13.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244278211.2475.13.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 06, 2009 at 02:20:11PM +0530, Jaswinder Singh Rajput wrote:
> On Fri, 2009-06-05 at 21:48 +0100, Russell King wrote:
> > On Thu, Jun 04, 2009 at 10:16:49PM +0200, Sam Ravnborg wrote:
> > > On Thu, Jun 04, 2009 at 01:53:07PM +0100, Russell King wrote:
> > > > On Thu, Jun 04, 2009 at 05:57:56PM +0530, Jaswinder Singh Rajput wrote:
> > > > > fix the following 'make headers_check' warning:
> > > > 
> > > > I think headers_check needs fixing - there's nothing wrong with the
> > > > code as it presently stands except the tools obviously can't properly
> > > > parse C preprocessor statements.
> > > 
> > > You are correct that headers_ceck is limited here and this patch
> > > take some valid code and refactor it to make it headers_check compatible.
> > 
> > Okay, here's the question:
> > 
> > Does userspace require anything in the ifdef __ASSEMBLY__ bits?
> 
> __ASSEMBLY__ is not specific to kernel. Any one can take benefit of it.
> 
> 
> > In any case, passing -D__KERNEL__ or -U__KERNEL__ allows unifdef to
> > do the right thing.
> > 
> > The problem which unifdef has is that if it finds a symbol in an
> > evaluation that it doesn't know about, it fails the expansion
> > entirely, rather than checking whether the expansion always results
> > in something which should be omitted.  In other words:
> > 
> > #if defined(__KERNEL__) && (<unknown>)
> > 
> 
> The problem is why you are trying to complex things which are simple and
> straight.

What you're saying is "you may not follow valid C ways of expressing
conditional compilation" to which I say "go and piss in someone elses
pool".

Since the fix for this in unifdef is soo trivial, and it doesn't require
people to write stuff in ways that stupid idiotic tools can understand,
I'm NEVER going to apply the fix to hwdef.h.

So you now have two options: either supply the (correct) additional
parameter to unifdef, or ignore the stupid idiotic warning message.

> My request to you please think bigger and look at bigger picture.

Same response to you actually.  What I'm doing is valid C and there
has NEVER been this convention you're trying to make out.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
