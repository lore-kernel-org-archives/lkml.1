Return-Path: <linux-kernel-owner+w=401wt.eu-S1760865AbXK1N1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760865AbXK1N1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 08:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757335AbXK1N1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 08:27:13 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:52514 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704AbXK1N1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 08:27:12 -0500
Subject: Re: NULL dereference in clockevents_program_event
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <1195502804.19479.6.camel@johannes.berg>
References: <1195502804.19479.6.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-quWCiOvAks0lV/vvf99N"
Date: Wed, 28 Nov 2007 00:52:20 +0100
Message-Id: <1196207540.6058.114.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-quWCiOvAks0lV/vvf99N
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> During a hibernate cycle on my G5, while machine was powering down after
> saving the image, I just had a NULL dereference  in
> clockevents_program_event when accessing dev->mode, dev was NULL.
>=20
> Unfortunately the machine rebooted before I was able to write down more
> than the fact that it was called from tick_program_event(); the problem
> doesn't seem to be easily reproducible.
>=20
> From what I can see when doing the same thing, the shutdown attempts to
> offline all CPUs. Because the snapshot was actually saved to disk and
> the machine was shutting down I guess that the it happened at that time,
> but I have no idea what else to do to debug this.
>=20
> I have
>=20
> | CONFIG_HIGH_RES_TIMERS=3Dy
> | CONFIG_NO_HZ=3Dy
>=20
> in this config.

I just got the same or a similar thing again and was able to write down
more of the stack dump:

NIP clock_events_program_event+0x20
LR  tick_program_event+0x64
Stack:
hr_timer_interrupt+0x211
timer_interrupt+0xc4
decrementer_common+0x110

johannes

--=-quWCiOvAks0lV/vvf99N
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0yts6Vg1VMiehFYAQJYZA//cjhZh6nlGykdEVy22iX/daoDFItEtJ1e
as1OIvnHZc4HUWzsoLeq8Mjj5cKYJrKObsEPRvTQ4F/8DDNCGD+BEAlreyb5y7o9
G91olSBsyum52lSqMPt8gXKuFGm/S5gnLEXah9I0NV7R5N+6hbCJm7mczSV8dsbr
fOiUNYOAMN4y/8pxOdyH1Yfp7m6pdiHpg4ElOpj72JeKBzHni9eMlYDQnNi1bJcB
liP43mDA+vgZL1b4beXlXBbd4JUymhHLAkF1lGsihjI6uYzrdj3QEGc7wmSp2Njb
vbnEQ5AjDM7rpf0Mk2tymFCVZbaUpnXcWPY5z3rJnPJE56uF6g56780AsjbsDUpe
KUM2VKuLIM5dtE4uJtcEiyfWJZHTjkJxF7AxgileOnKBPH8TPCVFKIN4ueKTtGv6
fCvUszHyXOWm/TWWCRFXhHrTvwGksMsiA/5susBn7A6ilytCMuyuVWidQlj9SVmH
uRdo9m4T4URFs3S9LgllDrqE7aoWzGUwWzOLWmuccCiXqna5XuridfomRsDYvY0o
HE3DRPUFZ0oRZ14LDAhr5WyaJpfBn88kXMFFm/R9JkoT4qp4wUw31PTlSRP6uqZQ
P1TSlkSdqsMwWIflHqelhGVVXuH84pavg3DEGlLDSM58JTokXpuIaiEIryEBTKhC
pi1rUHPseQ0=
=D/Bl
-----END PGP SIGNATURE-----

--=-quWCiOvAks0lV/vvf99N--

