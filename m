Return-Path: <linux-kernel-owner+w=401wt.eu-S1757997AbXFZSJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997AbXFZSJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 14:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756075AbXFZSJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 14:09:51 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43244 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752379AbXFZSJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 14:09:51 -0400
Date: Tue, 26 Jun 2007 11:09:46 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <andrew@sanpeople.com>,
       Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Oops in a driver while using SLUB as a SLAB allocator
In-Reply-To: <Pine.LNX.4.64.0706251953530.15624@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0706261107520.18010@schroedinger.engr.sgi.com>
References: <467A4532.40301@rfo.atmel.com> <Pine.LNX.4.64.0706220539050.11131@blonde.wat.veritas.com>
 <alpine.LFD.0.98.0706220937271.3593@woody.linux-foundation.org>
 <Pine.LNX.4.64.0706221040310.17139@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706221931370.4699@blonde.wat.veritas.com>
 <20070624083849.GA19079@flint.arm.linux.org.uk>
 <Pine.LNX.4.64.0706241122030.27778@blonde.wat.veritas.com>
 <20070624105152.GB14099@flint.arm.linux.org.uk>
 <Pine.LNX.4.64.0706250120560.28286@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706250607260.5191@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706251729250.4911@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706250952490.8320@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706251804420.7592@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706251108180.8907@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706251933540.13382@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706251147400.9332@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706251953530.15624@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2007, Hugh Dickins wrote:

> Please reread mails of the last 20 hours.  Your "ARM fix" may or may not
> be a good thing, I don't know.  But it had nothing to do with this oops,
> which (we believe) came from a kmalloc in drivers/mmc/core/sd.c.  There
> are likely to be many other drivers which pass down kmalloc'ed buffers
> to routines which handle both kmalloc'ed buffers and page buffers.
> Though very few of those needing to flush_dcache_page.

If that is so then those functions may want to check PageSlab before 
calling flush_dcache_page.

