Return-Path: <linux-kernel-owner+w=401wt.eu-S1762948AbXKMVwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762948AbXKMVwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 16:52:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761151AbXKMVwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 16:52:24 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45741 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757611AbXKMVwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 16:52:21 -0500
Date: Tue, 13 Nov 2007 13:52:17 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
cc: Ray Lee <ray-lk@madrabbit.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@csn.ul.ie>, Andi Kleen <ak@suse.de>,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: x86_64: Make sparsemem/vmemmap the default memory model
In-Reply-To: <20071113204100.GB20167@lazybastard.org>
Message-ID: <Pine.LNX.4.64.0711131349300.3714@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711121549370.29178@schroedinger.engr.sgi.com>
 <200711130059.34346.ak@suse.de> <Pine.LNX.4.64.0711121615120.29328@schroedinger.engr.sgi.com>
 <200711130149.54852.ak@suse.de> <Pine.LNX.4.64.0711121940410.30269@schroedinger.engr.sgi.com>
 <2c0942db0711122027m5b11502cveded5705c0bc4f64@mail.gmail.com>
 <Pine.LNX.4.64.0711122040380.30724@schroedinger.engr.sgi.com>
 <20071113204100.GB20167@lazybastard.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1700579579-1724930940-1194990737=:3714"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1700579579-1724930940-1194990737=:3714
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 13 Nov 2007, J=F6rn Engel wrote:

> On Mon, 12 November 2007 20:41:10 -0800, Christoph Lameter wrote:
> > On Mon, 12 Nov 2007, Ray Lee wrote:
> >=20
> > > Discontig obviously needs to die. However, FlatMem is consistently
> > > faster, averaging about 2.1% better overall for your numbers above. I=
s
> > > the page allocator not, erm, a fast path, where that matters?
> > >=20
> > > Order=09Flat=09Sparse=09% diff
> > > 0=09639=09641=090.3
> >=20
> > IMHO Order 0 currently matters most and the difference is negligible=20
> > there.
>=20
> Is it?  I am a bit concerned about the non-monotonic distribution.
> Difference starts a near-0, grows to 4.4, drops to near-0, grows to 4.9,
> drops to near-0.

The problem also is that the comparison here is between a SMP config for=20
flatmem vs a NUMA config for sparsemem. There is additional overhead in=20
the NUMA config.=20

The effect may also be due to the system being able to place=20
some pages in the same 2MB section as the memmap with flatmem. However,=20
that is only feasable immeidately after bootup. In regular operations this=
=20
should vanish.

Could you run your own test to verify?

> Is there an explanation for this behaviour?  More to the point, could
> repeated runs also return 4% difference for order-0?

I hope I have given some above. The number of the page allocator suggests=
=20
that we have far too much fat in the allocation paths. IMHO reasonable=20
numbers for an order-0 alloc should be ~100 cycles.
---1700579579-1724930940-1194990737=:3714--
