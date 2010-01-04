Return-Path: <linux-kernel-owner+w=401wt.eu-S1752914Ab0ADMqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab0ADMqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 07:46:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941Ab0ADMqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 07:46:32 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:21437 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab0ADMqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 07:46:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=e2GyA9jnbLt4TeZ/PfSFil5eSuOV7ajeFcwlwAcd8NRF4e87rEwzifjIk9HKNILT4Z
         FnE7OCO1BYdbSRfV2+0zGRZLL2mKSMIiPrLxYrLQZ64GU+fvhwwmCnVZ+D6R9FGYmImf
         iowVE/kbhW5KLozG2h6YEa2hwRLD71Smd8v6c=
Message-ID: <4B41E318.4050809@gmail.com>
Date: Mon, 04 Jan 2010 13:46:16 +0100
From: Daniel Borkmann <danborkmann@googlemail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: =?UTF-8?B?QmFydMWCb21pZWogWmltb8WE?= <uzi18@o2.pl>,
       linux-kernel@vger.kernel.org, awalls@radix.net,
       danborkmann@googlemail.com, linux-pm@lists.linux-foundation.org,
       stern@rowland.harvard.edu
Subject: Re: [suspend/resume] Re: userspace notification from module
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl> <201001040030.01256.rjw@sisk.pl> <54ac764e.502c1a33.4b4129c3.9dc1b@o2.pl> <201001040045.39517.rjw@sisk.pl>
In-Reply-To: <201001040045.39517.rjw@sisk.pl>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig617ACEB1397EFE08C9EE3CDF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig617ACEB1397EFE08C9EE3CDF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Rafael J. Wysocki wrote:
> On Monday 04 January 2010, Bart=C5=82omiej Zimo=C5=84 wrote:
>> And what do You think about sending extra signals to processes?
>=20
> I don't see a problem with this in principle, although I don't think si=
gnals
> are very suitable for this particular purpose, because you need two-way=

> communication between the power manager and the processes it's going to=

> notify (because it has to wait for the processes to finish their prepar=
ations
> and to tell it that they are ready).

Again, just to abandon some thoughts... do you really need that "two-way
communication"? I mean if the kernel delivers that specific signal to
the process/task_struct [do_signal():handle_signal()] it has to save the
original execution context that will later on be restored after the
non-default signal handling function returns. This is our ACK /
notification for the successful return of the programs "suspend
handler". The kernel module (if such exists) could be notified about
that for instance by a simple notifier hook within kernelspace. I mean
if I see this right, the "two-way" is just for the ACK isn't it?

Best regards,
Daniel


--------------enig617ACEB1397EFE08C9EE3CDF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAktB4xgACgkQ5AxJm1m3CC9vxQCfWdKkD2G/vFXqz3D3R3U0nsgD
PasAn2JqmawTG+k8NBjbddSFCxOggi+B
=8/RW
-----END PGP SIGNATURE-----

--------------enig617ACEB1397EFE08C9EE3CDF--
