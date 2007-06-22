Return-Path: <linux-kernel-owner+w=401wt.eu-S1753210AbXFVFLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbXFVFLP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 01:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbXFVFLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 01:11:01 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:57975 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751215AbXFVFLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 01:11:00 -0400
Date: Thu, 21 Jun 2007 22:10:59 -0700 (PDT)
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
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: Oops in a driver while using SLUB as a SLAB allocator
In-Reply-To: <Pine.LNX.4.64.0706220539050.11131@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0706212206430.12278@schroedinger.engr.sgi.com>
References: <467A4532.40301@rfo.atmel.com> <Pine.LNX.4.64.0706212244090.19755@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706211835070.11608@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706220539050.11131@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2007, Hugh Dickins wrote:

> However... what gives you confidence that flush_dcache_page is
> never applied to other slab pages?

Flush dcache page is supposed to run on pages not objects of varying 
length. It is suprising that this has not lead to earlier problems.
Objects allocated this way may straddle a page boundary under some 
conditions and in that case virt_to_page may not lead to a page that 
covers the complete object that is supposed to be flushed. Hopefully the 
"size" of the allocated object were whole pages.

> This looks to me like a clean way forward to try in -mm; but that
> 2.6.22 should go with the safety PageSlab test in page_mapping.

2.6.22 cleans up these issues and this one follows in those footsteps.

The reason for the introduction of the quicklist f.e. was to have a clear 
separation between page sized allocation and the variable allocations 
through slab allocators.
