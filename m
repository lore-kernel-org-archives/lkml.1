Return-Path: <linux-kernel-owner+w=401wt.eu-S1754425AbZBQUlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbZBQUlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 15:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753326AbZBQUlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 15:41:14 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:40283 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbZBQUlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 15:41:13 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Laurent Riffard <laurent.riffard@free.fr>
Subject: Re: linux-next: USB mouse won't work after resume.
Date: Tue, 17 Feb 2009 21:42:55 +0100
User-Agent: KMail/1.9.10
Cc: linux-input@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
References: <20090216172016.f1d159a7.sfr@canb.auug.org.au> <200902171135.13329.oliver@neukum.org> <499ABD80.9020904@free.fr>
In-Reply-To: <499ABD80.9020904@free.fr>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_RFymJVBcFduBUWG"
Message-Id: <200902172142.57302.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_RFymJVBcFduBUWG
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Tuesday 17 February 2009 14:37:04 schrieb Laurent Riffard:
> Le 17.02.2009 11:35, Oliver Neukum a =C3=A9crit :
> > Am Tuesday 17 February 2009 10:55:57 schrieb Laurent Riffard:
> >> My USB mouse won't work after suspend to disk and resume. I must unloa=
d and reload the ohci_hcd module to get it back.
> >=20
> > Please recompile your kernel with CONFIG_USB_DEBUG and
> > send me your dmesg.
> >=20
> > 	Regards
> > 		Oliver
> >=20
>=20
> Here is it:
>=20

Please try the attached patch.

	Regards
		Oliver

--Boundary-00=_RFymJVBcFduBUWG
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="hid_reset_resume.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="hid_reset_resume.diff"

--- nexttree/drivers/hid/usbhid/hid-core.c.alt	2009-02-17 21:39:45.000000000 +0100
+++ nexttree/drivers/hid/usbhid/hid-core.c	2009-02-17 21:39:57.000000000 +0100
@@ -1333,6 +1333,15 @@ static int hid_post_reset(struct usb_int
 	return 0;
 }
 
+static int hid_reset_resume(struct usb_interface *intf)
+{
+	struct hid_device *hid = usb_get_intfdata(intf);
+	struct usbhid_device *usbhid = hid->driver_data;
+
+	clear_bit(HID_REPORTED_IDLE, &usbhid->iofl);
+	return hid_post_reset(intf);
+}
+
 int usbhid_get_power(struct hid_device *hid)
 {
 	struct usbhid_device *usbhid = hid->driver_data;
@@ -1362,7 +1371,7 @@ static struct usb_driver hid_driver = {
 #ifdef CONFIG_PM
 	.suspend =	hid_suspend,
 	.resume =	hid_resume,
-	.reset_resume =	hid_post_reset,
+	.reset_resume =	hid_reset_resume,
 #endif
 	.pre_reset =	hid_pre_reset,
 	.post_reset =	hid_post_reset,

--Boundary-00=_RFymJVBcFduBUWG--
