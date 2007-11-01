Return-Path: <linux-kernel-owner+w=401wt.eu-S1759246AbXKAM7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759246AbXKAM7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 08:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755079AbXKAM7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 08:59:08 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:47692 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754297AbXKAM7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 08:59:07 -0400
Date: Thu, 1 Nov 2007 05:59:06 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [patch 1/7] allocpercpu: Make it a true per cpu allocator by
 allocating from a per cpu array
In-Reply-To: <47297F42.4050603@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0711010557340.27666@schroedinger.engr.sgi.com>
References: <20071101000211.970501947@sgi.com> <20071101000309.765254518@sgi.com>
 <47297F42.4050603@cosmosbay.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1700579579-1776251518-1193921946=:27666"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1700579579-1776251518-1193921946=:27666
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 1 Nov 2007, Eric Dumazet wrote:

> Christoph Lameter a =E9crit :
> > +
> > +enum unit_type { FREE, END, USED };
> > +
> > +static u8 cpu_alloc_map[UNITS_PER_CPU] =3D { 1, };
>=20
> You mean END here instead of 1 :)

Sigh. A leftover. This can be removed.

> > +/*
> > + * Allocate an object of a certain size
> > + *
> > + * Returns a per cpu pointer that must not be directly used.
> > + */
> > +static void *cpu_alloc(unsigned long size)
> > +{
>=20
> We might need to give an alignment constraint here. Some per_cpu users wo=
uld
> like to get a 64 bytes zone, siting in one cache line and not two :)

Well not sure about that. Alignment is mostly useful on SMP with cacheline=
=20
contention. This is a per cpu area that should not be contended.

---1700579579-1776251518-1193921946=:27666--
