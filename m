Return-Path: <linux-kernel-owner+w=401wt.eu-S1759899AbXFDSXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759899AbXFDSXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 14:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757386AbXFDSX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 14:23:28 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:45233 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756847AbXFDSX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 14:23:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=c3DiuWsuNLi1zMLbdJSV+QJkUeSKfK5cKrcz/1oHj/CnBk1u10u74ymfUHCAhPdoSgoXJmiQ5T/9DUPVewRIilJlMkomSEOyoF0ekgIHYN0K2MRTRyZ7H/BGPdgimE24CDzO153QH8/cIU5APT7q8QeKr5PDqOc6qr+0trNCJTU=
Date: Mon, 4 Jun 2007 22:22:08 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       jeremy@goop.org
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
Message-ID: <20070604182208.GB10438@cvg>
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com> <20070601204141.f84ad72f.akpm@linux-foundation.org> <Pine.LNX.4.64.0706012057580.11358@schroedinger.engr.sgi.com> <20070601213117.1178e8e0.akpm@linux-foundation.org> <Pine.LNX.4.64.0706012139480.11577@schroedinger.engr.sgi.com> <84144f020706040808t4882f961t80b8d8eb145bfa50@mail.gmail.com> <Pine.LNX.4.64.0706040916090.23191@schroedinger.engr.sgi.com> <84144f020706040922v56cb10eg5a730b4abe9d5251@mail.gmail.com> <alpine.LFD.0.98.0706040924070.23741@woody.linux-foundation.org> <84144f020706040937xb06535em543fa887ad65ee8f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020706040937xb06535em543fa887ad65ee8f@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Pekka Enberg - Mon, Jun 04, 2007 at 07:37:01PM +0300]
| On 6/4/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
| >Well, the red-zones won't catch readers, and more importantly, even for
| >writers they are *really* inconvenient, because it will just tell you
| >something bad happened, it won't tell you *where* it happened.
| 
| True.
| 
| On 6/4/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
| >Since comparing the addresses of two zero-sized allocations is insane and
| >not done _anyway_, it's just much better to return an invalid address.
| 
| Then we might as well return your regular NULL pointer for zero-length
| allocations as you can't do anything sane with ZERO_SIZE_PTR either.

Hi Pekka,

you know, I'm absolutely agree with you. Hey, kernel hackers don't blame
me ;). But lets just take an example from a real life: I'm asking for
someone to give me 50 cents he would probably give me this. But if I'm
asking someone to give me 0 cents - he''ll give me nothing!!! Nobody
giving me a spec. papper on which "zero cents" is written. :)
So the code

	p = kmalloc(0);
	if (!p) {
		return -ENOMEM;
	}

is absolutely right - we physically have _no_ zero-sized memory. And as result
we have no reason to keep spec. slab to track zero-sized allocs.

Please, don't get me wrong, I'm not a kernel specialist...
And sorry for meddling into coversation.

		Cyrill

