Return-Path: <linux-kernel-owner+w=401wt.eu-S933801AbXILKxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933801AbXILKxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 06:53:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763580AbXILKw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 06:52:58 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:52743 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754438AbXILKw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 06:52:57 -0400
Subject: Re: [RFC 0/3] Recursive reclaim (on __PF_MEMALLOC)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <npiggin@suse.de>, Daniel Phillips <phillips@phunq.net>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, dkegel@google.com,
       David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0709050507050.9141@schroedinger.engr.sgi.com>
References: <20070814142103.204771292@sgi.com>
	 <200709050220.53801.phillips@phunq.net>
	 <Pine.LNX.4.64.0709050334020.8127@schroedinger.engr.sgi.com>
	 <20070905114242.GA19938@wotan.suse.de>
	 <Pine.LNX.4.64.0709050507050.9141@schroedinger.engr.sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fwTWZsqKRH87p+p9kV5z"
Date: Wed, 12 Sep 2007 12:52:53 +0200
Message-Id: <1189594373.21778.114.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fwTWZsqKRH87p+p9kV5z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-09-05 at 05:14 -0700, Christoph Lameter wrote:

> Using the VM to throttle networking is a pretty bad thing because it=20
> assumes single critical user of memory. There are other consumers of=20
> memory and if you have a load that depends on other things than networkin=
g=20
> then you should not kill the other things that want memory.

The VM is a _critical_ user of memory. And I dare say it is the _most_
important user.=20

Every user of memory relies on the VM, and we only get into trouble if
the VM in turn relies on one of these users. Traditionally that has only
been the block layer, and we special cased that using mempools and
PF_MEMALLOC.

Why do you object to me doing a similar thing for networking?

The problem of circular dependancies on and with the VM is rather
limited to kernel IO subsystems, and we only have a limited amount of
them.=20

You talk about something generic, do you mean an approach that is
generic across all these subsystems?

If so, my approach would be it, I can replace mempools as we have them
with the reserve system I introduce.

--=-fwTWZsqKRH87p+p9kV5z
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBG58UFXA2jU0ANEf4RAqXpAJ44gtG8i0f0sDb01hlz1LO6naSWxwCeKVHT
7tMfY7TCD8CZ0+7xxNzhd/w=
=qyn1
-----END PGP SIGNATURE-----

--=-fwTWZsqKRH87p+p9kV5z--

