Return-Path: <linux-kernel-owner+w=401wt.eu-S1752585AbXLFLtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbXLFLtl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 06:49:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbXLFLtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 06:49:31 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:57673 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbXLFLta (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 06:49:30 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc4-mm1
In-Reply-To: Your message of "Tue, 04 Dec 2007 21:17:01 PST."
             <20071204211701.994dfce6.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1196941764_2917P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 06 Dec 2007 06:49:24 -0500
Message-ID: <3941.1196941764@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1196941764_2917P
Content-Type: text/plain; charset=us-ascii

On Tue, 04 Dec 2007 21:17:01 PST, Andrew Morton said:
>   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc4/2.6.24-rc4-mm1/

Something in here broke LVM support - an initrd that has worked fine for
quite some time suddenly couldn't mount /dev/VolGroup00/root so we get the
infamous "Kernel panic - not syncing: Attempted to kill init!" when we
fall off the end of the initrd and haven't pivoted to the real disk.

It finds the disk OK:

[   81.202310] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
[   81.214466] sd 0:0:0:0: [sda] Write Protect is off
[   81.226467] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   81.238436] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   81.250780]  sda: sda1 sda2
[   75.396119] sd 0:0:0:0: [sda] Attached SCSI disk

but then the lvm command says it can't find the volume group VolGroup00 (which
is actually sda2 - sda1 is a small /boot partition, rest of disk is LVM).

A quick look at the rc4-mm1 announcement doesn't have any obviously tempting
patch names to start at, so it looks like it's time to play mm-bisect.  It may
take me a day or two, as I have some time management issues this week...



--==_Exmh_1196941764_2917P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHV+HEcC3lWbTT17ARAlofAJ4gzgbt+6ChWgiDyo/HBqIpGt+EwwCfU8lX
aUTYCzJmgOLCxw0LZ6BmqtU=
=qNrK
-----END PGP SIGNATURE-----

--==_Exmh_1196941764_2917P--
