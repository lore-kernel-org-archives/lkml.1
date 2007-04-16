Return-Path: <linux-kernel-owner+w=401wt.eu-S1753943AbXDPFsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbXDPFsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 01:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbXDPFsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 01:48:54 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:49807 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945AbXDPFsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 01:48:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:x-mailer:mime-version:content-type;
        b=m0ps9cn4wpPeyeM2WIV5IxpXlJz+6UQFreGceowX3vHWdwakXDQaUdxeHoI3i8Kp6cD/r2UelINqJlENFEbjA2mFHMFtwn6O6EcxpczlosRMcoFzAJENNcUT2a/PNT7D5PKPHxzXKCnW139LpryuqVbUnFUr25MHao408KF+68Q=
Date: Sun, 15 Apr 2007 22:48:46 -0700
From: Mike Mattie <codermattie@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [BUG] 2.6.21-rc7 hpt366 driver broken
Message-ID: <20070415224846.52a465b6@reforged>
X-Mailer: Claws Mail 2.6.1 (GTK+ 2.10.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary=Sig_px8GjtOpPBIcclmHeZIxBMH;
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_px8GjtOpPBIcclmHeZIxBMH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

I am testing the 2.6.21-rc7 kernel release. The IDE hpt366 driver is crashi=
ng hanging the boot.
I have basically the same config as 2.6.20.7 which works fine (except for n=
etconsole mentioned in
a previous mail).

here is the hand-copied info:

* "unable to handle paging request" , null deref

* EIP @ init_chipset_hpt366

init_setup_hpt302
htp366_init_one
ide_scan_pcidev
ide_scan_pcibus
ide_init
init

some hardware info:

/usr/sbin/lspci -v | grep -i HPT -A 9                 [mattie@reforged]
00:09.0 RAID bus controller: Triones Technologies, Inc. HPT302/302N
(rev 02) Subsystem: Triones Technologies, Inc. Unknown device 0001
        Flags: bus master, 66MHz, medium devsel, latency 120, IRQ 18
        I/O ports at ec00 [size=3D8]
        I/O ports at e800 [size=3D4]
        I/O ports at e400 [size=3D8]
        I/O ports at e000 [size=3D4]
        I/O ports at dc00 [size=3D256]
        Expansion ROM at dffe0000 [disabled by cmd] [size=3D128K]
        Capabilities: <access denied>

I cannot get more information since netconsole is broken.

I am running a git-bisect to see if I can resolve it to a commit.

Cheers,
Mike Mattie

--Sig_px8GjtOpPBIcclmHeZIxBMH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGIw5CdfRchrkBInkRAl8IAKDsUOvUbQX/Ebd684d3jyZB7j4UtACgos+4
xcm886PIhCI3JYtvSc/LkQA=
=6v9Y
-----END PGP SIGNATURE-----

--Sig_px8GjtOpPBIcclmHeZIxBMH--
