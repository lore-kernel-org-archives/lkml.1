Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992AbZB1RMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbZB1RMV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 12:12:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbZB1RMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 12:12:07 -0500
Received: from mga01.intel.com ([192.55.52.88]:38891 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514AbZB1RMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 12:12:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,282,1233561600"; 
   d="asc'?scan'208";a="434982807"
Subject: Re: i915 X lockup
From: Keith Packard <keith.packard@intel.com>
Reply-To: keith.packard@intel.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Keith Packard <keith.packard@intel.com>, Jiri Slaby <jirislaby@gmail.com>,
       Eric Anholt <eric@anholt.net>, Sitsofe Wheeler <sitsofe@yahoo.com>,
       airlied@linux.ie, dri-devel@lists.sourceforge.net,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <20090228004751.96d1ea8d.akpm@linux-foundation.org>
References: <49A7B253.906@gmail.com>
	 <20090227023231.76e7c65f.akpm@linux-foundation.org>
	 <20090227130440.GA24633@silver.sucs.org> <49A7EF52.8080105@gmail.com>
	 <20090227231207.GA4687@silver.sucs.org> <1235780431.6992.14.camel@gaiman>
	 <49A8F660.10604@gmail.com>
	 <20090228004751.96d1ea8d.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+xa1vpZP1IXxfBBHor29"
Organization: Intel Corp
Date: Sat, 28 Feb 2009 09:11:58 -0800
Message-Id: <1235841119.4162.5.camel@aiko.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+xa1vpZP1IXxfBBHor29
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-02-28 at 00:47 -0800, Andrew Morton wrote:

> The kernel deadlocked on struct_mutex, did it not?  That's a kernel bug
> regardless of what userspace you're running.

No, it didn't deadlock on struct_mutex, it deadlocked because the
hardware got wedged, and we still don't know how to unwedge the hardware
and get it working again other than turning it off and back on again.

> Do we know why this happened?

Yes, the hardware will happily lock up when user space maps the PCI BAR
covering the device registers and the application pokes various internal
device registers directly.

That's the fundamental contract KMS requires -- if the kernel is going
to manage the device, then user space isn't supposed to manipulate it
directly anymore.

I suspect most any other device in the machine could be made to do 'bad
things' if userspace went and poked it directly.

--=20
keith.packard@intel.com

--=-+xa1vpZP1IXxfBBHor29
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJqXBbQp8BWwlsTdMRAvvdAJ9WDIDl8P7FyXzMkjNZtAHKfGW5cgCcDmqI
JVRS3lagO8wAhgkzmUQH4bs=
=Ms6R
-----END PGP SIGNATURE-----

--=-+xa1vpZP1IXxfBBHor29--

