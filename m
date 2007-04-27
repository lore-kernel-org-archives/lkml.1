Return-Path: <linux-kernel-owner+w=401wt.eu-S1757337AbXD0VbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbXD0VbR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 17:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750700AbXD0VbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 17:31:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757342AbXD0VbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 17:31:14 -0400
Message-ID: <46326B90.4050501@redhat.com>
Date: Fri, 27 Apr 2007 14:30:56 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, adobriyan@openvz.org
Subject: Re: [PATCH] v4: merged utimensat implementation
References: <200704271523.l3RFNwGN031209@devserv.devel.redhat.com> <20070427140450.3938183c.akpm@linux-foundation.org>
In-Reply-To: <20070427140450.3938183c.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.3.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEBB000611C04332275F4C7F1"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEBB000611C04332275F4C7F1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Andrew Morton wrote:
> Could we please have [...] a changelog
> for the commit?

Implement utimensat(2) which is an extension to futimesat(2) in that
it
a) supports nano-second resolution for the timestamps
b) allows to selectively ignore the atime/mtime value
c) allows to selectively use the current time for either atime or mtime
d) supports changing the atime/mtime of a symlink itself along the lines
   of the BSD lutimes(3) functions

For this change the internally used do_utimes() functions was changed to
accept a timespec time value and an additional flags parameter.

Additionally the sys_utime function was changed to match
compat_sys_utime which already use do_utimes instead of duplicating the
work.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enigEBB000611C04332275F4C7F1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGMmuQ2ijCOnn/RHQRAlS9AJsGZX1jeKm9cnKWjdPTdeXSmDVRLgCfe2G7
aFUCwvuxqKYtL/1O2lniXMw=
=VWn4
-----END PGP SIGNATURE-----

--------------enigEBB000611C04332275F4C7F1--
