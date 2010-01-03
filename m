Return-Path: <linux-kernel-owner+w=401wt.eu-S1752393Ab0ACKG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393Ab0ACKG2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 05:06:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205Ab0ACKG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 05:06:27 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:42243 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab0ACKG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 05:06:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=UdLcBcr64adfzBbOCj8RQ/bXGnbusz3OM0T5IGBt2dKbYCCk8ZmCsuagsVmVYmjEWR
         Zn/tWjJxtH63DJaGs4p7Zbc/ml58vBmW5z0qn8kS9qIcyPau7xwucvbXbbFcWWHLBQFL
         SqvlshZwNMypQzXeLDAUQjJoT0NZuEsUhlLuM=
Message-ID: <4B406C14.2070907@gmail.com>
Date: Sun, 03 Jan 2010 11:06:12 +0100
From: Daniel Borkmann <danborkmann@googlemail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: =?UTF-8?B?QmFydMWCb21pZWogWmltb8WE?= <uzi18@o2.pl>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Andy Walls <awalls@radix.net>,
       linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [suspend/resume] Re: userspace notification from module
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl> <201001022201.04281.rjw@sisk.pl> <7cf4f51f.5fc2a5cd.4b3fc3ad.c849c@o2.pl> <201001030029.22449.rjw@sisk.pl> <65e5aef6.33251eb4.4b3fecf4.a2f99@o2.pl> <4B4063AB.7080401@gmail.com>
In-Reply-To: <4B4063AB.7080401@gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCE6E6D957E429ACE3AC98FD2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCE6E6D957E429ACE3AC98FD2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Daniel Borkmann wrote:
> Bart=C5=82omiej Zimo=C5=84 wrote:
>> What about this discusion:
>> http://lists.freedesktop.org/archives/devkit-devel/2009-December/00061=
7.html
>>
>> I will perform some tests to know what amount of time is usualy needed=
 to disconnect
>> nicely client or something.
>=20
> Actually I think this is what signals are there for and bringing this
> information via signals would have least overhead, problem is that this=

> is not POSIX compliant, but may be you could have a try at this?!

I'm not quite sure how this is implemented within the kernel, but if you
have lots of processes doing their suspend routines, I think it is not
guaranteed that all of this finishes before doing the suspend, so you
will have some unknown states, processes could stuck at (and later [at
some unintended point of time] resume on).
Or, on the other hand you will have to block the kernel notification
chain until all the procs have signaled that they're done doing their
jobs. Regarding this, the kernel suspend would depend on the correctness
/ termination of userspace routines which is a _very_ bad thing.
You will have to introducte some timeouts... see where this is going? I
think a file interface might be too simple... just some thoughts about th=
is.

Regards,
Daniel


--------------enigCE6E6D957E429ACE3AC98FD2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAktAbBQACgkQ5AxJm1m3CC+N3ACfVohLlBmmZxuIoPj4Hj6Lq1F8
XNkAn0s7p2tLWTchN0h+6Cb6t/4OQB2a
=3BnN
-----END PGP SIGNATURE-----

--------------enigCE6E6D957E429ACE3AC98FD2--
