Return-Path: <linux-kernel-owner+w=401wt.eu-S935434AbYD1SB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935434AbYD1SB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 14:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933561AbYD1SBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 14:01:14 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:30521 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763964AbYD1SBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 14:01:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:references:in-reply-to:cc:mime-version:content-type:content-transfer-encoding:message-id;
        b=CHRXKTXamTTyrGlkTgqoLLR9GFwGJ9eMCzYhYN0sH7pj/DPPgwAKU3CephIPPH8evTAWAwHnz8fhiWbHJntipsP9+/34w9r1xAY4OGWJZ4ovYt3UVPHQyTvo8/4ha2BNcpJsjLP27eGyleRK/v+Rln7nU+dHJ1JHTrlcYNKiOoU=
From: Daniel Klaffenbach <danielklaffenbach@gmail.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [2.6.25-stable PATCH] regression: powertop says 120K wakeups/sec
Date: Mon, 28 Apr 2008 20:01:00 +0200
User-Agent: KMail/1.9.9
References: <200804242015.19462.lenb@kernel.org> <200804281209.47927.danielklaffenbach@gmail.com> <924EFEDD5F540B4284297C4DC59F3DEEF31621@orsmsx423.amr.corp.intel.com>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEEF31621@orsmsx423.amr.corp.intel.com>
Cc: "Len Brown" <lenb@kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1999919.mZ0I2DdeAx";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200804282001.06680.danielklaffenbach@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1999919.mZ0I2DdeAx
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Pallipadi, Venkatesh wrote:
> Did C1, C2 work fine with 2.6.24?
> Can you send me the full dmesg when it is failing to enter C1, C2 with
> latest git + patch.
> Output of
> #grep . /sys/devices/system/cpu/cpu*/cpuidle/*/*
> And also attach the acpidump output (pmtools package here
> http://www.lesswatts.org/projects/acpi/utilities.php)
No, C1/C2 did not seem to work with 2.6.24 - at least powertop reported 99,=
9%=20
C0 usage. It was the same behavior as after applying the wakeup patch.=20
However in 2.6.25 and 2.6.25-git11 C1/C2 worked correctly and C2 showed up =
in=20
pt. But after applying your patch to 2.6.25-git11 they did not:

git11:
PowerTOP version 1.9       (C) 2007 Intel Corporation
Cn                Avg residency       P-states (frequencies)
C0 (cpu running)        ( 9,4%)         1,80 Ghz   100,0%
C1                0,0ms ( 0,0%)         1,60 Ghz     0,0%
C2                0,4ms (90,6%)          800 Mhz     0,0%
Wakeups-from-idle per second : 9051,0   interval: 5,0s

git11 with wakeup-patch:
PowerTOP version 1.9       (C) 2007 Intel Corporation
Cn                Avg residency       P-states (frequencies)
C0 (cpu running)        (99,9%)         1,80 Ghz   100,0%
C1                0,0ms ( 0,0%)         1,60 Ghz     0,0%
C2                0,2ms ( 0,1%)          800 Mhz     0,0%
Wakeups-from-idle per second : 59,8     interval: 10,0s

In both cases the system was idle. I've uploaded the files you wanted:
http://www-user.tu-chemnitz.de/~klada/misc/kernel/cpuidle_git11.txt
http://www-user.tu-chemnitz.de/~klada/misc/kernel/cpuidle_git11_wakeuppatch=
=2Etxt
http://www-user.tu-chemnitz.de/~klada/misc/kernel/dmesg_git11.txt
http://www-user.tu-chemnitz.de/~klada/misc/kernel/dmesg_git11_wakeuppatch.t=
xt
http://www-user.tu-chemnitz.de/~klada/misc/kernel/nx6125_acpidump.out

If there is anything else I can do for debugging this issue please let me=20
know.

=2D Daniel

--nextPart1999919.mZ0I2DdeAx
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBIFhDiM8RD99ZskA8RArTbAJwO/3ORYomwNZPOY41B3+TH8nFmegCdH90X
Dl6SKxwfSjUAt48NhzODS+I=
=Kuf5
-----END PGP SIGNATURE-----

--nextPart1999919.mZ0I2DdeAx--
