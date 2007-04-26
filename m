Return-Path: <linux-kernel-owner+w=401wt.eu-S932332AbXDZJOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332AbXDZJOJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 05:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933699AbXDZJOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 05:14:08 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:19051 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332AbXDZJOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 05:14:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:x-mailer:mime-version:content-type;
        b=Kes+0RTegKRvf3+MXbHuR4zHaaB6FgMygTFHdBI7juCVmGed/QZK6H9e1HeENlyb/jdg5GyAApqzxeUHmLeBEidfCaUaB6BDAaSsT/CiRoX6teMC8gQXebtDwRedlWcTy0GkpBshW6Eos3oVfCrmHktc+VRxnv7urUPT5khpxPY=
Date: Thu, 26 Apr 2007 02:13:50 -0700
From: Mike Mattie <codermattie@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: recomended way to check longest period that interupts are disabled
 ?
Message-ID: <20070426021350.29ddfa0a@reforged>
X-Mailer: Claws Mail 2.6.1 (GTK+ 2.10.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_FRhUQfr90VvhNV7f3.K=cTr";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_FRhUQfr90VvhNV7f3.K=cTr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

I am still struggling to track down problems with audio playback. I get int=
ermittent:

Apr 26 02:01:40 reforged [13230.947879] cannot submit sync urb (err =3D -45)

I have tackled the scheduler issues to where I really don't think the
driver is being starved at all. I am running audacious like so:

schedtool -R -p 50 -n 1 -e audacious

At this point the strongest correlation I can get is that starting
programs seems to trigger the stutter. I have suspected IO for
some time.

My system image , / & /usr are on a libata (VIA PATA) driver.
I have disabled the write-cache , but I also have noatime set
on mount, for /usr

My big suspicion is that one of my drivers, likely IO is
disabling interrupts for too long.

I have looked but not found a tool for measuring the longest
period interrupts are disabled and pointing the finger at
the culprit, could anyone on this list recommend tools that
might help me pinpoint what is going on ?

I would also be delighted for any sort of recommended latency
testing tools.

pin-pointing this is going to be a "learning experience" but
every time I think I am about to have a bonding moment with=20
the kernel audio skips; I am highly motivated.

Cheers,
Mike Mattie - codermattie@gmail.com

--Sig_FRhUQfr90VvhNV7f3.K=cTr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGMG1XdfRchrkBInkRAhpdAJ4/wipQY/g5xQuQ1IzW2MVzwdvu3ACcDNeX
b0/MKQGM0qCq/HUs8lvSQdM=
=uYaS
-----END PGP SIGNATURE-----

--Sig_FRhUQfr90VvhNV7f3.K=cTr--
