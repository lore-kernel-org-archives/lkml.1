Return-Path: <linux-kernel-owner+w=401wt.eu-S1756523AbXFDOm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523AbXFDOm7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 10:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755275AbXFDOmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 10:42:52 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39723 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754845AbXFDOmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 10:42:51 -0400
Date: Mon, 4 Jun 2007 15:44:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matt Mackall <mpm@selenic.com>
Cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, jeremy@goop.org
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
Message-ID: <20070604154424.5c4750f7@the-village.bc.nu>
In-Reply-To: <20070603161528.GO11166@waste.org>
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com>
	<20070601204141.f84ad72f.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706012057580.11358@schroedinger.engr.sgi.com>
	<20070601213117.1178e8e0.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706012139480.11577@schroedinger.engr.sgi.com>
	<20070603161528.GO11166@waste.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > I agree the risk is low, but if something _does_ blow up, it will do so subtly.
> 
> Arguable the proposed badptr behavior is correct. It's basically "how many
> angels can dance on the head of a pin"? All the returned pointers are
> at least 0 bytes away from the previous one.

C++ very carefully keeps objects of zero size at differing addresses to
avoid exactly this kind of pointer confusion. Given the trivial fix is
simply

	size += !size;

at the start of malloc what is there worth arguing about ?

