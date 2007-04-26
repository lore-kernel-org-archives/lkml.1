Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbXDZNtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbXDZNtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 09:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbXDZNtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 09:49:46 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:11344 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791AbXDZNtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 09:49:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type;
        b=Cu/tuZD2XSTFWBX1et1fqucRDaXXRwMB0kJzy14sNMYbextYaugPj54j5iSdctplQkceL7veBUv3g26GQboHXRTE2ow1CP7qEi0LsWBi1UkCZhfPF+OmiXqA0R2d8c86nyp/8/0OMWdgtI0qXi0Her7krxC2jj8/A2Q7/SXE7wA=
Date: Thu, 26 Apr 2007 06:49:27 -0700
From: Mike Mattie <codermattie@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: htpt366 PCI latency value is really high
Message-ID: <20070426064927.13d0ed72@reforged>
X-Mailer: Claws Mail 2.6.1 (GTK+ 2.10.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary=Sig_suxTBialRlNvBpgZB4hRFBu;
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_suxTBialRlNvBpgZB4hRFBu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

while hunting down some latency problems I found something quite odd.
The latency reported by lspci -v for the HTP203N card is enormous.

00:09.0 RAID bus controller: Triones Technologies, Inc. HPT302/302N
(rev 02) Subsystem: Triones Technologies, Inc. Unknown device 0001
        Flags: bus master, 66MHz, medium devsel, latency 120, IRQ 17
        I/O ports at ec00 [size=3D8]
        I/O ports at e800 [size=3D4]
        I/O ports at e400 [size=3D8]
        I/O ports at e000 [size=3D4]
        I/O ports at dc00 [size=3D256]
        Expansion ROM at dffe0000 [disabled by cmd] [size=3D128K]
        Capabilities: [60] Power Management version 2


I am assuming that the "latency" field here is the PCI latency timer
which means this card is a bus hog.=20

=46rom some reading on this issue linux methodically sets a sane value for=20
all the PCI cards it sets up, which looks normal on the rest of the system,=
=20
which is set to the value: 32

setting the value 32 with:

setpci -v -s "00:09.0" latency_timer=3D32

00:09.0 RAID bus controller: Triones Technologies, Inc. HPT302/302N (rev 02)
        Subsystem: Triones Technologies, Inc. Unknown device 0001
        Flags: bus master, 66MHz, medium devsel, latency 48, IRQ 17
        I/O ports at ec00 [size=3D8]
        I/O ports at e800 [size=3D4]
        I/O ports at e400 [size=3D8]
        I/O ports at e000 [size=3D4]
        I/O ports at dc00 [size=3D256]
        Expansion ROM at dffe0000 [disabled by cmd] [size=3D128K]
        Capabilities: [60] Power Management version 2

Results in 48, which is not what I asked, but hopefully this is
linux doing the right thing.

I know this chipset is pretty brain-damaged, but is this
high latency value a work-around for broken hardware, or
just a oversight ?

Cheers,
Mike Mattie - codermattie@gmail.com

--Sig_suxTBialRlNvBpgZB4hRFBu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGMK3sdfRchrkBInkRAt2IAJ0ThMQ+kCmBMTFvo5KTC8VLzMQmTgCfd1NJ
pBNHMfwwqupcPrKLehzNj28=
=PCJW
-----END PGP SIGNATURE-----

--Sig_suxTBialRlNvBpgZB4hRFBu--
