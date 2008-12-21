Return-Path: <linux-kernel-owner+w=401wt.eu-S1754434AbYLUOXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbYLUOXz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 09:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbYLUOXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 09:23:48 -0500
Received: from mail.klingt.org ([86.59.21.178]:51679 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186AbYLUOXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 09:23:47 -0500
Subject: 2.6.28-rc9: oprofile regression
From: Tim Blechmann <tim@klingt.org>
To: oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1bjqSJNaRTaXLCfPMrVu"
Date: Sun, 21 Dec 2008 15:23:36 +0100
Message-Id: <1229869416.6911.1.camel@thinkpad>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (klingt.org [127.0.0.1]); Sun, 21 Dec 2008 15:23:43 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1bjqSJNaRTaXLCfPMrVu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

hello all,

i am experiencing an issue, similar to the one reported in
http://lkml.org/lkml/2008/10/30/319.

each time, i start the oprofile daemon, one NMI per cpu is executed. the
cpu is an intel core2 duo t7400, x86_64 architecture.

root@thinkpad:~# opcontrol -s
Using 2.6+ OProfile kernel interface.
Using log file /var/lib/oprofile/samples/oprofiled.log
Daemon started.
Profiler running.

tim@thinkpad:~/kernel/linux-2.6$ cat /proc/interrupts |grep NMI
NMI:          3          3   Non-maskable interrupts

root@thinkpad:~# opcontrol -h
Stopping profiling.
Killing daemon.

root@thinkpad:~# opcontrol -s
Using 2.6+ OProfile kernel interface.
Using log file /var/lib/oprofile/samples/oprofiled.log
Daemon started.
Profiler running.

tim@thinkpad:~/kernel/linux-2.6$ cat /proc/interrupts |grep NMI
NMI:          4          4   Non-maskable interrupts

oprofile samples are not collected.

commit 7c64ade53a6f977d73f16243865c42ceae999aea, which solved the issue
in the 2.6.28-rc2 regression, is already included in the 2.6.28-rc9
kernel, i am currently running. oprofile works fine with kernel 2.6.27
on the same machine.

best, tim

--
tim@klingt.org
http://tim.klingt.org

Nothing exists until or unless it is observed. An artist is making
something exist by observing it. And his hope for other people is that
they will also make it exist by observing it. I call it 'creative
observation.' Creative viewing.
  William S. Burroughs

--=-1bjqSJNaRTaXLCfPMrVu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklOUWIACgkQFz+XezW6HD6q+ACgo/UVaCVJ5BUz/8wnmf4KPqYy
uw4AoLDguyeGdEYWJLhvrFMF5CZm0EIw
=Md4G
-----END PGP SIGNATURE-----

--=-1bjqSJNaRTaXLCfPMrVu--

