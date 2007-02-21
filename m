Return-Path: <linux-kernel-owner+w=401wt.eu-S1423141AbXBUVkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423141AbXBUVkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 16:40:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423175AbXBUVkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 16:40:35 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:35451 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423141AbXBUVke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 16:40:34 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=thunder.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:X-Enigmail-Version:OpenPGP:Content-Type:Sender:Reply-To;
	b=RbzHeo2NtAvw6/k6muIk4Udva0ff4PzmVoqyBYbrxRXTAsnmuhKzp4MLiJdweD7E/4tN3tVF6E/jqWuaGapg6cNDBSISIHaw0KWKu7OKvL1zRH6A3Rs3bCML51Te47X7;
Message-ID: <45DCBC26.1050308@simon.arlott.org.uk>
Date: Wed, 21 Feb 2007 21:39:50 +0000
From: Simon Arlott <simon@arlott.org>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] usbatm: Detect usb device shutdown and ignore failed
 urbs.
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig413F644BEBAEBA64AF2DC789"
Reply-To: Simon Arlott <254ad70138dc1cdf241hjzcr0007jhhw@thunder.lp0.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig413F644BEBAEBA64AF2DC789
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Detect usb device shutdown and ignore failed urbs. This happens when the =
driver is unloaded or the device is unplugged.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 drivers/usb/atm/usbatm.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/atm/usbatm.c b/drivers/usb/atm/usbatm.c
index 83cea01..1f5faee 100644
--- a/drivers/usb/atm/usbatm.c
+++ b/drivers/usb/atm/usbatm.c
@@ -274,6 +274,10 @@ static void usbatm_complete(struct urb *
 			(!(channel->usbatm->flags & UDSL_IGNORE_EILSEQ) ||
 			 urb->status !=3D -EILSEQ ))
 	{
+		/* the module/device has probably been removed */
+		if (urb->status =3D=3D -ESHUTDOWN)
+			return;
+
 		if (printk_ratelimit())
 			atm_warn(channel->usbatm, "%s: urb 0x%p failed (%d)!\n",
 				__func__, urb, urb->status);
--=20
1.4.3.1


--=20
Simon Arlott


--------------enig413F644BEBAEBA64AF2DC789
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iQIVAwUBRdy8JqRtx1WjQ8ihAQpbpA//c78Z/PuQd7C4ejNvlpVGb1sCrO6RpGyE
FQ7q9ohHW0hSFMWRdmdc+bskzcDOdbwqGfbFIlpv5c3ujnc589KL/MZYy0vAEZ9z
u933GQeEqMhtIDce8KKaYdvwr6Int52KBBejyagQWa8Syp2t/ZMdEt/hrl0PccL3
nha4TxrEdAFexavzdDwlDwT0DoDvcE2vhyw1p207Y8IdjK3j5jjFf4H9b9Qw4uKY
asoXm1AyVeA2BbzsdLnXlnQoxCdI3F5AVH42RTWtJ/vdw7mc8j+W8eGsdoC0/t+7
631dkPenaZxrvDOq2oBC33iqyoAGXaF3qafhxaqNIctRekNt8zpvj6csAPlrn3fp
XPU06Hk2jTw1MVlnCORN0M7bPIF2MQ9rnit1ue3rWrQLrCC2mJukb6JxBSrYNPGU
I5nsm0FXjt1mXP4DUalPe1/eN7vPiKfLkZIVPKDnaehjUfs9Fj+Jr2/re01m3VZz
XmIKOL2xW5CQJF9Y62UR7Y1w4tRci+zvvoHTRBzQutEmsuzWeYeEMzU8C5qStX3r
3HbjvpeuQ1L/DPkPyIRzi/IU3X5+p8KZOBw5H6xzRtkFaeWRi6FYg+cD/YHMAJhx
HuOmkhzQAAfw9DP5/Y0mNqgPI/Rhw2Jim9uOQ+weKEcMSR7dLeo7VYtA4dhY4M53
fhYO8u5b+VU=
=gL4h
-----END PGP SIGNATURE-----

--------------enig413F644BEBAEBA64AF2DC789--
