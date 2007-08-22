Return-Path: <linux-kernel-owner+w=401wt.eu-S1764840AbXHVXFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764840AbXHVXFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 19:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758288AbXHVXFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 19:05:21 -0400
Received: from mail.computer-surgery.co.uk ([217.155.72.205]:3910 "EHLO
	nicole.computer-surgery.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757890AbXHVXFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 19:05:20 -0400
X-Greylist: delayed 2176 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Aug 2007 19:05:19 EDT
Date: Wed, 22 Aug 2007 23:29:02 +0100
To: linux-kernel@vger.kernel.org
Subject: hda_intel : Patch + Regression in 2.6.18 -> 2.6.22 
Message-ID: <20070822222902.GA28563@computer-surgery.co.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
X-GPG-Fingerprint: 72AF 0ACC 9A53 E59F B1B6  DC14 1983 A13E 5C3D 3CEB
X-GPG-Key: 1024D/5C3D3CEB (wwwkeys.uk.pgp.net)
X-Geo-Address: The Apple Barn, Maidstone Road, Pembury, Kent, TN2 4AD ,UK
X-Company: The Computer Surgery (Repair Centres) Ltd. No: 4180148
User-Agent: Mutt/1.5.9i
From: Roger Gammans <roger@computer-surgery.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi

I'm fighting a problem with my (new) Acer laptop.  (Aspire 9303)

In 2.6.18 the audio worked fine, but now I've upgraded to 2.6.22
it has stopped working.=20

I note that there is a acer specific quirk mode in patch_realtek.c
enabled for all acer devices introduced in the timeframe. Disabling
the quirk so that the driver uses it auot mode makes playback work
fine again.

To be clear this pathc seems to work for me:-

--- /usr/src/linux-source-2.6.22/sound/pci/hda/patch_realtek.c 2007-07-09 0=
0:32:17.000000000 +0100
+++ linux-source-2.6.22/sound/pci/hda/patch_realtek.c   2007-08-20 22:21:37=
=2E000000000 +0100
@@ -6392,7 +6392,7 @@
        SND_PCI_QUIRK(0x1462, 0x4319, "MSI", ALC883_TARGA_DIG),
        SND_PCI_QUIRK(0x1462, 0x4324, "MSI", ALC883_TARGA_DIG),
        SND_PCI_QUIRK(0x1462, 0xa422, "MSI", ALC883_TARGA_2ch_DIG),
-       SND_PCI_QUIRK(0x1025, 0, "Acer laptop", ALC883_ACER),
+/*     SND_PCI_QUIRK(0x1025, 0, "Acer laptop", ALC883_ACER) , */
        SND_PCI_QUIRK(0x15d9, 0x8780, "Supermicro PDSBA", ALC883_3ST_6ch),
        SND_PCI_QUIRK(0x161f, 0x2054, "Medion laptop", ALC883_MEDION),
        SND_PCI_QUIRK(0x1071, 0x8258, "Evesham Voyaeger", ALC883_LAPTOP_EAP=
D),=20


Unfortunately I think it's pretty clear it will break for others.

The lspci reports the following on the appropriate device:-
  00:10.1 0403: 10de:026c (rev a2)
        Subsystem: 1025:0112
        Flags: 66MHz, fast devsel, IRQ 19
        Memory at c0000000 (32-bit, non-prefetchable) [size=3D16K]
        Capabilities: <access denied>




TTFN
--=20
Roger. 	                        Home| http://www.sandman.uklinux.net/
Master of Peng Shui.      (Ancient oriental art of Penguin Arranging)
Work|Independent Sys Consultant | http://www.computer-surgery.co.uk/
 New key Fpr: 72AF 0ACC 9A53 E59F B1B6  DC14 1983 A13E 5C3D 3CEB=20

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFGzLiuGYOhPlw9POsRAt6bAJ42Kj0w2Kth15D85jca3jPhBY4IMQCeMvdS
Rs2VumUCjmiCGPLZEqUsjdw=
=cFuY
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
