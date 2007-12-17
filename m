Return-Path: <linux-kernel-owner+w=401wt.eu-S1762463AbXLQWpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762463AbXLQWpb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 17:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936843AbXLQWoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 17:44:34 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:49082 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934024AbXLQWod (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 17:44:33 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.24-rc5-mm1 - wonky disk cache and CDROM behavior...
In-Reply-To: Your message of "Thu, 13 Dec 2007 02:40:50 PST."
             <20071213024050.7d6e5f3e.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20071213024050.7d6e5f3e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1197931451_2751P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 17 Dec 2007 17:44:11 -0500
Message-ID: <30457.1197931451@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1197931451_2751P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <30445.1197931442.1@turing-police.cc.vt.edu>

On Thu, 13 Dec 2007 02:40:50 PST, Andrew Morton said:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc5/2.6.24-rc5-mm1/

OK, so I'm trying to 'dd' a CD and the drive on the laptop is having issues
reading the disk.

I try it once, and get an I/O error about 117M in - dd reports 1.7M/sec.

I try it again, and it reports it died at the same exact place, but in about
2 seconds flat, and reports 91M/sec transfer.  OK, that's *weird*, I didn't
think that blocks read from /dev/cdrom would get cached, but OK.  So I try
the obviously stupid thing:

# echo 1 >| /proc/sys/vm/drop_caches

Alas, that hangs gloriously - 'echo t > /proc/sysrq-trigger' tells me:

Dec 17 17:30:02 turing-police kernel: [20235.823201] bash          D 0000000000000001  5288 15123  15085
Dec 17 17:30:02 turing-police kernel: [20235.823206]  ffff81007ba7de28 0000000000000086 0000000000000000 0000000000000000
Dec 17 17:30:02 turing-police kernel: [20235.823210]  ffff81007bbd9000 ffff81007d70e000 ffff81007bbd9248 00000001019e3e48
Dec 17 17:30:02 turing-police kernel: [20235.823214]  ffffe20000f36028 ffffe200012b9978 ffffe20000eece48 ffffe20001164188
Dec 17 17:30:02 turing-police kernel: [20235.823218] Call Trace:
Dec 17 17:30:02 turing-police kernel: [20235.823224]  [<ffffffff80523e20>] __down_read+0x87/0xa1
Dec 17 17:30:02 turing-police kernel: [20235.823229]  [<ffffffff8024bc13>] down_read+0x9/0xe
Dec 17 17:30:02 turing-police kernel: [20235.823232]  [<ffffffff802abafe>] drop_pagecache+0x3a/0x8c
Dec 17 17:30:02 turing-police kernel: [20235.823235]  [<ffffffff802abb72>] drop_caches_sysctl_handler+0x22/0x38
Dec 17 17:30:02 turing-police kernel: [20235.823239]  [<ffffffff802d2b70>] proc_sys_write+0x7e/0xa6
Dec 17 17:30:02 turing-police kernel: [20235.823244]  [<ffffffff8028e18c>] vfs_write+0xc7/0x170
Dec 17 17:30:02 turing-police kernel: [20235.823248]  [<ffffffff8028e772>] sys_write+0x47/0x70
Dec 17 17:30:02 turing-police kernel: [20235.823251]  [<ffffffff8020c34c>] tracesys+0xdc/0xe1

Yowza.  And no, I don't dare to try to reproduce it until Thursday at the
earliest, I need a mostly-stable machine the next 2 days. ;)

--==_Exmh_1197931451_2751P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHZvu7cC3lWbTT17ARAnqSAKDFsDq1qLSXqFrwf9vrgc3YkdTqGACguifb
HMHMnm5I+DO6qQz9tvWExuU=
=yYVA
-----END PGP SIGNATURE-----

--==_Exmh_1197931451_2751P--
