Return-Path: <linux-kernel-owner+w=401wt.eu-S1759288AbXFDRPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759288AbXFDRPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 13:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757939AbXFDRPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 13:15:40 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55672 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757719AbXFDRPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 13:15:40 -0400
Date: Mon, 4 Jun 2007 18:20:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       jeremy@goop.org
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
Message-ID: <20070604182025.558a8d10@the-village.bc.nu>
In-Reply-To: <alpine.LFD.0.98.0706040924070.23741@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com>
	<20070601204141.f84ad72f.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706012057580.11358@schroedinger.engr.sgi.com>
	<20070601213117.1178e8e0.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706012139480.11577@schroedinger.engr.sgi.com>
	<84144f020706040808t4882f961t80b8d8eb145bfa50@mail.gmail.com>
	<Pine.LNX.4.64.0706040916090.23191@schroedinger.engr.sgi.com>
	<84144f020706040922v56cb10eg5a730b4abe9d5251@mail.gmail.com>
	<alpine.LFD.0.98.0706040924070.23741@woody.linux-foundation.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The thing is, why *should* we care about comparing addresses? We'll give 

Because people use it to tell objects apart. All over the kernel we do
things like

	if (inode1 == inode2)

to figure out if they are the same inode. Now inodes are not zero sized
so we are safe there

> the right result (you got many perfectly separate allocations, they're 
> just zero bytes apart, exactly like you asked for!). The fact that C++ has 
> some semantics for it is not a good argument 

Its the usual semantic in languages that use a pointer as an object
handle. C is actually the oddity here, the other languages use it to
avoid aliasing of object handles and the resulting confusion.

Clearly we do need an option to make the kernel explode when misusing
such pointers for debugging whatever the default for other behaviour is.
And on a 64bit box we probably have enough address space to hand out a
few million unique faulting pointers.
