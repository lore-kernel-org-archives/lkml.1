Return-Path: <linux-kernel-owner+w=401wt.eu-S1755783AbYCXWjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbYCXWjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 18:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbYCXWjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 18:39:11 -0400
Received: from mail.phnxsoft.com ([195.227.45.4]:2446 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbYCXWjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 18:39:09 -0400
Message-ID: <47E82D68.5070305@imap.cc>
Date: Mon, 24 Mar 2008 23:38:32 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [2.6.25-rc6] possible regression: X server dying
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig9248800D3441654A37F1B170"
X-Spam-Score: -0.658 () AWL,BAYES_50,RDNS_DYNAMIC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9248800D3441654A37F1B170
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

In the five days since I booted a 2.6.25-rc6 kernel on my development
machine, it has happened three times already that I came back to the
machine to find that the X server had exited, killing all applications
that still had a window open. This has never happened with previous
kernel versions (2.6.22.17, 2.6.24.3, 2.6.25-rc5), so I suspect some
relation to the latest rc kernel.

Syslog entries around the time of the crash (identical each time):

Mar 24 21:59:57 xenon kernel: [424469.161592] PM: Removing info for No
Bus:vcs7
Mar 24 21:59:57 xenon kernel: [424469.162591] PM: Removing info for No
Bus:vcsa7
Mar 24 21:59:57 xenon kernel: [424469.179556] uhci_hcd 0000:00:1d.1:
release dev 4 ep81-INT, period 8, phase 4, 93 us
Mar 24 21:59:57 xenon gconfd (ts-21705): Signal 15 erhalten,
ordungsgem=E4=DFes Herunterfahren
Mar 24 21:59:57 xenon gconfd (ts-21705): Beenden
Mar 24 21:59:57 xenon gdm[21341]: WARNING: gdm_slave_xioerror_handler:
Schwerwiegender X-Fehler - :0 wird neu gestartet
Mar 24 21:59:58 xenon kernel: [426716.212842] PM: Adding info for No
Bus:vcs7
Mar 24 21:59:58 xenon kernel: [426716.213300] PM: Adding info for No
Bus:vcsa7
Mar 24 21:59:58 xenon kernel: [426716.295997] PM: Removing info for No
Bus:vcs7
Mar 24 21:59:58 xenon kernel: [426716.296110] PM: Removing info for No
Bus:vcsa7
Mar 24 21:59:59 xenon kernel: [426716.434662] PM: Adding info for No
Bus:vcs7
Mar 24 21:59:59 xenon kernel: [426716.434742] PM: Adding info for No
Bus:vcsa7
Mar 24 22:00:00 xenon kernel: [426717.727427] uhci_hcd 0000:00:1d.1:
reserve dev 4 ep81-INT, period 8, phase 4, 93 us
Mar 24 22:00:00 xenon kernel: [424472.319521] uhci_hcd 0000:00:1d.1:
release dev 4 ep81-INT, period 8, phase 4, 93 us
Mar 24 22:00:00 xenon kernel: [426717.997926] uhci_hcd 0000:00:1d.1:
reserve dev 4 ep81-INT, period 8, phase 4, 93 us
Mar 24 22:00:02 xenon gconfd (root-15531): (Version 2.20.0) wird
gestartet, Prozesskennung 15531, Benutzer =BBroot=AB
Mar 24 22:00:02 xenon gconfd (root-15531): Die Adresse
=BBxml:readonly:/etc/gconf/gconf.xml.mandatory=AB wurde an der Position 0=
 zu
einer nur lesbaren Konfigurationsquelle aufgel=F6st
Mar 24 22:00:02 xenon gconfd (root-15531): Die Adresse
=BBxml:readwrite:/root/.gconf=AB wurde an der Position 1 zu einer
schreibbaren Konfigurationsquelle aufgel=F6st
Mar 24 22:00:02 xenon gconfd (root-15531): Die Adresse
=BBxml:readonly:/etc/gconf/gconf.xml.defaults=AB wurde an der Position 2 =
zu
einer nur lesbaren Konfigurationsquelle aufgel=F6st
Mar 24 22:00:02 xenon gconfd (root-15531): Die Adresse
=BBxml:readonly:/etc/gconf/gconf.xml.schemas=AB wurde an der Position 3 z=
u
einer nur lesbaren Konfigurationsquelle aufgel=F6st
Mar 24 22:00:05 xenon kernel: [426722.904631] gtk-window-deco[15527]:
segfault at 4 ip b785c98a sp bfa4d160 error 4 in
libcairo.so.2.11.5[b7852000+7c000]

(The translation of the German error message from gdm is:
"Serious X error - restarting :0"
The German language messages from gconfd are probably not important,
as they appear identically during a regular X logout/login cycle.)

I'm at a loss where to start investigating this. Bisecting appears
impractical given the error happens about every other day with no
obvious triggering condition (except me being afk for a longer time.)

Configuration: Pentium D940, 2 GB RAM, Intel 965 chipset, Matrox
G550 PCIe graphics adapter, openSUSE 10.3 32 bit install.

Ideas?

Thanks
Tilman



--------------enig9248800D3441654A37F1B170
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFH6C17Q3+did9BuFsRAo8aAJ0UdIqh2rcs+r0VPyVnH+ssgxTijACfXvld
ZjQB+HsnjHDzCQVhGzzvEjQ=
=PubG
-----END PGP SIGNATURE-----

--------------enig9248800D3441654A37F1B170--
