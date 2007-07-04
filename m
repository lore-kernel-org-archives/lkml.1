Return-Path: <linux-kernel-owner+w=401wt.eu-S1757930AbXGDWsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930AbXGDWsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 18:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755038AbXGDWsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 18:48:11 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:52893 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908AbXGDWsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 18:48:10 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC][PATCH -mm] PM: Do not sync from within the freezer during suspend to RAM
Date: Thu, 5 Jul 2007 08:48:15 +1000
User-Agent: KMail/1.9.6
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Oliver Neukum <oliver@neukum.org>, Pavel Machek <pavel@ucw.cz>,
       Paul Mackerras <paulus@samba.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Ingo Molnar <mingo@elte.hu>
References: <200707041658.59588.rjw@sisk.pl>
In-Reply-To: <200707041658.59588.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7692759.9nY2pkrZJM";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707050848.16163.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart7692759.9nY2pkrZJM
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Thursday 05 July 2007 00:58:58 Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>=20
> The syncing of filesystems from within the freezer in not needed for susp=
end=20
to
> RAM.  Change freeze_processes() so that it doesn't execute sys_sync() and
> introduce the "syncing" version of it to be called from the hibernation c=
ode
> paths.
>=20
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  include/linux/freezer.h |   14 ++++++++++++--
>  kernel/power/disk.c     |    2 +-
>  kernel/power/main.c     |    6 ++++++
>  kernel/power/process.c  |    8 +++++---
>  kernel/power/user.c     |    2 +-
>  5 files changed, 25 insertions(+), 7 deletions(-)

Looks ok, except that I wonder if you want the following fragment. It looks=
 to=20
me (looking at rc6) like with this code, you'll currently call sys_sync twi=
ce=20
when suspending to ram. Maybe I'm misreading it. Also, shouldn't it be done=
=20
after taking the mutex?

Regards,

Nigel

> @@ -231,6 +232,11 @@ static int enter_state(suspend_state_t s
> =20
>  	if (!valid_state(state))
>  		return -ENODEV;
> +
> +	printk("Syncing filesystems ... ");
> +	sys_sync();
> +	printk("done.\n");
> +
>  	if (!mutex_trylock(&pm_mutex))
>  		return -EBUSY;
> =20


=2D-=20
Nigel, Michelle and Alisdair Cunningham
5 Mitchell Street
Cobden 3266
Victoria, Australia

--nextPart7692759.9nY2pkrZJM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGjCOwN0y+n1M3mo0RAmW9AJ9NzS9aCKFkpdexUPU0UzOQ3RIncACePJvx
gxoZJun4JnpmzDREKDC43Fc=
=iP8p
-----END PGP SIGNATURE-----

--nextPart7692759.9nY2pkrZJM--
