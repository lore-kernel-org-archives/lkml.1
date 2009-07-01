Return-Path: <linux-kernel-owner+w=401wt.eu-S1753933AbZGAUVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbZGAUVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 16:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbZGAUVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 16:21:31 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:33076 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbZGAUVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 16:21:31 -0400
Message-ID: <4A4BC532.3020503@novell.com>
Date: Wed, 01 Jul 2009 16:21:06 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: kvm@vger.kernel.org
CC: linux-kernel@vger.kernel.org, mst@redhat.com, avi@redhat.com,
       davidel@xmailserver.org
Subject: Re: [KVM PATCH v8 1/3] KVM: Fix races in irqfd using new eventfd_kref_get
 interface
References: <20090701160208.3615.99153.stgit@dev.haskins.net> <20090701160902.3615.39426.stgit@dev.haskins.net>
In-Reply-To: <20090701160902.3615.39426.stgit@dev.haskins.net>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6793E3A6F21A5F77709B618F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6793E3A6F21A5F77709B618F
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> =20
> +	eventfd =3D eventfd_ctx_fileget(file);
> +	if (IS_ERR(file)) {
> +		ret =3D PTR_ERR(file);
> +		goto fail;
> +	}
> +
> +	irqfd->eventfd =3D eventfd;
> +
>  =20

<sigh>

Just noticed the typo (return "eventfd" but error-check "file").  Looks
like I will need at least a v9.  Is there any other feedback before I
push out the fix for v8?

-Greg


--------------enig6793E3A6F21A5F77709B618F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpLxTcACgkQlOSOBdgZUxnjNACfdzvshURJeHfpdbTZWycskgKd
i0sAnAxbo29oQaQNVibFHRbzHQfUihQU
=Ypvj
-----END PGP SIGNATURE-----

--------------enig6793E3A6F21A5F77709B618F--
