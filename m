Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbYAYL4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbYAYL4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 06:56:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbYAYLzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 06:55:54 -0500
Received: from mailsrv1.zmi.at ([212.69.162.198]:50540 "EHLO mailsrv1.zmi.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbYAYLzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 06:55:53 -0500
From: Michael Monnerie <michael.monnerie@it-management.at>
Organization: it-management http://it-management.at
To: netatalk-admins@lists.sourceforge.net
Subject: netatalk slow after system upgrade (possibly kernel problem?)
Date: Fri, 25 Jan 2008 12:55:42 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6632945.TfUIJRfp3V";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200801251255.48105@zmi.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6632945.TfUIJRfp3V
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Dear lists,

I've been spending a LOT of time trying to find out where's the problem,=20
but can't find it and therefore seek urgent help now. We have the=20
following system:

Server with VMware server
=2D> VM running a webserver and netatalk
=2D> 2 other VMs not related

The VM with netatalk was SUSE 10.0 with kernel 2.6.13-15.15-smp (from=20
SUSE), and things were pretty fun and quick. Then we upgraded to SUSE=20
10.2 and now 10.3, where everything EXCEPT netatalk runs perfect. Since=20
this upgrade, Apple clients (MacOS X) now do READ very very slowly=20
(about 512KB/s over the gigabit LAN), while writing to the server still=20
is normal (>20MB/s). I've even retried with the newest kernel=20
2.6.23.13, tried different /proc/sys/net/ipv4/tcp_congestion_control=20
(cubic, reno, bic, etc.) and nothing helps. I've then tried to install=20
Samba and found that we have similar problems reading with it from=20
MacOS clients. Now I'm pretty sure it should be something with the=20
linux kernel, but I don't understand what.

Here are the wireshark dumps in pcap format:
http://zmi.at/x/atalk-write-fast.pcap
=2D> you can see writing to the server (192.168.120.9) is normal and fast

http://zmi.at/x/atalk-read-slow.pcap
=2D> reading is horribly slow. Lots of "unknown", because of netatalk or=20
what?

http://zmi.at/x/unknown-atalk.pcap
=2D> another dump while reading, you see "unknown" reads. I'm not sure if=20
it's just wireshark not understanding the packets or netatalk.

And trying with samba:
http://zmi.at/x/smb-read-slow.pcap
http://zmi.at/x/smb-write-quick.pcap
you can see that it's also slow.

Now why did it work with the old 2.6.13 kernel? I still have that old=20
VM, and when I start it, it is always perfectly fast. Only newer=20
versions are slow. Can somebody give me a hint please?

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0676/846 914 666                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: www.keyserver.net                   Key-ID: 1C1209B4

--nextPart6632945.TfUIJRfp3V
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHmc5EzhSR9xwSCbQRAoEQAKDoG5CEGGDORjDVZGBwaJxiYWHdcgCgxsUG
rI8osiKsMQ6I1Qby0n/CE2s=
=Jd7R
-----END PGP SIGNATURE-----

--nextPart6632945.TfUIJRfp3V--
