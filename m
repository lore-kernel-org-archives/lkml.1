Return-Path: <linux-kernel-owner+w=401wt.eu-S1756681AbYBXEQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbYBXEQ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 23:16:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbYBXEQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 23:16:47 -0500
Received: from mail.gmx.net ([213.165.64.20]:46564 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753088AbYBXEQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 23:16:46 -0500
X-Authenticated: #44953887
X-Provags-ID: V01U2FsdGVkX1/uhOl2xi/umAQ5Nsovt0DyRk7EJsjv/wAs8XwmlB
	gK4mNV27qjKP7N
Subject: Re: [PATCH] PM: Introduce PM_EVENT_HIBERNATE (was: Re: i915
	hibernation patch (was: Re: 2.6.25-rc2 System no longer ...))
From: Mirco Tischler <mt-ml@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jeff Chua <jeff.chua.linux@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Romano Giannetti <romano@dea.icai.upcomillas.es>,
       Dave Airlie <airlied@linux.ie>, Greg KH <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200802231913.27592.rjw@sisk.pl>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com>
	 <alpine.LFD.1.00.0802221805540.21332@woody.linux-foundation.org>
	 <b6a2187b0802222036i33d5bcc2n4e3bafd6d846cc09@mail.gmail.com>
	 <200802231913.27592.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zyEGKsDvYSpQuS57/WV6"
Date: Sun, 24 Feb 2008 05:16:39 +0100
Message-Id: <1203826599.30621.25.camel@mtlp>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.91 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zyEGKsDvYSpQuS57/WV6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


On Sa, 2008-02-23 at 19:13 +0100, Rafael J. Wysocki wrote:
> Index: linux-2.6/drivers/usb/host/u132-hcd.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/usb/host/u132-hcd.c
> +++ linux-2.6/drivers/usb/host/u132-hcd.c
> @@ -3214,14 +3214,19 @@ static int u132_suspend(struct platform_
>                  return -ESHUTDOWN;
>          } else {
>                  int retval =3D 0;
> -                if (state.event =3D=3D PM_EVENT_FREEZE) {
> +
> +		switch (state.event) {
> +		case PM_EVENT_FREEZE:
>                          retval =3D u132_bus_suspend(hcd);
> -                } else if (state.event =3D=3D PM_EVENT_SUSPEND) {
> +			break;
> +		case PM_EVENT_SUSPEND:
> +		case PM_EVENT_HIBERNATE:
>                          int ports =3D MAX_U132_PORTS;
>                          while (ports-- > 0) {
>                                  port_power(u132, ports, 0);
>                          }
> -                }
> +			break;
> +		}
>                  if (retval =3D=3D 0)
>                          pdev->dev.power.power_state =3D state;
>                  return retval;
=EF=BB=BFHmm. Doesn't compile for me in 2.6.25-rc2-git7:

  CC [M]  drivers/usb/host/u132-hcd.o
drivers/usb/host/u132-hcd.c: In function =E2=80=98u132_suspend=E2=80=99:
drivers/usb/host/u132-hcd.c:3224: error: expected expression before
=E2=80=98int=E2=80=99
drivers/usb/host/u132-hcd.c:3225: error: =E2=80=98ports=E2=80=99 undeclared=
 (first use
in this function)
drivers/usb/host/u132-hcd.c:3225: error: (Each undeclared identifier is
reported only once
drivers/usb/host/u132-hcd.c:3225: error: for each function it appears
in.)
make[3]: *** [drivers/usb/host/u132-hcd.o] Error 1
make[2]: *** [drivers/usb/host] Error 2
make[1]: *** [drivers/usb] Error 2
make: *** [drivers] Error 2

This fixes it:

Thanks
Mirco

---
From: Mirco Tischler <mt-ml@gmx.de>

Fixes the following compile error caused by commit
3a2d5b700132f35401f1d9e22fe3c2cab02c2549

...
  CC [M]  drivers/usb/host/u132-hcd.o
drivers/usb/host/u132-hcd.c: In function =E2=80=98u132_suspend=E2=80=99:
drivers/usb/host/u132-hcd.c:3224: error: expected expression before
=E2=80=98int=E2=80=99
drivers/usb/host/u132-hcd.c:3225: error: =E2=80=98ports=E2=80=99 undeclared=
 (first use
in this function)
...

Signed-off-by: Mirco Tischler <mt-ml@gmx.de>
---
 drivers/usb/host/u132-hcd.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/u132-hcd.c b/drivers/usb/host/u132-hcd.c
index 6fca069..58830b2 100644
--- a/drivers/usb/host/u132-hcd.c
+++ b/drivers/usb/host/u132-hcd.c
@@ -3214,6 +3214,7 @@ static int u132_suspend(struct platform_device
*pdev, pm_message_t state)
                 return -ESHUTDOWN;
         } else {
                 int retval =3D 0;
+		int ports =3D 0;
=20
 		switch (state.event) {
 		case PM_EVENT_FREEZE:
@@ -3221,7 +3222,7 @@ static int u132_suspend(struct platform_device
*pdev, pm_message_t state)
 			break;
 		case PM_EVENT_SUSPEND:
 		case PM_EVENT_HIBERNATE:
-                        int ports =3D MAX_U132_PORTS;
+			ports =3D MAX_U132_PORTS;
                         while (ports-- > 0) {
                                 port_power(u132, ports, 0);
                         }


--=-zyEGKsDvYSpQuS57/WV6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHwO+nz+diZ7c2xfgRAmHZAJwO5uX55UH5d8T5sw4laow0LBxyVACeK1PD
nIrfm2m5GjIflDP7vPzjtyY=
=Vx2M
-----END PGP SIGNATURE-----

--=-zyEGKsDvYSpQuS57/WV6--

