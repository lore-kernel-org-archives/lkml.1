Return-Path: <linux-kernel-owner+w=401wt.eu-S1755379AbYKDJNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbYKDJNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 04:13:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbYKDJNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 04:13:16 -0500
Received: from mx71.mail.ru ([194.67.23.4]:57995 "EHLO mx71.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753587AbYKDJNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 04:13:13 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.28-rc3: kernel mounts the same device twice? Or /proc/mounts lies?
Date: Tue, 4 Nov 2008 12:13:07 +0300
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart23578011.orLi6yiMUp";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200811041213.07717.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart23578011.orLi6yiMUp
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Out of some infinite wisdom something on my system decided to add
fstab entry for "new" device after switching from IDE to PATA:

# Entry for /dev/LABEL=/ :
LABEL=/ / reiserfs relatime,tail 1 1
none /proc proc defaults 0 0
none /sys sysfs defaults 0 0
none /tmp tmpfs defaults 0 0
# Entry for /dev/LABEL=swap :
LABEL=swap swap swap defaults 0 0
# Entry for /dev/sda2 :
UUID=72973377-c299-4ca6-ae94-2022b7dca58f /media/hd reiserfs defaults 0 0

Note that both / and /media/hd refer to the same device:

{pts/0}% sudo blkid
/dev/sda1: TYPE="swap" LABEL="swap" UUID="3b4dc82c-a6e6-4609-be9e-16d9206ab7fd"
/dev/sda2: UUID="72973377-c299-4ca6-ae94-2022b7dca58f" LABEL="/" TYPE="reiserfs"

And according to /proc/mounts both are mounted at the same time:

{pts/0}% cat /proc/mounts
rootfs / rootfs rw 0 0
/dev/root / reiserfs rw 0 0
/dev /dev tmpfs rw 0 0
/proc /proc proc rw 0 0
/sys /sys sysfs rw 0 0
/proc/bus/usb /proc/bus/usb usbfs rw,devgid=43,devmode=664 0 0
none /dev/pts devpts rw,mode=620 0 0
none /dev/shm tmpfs rw 0 0
none /tmp tmpfs rw 0 0
none /proc/sys/fs/binfmt_misc binfmt_misc rw 0 0
/dev/sda2 /media/hd reiserfs rw 0 0
{pts/0}% ll /dev/root
brw------- 1 root root 8, 2 2008-11-04 12:01 /dev/root
{pts/0}% ll /dev/sda2
brw-rw---- 1 root disk 8, 2 2008-11-04 12:01 /dev/sda2

Bug or feature?

--nextPart23578011.orLi6yiMUp
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkQEiMACgkQR6LMutpd94whQQCgkWE/FniUjTzJeAbjKetRw1mh
xJYAoJmIQuOElrDAzs5DaAX6l/SvsJvE
=QYoB
-----END PGP SIGNATURE-----

--nextPart23578011.orLi6yiMUp--
