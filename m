Return-Path: <linux-kernel-owner+w=401wt.eu-S933064AbXGSCSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064AbXGSCSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 22:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758653AbXGSCSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 22:18:34 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:49809 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbXGSCSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 22:18:34 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
Subject: Re: which signal is sent to freeze process?
Date: Thu, 19 Jul 2007 12:18:32 +1000
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <A3258B497F1C1441AD36A2E8B45FD6285507A5@scsmsx412.amr.corp.intel.com>
In-Reply-To: <A3258B497F1C1441AD36A2E8B45FD6285507A5@scsmsx412.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1242082.qHtJv7LF1z";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707191218.32730.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1242082.qHtJv7LF1z
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Thursday 19 July 2007 09:42:02 Agarwal, Lomesh wrote:
> My understanding is that Linux kernel sends a signal to freeze processes
> during suspend2ram operation. Which signal is used to achieve this?
> The problem I am facing is that some of the system calls are failing
> with EINTR errno during suspend operation and I want to install a signal
> handler for freeze signal with SA_RESTART flag. That should make the
> kernel to retry the system calls. Right?

No signal is sent. We tell affected processes that they have a signal pendi=
ng,=20
and capture them in the signal handling code while the suspend to ram is=20
occuring. After the suspend to ram is finished, we recalculate whether they=
=20
have a signal pending, and let them continue.

Not being a guru on signal handling itself, I won't try to answer the quest=
ion=20
itself :\.

Regards,

Nigel

--nextPart1242082.qHtJv7LF1z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGnsn4N0y+n1M3mo0RAg0FAJ4odLWIGG3wuHouyag19YyDsISgLwCeJJqy
zd9KF3v3Ta87sUeue5WWjYk=
=Y2lX
-----END PGP SIGNATURE-----

--nextPart1242082.qHtJv7LF1z--
