Return-Path: <linux-kernel-owner+w=401wt.eu-S1754687AbZKCRcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbZKCRcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 12:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbZKCRcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 12:32:15 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:54421 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648AbZKCRcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 12:32:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=V5xLl8zMGOLQDEXWt7ct0LKmOIF91iQrBeCunz7etG5GSgpS1X9Ja9/UfywtQR3fhd
         UAIS4NqJT/vFdcKSWZRSbsfHh0qx3tjkqQou0xglsn8Cx5Um90cMQEMFgerxhxHo0jD/
         ZCZUcDXNVIOeZtefjMsrT3OBVIeodcBXFxdls=
Message-ID: <4AF06911.6040200@gmail.com>
Date: Tue, 03 Nov 2009 12:32:01 -0500
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-mm@kvack.org, akpm@linux-foundation.org, hpa@zytor.com,
       Rusty Russell <rusty@rustcorp.com.au>, s.hetze@linux-ag.com
Subject: Re: [PATCHv7 2/3] mm: export use_mm/unuse_mm to modules
References: <cover.1257267892.git.mst@redhat.com> <20091103172411.GC5591@redhat.com>
In-Reply-To: <20091103172411.GC5591@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig598D640FFD0D66019E041E55"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig598D640FFD0D66019E041E55
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> vhost net module wants to do copy to/from user from a kernel thread,
> which needs use_mm. Export it to modules.
>=20
> Acked-by: Andrea Arcangeli <aarcange@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

I need this too:

Acked-by: Gregory Haskins <ghaskins@novell.com>

> ---
>  mm/mmu_context.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>=20
> diff --git a/mm/mmu_context.c b/mm/mmu_context.c
> index ded9081..0777654 100644
> --- a/mm/mmu_context.c
> +++ b/mm/mmu_context.c
> @@ -5,6 +5,7 @@
> =20
>  #include <linux/mm.h>
>  #include <linux/mmu_context.h>
> +#include <linux/module.h>
>  #include <linux/sched.h>
> =20
>  #include <asm/mmu_context.h>
> @@ -37,6 +38,7 @@ void use_mm(struct mm_struct *mm)
>  	if (active_mm !=3D mm)
>  		mmdrop(active_mm);
>  }
> +EXPORT_SYMBOL_GPL(use_mm);
> =20
>  /*
>   * unuse_mm
> @@ -56,3 +58,4 @@ void unuse_mm(struct mm_struct *mm)
>  	enter_lazy_tlb(mm, tsk);
>  	task_unlock(tsk);
>  }
> +EXPORT_SYMBOL_GPL(unuse_mm);



--------------enig598D640FFD0D66019E041E55
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkrwaRIACgkQP5K2CMvXmqGMiACeN0+/nU4v8+3SYnFHbPpWW7yY
+YMAoIolyA+MA43fNvoJCMg/0hjy8eFS
=oNu+
-----END PGP SIGNATURE-----

--------------enig598D640FFD0D66019E041E55--
