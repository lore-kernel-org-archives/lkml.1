Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886AbYICN40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbYICN40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 09:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753261AbYICN4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 09:56:19 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:59701 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbYICN4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 09:56:18 -0400
Date: Wed, 3 Sep 2008 15:56:16 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Andrey Mirkin <major@openvz.org>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH 3/9] Introduce context structure needed during
	checkpointing/restart
Message-ID: <20080903135616.GR14473@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
References: <1220439476-16465-1-git-send-email-major@openvz.org> <1220439476-16465-2-git-send-email-major@openvz.org> <1220439476-16465-3-git-send-email-major@openvz.org> <1220439476-16465-4-git-send-email-major@openvz.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-23144-1220450043-0001-2"
Content-Disposition: inline
In-Reply-To: <1220439476-16465-4-git-send-email-major@openvz.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-23144-1220450043-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 03, 2008 at 02:57:50PM +0400, Andrey Mirkin wrote:
> Add functions for context allocation/destroy.
> Introduce functions to read/write image.
> Introduce image header and object header.
>=20

[...]

> diff --git a/cpt/cpt_image.h b/cpt/cpt_image.h
> new file mode 100644
> index 0000000..3d26229
> --- /dev/null
> +++ b/cpt/cpt_image.h
> @@ -0,0 +1,63 @@
> +/*
> + *  Copyright (C) 2008 Parallels, Inc.
> + *
> + *  Author: Andrey Mirkin <major@openvz.org>
> + *
> + *  This program is free software; you can redistribute it and/or
> + *  modify it under the terms of the GNU General Public License as
> + *  published by the Free Software Foundation, version 2 of the
> + *  License.
> + *
> + */
> +
> +#ifndef __CPT_IMAGE_H_
> +#define __CPT_IMAGE_H_ 1
> +
> +enum _cpt_object_type
> +{
> +	CPT_OBJ_TASK =3D 0,
> +	CPT_OBJ_MAX,
> +	/* The objects above are stored in memory while checkpointing */
> +
> +	CPT_OBJ_HEAD =3D 1024,
> +};
> +
> +enum _cpt_content_type {
> +	CPT_CONTENT_VOID,
> +	CPT_CONTENT_ARRAY,
> +	CPT_CONTENT_DATA,
> +	CPT_CONTENT_NAME,
> +	CPT_CONTENT_REF,
> +	CPT_CONTENT_MAX
> +};
> +
> +#define CPT_SIGNATURE0 0x79
> +#define CPT_SIGNATURE1 0x1c
> +#define CPT_SIGNATURE2 0x01
> +#define CPT_SIGNATURE3 0x63
> +
> +struct cpt_head
> +{
> +	__u8	cpt_signature[4];	/* Magic number */
> +	__u32	cpt_hdrlen;		/* Header length */
> +	__u16	cpt_image_major;	/* Format of this file */
> +	__u16	cpt_image_minor;	/* Format of this file */
> +	__u16	cpt_image_sublevel;	/* Format of this file */
> +	__u16	cpt_image_extra;	/* Format of this file */
> +	__u16	cpt_arch;		/* Architecture */
> +	__u16	cpt_pad1;
> +	__u32	cpt_pad2;
> +#define CPT_ARCH_I386		0

Why is this constant precisely defined after the padding?

> +	__u64	cpt_time;		/* Time */
> +} __attribute__ ((aligned (8)));
> +
> +/* Common object header. */
> +struct cpt_object_hdr
> +{
> +	__u64	cpt_len;		/* Size of current chunk of data */
> +	__u16	cpt_type;		/* Type of object */
> +	__u32	cpt_hdrlen;		/* Size of header */
> +	__u16	cpt_content;		/* Content type: array, reference... */

This layout looks a bit awkward for 32bits/64bits compatibility. Maybe put
cpt_hdrlen before cpt_type?

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-23144-1220450043-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIvpeAVKcRuvQ9Q1QRAtwLAKCjFXK7gBYNW+Ccr5j9jYCBwL++gwCeMQy0
uHq74XuyyyA3FIjsPebruj8=
=o02x
-----END PGP SIGNATURE-----

--=_bohort-23144-1220450043-0001-2--
