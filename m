Return-Path: <linux-kernel-owner+w=401wt.eu-S1758185AbXLGUo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185AbXLGUo6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 15:44:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754903AbXLGUou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 15:44:50 -0500
Received: from threatwall.zlynx.org ([199.45.143.218]:34511 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754111AbXLGUou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 15:44:50 -0500
Subject: 2.6.24-rc4-mm1 and excessive block IO errors
From: Zan Lynx <zlynx@acm.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NoBLaUe96eM9W5cB5XRq"
Date: Fri, 07 Dec 2007 20:44:45 +0000
Message-Id: <1197060285.15428.20.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20071207/1J0k3y-0000Xy-Js-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NoBLaUe96eM9W5cB5XRq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

I am not sure if this problem has been addressed already.  I read some
about the fast-fail issues and this may be related?

On nearly all my USB block devices, I have been getting zillions of I/O
errors.  But they aren't real, they don't appear with 2.6.23 kernels.

I can often read and write data to the device, but these IO errors cause
error aborts in user space applications in many cases, making it a
chancy thing to run backup software, for example.

Here is a bit of dmesg from plugging in a perfectly good USB-2 flash
drive.

hub 3-0:1.0: state 7 ports 6 chg 0000 evt 0004
ehci_hcd 0000:00:02.2: GetStatus port 2 status 001803 POWER sig=3Dj CSC CON=
NECT
hub 3-0:1.0: port 2, status 0501, change 0001, 480 Mb/s
hub 3-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:02.2: port 2 high speed
ehci_hcd 0000:00:02.2: GetStatus port 2 status 001005 POWER sig=3Dse0 PE CO=
NNECT
usb 3-2: new high speed USB device using ehci_hcd and address 9
ehci_hcd 0000:00:02.2: port 2 high speed
ehci_hcd 0000:00:02.2: GetStatus port 2 status 001005 POWER sig=3Dse0 PE CO=
NNECT
usb 3-2: default language 0x0409
usb 3-2: uevent
usb 3-2: usb_probe_device
usb 3-2: configuration #1 chosen from 1 choice
usb 3-2: adding 3-2:1.0 (config #1, interface 0)
usb 3-2:1.0: uevent
libusual 3-2:1.0: usb_probe_interface
libusual 3-2:1.0: usb_probe_interface - got id
usb-storage 3-2:1.0: usb_probe_interface
usb-storage 3-2:1.0: usb_probe_interface - got id
scsi4 : SCSI emulation for USB Mass Storage devices
drivers/usb/core/inode.c: creating file '009'
usb 3-2: New USB device found, idVendor=3D05dc, idProduct=3Da400
usb 3-2: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D3
usb 3-2: Product: JUMPDRIVE
usb 3-2: Manufacturer: LEXAR MEDIA
usb 3-2: SerialNumber: 0A4EEC05201219080904
usb-storage: device found at 9
usb-storage: waiting for device to settle before scanning
usb-storage: device scan complete
scsi 4:0:0:0: Direct-Access     LEXAR    JUMPDRIVE        1000 PQ: 0 ANSI: =
0 CCS
sd 4:0:0:0: [sdg] 2026592 512-byte hardware sectors (1038 MB)
sd 4:0:0:0: [sdg] Write Protect is off
sd 4:0:0:0: [sdg] Mode Sense: 43 00 00 00
sd 4:0:0:0: [sdg] Assuming drive cache: write through
sd 4:0:0:0: [sdg] 2026592 512-byte hardware sectors (1038 MB)
sd 4:0:0:0: [sdg] Write Protect is off
sd 4:0:0:0: [sdg] Mode Sense: 43 00 00 00
sd 4:0:0:0: [sdg] Assuming drive cache: write through
 sdg: sdg1
sd 4:0:0:0: [sdg] Attached SCSI removable disk
sd 4:0:0:0: Attached scsi generic sg7 type 0
sd 4:0:0:0: [sdg] Result: hostbyte=3D0x01 driverbyte=3D0x00
end_request: I/O error, dev sdg, sector 3984
sd 4:0:0:0: [sdg] Result: hostbyte=3D0x01 driverbyte=3D0x00
end_request: I/O error, dev sdg, sector 162
sd 4:0:0:0: [sdg] Result: hostbyte=3D0x01 driverbyte=3D0x00
end_request: I/O error, dev sdg, sector 290
sd 4:0:0:0: [sdg] Result: hostbyte=3D0x01 driverbyte=3D0x00
end_request: I/O error, dev sdg, sector 418
sd 4:0:0:0: [sdg] Result: hostbyte=3D0x01 driverbyte=3D0x00
end_request: I/O error, dev sdg, sector 546
sd 4:0:0:0: [sdg] Result: hostbyte=3D0x01 driverbyte=3D0x00
end_request: I/O error, dev sdg, sector 674
sd 4:0:0:0: [sdg] Result: hostbyte=3D0x01 driverbyte=3D0x00
end_request: I/O error, dev sdg, sector 802
sd 4:0:0:0: [sdg] Result: hostbyte=3D0x01 driverbyte=3D0x00
end_request: I/O error, dev sdg, sector 930
sd 4:0:0:0: [sdg] Result: hostbyte=3D0x01 driverbyte=3D0x00
end_request: I/O error, dev sdg, sector 1058
sd 4:0:0:0: [sdg] Result: hostbyte=3D0x01 driverbyte=3D0x00
end_request: I/O error, dev sdg, sector 1186
sd 4:0:0:0: [sdg] Result: hostbyte=3D0x01 driverbyte=3D0x00
end_request: I/O error, dev sdg, sector 1314
sd 4:0:0:0: [sdg] Result: hostbyte=3D0x01 driverbyte=3D0x00
end_request: I/O error, dev sdg, sector 1442
sd 4:0:0:0: [sdg] Result: hostbyte=3D0x01 driverbyte=3D0x00
end_request: I/O error, dev sdg, sector 1570
sd 4:0:0:0: [sdg] Result: hostbyte=3D0x01 driverbyte=3D0x00
end_request: I/O error, dev sdg, sector 1698
sd 4:0:0:0: [sdg] Result: hostbyte=3D0x01 driverbyte=3D0x00
end_request: I/O error, dev sdg, sector 1826
sd 4:0:0:0: [sdg] Result: hostbyte=3D0x01 driverbyte=3D0x00
end_request: I/O error, dev sdg, sector 1954
sd 4:0:0:0: [sdg] Result: hostbyte=3D0x01 driverbyte=3D0x00
end_request: I/O error, dev sdg, sector 528288
sd 4:0:0:0: [sdg] Result: hostbyte=3D0x01 driverbyte=3D0x00
end_request: I/O error, dev sdg, sector 528672
sd 4:0:0:0: [sdg] Result: hostbyte=3D0x01 driverbyte=3D0x00
end_request: I/O error, dev sdg, sector 546392

--=20
Zan Lynx <zlynx@acm.org>

--=-NoBLaUe96eM9W5cB5XRq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHWbC9G8fHaOLTWwgRAg1JAJ9OzPuX6GjKcEuHggoz5mKz5AMnzACeMyOK
IevkIVzrO47HIffm9pnO3Ls=
=knoR
-----END PGP SIGNATURE-----

--=-NoBLaUe96eM9W5cB5XRq--

