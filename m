Return-Path: <linux-kernel-owner+w=401wt.eu-S932989AbXCETVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989AbXCETVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 14:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933100AbXCETVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 14:21:23 -0500
Received: from hoefnix.telenet-ops.be ([195.130.132.54]:38325 "EHLO
	hoefnix.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932989AbXCETVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 14:21:22 -0500
Subject: Re: Boot time Bluetooth BUG: warning: (value > m) at hid-core.c:793
From: Amedee Van Gasse <amedee@amedee.be>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2ZT4fozuZKpi/pNdd+wj"
Date: Mon, 05 Mar 2007 20:19:12 +0100
Message-Id: <1173122352.19761.33.camel@saruman>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.92 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-2ZT4fozuZKpi/pNdd+wj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Feb 2007 16:54:27 +0100 (CET), Jiri Kosina <> wrote:
>=20
> What puzzles me a bit is a fact that both the bugreporters seem to
> state pretty clearly that this started happening after some update, am
> I right?
>=20
> Or did the hardware before work all the time in the HID mode, without
> even being attempted to switch to HCI (which seems to cause the bug)?

It _appears_ that the bug reports started after an update of
bluez-utils, but this remains to be confirmed. It could be
coincidence/temporal correlation (which does not imply causation).

As for myself, I have a Logitech MX5000 keyboard/mouse with usb dongle,
and I can confirm that the keyboard/mouse have always worked in HID.
But in HID mode, no other bluetooth functions are possible (like pairing
with a smartphone).
It's possible to switch from HID to HCI and have a working mouse
+bluetooth receiver, but in that case the keyboard can't pair.

I used this script to get functional bluetooth (and unresponsive
keyboard):

hid2hci --tohci
sleep 1
/etc/init.d/bluetooth restart
sleep 1
# connect with the mouse
hidd -i hci0 --connect 00:07:61:48:71:DE
# connect with the keyboard
hidd -i hci0 --connect 00:07:61:3F:DA:41

I think the "-i hci0" isn't even needed, but it can't hurt.

This triggers a lot of occurences of the following in my logs:

BUG: at drivers/hid/hid-core.c:785 implement()
 [<f8d59608>] hid_output_report+0x288/0x300 [hid]
 [<f8d7d4c8>] hid_submit_ctrl+0x58/0x200 [usbhid]
 [schedule_timeout+83/208] schedule_timeout+0x53/0xd0
 [finish_wait+45/112] finish_wait+0x2d/0x70
 [<f8d7d78b>] usbhid_submit_report+0x11b/0x1b0 [usbhid]
 [autoremove_wake_function+0/80] autoremove_wake_function+0x0/0x50
 [<f8d7f9d6>] hiddev_ioctl+0x446/0xb40 [usbhid]
 [filemap_nopage+753/928] filemap_nopage+0x2f1/0x3a0
 [kmap_atomic+134/160] kmap_atomic+0x86/0xa0
 [kunmap_atomic+107/112] kunmap_atomic+0x6b/0x70
 [__handle_mm_fault+633/2624] __handle_mm_fault+0x279/0xa40
 [nameidata_to_filp+53/64] nameidata_to_filp+0x35/0x40
 [do_ioctl+120/144] do_ioctl+0x78/0x90
 [vfs_ioctl+92/672] vfs_ioctl+0x5c/0x2a0
 [sys_ioctl+114/144] sys_ioctl+0x72/0x90
 [sysenter_past_esp+105/169] sysenter_past_esp+0x69/0xa9
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

There are a few Ubuntu bug reports that describe the problem, with some
log files and other useful info:
https://bugs.launchpad.net/ubuntu/+source/bluez-utils/+bug/32415
https://launchpad.net/ubuntu/+source/bluez-utils/+bug/66884/
I have found similar descriptions in other distros.

I have exactly the same experience as Vincent Fortier described
(keyboard working at boot, some keys repeating sometimes, keyboard
unresponsive when bluetooth comes up, keyboard works again after dongle
unplug/replug, but no bluetooth)

Anyway, is this a kernel problem or is bluez-utils to blame?


PS: I bumped into this topic when googling for "046d:c70e". I'm not a
developer (I'm what they call "a user"), but I'm not afraid to get my
hands dirty. If you want me to run debug versions or patched kernels, I
can do that. After all, I have the hardware and I might give you
valuable information (even if I wouldn't recognise it when it spat me in
the face).

--=20
Amedee Van Gasse
amedee@amedee.be

--=-2ZT4fozuZKpi/pNdd+wj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBF7G0wLx1bbS7O0EYRAj+1AJwPV/DgXQthCvsswMqpooFqW2fubgCcDvwM
tNMRzZS8/fxGMJZZvpkJNOg=
=En5V
-----END PGP SIGNATURE-----

--=-2ZT4fozuZKpi/pNdd+wj--

