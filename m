Return-Path: <linux-kernel-owner+w=401wt.eu-S1759319AbZFKOYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319AbZFKOYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 10:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbZFKOYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 10:24:40 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:36875 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751505AbZFKOYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 10:24:40 -0400
Date: Thu, 11 Jun 2009 10:24:35 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: linux-kernel@vger.kernel.org, mel@csn.ul.ie, Larry.Finger@lwfinger.net
Subject: Re: [PATCH 2/2] SLUB: Disable debugging if it increases the minimum
 page order
In-Reply-To: <1244728824.17483.51.camel@penberg-laptop>
Message-ID: <alpine.DEB.1.10.0906111021340.29827@gentwo.org>
References: <Pine.LNX.4.64.0906111143490.6132@melkki.cs.Helsinki.FI>  <alpine.DEB.1.10.0906110941520.29827@gentwo.org> <1244728824.17483.51.camel@penberg-laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jun 2009, Pekka Enberg wrote:

> On Thu, 2009-06-11 at 09:43 -0400, Christoph Lameter wrote:
> > We have had that with SLAB. NO! This leads to the situation that some
> > slabs have debug on and some have not. You just do not know which.
>
> I do see your point but surely we don't want to use order 1 allocations
> in the fall-back case for kmalloc-4096? Couldn't we just add a printk
> saying that debug was disabled for the cache? After all, my patch is
> much better than what SLAB does.

If we are enabling global debugging then we are looking for memory
corruption in *all* slab caches. Disabling debugging of some cache behind
the scenes is bad even if this leads to order 1 allocations.

We could refine the way to specify groups of slab caches that should have
debugging on.

> On Thu, 2009-06-11 at 09:43 -0400, Christoph Lameter wrote:
> > Note that CONFIG_SLUB_DEBUG only enables the code to debug a slab. It does
> > not enable debugging for each slab. CONFIG_SLUB_DEBUG_ON does that.
>
> True. Larry, do you have CONFIG_SLUB_DEBUG_ON enabled or are you passing
> SLUB debugging options to the kernel?


