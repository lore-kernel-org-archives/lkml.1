Return-Path: <linux-kernel-owner+w=401wt.eu-S933808AbYBGXcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933808AbYBGXcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 18:32:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757496AbYBGXcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 18:32:31 -0500
Received: from relay1.sgi.com ([192.48.171.29]:45363 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756946AbYBGXca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 18:32:30 -0500
Date: Thu, 7 Feb 2008 15:32:29 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andi Kleen <andi@firstfloor.org>,
       Richard Knutsson <ricknu-0@student.ltu.se>
Subject: Re: [PATCH 1/2] kmemcheck v3
In-Reply-To: <19f34abd0802071518j1ffc3dafp46fcbd8d36d36f17@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802071530040.3845@schroedinger.engr.sgi.com>
References: <47AB79D4.2070605@gmail.com>  <Pine.LNX.4.64.0802071341500.2544@schroedinger.engr.sgi.com>
  <19f34abd0802071412m569e4993kffb4a3af163fa16c@mail.gmail.com> 
 <Pine.LNX.4.64.0802071443440.3289@schroedinger.engr.sgi.com>
 <19f34abd0802071518j1ffc3dafp46fcbd8d36d36f17@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2008, Vegard Nossum wrote:

> The tracking that kmemcheck does is actually a byte-for-byte tracking
> of whether memory has been initialized or not. Think of it as valgrind
> for the kernel. We do this by "hiding" pages (marking them non-present
> for for MMU) and taking the page faults, which effectively tells us
> what memory is being attempted to be read from or written to.

Ahh. Okay. But ZONE_DMA pages are exempt from that scheme? You know 
that ZONE_NORMAL pages can undergo dma?

> I chose to implement this in the slab layer because this is probably
> where most of the interesting allocations are coming from, and this
> gives us a better control over what most users/callers care about,
> namely the specific objects.

But the slab layer allocates pages < PAGE_SIZE. You need to take a fault 
right? So each object would need its own page?
