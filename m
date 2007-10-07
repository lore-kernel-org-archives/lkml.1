Return-Path: <linux-kernel-owner+w=401wt.eu-S1755208AbXJGQr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbXJGQr4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 12:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbXJGQrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 12:47:49 -0400
Received: from mail.gmx.net ([213.165.64.20]:37304 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751854AbXJGQrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 12:47:48 -0400
X-Authenticated: #815327
X-Provags-ID: V01U2FsdGVkX19jzj0ruY5jNmT+meEjCqCSQmZH0z3htLNL7JmBWI
	KAP2b737cpiVFX
Date: Sun, 7 Oct 2007 18:47:41 +0200
From: Malte =?UTF-8?B?U2NocsO2ZGVy?= <maltesch@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Strange network related data corruption
Message-ID: <20071007184741.3b1951c1@highlander.home.lan>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/W=SulzrQ8FVbxWLB0T1Bkfj";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/W=SulzrQ8FVbxWLB0T1Bkfj
Content-Type: multipart/mixed; boundary="MP_/gbekJIm8bJITx.Ku1==4rPs"

--MP_/gbekJIm8bJITx.Ku1==4rPs
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,
I am encountering some strange data corruption when transferring
data from one of my PCs that I use as a file-server.

on the server:
FILE=3D<large file>; | cut -d" " -f1 | nc -lp5000 -q0; while nc
-lp5000 -q0 < $FILE; do : ; done

on the client:
H=3D<server>; SUM=3D$(nc -q0 $H 5000);sleep 1s; while nc -q0 $H 5000 |
sha1sum | (grep -v $SUM || echo -n .); do sleep 1s ;done

(output looks somewhat like this:
..............6dd5fb1ce29d270acdfbb02d00921bf75d141773  -
...
)

I would expect the sha1sum to be the same in every pass (assuming the
source file does not change). But every few passes (with no apparent
pattern) there is a different sum returned. I first noticed this when
transferring large files (backups) with with SMB and NFS(v3 and v4) but
to rule that out I tried netcat in the way noted above.

When I have the server do the sha1sum of the file locally the problem
is not reproducible. When I do this with a small file that easily fits
into the cache the problem stays reproducible.

Another thing I did was to use dd to transfer data in 1GiB chunks from
/dev/zero and generate the sha1sum on the client. There I was not able
to reproduce the problem.


The server is a Athlon64 3400+ (good old Clawhammer) with 1GiB RAM. I
use 4 SATA drives in a software RAID5 configuration, attached to a
Promise TX4 300 SATA-II controller. The filesystem is ext3 without
special mount-options. The dist is Debian/Sid for AMD64 with
self-compiled kernel 2.6.23-rc9 (.config attached).

The clients I tried are a Core2Duo 6600 with 3GiB of RAM, also
Debian/Sid AMD64 (kernel 2.6.23-rc9) and a Centrino notebook with
Pentium M and 1GiB of RAM (Debian/Sid i386, kernel 2.6.23-rc7).

All PCs mentioned have gigabit ethernet and are connected via a gigabit
switch.

I tried these tests between the clients and could not reproduce the
problem there.

I had the server run memtest68+ with 20 passes without problems.

I tried several kernel versions on the server (from .18 to .23-rc9), all
showed the problem. I suspect a hardware problem, but I cannot isolate
the part responsible. I tried another ethernet adapter (the 3com905cin
lspci output) and I also tried the onboard sata controller(s) (2 ports
via and 2 ports promise tx2).

I don't know if this is a kernel problem or just my and my setup, but
maybe some one on this list has an idea wher I could look next.

Thanks and regards
Malte
--=20
---------------------------------------
Malte Schr=C3=B6der
MalteSch@gmx.de
ICQ# 68121508
---------------------------------------


--MP_/gbekJIm8bJITx.Ku1==4rPs
Content-Type: text/plain; name=config-2.6.23-rc9
Content-Disposition: attachment; filename=config-2.6.23-rc9

-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
--MP_/gbekJIm8bJITx.Ku1==4rPs--
--Sig_/W=SulzrQ8FVbxWLB0T1Bkfj--
