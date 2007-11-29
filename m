Return-Path: <linux-kernel-owner+w=401wt.eu-S1762685AbXK2BfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762685AbXK2BfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 20:35:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759760AbXK2BfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 20:35:04 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33385 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758024AbXK2BfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 20:35:02 -0500
Date: Wed, 28 Nov 2007 17:35:01 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: Re: [patch 05/14] percpu: Use a Kconfig variable to configure arch
 specific percpu setup
In-Reply-To: <474E163E.2070702@goop.org>
Message-ID: <Pine.LNX.4.64.0711281731410.19914@schroedinger.engr.sgi.com>
References: <20071127001407.859743255@sgi.com> <200711281236.02014.rusty@rustcorp.com.au>
 <Pine.LNX.4.64.0711281050470.11968@schroedinger.engr.sgi.com>
 <200711291017.52727.rusty@rustcorp.com.au> <474DFD7E.907@goop.org>
 <Pine.LNX.4.64.0711281604560.17738@schroedinger.engr.sgi.com>
 <474E163E.2070702@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2007, Jeremy Fitzhardinge wrote:

> I don't see the problem.  The way i386 does it inherently supports
> per-cpu data very early on (it uses the prototype percpu section until
> the real percpu values are set up).

Ok so we could do that for x86_64 as well? There is more complicated 
bootstrap since i386 does not support NUMA aware placement of per cpu 
areas.

> > The i386 way of referring to per cpu data is not optimal because it is 
> > always offset by __per_cpu_start. per cpu data offsets need to be relative 
> > to the beginning of the per cpu area. per cpu data is less than 64k so 2 
> > byte offsets would be enough.
> >   
> 
> I don't see that's terribly important.  percpu references aren't all
> that common overall, and - at least on x86 - using a 16-bit offset
> (assuming its possible) would require a prefix anyway, so it would only
> save 1 byte per reference.  But I can't convince gas to generate a
> 16-bit offset anyway.

percpu references are quite frequent already (vm statistics) and will be 
more frequent after we have converted the per cpu arrays to per cpu 
allocations.


> > That way the __per_cpu_offset array and the registers that are used on 
> > various platforms are pointing to the actual data and can be loaded
> > directly into a register and then a load with a small offset to that 
> > register can be performed. On x86_64 this is gs, on i386 fs, on sparc g5, 
> > on ia64 a fixed address stands in for the register.
> 
> The asm used to generate these references is inherently arch-specific
> anyway, so the type and size of offset needed from the per-cpu base
> register to the data itself can be arch-dependent without loss of
> generality.  

Well yes that is already the case and made explicit by the percpu cleanup 
done so far. The offset of a base is used by multiple architectures.


