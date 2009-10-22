Return-Path: <linux-kernel-owner+w=401wt.eu-S1751956AbZJWNfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbZJWNfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 09:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbZJWNfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 09:35:04 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:43325 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbZJWNfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 09:35:01 -0400
Subject: Re: 2.6.32-rc5-git1 -- INFO: possible circular locking dependency
 detected
From: Johannes Berg <johannes@sipsolutions.net>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Holger Schurig <hs4233@mail.mn-solutions.de>,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>
In-Reply-To: <4ADDBD2A.7070807@gmail.com>
References: <4ADDBD2A.7070807@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-NdW1pWgTUZ4H1OMPV1Od"
Date: Thu, 22 Oct 2009 10:34:43 +0200
Message-Id: <1256200483.12174.16.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NdW1pWgTUZ4H1OMPV1Od
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-10-20 at 09:37 -0400, Miles Lane wrote:
> Resending with wrapping off and time info removed:

Hey, thanks for that!

> [ INFO: possible circular locking dependency detected ]
>  2.6.32-rc5-git1 #1
>  -------------------------------------------------------
>  events/0/9 is trying to acquire lock:
>   (&rfkill->sync_work){+.+.+.}, at: [<c1039083>]=20
> __cancel_work_timer+0x81/0x181
> =20
>  but task is already holding lock:
>   (&ehotk->hotplug_lock){+.+.+.}, at: [<f8587708>]=20
> eeepc_rfkill_hotplug+0x45/0xda [eeepc_laptop]
> =20
>  which lock already depends on the new lock.
> =20
>=20
>  the existing dependency chain (in reverse order) is:
> =20
>  -> #2 (&ehotk->hotplug_lock){+.+.+.}:

>         [<c129e5ee>] mutex_lock_nested+0x2b/0x33
>         [<f8587708>] eeepc_rfkill_hotplug+0x45/0xda [eeepc_laptop]
>         [<f858787c>] eeepc_rfkill_set+0x1d/0x2d [eeepc_laptop]
>         [<f83f4a9f>] rfkill_set_block+0x6f/0xb1 [rfkill]
>         [<f83f4b78>] __rfkill_switch_all+0x2e/0x51 [rfkill]
>         [<f83f4c12>] rfkill_switch_all+0x33/0x41 [rfkill]
>         [<f83f51b0>] rfkill_op_handler+0xf0/0x11e [rfkill]
>         [<c1038965>] worker_thread+0x161/0x233
>         [<c103b883>] kthread+0x5f/0x64
>         [<c1003613>] kernel_thread_helper+0x7/0x10
> =20
>  -> #1 (rfkill_global_mutex){+.+.+.}:
>         [<c104ac60>] __lock_acquire+0x9fb/0xb6d
>         [<c104ae2e>] lock_acquire+0x5c/0x73
>         [<c129e223>] __mutex_lock_common+0x39/0x375
>         [<c129e5ee>] mutex_lock_nested+0x2b/0x33
>         [<f83f4c36>] rfkill_sync_work+0x16/0x35 [rfkill]

Hmm. It seems eeepc takes the hotplug lock in the set path, but also
elsewhere? Seems like a bug in eeepc, Alan?

johannes

--=-NdW1pWgTUZ4H1OMPV1Od
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK4BkgAAoJEODzc/N7+QmaxfAP/RtscsXQS99FqXPywJe4K4H+
6G0ottiBxCxjleJ98aOGnUN5SZaMNQJ9VjDNCEuguiIUac3bTTvmRFGyc5jFHTkr
3YeITUAxGCnJGYv9hcrOPohBaNQBBiNbhB634sF128rZLAk7+a4xEZyRaNY3l7Of
jrC0dXzFGa9sNEcXZSSwNYXQtyOtVCclGiSisVlZnCv5+wA5h7wgAUqkndOXgk0U
sAZGFhVK208JuSyPHH7nq3IvXp8b9/QcuwYfE5ZlV5bW9P9vxSLEGdKQyLxouKH+
QFJd1smh1l6yI2PKfEMpXZecxzzw3K/P4X+IE7qT8K2ADVRhhwyPGFvRdDa8rQmg
2+JOb7v0XiCg42G+MW2/nmeNgHm5y87yfL/o3ESKNyJKhqLNFVgyIlrnFz2+3wR3
AhZNyifxdAJKSiFXF/5TVtwbLDdod1rqFolGUz6oGN2FH6x2mzzGgqyTR/FzuaOP
+daBWVnHp3XyMLSVzGWD8sHinGLSrVU8bjqEEaSNIHrooKuMuv4uYVE1IyKlHgwj
U/mj2ieONVlHq1Gi+pM+7jQwBUM/XNHxxeLRco77tg7UyF7BnKGx9y4WeNVAVH2T
KZ7/Sj5phHfTk+amVVFhHyTzFsa5blIVVP6gexJLm4rFmHLo+UTcQjbuwmoJt0UY
6uUFIkZiWgBoIdUIWZQ5
=sx87
-----END PGP SIGNATURE-----

--=-NdW1pWgTUZ4H1OMPV1Od--

