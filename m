Return-Path: <linux-kernel-owner+w=401wt.eu-S1752146AbZHSROJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbZHSROJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 13:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbZHSROI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 13:14:08 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:43291 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbZHSROH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 13:14:07 -0400
Subject: Re: [PATCH 2/3] Add rfkill support to compal-laptop
From: Johannes Berg <johannes@sipsolutions.net>
To: Mario Limonciello <mario_limonciello@dell.com>
Cc: Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Marcel Holtmann <marcel@holtmann.org>, cezary.jackiewicz@gmail.com,
       linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4A8C2C6C.2020007@dell.com>
References: <4A89E768.7010207@dell.com>
	 <1250558643.30166.109.camel@localhost.localdomain>
	 <9b2b86520908180044l72cb8642j6256e246662f7971@mail.gmail.com>
	 <9b2b86520908180752k66feda09rf9034a96ac6ef470@mail.gmail.com>
	 <4A8AE459.8060102@dell.com>
	 <9b2b86520908181408v5f7875b6sea31d8d95cc08c0b@mail.gmail.com>
	 <1250631063.16393.14.camel@johannes.local>  <4A8B246D.7050004@dell.com>
	 <1250672475.25419.7.camel@johannes.local>  <4A8C2C6C.2020007@dell.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-peNaJbSVQwLh1Yb1SwHX"
Date: Wed, 19 Aug 2009 19:13:32 +0200
Message-Id: <1250702012.8073.1.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.90 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-peNaJbSVQwLh1Yb1SwHX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Mario,

First, let me say I agree with Alan, the option 1 is more desirable if
possible to do with the hardware. But this looks ok from an rfkill POV
now, except there's a small bug:

> +       ret =3D setup_rfkill();
> +       if (ret)
> +               printk(KERN_WARNING "compal-laptop: Unable to setup
> rfkill\n");

That doesn't error out, so

> +       rfkill_unregister(wifi_rfkill);
> +       rfkill_destroy(wifi_rfkill);
> +       rfkill_unregister(bt_rfkill);
> +       rfkill_destroy(bt_rfkill);

this will crash without NULL checks.

(and you have to explicitly assign NULL in setup_rfkill() too, when
bluetooth fails and wifi is freed)

johannes

--=-peNaJbSVQwLh1Yb1SwHX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKjDK5AAoJEODzc/N7+QmacT8P/j9aU1peDCZGQRYhfJZcYi/z
i+YQeL2Xrkbri+BUnA6LUWimK5I19JOmP5IVmllK9IC0Zp6rH8Safl5FpgfAj6oa
j/1xgsaVPrNd9dr3mh8p3NdYPVcLhS05UG1hbiHE+hQRnBIYt6HVi1/as7sv3Qjr
FxAL510WOSagm3JXO1G0KRZkhA5z3igVSOQRi+d3yTQ4PAMX74CfHHTLm/d+iBn6
Yi7bUyJ0a21Gptj1Xeen4CNvPxbtq07f0INkquXdeeiQgCuumszUpyG21C3yRaQM
WuWNhtCoXR+InOiKNn7y2a5weo1iOxb4/Pns7XkAwaR6OAkjpjV2Pd4VyzxVtNvF
dQNrWkkwpwFM5+21e9cw4JdNkYn0/I/N7wJyQrSF/l14p+XViNSCkVDI1NPem9mW
StP7XghlumIX+QH9dOE4ijkk2biI2UbOqjsvR9VPa2Qf8GtIVkI8vOZaoqrI29K2
dCV/eFSZPHm4uv7xHA9/uEYOf9Pe+lehlFK/hytOkONdB5uUT4QqLGmTFpGVdYlM
qeLOVJQojesRzhHU6JGd2dQX1nAu79vpZPgg+Ca88kVUOlidjPoZgMTAJgX3RtpJ
TiovoizVA6IqZv0A0Kg+iBjrlUpY7c8+BEo684xfPgU1GbHTe+s2vg27iHutHXAJ
ZuK41NMnseeD1kil1zER
=wbhm
-----END PGP SIGNATURE-----

--=-peNaJbSVQwLh1Yb1SwHX--

