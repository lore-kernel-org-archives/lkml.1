Return-Path: <linux-kernel-owner+w=401wt.eu-S932861AbXKOXvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861AbXKOXvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 18:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757592AbXKOXvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 18:51:09 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:51142 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755696AbXKOXvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 18:51:08 -0500
X-Sasl-enc: +TlrtByyWHjPRtKhhbe3qzHK5iPfg5VBxhVkxnvSoKuh 1195170665
Message-ID: <473CDB91.8010808@imap.cc>
Date: Fri, 16 Nov 2007 00:51:45 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-usb-devel@lists.sourceforge.net, hjlipp@web.de, kkeil@suse.de,
       i4ldeveloper@listserv.isdn4linux.de
Subject: Re: [PATCH 3/4] bas_gigaset: suspend support (v2)
References: <20071112-patch0@xenon.ts.pxnet.com>	<20071112-patch3@xenon.ts.pxnet.com> <20071115145022.99f9abbc.akpm@linux-foundation.org>
In-Reply-To: <20071115145022.99f9abbc.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE5926063426471DB186232A4"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE5926063426471DB186232A4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 15.11.2007 23:50 schrieb Andrew Morton:
>> ...
>>
>> +	if (atomic_read(&cs->hw.bas->basstate) & BS_SUSPEND) {
>=20
> that's pretty peculiar.  We'd only expect to see atomics being used in
> conjunction with atomic_add/sub/inc/etc.  Here the driver is using an
> atomic_t as a state variable.  And here's the magic bit:
>=20
> 	spin_lock_irqsave(&ucs->lock, flags);
> 	state =3D atomic_read(&ucs->basstate);
> 	atomic_set(&ucs->basstate, (state & ~clear) | set);
> 	spin_unlock_irqrestore(&ucs->lock, flags);
>=20
> I'm suspecting that a plain old `int' would be more appropriate here.

You're right. That's a prehistoric leftover. That variable was
originally accessed using atomic_set_mask() and atomic_clear_mask()
which are unfortunately x86 platform specific.

I'll prepare a cleanup patch.

Thanks,
Tilman

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigE5926063426471DB186232A4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHPNubMdB4Whm86/kRAg+jAJsGQwziVlJ4/qOuorGbWAf1JjULaQCfZ8Tc
v3qH/XYtx4CGE5zaGI+VNpw=
=J3wk
-----END PGP SIGNATURE-----

--------------enigE5926063426471DB186232A4--
