Return-Path: <linux-kernel-owner+w=401wt.eu-S1752184AbXB1NAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbXB1NAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 08:00:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbXB1NAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 08:00:41 -0500
Received: from lvps87-230-19-68.dedicated.hosteurope.de ([87.230.19.68]:49530
	"EHLO lvps87-230-19-68.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752184AbXB1NAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 08:00:40 -0500
Message-ID: <45E57C67.5060806@toshsoft.de>
Date: Wed, 28 Feb 2007 13:58:15 +0100
From: Oliver Pahl <opahl@toshsoft.de>
User-Agent: Thunderbird 2.0b2 (X11/20070123)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: 2.6.20-mm2: Oops in generic_make_request not git-block.patches fault
X-Enigmail-Version: 0.94.1.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I rebuild the kernel, without the git-block patches Patches

revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block.patch
git-block-fixup.patch
git-block-dupe-definitions.patch
git-block-xfs-barriers-broke.patch

but i still get:

BUG: unable to handle kernel NULL pointer dereference at virtual
address 0000000
4
 printing eip:
c01f369b
*pde = 00000000
Oops: 0000 [#1]
PREEMPT
last sysfs file:
/devices/pci0000:00/0000:00:1d.3/usb5/5-0:1.0/bInterfaceProtoco
l
Modules linked in: fglrx(P) arc4 ecb blkcipher cryptomgr
crypto_algapi ieee80211
_crypt_wep ipw2200 ieee80211 ieee80211_crypt sk98lin intel_agp
agpgart
CPU:    0
EIP:    0060:[<c01f369b>]    Tainted: P       VLI
EFLAGS: 00210297   (2.6.20-tEwaN1 #4)
EIP is at __make_request+0xeb/0x2d7
eax: ffffffff   ebx: 00000000   ecx: 00000000   edx: 00010585
esi: dff497d4   edi: c1974d54   ebp: c1947200   esp: ec6b1b1c
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process firefox-bin (pid: 10937, ti=ec6b0000 task=c1938540
task.ti=ec6b0000)
Stack: 00000000 c1947200 dff4c494 00000008 00000100 c1947200
dff497d4 c01f1778
       ef4c15c0 00672810 00000000 ef07c9a0 00000008 ef7de6b8
00000000 c1948d8c
       00200202 00000000 c192dc00 000112d0 00200202 c017c700
00000001 c1947200
Call Trace:
 [<c01f1778>] generic_make_request+0x18d/0x1bb
 [<c017c700>] do_mpage_readpage+0x44e/0x454
 [<c01f343e>] submit_bio+0xc3/0xca
 [<c0192124>] ext3_get_block+0xa8/0xbe
 [<c017c75b>] mpage_end_io_read+0x0/0x61
 [<c017bd81>] mpage_bio_submit+0x19/0x1d
 [<c017c5fe>] do_mpage_readpage+0x34c/0x454
 [<c0179168>] bio_add_page+0x31/0x37
 [<c019207c>] ext3_get_block+0x0/0xbe
 [<c013e2b9>] add_to_page_cache+0x37/0xa7
 [<c017c8d1>] mpage_readpages+0xb2/0x119
 [<c019207c>] ext3_get_block+0x0/0xbe
 [<c02781d4>] ata_qc_issue_prot+0xfe/0x234
 [<c0275255>] ata_qc_issue+0x43b/0x48d
 [<c02795ca>] ata_scsi_rw_xlat+0x126/0x19c
 [<c01915f4>] ext3_readpages+0x0/0x15
 [<c0144143>] __do_page_cache_readahead+0x16a/0x237
 [<c019207c>] ext3_get_block+0x0/0xbe
 [<c026bce9>] scsi_prep_fn+0x1b5/0x227
 [<c01fbdfb>] radix_tree_scan_hole_backward+0x17/0x2d
 [<c0144799>] try_context_based_readahead+0x307/0x336
 [<c0102dbc>] __switch_to+0x161/0x17b
 [<c01442c9>] ra_submit+0xb9/0xc5
 [<c0144a9b>] page_cache_readahead_adaptive+0x2d3/0x4a4
 [<c036552a>] io_schedule+0x4e/0x57
 [<c013e066>] file_read_actor+0x79/0xca
 [<c013e7f8>] do_generic_mapping_read+0x1a4/0x4f3
 [<c01409ad>] generic_file_aio_read+0x1af/0x1f6
 [<c013dfed>] file_read_actor+0x0/0xca
 [<c01efb84>] elv_next_request+0x105/0x114
 [<c015af8f>] do_sync_read+0xc7/0x10a
 [<c026b50c>] scsi_next_command+0x25/0x2f
 [<c0128560>] wake_bit_function+0x0/0x44
 [<c015defe>] sys_fstat64+0x1e/0x23
 [<c015aec8>] do_sync_read+0x0/0x10a
 [<c015b6f2>] vfs_read+0x88/0x10a
 [<c015ba3a>] sys_read+0x41/0x67
 [<c0103cce>] sysenter_past_esp+0x5f/0x85
 [<c0360000>] inet6_synq_hash+0xe0/0xf5
 =======================
Code: 83 f8 02 75 0d 89 e9 89 da 89 f0 e8 82 ec ff ff eb 0e 48 75 13 89
e9 89 da
 89 f0 e8 f0 e9 ff ff 85 c0 0f 85 e5 01 00 00 8b 5b 04 <8b> 43 04 0f 18
00 90 8d
 47 14 39 c3 75 be fa 89 e0 25 00 e0 ff
EIP: [<c01f369b>] __make_request+0xeb/0x2d7 SS:ESP 0068:ec6b1b1c

Ths time i had to wait a few hours till the Bug jumped on. I am trying
to make a bisection search, without the patches,
but i am not that experienced.

HTH

Oli

- --
This email is intended for the person specified at the beginning of this
message. It is confidential and may contain legally privileged
information. If you have received this in error please let us know. You
should note that you may not copy this email or use any information
contained within it. Messages sent by email over the Internet are not
necessarily completely secure. We accept no responsibility for changes
made to this email after we sent it. You should be aware of these risks
if you communicate with us by email. If you are unsure about how to act
on this email please contact the person sending it to you.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFF5XxnTvJ2Ft8Rz5cRAlVlAJ9jWSrE1Jf6KS476LNgHBr5nUjGOgCcDR34
SNFSeDQx6IhF4I1HWe25N1c=
=00jf
-----END PGP SIGNATURE-----

