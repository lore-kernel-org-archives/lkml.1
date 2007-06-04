Return-Path: <linux-kernel-owner+w=401wt.eu-S1758467AbXFDQ1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467AbXFDQ1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 12:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756693AbXFDQ1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 12:27:00 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756515AbXFDQ1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 12:27:00 -0400
Date: Mon, 4 Jun 2007 09:26:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       jeremy@goop.org
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
In-Reply-To: <84144f020706040922v56cb10eg5a730b4abe9d5251@mail.gmail.com>
Message-ID: <alpine.LFD.0.98.0706040924070.23741@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com> 
 <20070601204141.f84ad72f.akpm@linux-foundation.org> 
 <Pine.LNX.4.64.0706012057580.11358@schroedinger.engr.sgi.com> 
 <20070601213117.1178e8e0.akpm@linux-foundation.org> 
 <Pine.LNX.4.64.0706012139480.11577@schroedinger.engr.sgi.com> 
 <84144f020706040808t4882f961t80b8d8eb145bfa50@mail.gmail.com> 
 <Pine.LNX.4.64.0706040916090.23191@schroedinger.engr.sgi.com>
 <84144f020706040922v56cb10eg5a730b4abe9d5251@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 4 Jun 2007, Pekka Enberg wrote:
> 
> Ok, makes sense. I guess I might as well throw my suggestion in the
> mix. Lets create a new kmalloc cache for zero-length objects where
> object size is zero but there are regular red-zones on both sides.

Well, the red-zones won't catch readers, and more importantly, even for 
writers they are *really* inconvenient, because it will just tell you 
something bad happened, it won't tell you *where* it happened.

Since comparing the addresses of two zero-sized allocations is insane and 
not done _anyway_, it's just much better to return an invalid address.

The thing is, why *should* we care about comparing addresses? We'll give 
the right result (you got many perfectly separate allocations, they're 
just zero bytes apart, exactly like you asked for!). The fact that C++ has 
some semantics for it is not a good argument - C++ is a broken language, 
and it's not the language we use for the kernel anyway.

		Linus
