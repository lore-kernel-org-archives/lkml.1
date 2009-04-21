Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbZDUOdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbZDUOdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 10:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbZDUOdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 10:33:04 -0400
Received: from intcomgrp.com ([216.54.13.120]:44138 "EHLO beta.intcomgrp.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbZDUOdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 10:33:01 -0400
Message-ID: <49EDD8C6.7030204@beta.intcomgrp.com>
Date: Tue, 21 Apr 2009 10:31:34 -0400
From: James Kosin <jkosin@beta.intcomgrp.com>
Organization: International Communications Group, Inc.
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Mike Rapoport <mike@compulab.co.il>
CC: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [RFD] voltage/current regulator consumer interface
References: <ct38K-3Fq-11@gated-at.bofh.it> <49EC9709.8070002@support.intcomgrp.com> <49ED628A.4000505@compulab.co.il> <49EDC935.7080308@beta.intcomgrp.com> <49EDD2A7.9090300@compulab.co.il>
In-Reply-To: <49EDD2A7.9090300@compulab.co.il>
X-Enigmail-Version: 0.95.7
OpenPGP: id=7BB59129
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF3FBC6304210C9A7A2E1C3AF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF3FBC6304210C9A7A2E1C3AF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Mike Rapoport wrote:
> James Kosin wrote:
>> Mike Rapoport wrote:
>>> James Kosin wrote:
>>>> Mike Rapoport wrote:
>>>>> Hi,
>>>>>
>>>>> Recently there was a brief discussion on linux-arm-kernel list [1] =
about
>>>>> controlling voltage regulator state in cases when there is no consu=
mer device
>>>>> for a particular regulator.
>>>>>
>>>>> I have some thoughts but I'd like to know people opinion before I s=
tart
>>>>> implementation.
>>>>>
>>>>> Problem
>>>>> -------
>>>>> The regulator framework API provides ability to control the state o=
f
>>>>> voltage/current regulators from within the kernel. Usually the regu=
lator
>>>>> supplies power to a device and device driver or some hooks to the p=
latform code
>>>>> from the device driver manipulate the regulator state. However, the=
 regulator
>>>>> framework does not have userspace ABI that allows regulator state m=
odifications.
>>>>> Lack of this ABI prevents fine-grained control for power consumptio=
n of devices
>>>>> such as GPS trancievers and GSM modems. Moreover, in SoC based syst=
ems it is
>>>>> possible to switch on/off power to entire subsystem when it is not =
used.
>>>>>
>>>> I'd also ask the question, Why?
>>>> If exposing to user space it leaves the possibility of damaging hard=
ware
>>>> or completely frying a board.
>>> Suppose you have a handheld device with GPS transceiver. You would li=
ke to give
>>> user the ability to switch the transceiver on and off.
>>>
>> Then the GPS drivers should be made aware and let the drivers handle t=
he
>> on/off interface.  If a user is allowed to turn interfaces on/off at
>> will with this then drivers could suffer from (shock)...  ie: you coul=
d
>> turn off your hard-drive in a middle of a write by the driver corrupti=
ng
>> data, if handled in the driver it could finish the write before turnin=
g
>> off the drive.  I know this is a far stretch from a GPS were the devic=
e
>> is only READ only.
>=20
> The point is there's no GPS driver... GPS transceivers are usually conn=
ected to
> a serial line and the applications access the GPS data through ttySX. T=
he case
> when there is a kernel driver for device connected to a regulator is co=
mpletely
> different. It is then the driver responsibility to decide when to power=
 on/off
> the device.
>=20
>> I do agree it could be useful, but we need to be careful on how much
>> control the user has over the drivers and system.  To an extreme, a us=
er
>> could be able to turn off CPU cores outside of the drivers control
>> causing serious pipeline hazards that would need to be handled at the
>> driver level.  This would not be an issue for GPS were the data is rea=
d
>> only and the missing data is really not that important to the system
>> operation and continued use.
>>
>> James
>>
>=20
Ok.  You have a valid point.

What about a GPS driver that can use the RS232 interface as the
transport.  Much like the IDE over Parallel Port in older kernels did.
This way the driver would still be responsible and not have to
completely expose the regulator control.

James


--------------enigF3FBC6304210C9A7A2E1C3AF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAknt2MsACgkQkNLDmnu1kSkXogCeMREObXFagpbThWxD42dBX/IS
nvcAnjBM7hqgvK0wqBPUhW33APA1I6yZ
=rqTj
-----END PGP SIGNATURE-----

--------------enigF3FBC6304210C9A7A2E1C3AF--
