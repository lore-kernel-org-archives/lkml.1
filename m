Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbYJ3Lr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbYJ3Lr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 07:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753386AbYJ3Lru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 07:47:50 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:40608 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbYJ3Lru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 07:47:50 -0400
Date: Thu, 30 Oct 2008 12:47:47 +0100
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Andrey Mirkin <major@openvz.org>
Cc: Oren Laadan <orenl@cs.columbia.edu>, Dave Hansen <dave@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>, Cedric Le Goater <clg@fr.ibm.com>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [Devel] Re: [PATCH 0/9] OpenVZ kernel based
	checkpointing/restart
Message-ID: <20081030114747.GL15171@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
References: <1220439476-16465-1-git-send-email-major@openvz.org> <200810271707.13580.major@openvz.org> <4905D2AD.1070309@cs.columbia.edu> <200810300902.47067.major@openvz.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-30093-1225367121-0001-2"
Content-Disposition: inline
In-Reply-To: <200810300902.47067.major@openvz.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-30093-1225367121-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2008 at 10:02:44AM +0400, Andrey Mirkin wrote:
> > > kernel. Also we will need a functionolity to create processes with
> > > predefined PID. I think it is not very good to provide such ability to
> > > user space. That is why we prefer in OpenVZ to do all the job in kern=
el.
> >
> > This is the weak side of creating the processes in user space -
> > that we need such an interface. Note, however, that we can
> > easily "hide" it inside the interface of the sys_restart() call,
> > and restrict how it may be used.
>=20
> Of course we can "hide" it somehow, but anyway we will have a hole and th=
at is=20
> not good.
>=20
> Anyway we should ask everyone what they think about user- and kernel- bas=
ed=20
> process creation.
> Dave, Serge, Cedric, Daniel, Louis what do you think about that?

Frankly, I'm not convinced (yet) that one approach is better than the other=
 one.
I only *tend* to prefer kernel-based, for the reasons explained below. I kn=
ow
that there are arguments in favor of userspace (I've at least seen
security-related ones), but I let their authors detail them (again).

In Kerrighed this is kernel-based, and will remain kernel-based because we
checkpoint a distributed task tree, and want to restart it as mush as possi=
ble
with the same distribution. The distributed protocol used for restart is
currently too fragile and complex to rely on customized user-space
implementations. That said, if someone brings very good arguments in favor =
of
userspace implementations, we might consider changing this.

Without taking distributed restart into account, I also tend to prefer
kernel-based, mainly for two (not so strong) reasons:
1) this prevents userspace from doing weird things, like changing the task =
tree
and let the kernel detect it and deal with the mess this creates (think abo=
ut
two threads being restarted in separate processes that do not even share th=
eir
parents). But one can argue that userspace can change the checkpoint image =
as
well, so that the kernel must check for such weird things anyway.
2) restart will be more efficient with respect to shared objects.

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-30093-1225367121-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJCZ7jVKcRuvQ9Q1QRApKeAKCsUFFiC/RJBW7wNKKF7iPjAms5sACdG9cr
b9+Zh+eBenOil48XhDZU3ws=
=a0Rz
-----END PGP SIGNATURE-----

--=_bohort-30093-1225367121-0001-2--
