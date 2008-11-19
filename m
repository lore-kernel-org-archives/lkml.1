Return-Path: <linux-kernel-owner+w=401wt.eu-S1752977AbYKSWTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977AbYKSWTX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 17:19:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbYKSWTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 17:19:14 -0500
Received: from rv-out-0506.google.com ([209.85.198.232]:40917 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbYKSWTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 17:19:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Jj9uyFoOejkdUf0N47USOu5e7QFebnIqUF2POFcJIJwA/AdH03SStwxW1KB6Sxrxo6
         6Zr0WhkDYaU41o1mMThq9eoAjqe4ojgvb7FKbe1gjF/PWMMgXBReRDR0wSVRvzIcZhZD
         WYB4r5j8IqrtA+HtEAi0IEy6jxcWGnrBaNJgw=
Message-ID: <19f34abd0811191419x3f6981ady7de5bf40f9ae2983@mail.gmail.com>
Date: Wed, 19 Nov 2008 23:19:12 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Brian Phelps" <lm317t@gmail.com>
Subject: Re: kernel BUG at mm/slab.c:601
Cc: linux-kernel@vger.kernel.org, "Al Viro" <viro@zeniv.linux.org.uk>,
       "Mikael Pettersson" <mikpe@it.uu.se>,
       "Alexander Shaduri" <ashaduri@gmail.com>,
       "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <ea3b75ed0811181524y7cdad2afl85e0281e293922cc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ea3b75ed0811181524y7cdad2afl85e0281e293922cc@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2008 at 12:24 AM, Brian Phelps <lm317t@gmail.com> wrote:
> This possible kernel bug (see bottom) is very reproducible when the
> pci bus gets loaded with traffic, specifically video data.
> It has been reproduced on 2 identical machines.
>
> Please let me know if you need more information

Hi,

Can you reproduce this with CONFIG_DEBUG_SLAB=y?

Can you reproduce this with CONFIG_SLUB=y instead of SLAB? If not,
could be a genuine bug in SLAB (but I doubt it). If yes, then SLUB
debugging might help us more than SLAB debugging can.

It sounds likely that bttv driver is involved somehow -- it would fit
with your description too. Maybe the fact that the same driver is
serving many devices on the same IRQ? But I guess that shouldn't
really be a problem.

It would also be interesting to see if you can find more different
crashes in other places, like the corrupted page tables. Those are
important clues. Like this:

> [ 2128.370257] PGD 10869067 PUD 23232323 BAD

That looks like a magic number of sorts. This was the only one I could
find, however:

crypto/anubis.c:      0x83838383U, 0x1b1b1b1bU, 0x0e0e0e0eU, 0x23232323U,

But google has some more info. A google for "23232323 bug" turned up
this thread:

http://lkml.org/lkml/2008/1/5/51

...which also involves bttv driver. I've added the Ccs of that discussion.

But it seems that it is not a regression at least. Did you try earlier
kernels as well?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
