Return-Path: <linux-kernel-owner+w=401wt.eu-S1754524AbZFFItr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbZFFItr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 04:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436AbZFFItg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 04:49:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:56567 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398AbZFFIte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 04:49:34 -0400
Subject: Re: [PATCH 1/6] headers_check fix: arm, hwcap.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <20090605204805.GA22367@flint.arm.linux.org.uk>
References: <1244118232.5172.26.camel@ht.satnam>
	 <1244118476.5172.29.camel@ht.satnam>
	 <20090604125306.GC24491@flint.arm.linux.org.uk>
	 <20090604201649.GC13892@uranus.ravnborg.org>
	 <20090605204805.GA22367@flint.arm.linux.org.uk>
Content-Type: text/plain
Date: Sat, 06 Jun 2009 14:20:11 +0530
Message-Id: <1244278211.2475.13.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-05 at 21:48 +0100, Russell King wrote:
> On Thu, Jun 04, 2009 at 10:16:49PM +0200, Sam Ravnborg wrote:
> > On Thu, Jun 04, 2009 at 01:53:07PM +0100, Russell King wrote:
> > > On Thu, Jun 04, 2009 at 05:57:56PM +0530, Jaswinder Singh Rajput wrote:
> > > > fix the following 'make headers_check' warning:
> > > 
> > > I think headers_check needs fixing - there's nothing wrong with the
> > > code as it presently stands except the tools obviously can't properly
> > > parse C preprocessor statements.
> > 
> > You are correct that headers_ceck is limited here and this patch
> > take some valid code and refactor it to make it headers_check compatible.
> 
> Okay, here's the question:
> 
> Does userspace require anything in the ifdef __ASSEMBLY__ bits?

__ASSEMBLY__ is not specific to kernel. Any one can take benefit of it.


> In any case, passing -D__KERNEL__ or -U__KERNEL__ allows unifdef to
> do the right thing.
> 
> The problem which unifdef has is that if it finds a symbol in an
> evaluation that it doesn't know about, it fails the expansion
> entirely, rather than checking whether the expansion always results
> in something which should be omitted.  In other words:
> 
> #if defined(__KERNEL__) && (<unknown>)
> 

The problem is why you are trying to complex things which are simple and
straight.

#ifdef __KERNEL__ is for kernel
#ifndef __KERNEL__ is for userspace

Do not mix it with others defines, Whole kernel is following this
protocol why you need a exception ?

> results in basically an "unknown" answer from the evaluator, where
> we can see perfectly well that the expansion can never be true if
> __KERNEL__ is never set.
> 
> So, the trivial answer to the problem if:
> 
> #if defined(__KERNEL__) && something-depending-on-__ASSEMBLY__
> 
> is to tell unifdef whether we want __ASSEMBLY__ defined or not defined.
> This does shut up the headers_install warning from ARMs hwdef.h.
> 

#ifdef __KERNEL__
something-depending-on-__ASSEMBLY__

will not only shut up these warnings but also avoid confusion, keep
things simple and avoid unknown future problems.

My request to you please think bigger and look at bigger picture.

Thanks,
--
JSR

