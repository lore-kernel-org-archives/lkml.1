Return-Path: <linux-kernel-owner+w=401wt.eu-S1752643AbZAKSu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbZAKSu1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 13:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbZAKSuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 13:50:19 -0500
Received: from xsmtp1.ethz.ch ([82.130.70.13]:34049 "EHLO xsmtp1.ethz.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbZAKSuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 13:50:18 -0500
Message-ID: <496A3F62.8090902@gmx.de>
Date: Sun, 11 Jan 2009 19:50:10 +0100
From: Dieter Ries <clip2@gmx.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20090102)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, travis@sgi.com, rusty@rustcorp.com.au
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc1 does not boot
References: <496A085E.8020604@gmx.de> <20090111151924.GA5722@elte.hu> <496A107A.2090301@gmx.de> <20090111153548.GB7401@elte.hu>
In-Reply-To: <20090111153548.GB7401@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA24B0950A34AE17E4BAD9CB1"
X-OriginalArrivalTime: 11 Jan 2009 18:50:16.0134 (UTC) FILETIME=[71599660:01C9741D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA24B0950A34AE17E4BAD9CB1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

Ingo Molnar schrieb:
>>> * Dieter Ries <clip2@gmx.de> wrote:
>>>
>>>> Hi,
>>>>
>>>> I just pulled 2.6.29-rc1, ran oldconfig with defaults and built it.
>>>> When I try to boot it, that kind of works until init should start. T=
hen
>>>> nothing happens. I tried with init=3D/bin/bash, which sometimes work=
s, and
>>>> sometimes gets me a bash without the prompt flashing.
>>>>
>>>> I captured the output with netconsole, but I cannot see a problem th=
ere.
>>>> It is attached.
>>>>
>>>> My config is also attached.
>>>>
>>>> The machine:
>>>>
>>>> Lenovo Thinkpad T60
>>>> Core2Duo 2GHz
>>>>
>>>> Gentoo 64bit
>>>>
>>>>
>>>> What else should I provide for debugging that?
>=20
> Unless you can see some particular badness in the kernel messages=20
> (something that changed to the last working version) that narrows it do=
wn=20
> to some subsystem, i suspect this would have to be bisected ...

Bisected it:

####################################################################
7503bfbae89eba07b46441a5d1594647f6b8ab7d is first bad commit
commit 7503bfbae89eba07b46441a5d1594647f6b8ab7d
Author: Mike Travis <travis@sgi.com>
Date:   Sun Jan 4 05:18:09 2009 -0800

cpumask: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write

Impact: use new cpumask API to reduce stack usage

Replace the saving of current->cpus_allowed and set_cpus_allowed_ptr()
with a work_on_cpu function for drv_read() and drv_write().

Basically converts do_drv_{read,write} into "work_on_cpu" functions that
are now called by drv_read and drv_write.

Signed-off-by: Mike Travis <travis@sgi.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
####################################################################

I reverted that patch, which makes my machine boot again. So I guess
theres something wrong here. Please tell me which information you need
to fix the problem, I will help as I can.


>=20
> 	Ingo
>=20

cu
Dieter

--=20
3rd Law of Computing:
        Anything that can go wr
fortune: Segmentation violation -- Core dumped


--------------enigA24B0950A34AE17E4BAD9CB1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAklqP2UACgkQ5YzjaZZeXo2pFQCfW1Zu2uHIm/xoOzAoBDqF5T+7
fd8An3a5aOYoTRlC8Y9IJvWuVtJd/oKL
=ZUr1
-----END PGP SIGNATURE-----

--------------enigA24B0950A34AE17E4BAD9CB1--
