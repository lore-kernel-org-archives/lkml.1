Return-Path: <linux-kernel-owner+w=401wt.eu-S1760803AbYBKXc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760803AbYBKXc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 18:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755325AbYBKXcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 18:32:51 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:54750 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295AbYBKXcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 18:32:50 -0500
Date: Mon, 11 Feb 2008 18:32:24 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Matt Mackall <mpm@selenic.com>, Pekka J Enberg <penberg@cs.helsinki.fi>,
       blaisorblade@yahoo.it, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slob: fix linking for user mode linux
Message-ID: <20080211233224.GA11432@c2.user-mode-linux.org>
References: <Pine.LNX.4.64.0802120032160.27876@sbz-30.cs.Helsinki.FI> <1202769569.12383.49.camel@cinder.waste.org> <Pine.LNX.4.64.0802111443130.28253@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802111443130.28253@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 02:44:21PM -0800, Christoph Lameter wrote:
> UML defined its own external __kmalloc and things. Isnt there some other 
> way to fix it? I guess including slab.h is not possible here?

This is definitely dubious code on my part and I wouldn't support
Pekka's patch unless you're going to uninline __kmalloc for some
other reason.

The reason for this is that part of UML is userspace code, and thus
can't use kernel headers.  However, they do need some kernel
interfaces in some form.  That form has traditionally been little
wrappers in the kernel side of UML which just call the kernel
interface.

In this case, there used to be um_kmalloc, which just called kmalloc.
I've been trying to get rid of these stupid little helpers for a
while, and this is what I ended up with for kmalloc.

It would be an annoyance to reintroduce um_kmalloc, but that might be
the best thing to do here.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
