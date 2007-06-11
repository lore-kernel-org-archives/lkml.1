Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbXFKScm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbXFKScm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 14:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbXFKScg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 14:32:36 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38418 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751026AbXFKScf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 14:32:35 -0400
Date: Mon, 11 Jun 2007 11:32:33 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>
cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: kernel BUG at mm/slub.c:3689!
In-Reply-To: <1defaf580706111122n78ab46c3sda05cbd4ace97319@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706111129270.18327@schroedinger.engr.sgi.com>
References: <20070611161926.2a9f8efd@dhcp-255-175.norway.atmel.com> 
 <Pine.LNX.4.64.0706110918340.15466@schroedinger.engr.sgi.com> 
 <1defaf580706110943q56d83939t9ab6331cc45b4810@mail.gmail.com> 
 <Pine.LNX.4.64.0706110946430.15910@schroedinger.engr.sgi.com> 
 <1defaf580706111011w641b26fbu68d6d34028f6e953@mail.gmail.com> 
 <Pine.LNX.4.64.0706111041160.17264@schroedinger.engr.sgi.com>
 <1defaf580706111122n78ab46c3sda05cbd4ace97319@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1700579579-700153460-1181586753=:18327"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1700579579-700153460-1181586753=:18327
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 11 Jun 2007, H=E5vard Skinnemoen wrote:

> > Note that I do not get why you would be aligning the objects to 32 byte=
s.
> > Increasing the smallest cache size wastes a lot of memory. And it is
> > usually advantageous if multiple related objects are in the same cachel=
ine
> > unless you have heavy SMP contention.
>=20
> It's not about performance at all, it's about DMA buffers allocated
> using kmalloc() getting corrupted. Imagine this:

Uhhh... How about using a separate slab for the DMA buffers?
=20
> Maybe there are other solutions to this problem, but the old SLAB
> allocator did guarantee 32-byte alignment as long as SLAB debugging
> was turned off, so setting ARCH_KMALLOC_MINALIGN seemed like the
> easiest way to get back to the old, known-working behaviour.

SLABs mininum object size is 32 thus you had no problems. I see. SLAB=20
does not guarantee 32 byte alignment. It just happened to work. If you=20
switch on CONFIG_SLAB_DEBUG you will likely get into trouble.

So I'd suggest to set up a special slab for your DMA buffers.
---1700579579-700153460-1181586753=:18327--
