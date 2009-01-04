Return-Path: <linux-kernel-owner+w=401wt.eu-S1757952AbZADMFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952AbZADMFx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 07:05:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750877AbZADMFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 07:05:45 -0500
Received: from mail.gmx.net ([213.165.64.20]:41321 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750795AbZADMFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 07:05:44 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+Syv4fuACSGogYhYndp3AYjd743qsh3NhN8AtI2i
	MBDEMiuiqiqeX6
From: Toralf =?iso-8859-15?q?F=F6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: 2.6.27.10:  CPU ondemand governor doesn't work well
Date: Sun, 4 Jan 2009 13:05:34 +0100
User-Agent: KMail/1.9.10
Cc: cpufreq@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart30042847.jyrcqDUBTU";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200901041305.39883.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart30042847.jyrcqDUBTU
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Starting with kernel 2.6.27.10 I observed sometimes that my ThinkPad T41 st=
ays=20
at CPU frequency of 600 MHz when I run a lot of processes with nice level 3=
=20
and few more at 19 - even if I have some foreground jobs which normally for=
ce=20
the CPU to go to at 1700 MHz=20
A typical scenario is to compile glibc at a Gentoo system mit "make -j 2" a=
nd=20
then run another make job at nice level 0 or try to start firefox (which=20
start time itself is OTOH slow enough even with 1.7 GHz). I can quantify th=
is=20
observation with a quick&dirty command line like :

$> time factor 819734028463158891

I would expect a real value of 6-7 seconds and a user value of 5-6 seconds.=
=20
However when I used it 2 times in a row I got :

tfoerste@n22 ~ $ time factor 819734028463158891
819734028463158891: 3 273244676154386297

real    0m51.658s
user    0m15.691s
sys     0m0.013s

tfoerste@n22 ~ $ time factor 819734028463158891
819734028463158891: 3 273244676154386297

real    0m19.136s
user    0m6.944s
sys     0m0.044s

BTW during startup I set :

$>echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/ondemand/ignore_nice_load

My system:

tfoerste@n22 ~ $ uname -a
Linux n22 2.6.27-gentoo-r7 #12 Sun Dec 28 18:26:57 CET 2008 i686 Intel(R)=20
Pentium(R) M processor 1700MHz GenuineIntel GNU/Linux

The appropriate kernel config values are :

tfoerste@n22 ~/devel/wireshark/docbook $ zgrep -e GOV -e=20
=46REQ /proc/config.gz  | grep -v '#'
CONFIG_CPU_FREQ=3Dy
CONFIG_CPU_FREQ_TABLE=3Dy
CONFIG_CPU_FREQ_STAT=3Dm
CONFIG_CPU_FREQ_STAT_DETAILS=3Dy
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=3Dy
CONFIG_CPU_FREQ_GOV_PERFORMANCE=3Dy
CONFIG_CPU_FREQ_GOV_POWERSAVE=3Dm
CONFIG_CPU_FREQ_GOV_ONDEMAND=3Dy
CONFIG_X86_ACPI_CPUFREQ=3Dm
CONFIG_CPU_IDLE_GOV_LADDER=3Dy
CONFIG_CPU_IDLE_GOV_MENU=3Dy

=2D-=20
MfG/Sincerely

Toralf F=F6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3


--nextPart30042847.jyrcqDUBTU
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAklgphMACgkQhyrlCH22naNCOQCghZC8IAsAcus6HWpSn/hk8Vyv
giAAnivBBFuU5M7urxF8/2gQ52Kwbhek
=8Sma
-----END PGP SIGNATURE-----

--nextPart30042847.jyrcqDUBTU--
