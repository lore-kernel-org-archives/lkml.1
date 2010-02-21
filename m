Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550Ab0BULOv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 06:14:51 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:34166 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab0BULOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 06:14:50 -0500
Subject: Re: [2.6.33-rc5] Weird deadlock when shutting down
From: Johannes Berg <johannes@sipsolutions.net>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <7b6bb4a51002210312o2a1d070aneb54c107aeab6952@mail.gmail.com>
References: <1264740107.20211.53.camel@pasglop>
	 <2375c9f91002192313j3fb84acje4c286c4f86457f3@mail.gmail.com>
	 <1266656213.5347.0.camel@jlt3.sipsolutions.net>
	 <2375c9f91002200106j56b0298ds1a425fde8983d988@mail.gmail.com>
	 <1266665331.12525.0.camel@jlt3.sipsolutions.net>
	 <20100220134447.GA3000@hack>
	 <1266674268.18465.6.camel@jlt3.sipsolutions.net>
	 <2375c9f91002210151i6fe3f769k72a8a6a3485d8cf5@mail.gmail.com>
	 <1266749023.5468.1.camel@jlt3.sipsolutions.net>
	 <7b6bb4a51002210255t5ceaeb84r1438461085446385@mail.gmail.com>
	 <7b6bb4a51002210312o2a1d070aneb54c107aeab6952@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-EWI9mcQBbeUpvIMJ400W"
Date: Sun, 21 Feb 2010 12:14:41 +0100
Message-ID: <1266750881.10419.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EWI9mcQBbeUpvIMJ400W
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2010-02-21 at 19:12 +0800, Xiaotian Feng wrote:
> On Sun, Feb 21, 2010 at 6:55 PM, Xiaotian Feng <xtfeng@gmail.com>
> wrote:
> > On Sun, Feb 21, 2010 at 6:43 PM, Johannes Berg
> > <johannes@sipsolutions.net> wrote:
> >> Incidentally, the machine also freezes hard without any output at
> all if
> >> I "echo 0 > /sys/.../cpu1/online".
> >
> > It might be nothing related with cpufreq. I think there's something
> > wrong during the _cpu_down path.
> > put more debug printks into _cpu_down(), if we can find kernel is
> > stuck in which place in _cpu_down, it would be helpful.
>=20
> and it looks like this breakage is only seen on powerMac G5, so it
> might be arch specific. Maybe some commit in powermac breaks G5's
> cpu_down, just a guess ;-)

Hmm, not sure ... it seems to be in __stop_machine(), in this code:

        printk("got cpu\n");
        for_each_online_cpu(i) {
                sm_work =3D per_cpu_ptr(stop_machine_work, i);
                INIT_WORK(sm_work, stop_cpu);
                queue_work_on(i, stop_machine_wq, sm_work);
        }
        /* This will release the thread on our CPU. */
        put_cpu();
        printk("put cpu\n");


which is weird... the "got cpu" printk is the last thing I see.

johannes

--=-EWI9mcQBbeUpvIMJ400W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLgRWeAAoJEODzc/N7+QmaGmoQAIbdXxUYomOwMTDhe+0lOvDJ
XZ67cAcLh5NdvebMdylB+OiHAq+jzZSPTnacJQTq/69t/THetuJ+ZDav//TgKsVu
Wh/+Xk6LK2084n6Yn6ZtvckCJuESHgl5KoUtRyhDBbrlR0LUELu+M2Rzp15XP/OF
/m8DxwmSKaw3NLNVQZ7Wx8b2SUU58Vvh1rQalWm9bIsGirunOR6QIBeZbNGs7iE5
v/haI64muNEzPHFK3v7fHuI9rhFKcuE7lM6A2AR5Ff/UZ2jLywjIaXMiH+GanM6b
sJ0k5jV1xauf5t+g4y6qLa7eJY/H6na57vANGhBsTw2qrOUqgW9soSfspfTsM6Hl
PDHD/jPWivebPIAMClNcWEiALz21rjGKHEwIX3desDG8bg0dlYg9Q9bkvm22hxuu
++8kf9M9GqCILlmP5HYYDrOMjfbuGjfdyiX64AgEM8DL9m4qy+KJo6uBid0sHQQI
mvC3dqeJhw50iPZiIAbA4FVjm8QV5c8jK1G/WdFrltqeccB8uht84rryw77b6693
nDghs+FJ/sC6WTPyHAvUe4pQG61Iw7U0fs+oJkh1hAnshJdawiqe4pfdHVbzSd2w
uothp2U722kJI0Q3GflyQcOYrge2j6IyVP74xwnY2Hk/y8HMAVpRDo+XPx6G2hS0
gQ23w9aCsP5BkGfe0eGx
=CDro
-----END PGP SIGNATURE-----

--=-EWI9mcQBbeUpvIMJ400W--

