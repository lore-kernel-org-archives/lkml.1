Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbZARTdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbZARTdd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 14:33:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbZARTdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 14:33:23 -0500
Received: from flock1.newmail.ru ([82.204.219.207]:38559 "HELO
	flock1.newmail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753323AbZARTdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 14:33:23 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [2.6.29-rc2] Inconsistent lock state on resume in hres_timers_resume
Date: Sun, 18 Jan 2009 22:32:43 +0300
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-1avb; KDE/4.1.96; i686; ; )
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <200901181642.00886.arvidjaar@mail.ru> <1232293169.5204.14.camel@laptop> <20090118172511.GA22624@elte.hu>
In-Reply-To: <20090118172511.GA22624@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7007971.8LXhEzKlqZ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200901182232.57186.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart7007971.8LXhEzKlqZ
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 18 =D1=8F=D0=BD=D0=B2=D0=B0=D1=80=D1=8F 2009 20:25:11 Ingo Molnar wrote:

> Rafael, can you think of anything in the s2ram code that would have
>
> changed the irqs-off status of hres_timers_resume() in this codepath:
> > > [17854.688347]  [<c013711a>] hres_timers_resume+0xa/0x10
> > > [17854.688347]  [<c013aa8e>] timekeeping_resume+0xee/0x150
> > > [17854.688347]  [<c0273384>] __sysdev_resume+0x14/0x50
> > > [17854.688347]  [<c0273407>] sysdev_resume+0x47/0x80
> > > [17854.688347]  [<c02791ab>] device_power_up+0xb/0x20
> > > [17854.688347]  [<c015043f>] suspend_devices_and_enter+0xcf/0x150
> > > [17854.688347]  [<c0150c2f>] ? freeze_processes+0x3f/0x90
> > > [17854.688347]  [<c0150614>] enter_state+0xf4/0x140
> > > [17854.688347]  [<c01506dd>] state_store+0x7d/0xc0
>
> ?
>

As far as I can tell, timekeeping_resume is called via class ->resume=20
method; and according to comments in sysdev_resume() and=20
device_power_up(), they are called with interrupts disabled.

Looking at suspend_enter, irqs *are* disabled at this point.

So it actually looks like something (may be some driver) unconditionally=20
enabled irqs in resume path.

I believe the patch should be hold back until this is clarified.

--nextPart7007971.8LXhEzKlqZ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklzg+AACgkQR6LMutpd94yLngCggStzAQESiBe2VWzVq21EP4QP
VkIAn0EhjF7itb49TUH91JC6F9OgA5by
=xo2G
-----END PGP SIGNATURE-----

--nextPart7007971.8LXhEzKlqZ--
