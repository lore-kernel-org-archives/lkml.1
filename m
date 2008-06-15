Return-Path: <linux-kernel-owner+w=401wt.eu-S1759288AbYFOPGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759288AbYFOPGS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 11:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758283AbYFOPFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 11:05:50 -0400
Received: from [194.117.236.238] ([194.117.236.238]:54301 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758210AbYFOPFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 11:05:49 -0400
Date: Sun, 15 Jun 2008 18:04:46 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: tzanussi@gmail.com, linux-kernel@vger.kernel.org
Cc: penberg@cs.helsinki.fi, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, compudj@krystal.dyndns.org
Subject: [PATCH 0/3] relay buffer-only channels (resubmit)
Message-ID: <20080615180446.5af80e85@linux360.ro>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Ai9+BvA/.Ib8LZQiQkg3yHP";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Ai9+BvA/.Ib8LZQiQkg3yHP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

This is a resubmit of the buffer-only channels implementation for
relay. Basically I followed Pekka Enberg's suggestion of doing things
CPU-hotplug-aware.

The first two patches allow relay to set up an early initcall for
registering a CPU hotplug notifier. This has to run before SMP is up,
so non-boot CPUs get a buffer as soon as they're up.

Feel free to ask any questions or suggest anything.

Eduard - Gabriel Munteanu (3):
  Unignore vmlinux.lds.h from Git.
  Better interface for hooking early initcalls.
  relay: Add buffer-only channels; useful for early logging.

 .gitignore                          |    1 +
 Documentation/filesystems/relay.txt |   11 +++
 include/asm-generic/vmlinux.lds.h   |    2 +
 include/linux/init.h                |    7 ++
 include/linux/relay.h               |    5 +
 init/main.c                         |   13 +++-
 kernel/relay.c                      |  141 +++++++++++++++++++++++++++----=
----
 7 files changed, 147 insertions(+), 33 deletions(-)

--Sig_/Ai9+BvA/.Ib8LZQiQkg3yHP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iQIVAwUBSFUvkdxcOkuRpXptAQKxtw//VqHQdzD36x4N/xJdEaAA/Lf+4NeuFZU9
O9Hx81OuhKSyXz/yx+BVt0S8gDWxCRVFPZnVl3557T9z4BtWuQ4/om+KyRimUpVJ
mq6jTE8nZH3RbVJgxEA2oeRHC4oa5JMTfwqjPOv/Lks3c+WIRPSrP6aTpzvbyja+
Rrm+VPG2oAuqb9hs+DbkwqMEFl12BX8vBBSIXGyUKTr4A5NIgcJ+4UJGlILyawpb
uTY9fAXYY35jSdeH+lVbCAD5GQcRg+Z0yZhrpi6Ku5BiSSglDkZHLM2Qw4Vgukqj
jXryzh6LdxUIadzciUVfz6CC7AnqTAXYjDGfq+NMOPyRsgjz89unH9K75LKA4cZj
vC9uv5lDFuu25Db730fOobsuxkyiBO0kU4ZAP6ikSC3NdJlgvZ6rtUVXHPTsgXe1
DGZAXKzYDXp92UCFWIfrDIdPQtCPPHL/vYE6WbfImP6ISmjiyIyhHxivNy1PHWhM
KU2G6a7EfrUsr5KQ/XOw9LOJEBeKBnU5MCTgX/DGQG1PuwJDdBkhQweDkIG7kEiw
1u0YO8cO+Cufzt9RWa2kkJKksON8PM8RV68sSjbM25MHtKB4o/tGMOJZfv2z1yhM
jLHAasnhmRdd6Wqy+tsGiQYBmM+dxUEsfo4iH3tEruZliPO6QGwtg+8Zk5ADuzhe
pbVpNNrQWLQ=
=+6tm
-----END PGP SIGNATURE-----

--Sig_/Ai9+BvA/.Ib8LZQiQkg3yHP--
