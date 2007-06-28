Return-Path: <linux-kernel-owner+w=401wt.eu-S1763622AbXF1Qdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763622AbXF1Qdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 12:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758536AbXF1Qdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 12:33:41 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:57344 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756745AbXF1Qdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 12:33:40 -0400
Subject: Re: [RFC/PATCH] debug workqueue deadlocks with lockdep
From: Johannes Berg <johannes@sipsolutions.net>
To: Ingo Molnar <mingo@redhat.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1182969638.4769.56.camel@johannes.berg>
References: <1182969638.4769.56.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-uMpuGcvJ42F0wUS/qSa5"
Date: Thu, 28 Jun 2007 18:33:49 +0200
Message-Id: <1183048429.4089.1.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-uMpuGcvJ42F0wUS/qSa5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-06-27 at 20:40 +0200, Johannes Berg wrote:

> --- linux-2.6-git.orig/kernel/workqueue.c	2007-06-27 19:10:35.183199046 +=
0200
> +++ linux-2.6-git/kernel/workqueue.c	2007-06-27 20:30:00.896667168 +0200
> @@ -61,8 +61,15 @@ struct workqueue_struct {
>  	const char *name;
>  	int singlethread;
>  	int freezeable;		/* Freeze threads during suspend */
> +#ifdef CONFIG_LOCKDEP
> +	struct lockdep_map lockdep_map;
> +#endif
>  };
> =20
> +#ifdef CONFIG_LOCKDEP
> +static struct lock_class_key wq_lockdep_key;
> +#endif

I think I misunderstood how lockdep works because the output was
actually wrong, should the key be part of the workqueue_struct as well?

johannes

--=-uMpuGcvJ42F0wUS/qSa5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGg+Lt/ETPhpq3jKURAgK7AKCTY4e2N/M+4rWX8PrM8Toyuq+LZACgiPDn
9TjECpFb/ZM3wuUpmYdOhRk=
=OmGJ
-----END PGP SIGNATURE-----

--=-uMpuGcvJ42F0wUS/qSa5--

