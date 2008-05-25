Return-Path: <linux-kernel-owner+w=401wt.eu-S1754073AbYEYON4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbYEYON4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 10:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbYEYONq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 10:13:46 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:58960 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbYEYONq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 10:13:46 -0400
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Michael Buesch <mb@bu3sch.de>, David Woodhouse <dwmw2@infradead.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       aoliva@redhat.com, alan@lxorguk.ukuu.org.uk,
       Abhay Salunke <Abhay_Salunke@dell.com>, kay.sievers@vrfy.org,
       Takashi Iwai <tiwai@suse.de>
In-Reply-To: <09817CD9-2158-4EC3-8AB4-17BBAF34A8DA@holtmann.org>
References: <1211550282.28967.8.camel@pmac.infradead.org>
	 <1211707837.17151.14.camel@johannes.berg>
	 <95BCF0F0-755A-4501-9B44-B421AD3E8F42@holtmann.org>
	 <200805251405.05684.mb@bu3sch.de>
	 <09817CD9-2158-4EC3-8AB4-17BBAF34A8DA@holtmann.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GxpSXObjAhrV/VVqarwR"
Date: Sun, 25 May 2008 16:13:23 +0200
Message-Id: <1211724803.17151.36.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-GxpSXObjAhrV/VVqarwR
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


> No it is not. The kobject doesn't allow "/" and why should =20
> request_firmware() be an exception. Also see my other comment on how =20
> the kernel handles device nodes and on how udev maps them to real =20
> device nodes on the filesystem.

As I said, kobjects have nothing to do with it, they don't need to have
a filename based on the firmware key.

> And again. This is up to the userspace to handle and not the kernel. =20
> In userspace you could do a general approach to support these kind of =20
> testing, but you decide to only do this for your driver. You are fully =20
> exploiting the request_firmware() interface and making any kind of =20
> userspace policy impossible. This in return actually means that if we =20
> would improve the request_firmware(), we have to maintain special =20
> cases for the b43 drivers, because your driver does some hacking of =20
> firmware files inside the kernel. You actually proved my point that we =20
> should not allow this inside the kernel.

That makes no sense at all.

Michael is exploiting the firmware API that you are suggesting to
change, and so far I don't see a technical reason for changing it. In
kernel space, he's simply requesting varying firmware blobs based on
different keys, which happen to be "b43%s/%s" because that's making
things simpler for him on the other end.

On the other hand, you're saying that we have all kinds of policy about
this in userspace, so why are you saying that directory separators
(slashes, but you seem to distinguish those on some level I do not
understand) should be special in the firmware key?

The firmware key is just that, a *key*. It's only exposed to userspace
via an environment variable in a kobject named
"/devices/pci0001:10/0001:10:12.0/ssb0:0/firmware/ssb0:0" or similar.

The fact that userspace uses the key as a filename is maybe unfortunate,
maybe fortunate, but shouldn't have anything to do with what sort of
keys the kernel allows.

If Michael wants to serve his firmware blobs from an SQL database, he'd
use a simple table like this:

CREATE TABLE firmware (
	ID INTEGER,
	name VARCHAR(100),
	data BLOB
);

I don't see any problem with that.

Also, you said above (quoting again):

> =EF=BB=BFYou are fully =20
> exploiting the request_firmware() interface and making any kind of =20
> userspace policy impossible.

That's not true at all. If you decide that the userspace policy should
be to load $modulename/$firmwarekey then you'd maybe have something
like /lib/firmware/b43/b43-test/ucode5.fw
and /lib/firmware/b43/b43-osfw/ucode5.fw
and /lib/firmware/b43/b43/ucode5.fw, this doesn't preclude the use.

Now, if it had been like that from the beginning, Michael probably
wouldn't have used the string "b43" (or "b43-*") but rather requested
"broadcom/ucode5.fw" by default and "osfw/ucode5.fw" for the open source
firmware, but since it's just a key that doesn't matter.

johannes

--=-GxpSXObjAhrV/VVqarwR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDl0AqVg1VMiehFYAQLViw/+Nhiok85HVajLAlYiE73oDCOGzgJSKUlo
LzVHNV9S/HzGqvopD4SIU1N7ITjaqvlcsBVPi1z45FiSU2sb+SKRtGcBNweesLF3
SBOig1WTFhjiQpD32BvEobUkxXzVTnzT8rw8OywcI24seHO5T+PxIEUPjuiY1RaY
UTy/UJyX9qyzDa1SPF5Kd3n4NeWP6KCKPOloSppCZEhloG/GmtjPWIAYE1Dd3uIf
X6LJthaLO4D8G6uspyh+pSBCIcmulkUclgjhhD4mVhiLJkAghcV4iAxD3OfSTZ7F
1bJ85Uabvm6l6VnxU3xmYhNU9PhV9XLFbQOCBS2tqXO5fE2UK0EBX6A5XE6yl9Vh
+2I1eO76X77rQsqV3yoJZBAq9JCb+/ItFOiQZT3dkdBrK1XxBSyuymKb1YTX70pJ
JnlRwL0NptRVcvYlyrHxL9EMbFQiH0gjI+1UgBI6Fu0QHTihuCEk0djca/+T70Y5
dw3u2EPEgDI3mnXhITG5qSn82Llcpq/TWYnn7Bik+AqrN6FUfLRfSVLyBOMIudRf
FiVDpLkDRnxmLTv8P8cmddWGUQqFhwvbkekQIQPCNRFGJB7cj+8dqMM/E5eMAzB5
pDJu0n+b+xgVEm0nOFPKt2KzMJZYDmfUpQsHw3m5h6y+UYj4l9XT/NinaCHm0sWQ
rqf7go7TuD4=
=Sb3O
-----END PGP SIGNATURE-----

--=-GxpSXObjAhrV/VVqarwR--

