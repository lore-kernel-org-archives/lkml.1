Return-Path: <linux-kernel-owner+w=401wt.eu-S1756809AbXIEOh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809AbXIEOh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 10:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756430AbXIEOhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 10:37:48 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:46091 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756347AbXIEOhr (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 10:37:47 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc4-mm1
In-Reply-To: Your message of "Fri, 31 Aug 2007 21:58:22 PDT."
             <20070831215822.26e1432b.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1189003060_2915P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 05 Sep 2007 10:37:40 -0400
Message-ID: <26495.1189003060@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1189003060_2915P
Content-Type: text/plain; charset=us-ascii

On Fri, 31 Aug 2007 21:58:22 PDT, Andrew Morton said:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc4/2.6.23-rc4-mm1/

(Warning - if discussion of binary modules bothers you, hit delete now..)

Dell Latitude D840, x86_64 kernel

memory-controller-memory-accounting-v7.patch causes the NVidia graphics driver
to go into a soft-lockup:

BUG: soft lockup - CPU#0 stuck for 11s! [X:2733]
CPU 0:
Modules linked in: irnet ppp_generic slhc irtty_sir sir_dev ircomm_tty ircomm irda crc_ccitt nf_conntrack_ftp xt_pkttype ipt_REJECT ipt_osf nf_conntrack_ipv4 xt_ipisforif ipt_recent ipt_LOG xt_u32 iptable_filter ip_tables xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack nfnetlink ip6t_LOG xt_limit ip6table_filter ip6_tables x_tables vmnet(P)(U) vmmon(U) sha256 aes fan container bay acpi_cpufreq nvram arc4 ecb pcmcia iwl3945 firmware_class yenta_socket nvidia(P)(U) mac80211 iTCO_wdt rsrc_nonstatic iTCO_vendor_support ohci1394 watchdog_core ieee1394 watchdog_dev pcmcia_core cfg80211 video thermal output button battery processor ac intel_agp rtc
Pid: 2733, comm: X Tainted: P        2.6.23-rc4-mm1 #1
RIP: 0010:[<ffffffff80520e16>]  [<ffffffff80520e16>] _spin_lock+0x5b/0x75
RSP: 0018:ffff810007ecdcf8  EFLAGS: 00000202
RAX: 0000000000000000 RBX: ffff810007ecdd08 RCX: 0000000000000173
RDX: ffff8100040fe000 RSI: 00007f3cbf672000 RDI: ffff81000111ec90
RBP: 0000000000000006 R08: ffffffff80687d85 R09: 0000000000010000
R10: ffff810007ecdd60 R11: 00000001000355e8 R12: 00000000000002c7
R13: 0000000000000000 R14: 000000000000000a R15: 0000000000000002
FS:  00007f3cbf65f780(0000) GS:ffffffff806c6000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f3cbc83d540 CR3: 00000000046af000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
[<ffffffff8027b358>] get_locked_pte+0x100/0x114
[<ffffffff8027b3d5>] vm_insert_page+0x69/0x100
[<ffffffff8841e5f8>] :nvidia:nv_kern_mmap+0x712/0x7c0
[<ffffffff8027ec71>] mmap_region+0x222/0x426
[<ffffffff80327dc6>] selinux_file_mmap+0x7d/0x8a
[<ffffffff8027f489>] do_mmap_pgoff+0x2c6/0x32d
[<ffffffff805204ce>] __down_write_nested+0x3d/0xab
[<ffffffff80211d3f>] sys_mmap+0x90/0x119
[<ffffffff8020c2ec>] tracesys+0xdc/0xe1

The only reason that it's at all noteworthy is because the kernel is built
with CONFIG_CONTAINERS=n and the patch *looks* like it tries very hard to
make zero changes in code logic in that case.  I've been looking at it for
a few days and totally failing to see what changed behavior is causing the
problem.  There's a change to unuse_pte() to return a -ENOMEM, but that's
conditioned off a mem_container_charge() that should optimize itself to '0'.


--==_Exmh_1189003060_2915P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG3r80cC3lWbTT17ARAlXdAJoC7RNopT1LyHJwrS82t0VJmYvNeACeO0Vd
yB0cBN1886j2Ccl/4IZjtWw=
=wUn7
-----END PGP SIGNATURE-----

--==_Exmh_1189003060_2915P--
