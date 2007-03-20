Return-Path: <linux-kernel-owner+w=401wt.eu-S1030801AbXCTAyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030801AbXCTAyx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 20:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966064AbXCTAyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 20:54:53 -0400
Received: from lana.hrz.tu-chemnitz.de ([134.109.132.3]:40018 "EHLO
	lana.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966062AbXCTAyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 20:54:52 -0400
From: Tobias Doerffel <tobias.doerffel@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Suspend to RAM doesn't work anymore in 2.6.21
Date: Tue, 20 Mar 2007 01:54:45 +0100
User-Agent: KMail/1.9.6
References: <200703191350.44105.tobias.doerffel@gmail.com> <200703192243.20836.rjw@sisk.pl>
In-Reply-To: <200703192243.20836.rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2180764.zSylXJFeQB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200703200154.49695.tobias.doerffel@gmail.com>
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.1.8 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: a3b0e08747af407ddbe205f4431f3cdb
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2180764.zSylXJFeQB
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 19 March 2007 22:43:20 you wrote:
> Hi,
>
> On Monday, 19 March 2007 13:50, Tobias Doerffel wrote:
> > Hi,
> >
> > Suspend to RAM used to work fine on my computer (Intel Core Duo, 1 GB
> > RAM, Intel 82801G (ICH7-chipset) mainboard, NVIDIA-gfx-card,
> > tg3-ethernet) up to 2.6.20.3. But no matter which rc of 2.6.21 I use,
> > suspend to RAM doesn't work anymore. Up to rc3 even suspending stopped =
at
> > "suspending console" which appearently seems to be fixed in rc4. I tried
> > rc4-git4 with minimal config (no dyndicks, no HRT, no MSI, no sound, no
> > bluetooth, no PCMCIA, no WLAN, no USB, no cpufreq) but still I can't
> > resume properly. Caps works and I can login through SSH. Back to a more
> > complete config (sound, MMC, WLAN, PCMCIA - still no dynticks or HRT -
> > see attachment "config") I get exactly the same behaviour.
> >
> > When logged in through SSH after resume I saved output of dmesg (which
> > includes full power management debug messages), see
> > attachement "dmesg-resume". The system basically seems to be back but l=
ot
> > of things do not work such as loading/unloading e.g. my WLAN-driver
> > (ipw3945), running "top" or "dstat" etc.   "uptime" always returns 0 mi=
n,
> > even with power management debug disabled.
> >
> > Kernel:
> > Linux version 2.6.21-rc4 (gcc version 4.1.2 20061115 (prerelease) (Debi=
an
> > 4.1.1-21)) #23 SMP PREEMPT Mon Mar 19 12:27:56 CET 2007
I made some further investigations on this issue. A complete bisect between=
=20
2.6.20 and 2.6.21-rc4-git4 stops at a stage=20
(a4bbb810dedaecf74d54b16b6dd3c33e95e1024c) where I'm not able to compile th=
e=20
kernel anymore because of compiling-errors in arch/i386/kernel/setup.c=20
(ACPI-related compiling errors). Stepping some revisions back until it=20
compiled again resume didn't work either.

So I started all over again with bisect only on arch/i386 and ended up at=20
ceb6c46839021d5c7c338d48deac616944660124 as the bad commit. But this file=20
seems to be some kind of finalization of a series of patches ("ACPICA: Remo=
ve=20
duplicate table manager") so I guess it's hard to debug this thing...

> Can you please do
>
> # echo test > /sys/power/disk
> # echo disk > /sys/power/state
>
> (the system should freeze tasks, suspend devices, disable nonboot CPUs,
> wait for 5 seconds, enable nonboot CPUs, resume devices, thaw tasks and
> return to your command prompt) and see if you can reproduce the problem?
Same problem here. Works fine in 2.6.20 as well as before=20
ceb6c46839021d5c7c338d48deac616944660124. Doesn't work on recent=20
2.6.21-rc4-git4.

Any more information I can give?

Tobias

--nextPart2180764.zSylXJFeQB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD4DBQBF/zDZHsjdpw2OaacRAu/3AJ4sl0EooHwm864XKEnB58sUKyhiDgCWMTcf
0Tur6hmmMkhN9LxS9f9txQ==
=jsoO
-----END PGP SIGNATURE-----

--nextPart2180764.zSylXJFeQB--
