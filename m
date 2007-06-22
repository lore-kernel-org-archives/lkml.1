Return-Path: <linux-kernel-owner+w=401wt.eu-S1754479AbXFVFb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbXFVFb5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 01:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbXFVFbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 01:31:49 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41453 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750881AbXFVFbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 01:31:49 -0400
Date: Thu, 21 Jun 2007 22:31:46 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <andrew@sanpeople.com>,
       Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: Oops in a driver while using SLUB as a SLAB allocator
In-Reply-To: <Pine.LNX.4.64.0706220540150.11131@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0706212226350.12396@schroedinger.engr.sgi.com>
References: <467A4532.40301@rfo.atmel.com> <Pine.LNX.4.64.0706212244090.19755@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706211839440.11717@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706220540150.11131@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2007, Hugh Dickins wrote:

> But PA-RISC also has a function called flush_dcache_page, which uses
> page_mapping and expects a struct address_space * from it.  If that
> can ever be get applied to a SLOB page (which is not so clear as in
> the ARM case, but cannot easily be ruled out completely), we're
> in trouble without a PageSlab test within page_mapping.

A page comes from the page allocator. Access to a slab allocators "page" 
is an access to subsystem internals. Those internals vary 
(including the representation of objects in the "page") and depend on the 
slab allocator selected, the debug options in effect and parameters 
with which the slab was created etc etc.

If flush_dcache_page is applied to a slab object then we need to do a 
similar change to PA-RISC as for ARM.
