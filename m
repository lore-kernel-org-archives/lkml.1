Return-Path: <linux-kernel-owner+w=401wt.eu-S1759050AbXFDQsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050AbXFDQsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 12:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756847AbXFDQsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 12:48:47 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56038 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757077AbXFDQsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 12:48:47 -0400
Date: Mon, 4 Jun 2007 09:48:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       jeremy@goop.org
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
In-Reply-To: <84144f020706040937xb06535em543fa887ad65ee8f@mail.gmail.com>
Message-ID: <alpine.LFD.0.98.0706040945200.23741@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com> 
 <20070601204141.f84ad72f.akpm@linux-foundation.org> 
 <Pine.LNX.4.64.0706012057580.11358@schroedinger.engr.sgi.com> 
 <20070601213117.1178e8e0.akpm@linux-foundation.org> 
 <Pine.LNX.4.64.0706012139480.11577@schroedinger.engr.sgi.com> 
 <84144f020706040808t4882f961t80b8d8eb145bfa50@mail.gmail.com> 
 <Pine.LNX.4.64.0706040916090.23191@schroedinger.engr.sgi.com> 
 <84144f020706040922v56cb10eg5a730b4abe9d5251@mail.gmail.com> 
 <alpine.LFD.0.98.0706040924070.23741@woody.linux-foundation.org>
 <84144f020706040937xb06535em543fa887ad65ee8f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 4 Jun 2007, Pekka Enberg wrote:
> 
> Then we might as well return your regular NULL pointer for zero-length
> allocations as you can't do anything sane with ZERO_SIZE_PTR either.


No. NULL really _is_ special.

We use NULL in tons of places for saying "we haven't allocated anything at 
all".

That's *not* the same as saying "we have initialized this pointer, it just 
happens to point to a zero-sized object".

Two *totally* different things. I don't understand why people mix them up.

We literally have code that tests pointers for NULL to determine if the 
subsystem has been initialized.

In other words: YOU MUST NOT RETURN NULL FOR A "SUCCESSFUL POINTER 
ALLOCATION", regardless of the size.

Yeah, yeah, I realize that the C library traditionally allows it, and user 
space is used to it, but it's still wrong and stupid. We can do so much 
better.

When malloc() returns NULL, it means that it failed. 

When a pointer is NULL, it means that it doesn't exist.

And ZERO_SIZE_PTR is _neither_ of those cases!

		Linus
