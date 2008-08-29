Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbYH2Kut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbYH2Kut (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 06:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbYH2Kul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 06:50:41 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:1296 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752118AbYH2Kuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 06:50:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsgEALlxt0jCTsYx/2dsb2JhbACBZbgfZIEG
From: Laurent Pinchart <laurentp@cse-semaphore.com>
Organization: CSE Semaphore
To: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: v2.6.27-rc5 regression: mtd/block device issue with cmd_filter
Date: Fri, 29 Aug 2008 12:50:33 +0200
User-Agent: KMail/1.9.9
Cc: jens.axboe@oracle.com
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1277794.UfHTJonZ4V";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200808291250.36591.laurentp@cse-semaphore.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1277794.UfHTJonZ4V
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi everybody,

the following commit either introduces a regression or makes and MTD-relate=
d issue come up to the surface:

abf5439370491dd6fbb4fe1a7939680d2a9bc9d4 introduces=20
block: move cmdfilter from gendisk to request_queue

When registering an MTD device that contains several partitions, the kernel=
 complains about reinitialization of a kobject:

=2D-------------------------- CUT HERE -----------------------
40000000.flash: Found 1 x16 devices at 0x0 in 16-bit bank
Amd/Fujitsu Extended Query Table at 0x0040
40000000.flash: CFI does not contain boot bank location. Assuming top.
number of CFI chips: 1
cfi_cmdset_0002: Disabling erase-suspend-program due to code brokenness.
cmdlinepart partition parsing not available
RedBoot partition parsing not available
Creating 4 MTD partitions on "40000000.flash":                             =
                                                 =20
0x00000000-0x00040000 : "uboot"
0x00040000-0x00080000 : "firmware"
kobject (c3907194): tried to init an initialized object, something is serio=
usly wrong.
Call Trace:
[c3821c20] [c0008d84] show_stack+0x48/0x16c (unreliable)
[c3821c50] [c01256b0] kobject_init+0x74/0xa0
[c3821c60] [c0125aa4] kobject_init_and_add+0x30/0x78
[c3821d00] [c011d890] blk_register_filter+0x4c/0x8c
[c3821d20] [c011b434] add_disk+0x68/0xc0
[c3821d40] [c0177798] add_mtd_blktrans_dev+0x184/0x294
[c3821d60] [c0178564] mtdblock_add_mtd+0x60/0x80
[c3821d70] [c0177a24] blktrans_notify_add+0x40/0x80
[c3821d90] [c0173730] add_mtd_device+0x9c/0x144
[c3821db0] [c01753d8] add_mtd_partitions+0x4f0/0x62c
[c3821de0] [c0238ec0] 0xc0238ec0
[c3821e40] [c0199060] of_platform_device_probe+0x74/0xa0
[c3821e60] [c01519d4] driver_probe_device+0x120/0x1e4
[c3821e80] [c0151be0] __driver_attach+0x9c/0xd0
[c3821ea0] [c0150618] bus_for_each_dev+0x58/0x9c
[c3821ed0] [c0151c38] driver_attach+0x24/0x34
[c3821ee0] [c0150ff8] bus_add_driver+0x198/0x270
[c3821f10] [c015226c] driver_register+0x64/0x18c
[c3821f30] [c01992d0] of_register_driver+0x44/0x54
[c3821f40] [c02bfcd0] of_flash_init+0x20/0x30
[c3821f50] [c00038f0] do_one_initcall+0x34/0x1c4
[c3821fd0] [c02ac80c] kernel_init+0x94/0x110
[c3821ff0] [c0010328] kernel_thread+0x44/0x60                              =
                                                 =20
0x00080000-0x00200000 : "kernel"
kobject (c3907194): tried to init an initialized object, something is serio=
usly wrong.
Call Trace:
[c3821c20] [c0008d84] show_stack+0x48/0x16c (unreliable)
[c3821c50] [c01256b0] kobject_init+0x74/0xa0
[c3821c60] [c0125aa4] kobject_init_and_add+0x30/0x78
[c3821d00] [c011d890] blk_register_filter+0x4c/0x8c
[c3821d20] [c011b434] add_disk+0x68/0xc0
[c3821d40] [c0177798] add_mtd_blktrans_dev+0x184/0x294
[c3821d60] [c0178564] mtdblock_add_mtd+0x60/0x80
[c3821d70] [c0177a24] blktrans_notify_add+0x40/0x80
[c3821d90] [c0173730] add_mtd_device+0x9c/0x144
[c3821db0] [c01753d8] add_mtd_partitions+0x4f0/0x62c
[c3821de0] [c0238ec0] 0xc0238ec0
[c3821e40] [c0199060] of_platform_device_probe+0x74/0xa0
[c3821e60] [c01519d4] driver_probe_device+0x120/0x1e4
[c3821e80] [c0151be0] __driver_attach+0x9c/0xd0
[c3821ea0] [c0150618] bus_for_each_dev+0x58/0x9c
[c3821ed0] [c0151c38] driver_attach+0x24/0x34
[c3821ee0] [c0150ff8] bus_add_driver+0x198/0x270
[c3821f10] [c015226c] driver_register+0x64/0x18c
[c3821f30] [c01992d0] of_register_driver+0x44/0x54
[c3821f40] [c02bfcd0] of_flash_init+0x20/0x30
[c3821f50] [c00038f0] do_one_initcall+0x34/0x1c4
[c3821fd0] [c02ac80c] kernel_init+0x94/0x110
[c3821ff0] [c0010328] kernel_thread+0x44/0x60                              =
                                                 =20
=2D-------------------------- CUT HERE -----------------------

(fourth partition omitted for the sake of clarity, the kobject pointer and =
stack trace are identical).

The issue is triggered by the MTD block translation layer drivers/mtd/mtdbl=
ock.c sharing a single request_queue structure for all its gendisk instance=
s. The queue is allocated and initialized by register_mtd_blktrans in drive=
rs/mtd/mtd_blktrans.c called when the MTD block translation layer is regist=
ered, passed to newly created mtd_blktrans_dev in mtdblock_add_mtd through =
the mtd_blktrans_ops pointer, and set as the gendisk queue in add_mtd_blktr=
ans_dev.

I don't know who is at fault here - the MTD layer for sharing a queue or th=
e block layer for assuming queues are not shared.

Best regards,

=2D-=20
Laurent Pinchart
CSE Semaphore Belgium

Chaussee de Bruxelles, 732A
B-1410 Waterloo
Belgium

T +32 (2) 387 42 59
=46 +32 (2) 387 42 75

--nextPart1277794.UfHTJonZ4V
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAki31HwACgkQ8y9gWxC9vpcZ0gCfQkMqKiUoKXGWJaZAt0ptZbUo
WXQAniBq7PcgyV7WhtePiY8WFR4CYbno
=3E9h
-----END PGP SIGNATURE-----

--nextPart1277794.UfHTJonZ4V--
