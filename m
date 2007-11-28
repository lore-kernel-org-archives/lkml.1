Return-Path: <linux-kernel-owner+w=401wt.eu-S1761408AbXK1XSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761408AbXK1XSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 18:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758823AbXK1XR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 18:17:58 -0500
Received: from ozlabs.org ([203.10.76.45]:52249 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759412AbXK1XR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 18:17:57 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch 05/14] percpu: Use a Kconfig variable to configure arch specific percpu setup
Date: Thu, 29 Nov 2007 10:17:52 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, Jeremy Fitzhardinge <jeremy@goop.org>
References: <20071127001407.859743255@sgi.com> <200711281236.02014.rusty@rustcorp.com.au> <Pine.LNX.4.64.0711281050470.11968@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0711281050470.11968@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711291017.52727.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 November 2007 05:51:29 Christoph Lameter wrote:
> On Wed, 28 Nov 2007, Rusty Russell wrote:
> > On Wednesday 28 November 2007 05:14:47 Christoph Lameter wrote:
> > > On Tue, 27 Nov 2007, Rusty Russell wrote:
> > > > Have you considered moving x86-64's setup_per_cpu_areas into generic
> > > > code? It's a bit messier because some archs might not have set up
> > > > NUMA stuff yet, but it's logically generic...
> > >
> > > Yes that will happen later. This is just the early cleanup work. I
> > > plan to generally bring the two x86 arches in line. The pda will be
> > > folded into the per cpu area and after that its easy to do.
> >
> > Unfortunately, we tried to get rid of the x86-64 pda (like i386) but you
> > lose the ability to use the stack protection config option.  That's
> > because it assumes that gs:0x68 (or something) is the stack canary; we
> > need a YA gcc change to make this gs:__builtin_stack_canary_off (where
> > gcc can emit __builtin_stack_canary_off as a weak absolute symbol, so we
> > can override it for the kernel.
>
> This works if you rebase the per cpu area at zero. gs:0x68 is still the
> stack canary.
>
> The i386 method does not work because the segment register does not
> directly point to the pda.

But the PDA itself is silly (Jeremy ported it to i386 and I balked).  We have 
a generic one: it's called the per-cpu data.  Having a completely separate 
per-cpu structure for x86-64 is a mistake.

Setting up gs as the per-cpu offset has lovely properties and avoids YA 
arch-specific concept; see the i386 code.  Introducing a generic 
read_percpu()/write_percpu() would even make it optimal.

Cheers,
Rusty.
