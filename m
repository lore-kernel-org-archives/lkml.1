Return-Path: <linux-kernel-owner+w=401wt.eu-S1758879AbXFDQhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879AbXFDQhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 12:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757182AbXFDQhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 12:37:04 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:41195 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756372AbXFDQhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 12:37:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=rBMqsvQ3cSTGa82LUAH/ipjJFenBPHmYDOPexcKE1syAOBfc1AlNgz8HjMa1nkGQ4OhF4PGgMnnxBO2YX6U1kQGuhFyJ2TFAmBZhCaNLP1wGEGGUsGSZzzl4gjkjF6XMHxk9LhdVEMmPw1MC3vk3wnIwgIAdrIiVuuKexfmkrmc=
Message-ID: <84144f020706040937xb06535em543fa887ad65ee8f@mail.gmail.com>
Date: Mon, 4 Jun 2007 19:37:01 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
Cc: "Christoph Lameter" <clameter@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, jeremy@goop.org
In-Reply-To: <alpine.LFD.0.98.0706040924070.23741@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com>
	 <20070601204141.f84ad72f.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0706012057580.11358@schroedinger.engr.sgi.com>
	 <20070601213117.1178e8e0.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0706012139480.11577@schroedinger.engr.sgi.com>
	 <84144f020706040808t4882f961t80b8d8eb145bfa50@mail.gmail.com>
	 <Pine.LNX.4.64.0706040916090.23191@schroedinger.engr.sgi.com>
	 <84144f020706040922v56cb10eg5a730b4abe9d5251@mail.gmail.com>
	 <alpine.LFD.0.98.0706040924070.23741@woody.linux-foundation.org>
X-Google-Sender-Auth: 774b40f83daef432
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/4/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> Well, the red-zones won't catch readers, and more importantly, even for
> writers they are *really* inconvenient, because it will just tell you
> something bad happened, it won't tell you *where* it happened.

True.

On 6/4/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> Since comparing the addresses of two zero-sized allocations is insane and
> not done _anyway_, it's just much better to return an invalid address.

Then we might as well return your regular NULL pointer for zero-length
allocations as you can't do anything sane with ZERO_SIZE_PTR either.
