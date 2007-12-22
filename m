Return-Path: <linux-kernel-owner+w=401wt.eu-S1753395AbXLVKqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbXLVKqk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 05:46:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbXLVKqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 05:46:32 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:46764 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376AbXLVKq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 05:46:29 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "Adrian McMenamin" <lkmladrian@gmail.com>
Subject: Re: [PATCH - SH/Dreamcast] Add support for GD-Rom device
Date: Sat, 22 Dec 2007 05:44:24 -0500
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
       "Paul Mundt" <lethal@linux-sh.org>, axboe@kernel.dk
References: <8b67d60712201559h5dbb2a17q8f16223b26b88006@mail.gmail.com> <8b67d60712201607k66d67fa2la8b21fc698fdb3ab@mail.gmail.com>
In-Reply-To: <8b67d60712201607k66d67fa2la8b21fc698fdb3ab@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8944693.2HOO8kNTK4";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200712220544.25102.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart8944693.2HOO8kNTK4
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 20 December 2007, Adrian McMenamin wrote:
> On 20/12/2007, Adrian McMenamin <lkmladrian@gmail.com> wrote:
> > This patch adds support for the CD Rom device (called a "GD Rom") on
> > the SEGA Dreamcast.This device has a command block similar to a
> > standard ATA-3 device, though implements Sega's proprietary packet
> > interface - the so-called "Sega Packet Interface".

thanks for keeping the dc port up to date :)

> diff -ruN linux-2.6-orig/drivers/block/Kconfig
> +config	GDROM

most people use a space here *shrug*

> +	tristate "SEGA Dreamcast GD-ROM drive"
> +	depends on SH_DREAMCAST
> +	help
> +	  A standard SEGA Dreamcast comes with a modified CD ROM drive called a
> +	  "GD-ROM" by SEGA to signify it is capable of reading special disks
> +	  with up to 1 GB of data. This drive will also read standard CD ROM
> +	  disks. Select this option to access any disks in your GD ROM drive.
> +          Most users will want to say "Y" here.

this line has broken whitespace at the start

> +	  You can also build this as a module - which will be called gdrom.ko

no need for the - there ...

> +static int gdrom_preparedisk_cmd(void)
> +	if ((gd.status & 0x01) !=3D 0) {

no need for the compare i dont think ?
if (gd.status & 0x01)

> +static int gdrom_readtoc_cmd(struct gdromtoc *toc, int session)
> +	if ((gd.status & 0x01) !=3D 0)

same here


> +static int gdrom_drivestatus(struct cdrom_device_info *cd_info, int
> +	sense &=3D0xF0;

missing a space after the =3D ...


> +static void gdrom_request(struct request_queue *rq)
> +		if (! blk_fs_request(req)) {

extraneous space with the ! there

> +static int __init probe_gdrom(struct platform_device *devptr)
> +	sprintf(gd.cd_info->name, GDROM_DEV_NAME);
> +	sprintf(gd.disk->disk_name, GDROM_DEV_NAME);

strcpy() prob runs with lower overhead

> +static int __init init_gdrom(void)
> +{
> +	rc =3D platform_driver_register(&gdrom_driver);
> +	if (rc) {
> +		printk(KERN_INFO "Could not register GDROM driver - error 0x%X\n", rc);
> +		return -EPERM;

shoudnt you return rc ?  then there's probably no need to display the rc va=
lue=20
in the printk() as it'd get passed back to higher levels ...

> +	pd =3D platform_device_register_simple(GDROM_DEV_NAME, -1, NULL, 0);
> +	if (IS_ERR(pd)) {
> +		platform_driver_unregister(&gdrom_driver);
> +		return -ENODEV;

similar thing ... return the error stored in pd
=2Dmike

--nextPart8944693.2HOO8kNTK4
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iQIVAwUAR2zqiUFjO5/oN/WBAQL18A//egkMSCCwg0FMCfU0f00fZ1jkL6CdYvEU
ifRjwtBr91wxL/+vOoMNY6/V20T43aY8pmkDbzRgy3J2i3CXUeJZPAZuqJ1+ZFrk
trwoAkSIeD/nG/0Oav6Qz8BxmfszoRlfj5nMTgIYwg6GvVpGXVTtr5LHHyAhbg6p
IEvV5ldTQuLBfYEEtNotNKH10llN/8e7gSPpQUbH76k2MvYsHSZyoEcBgNsyKfCT
llkKZlTPCZ5q96D2CsUlSDScU537NyGZCa8XdERagVI4tv+RsOW6jXVI0Wka9U9t
/Twvqlfy8WEoQk11JqMqdYsg4Hb4yevGjPrB+WWykg77EYrgXAfSEKV67R3AtwFl
H+v+6aJj3XzZQGe0ijweKaZuIUG8gQ9FkXHSvYrNY/aGgJ0KmTglyh2teqDGqUxY
22XYx+jjaP2xmGgW/mCxQ/6sIy3KogFauFIfdhFFrGheuK7EClBdWoOxGLMr/QNw
W/Tq32T2eh1EKHjDhoEQD76AiFX0ILDBHdD9jVg+izjMh/YoxI0JurUWUFkWMhUa
NCAIRWVpm0fdL/HbJ1q9xnJilrDO8gnMdlO8PkHhxWNNA5C69oBKxC3ei2QQHSaB
R7mLi7ELszfPEWKh0tGUx18cFBJIubYZoTcHk516iAGcVxYoXlGqRqFvOLHQDZBY
fGaTcN8Ja/k=
=qd3X
-----END PGP SIGNATURE-----

--nextPart8944693.2HOO8kNTK4--
