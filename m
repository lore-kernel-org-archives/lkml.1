Return-Path: <linux-kernel-owner+w=401wt.eu-S1752991AbZF2Jd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbZF2Jd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 05:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbZF2Jdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 05:33:45 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:35414 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbZF2Jdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 05:33:43 -0400
Subject: Re: [2.6.31-rc1] iwlagn (4965): regression when hardware rf switch
 is used
From: Johannes Berg <johannes@sipsolutions.net>
To: Frans Pop <elendil@planet.nl>
Cc: linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200906291128.05639.elendil@planet.nl>
References: <200906291128.05639.elendil@planet.nl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-0wF0QopLZCySK2soLrq2"
Date: Mon, 29 Jun 2009 11:33:42 +0200
Message-Id: <1246268022.7775.24.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0wF0QopLZCySK2soLrq2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Now that I took a closer look...

> I've tried .31-rc1 on my HP 2510p notebook and noticed a problem when
> using the hardware rf kill switch.


> But with 2.6.31 I get this:
> [disable]
> wlan0: deauthenticating by local choice (reason=3D3)
> iwlagn 0000:10:00.0: Error sending REPLY_ADD_STA: enqueue_hcmd failed: -5
> mac80211-phy0: failed to remove key (0, 00:14:c1:38:e5:15) from hardware =
(-5)
> iwlagn 0000:10:00.0: Error sending REPLY_ADD_STA: enqueue_hcmd failed: -5
> mac80211-phy0: failed to remove key (1, ff:ff:ff:ff:ff:ff) from hardware =
(-5)
> usb 3-1: USB disconnect, address 2

These errors are a driver problem.

> [enable]
> usb 3-1: new full speed USB device using uhci_hcd and address 3
> usb 3-1: configuration #1 chosen from 1 choice

That is completely unrelated. You plugged in a USB device too :)

> A lot uglier with those errors. And after that I have to run ifdown/ifup
> before networking is up again (ifup only does not work as it will complai=
n
> "interface already configured"):

And that's actually expected, and/or a bug in the debian networking
scripts.
(You can trigger the same problem by doing
ifup wlan0
ip link set wlan0 down
ifup wlan0 -> error)

To get your network connection back automatically we will require
changes to userland tools to listen to rfkill events.

> BTW, would it make sense to bring back the first two lines shown with .30
> (or at least the first one):
>    iwlagn 0000:10:00.0: Radio Frequency Kill Switch is On:
>    Kill switch must be turned off for wireless networking to work.
> IMHO it's good to register the reason for the disconnect.

I guess something like that could be added to cfg80211:
phy0: taking interfaces down due to rfkill

johannes

--=-0wF0QopLZCySK2soLrq2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKSIpxAAoJEODzc/N7+QmaYdAQAJUA54sKACgxWVUQKJeJLBJP
4JDCQECM05HlbGvhAUQwTp4SBMIjqxTcMEt0d643V2DTolGBFFMy0PjUrYbEMizc
MVZTb3AHNThWIw0vQSKSn20hC5GQTl0Ahq4bkpMD13tfsto4VNL5BSmXg6mZxIN0
u/EPHhAz7LBxlBbx835imYUNSdXG1LcvObyGIyg+SLV0rRUMPduyH3MUUmlATFI0
tSVIsM9uEaTkXYjqdiuYxk8xWLU1pIiUyKGMSo4KJYqCs6YF8d1zqiFSejcwZmbw
Y+5CDDGznNIBqZBM5vrx6TW8LtoEJeg0eYzJpMRnqPexgPIaJlBJRFVmbxNgq0JW
Iu6rnLyGS3bpqnCnKUe8PiN3HZcnPJyTqb3Tg0Mx0sX6CxS/b9dRYoGYCRGNT2zM
xHaMJieBRopdN44U6Pj8ZO72OkkSOU8ZKkeC1nQ4xyGommeDZ1XtioqSyblP1Te1
x69aeqffBMrC3EUA6nvjvr92QQnHfgizhJJnViZWxZ+JJGuwtSiGc2la3FQD8S/e
OAo2zS1Vf2hnz+3MMv1hbNm7ZWKpn+siuqc55H7f+HNUZNu/sTuZhDfsR4uRerVQ
HjdF6gmXOdLbHasMuiUQ08hgG3bzEE3HqJVjwTBS8mIZfaHLQIBj9CkCsNymzGXc
fOzBKqqDJE7gHak2Xq81
=NrcQ
-----END PGP SIGNATURE-----

--=-0wF0QopLZCySK2soLrq2--

