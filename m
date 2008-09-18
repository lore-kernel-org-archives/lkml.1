Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbYIRJLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbYIRJLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 05:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbYIRJLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 05:11:11 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:54615 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736AbYIRJLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 05:11:09 -0400
Date: Thu, 18 Sep 2008 11:11:07 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Singaravelan Nallasellan <singaravelann@gmail.com>
Cc: Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: New IOCTLs
Message-ID: <20080918091107.GE20061@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
References: <3baf3d760809170955l5dec0495n93fc373a52a120ae@mail.gmail.com> <48D164B9.7020507@redhat.com> <3baf3d760809172123q5445780dldaaa51d59c0b688a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-31260-1221728930-0001-2"
Content-Disposition: inline
In-Reply-To: <3baf3d760809172123q5445780dldaaa51d59c0b688a@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-31260-1221728930-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 18, 2008 at 09:53:51AM +0530, Singaravelan Nallasellan wrote:
> Thank you for your response.
>=20
> The driver needs to assign an id for each open and create a sysfs
> entry based on that id and expose some properties.
>=20
> For example, if the driver assigns an id 2, the sysfs entry will be as be=
low:
> /sys/class/xxx/<drivername>/2/version
>=20
> When the driver close is invoked, it will have to remove the entry.
>=20
> The issue here is that the application needs:
> 1. To know the id it should use to access properties after the open.
> 2. To have exclusive access to the sysfs entries. No other application
> should and open the entry and use it. There is a chance the the other
> application could open the entries before this application opens it.
>=20
> The driver allows multiple opens and assigns any random id.
>=20
> I appreciate your suggestion on alternate ways to implement the functiona=
lity.

What about using configfs? A user could create an id using mkdir in the dri=
ver's
configfs subsystem, and this would make the driver create the matching sysfs
entry.

# mkdir /sys/kernel/config/<driver_subsys>/2
-> reserve id 2 for the caller, and create /sys/class/xxx/<drivername>/2

You could even put whatever configuration items inside configfs instead of
sysfs.

Louis

>=20
>=20
> On Thu, Sep 18, 2008 at 1:42 AM, Chris Snook <csnook@redhat.com> wrote:
> > Singaravelan Nallasellan wrote:
> >>
> >> I need to send device control messages to the driver. I am planning to
> >> use the IOCTLs. But I came to know that Linux community does not
> >> accept any new IOCTLs anymore.
> >> Can somebody provide the reason behind the decision? Are there any
> >> better approach to implement the device control interface other than
> >> sysfs interface. I have some issues in using the sysfs interface.
> >> Thanks in advance.
> >
> > IOCTLs are discouraged, but not strictly forbidden.  Is there something
> > about sysfs that would make it an unsuitable interface, or are you just
> > having trouble finding good documentation on using it?
> >
> > -- Chris
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-31260-1221728930-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFI0hsrVKcRuvQ9Q1QRAphCAKC2OwlK5hRrs0HLy48IfRAfol92gACbBZvM
K6GllRJ1P+xoe89BmctBAx4=
=+LNH
-----END PGP SIGNATURE-----

--=_bohort-31260-1221728930-0001-2--
