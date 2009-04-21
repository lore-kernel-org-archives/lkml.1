Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbZDUN0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbZDUN0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 09:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbZDUN0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 09:26:30 -0400
Received: from intcomgrp.com ([216.54.13.120]:44095 "EHLO beta.intcomgrp.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752974AbZDUN0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 09:26:30 -0400
Message-ID: <49EDC935.7080308@beta.intcomgrp.com>
Date: Tue, 21 Apr 2009 09:25:09 -0400
From: James Kosin <jkosin@beta.intcomgrp.com>
Organization: International Communications Group, Inc.
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Mike Rapoport <mike@compulab.co.il>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFD] voltage/current regulator consumer interface
References: <ct38K-3Fq-11@gated-at.bofh.it> <49EC9709.8070002@support.intcomgrp.com> <49ED628A.4000505@compulab.co.il>
In-Reply-To: <49ED628A.4000505@compulab.co.il>
X-Enigmail-Version: 0.95.7
OpenPGP: id=7BB59129
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB5D79755CE35BC6754AF684C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB5D79755CE35BC6754AF684C
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Mike Rapoport wrote:
>=20
> James Kosin wrote:
>> Mike Rapoport wrote:
>>> Hi,
>>>
>>> Recently there was a brief discussion on linux-arm-kernel list [1] ab=
out
>>> controlling voltage regulator state in cases when there is no consume=
r device
>>> for a particular regulator.
>>>
>>> I have some thoughts but I'd like to know people opinion before I sta=
rt
>>> implementation.
>>>
>>> Problem
>>> -------
>>> The regulator framework API provides ability to control the state of
>>> voltage/current regulators from within the kernel. Usually the regula=
tor
>>> supplies power to a device and device driver or some hooks to the pla=
tform code
>>> from the device driver manipulate the regulator state. However, the r=
egulator
>>> framework does not have userspace ABI that allows regulator state mod=
ifications.
>>> Lack of this ABI prevents fine-grained control for power consumption =
of devices
>>> such as GPS trancievers and GSM modems. Moreover, in SoC based system=
s it is
>>> possible to switch on/off power to entire subsystem when it is not us=
ed.
>>>
>>
>> I'd also ask the question, Why?
>> If exposing to user space it leaves the possibility of damaging hardwa=
re
>> or completely frying a board.
>=20
> Suppose you have a handheld device with GPS transceiver. You would like=
 to give
> user the ability to switch the transceiver on and off.
>=20

Then the GPS drivers should be made aware and let the drivers handle the
on/off interface.  If a user is allowed to turn interfaces on/off at
will with this then drivers could suffer from (shock)...  ie: you could
turn off your hard-drive in a middle of a write by the driver corrupting
data, if handled in the driver it could finish the write before turning
off the drive.  I know this is a far stretch from a GPS were the device
is only READ only.

I do agree it could be useful, but we need to be careful on how much
control the user has over the drivers and system.  To an extreme, a user
could be able to turn off CPU cores outside of the drivers control
causing serious pipeline hazards that would need to be handled at the
driver level.  This would not be an issue for GPS were the data is read
only and the missing data is really not that important to the system
operation and continued use.

James


--------------enigB5D79755CE35BC6754AF684C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkntyTkACgkQkNLDmnu1kSnEewCfetbfQ8A3uxFQIyjMtMV7PwXa
J38AnRI2xW9fFs4Stzx/n8XQp83yUJn0
=FHrC
-----END PGP SIGNATURE-----

--------------enigB5D79755CE35BC6754AF684C--
