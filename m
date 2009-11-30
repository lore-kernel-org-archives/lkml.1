Return-Path: <linux-kernel-owner+w=401wt.eu-S1752719AbZK3R2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbZK3R2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 12:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbZK3R2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 12:28:49 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:41639 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbZK3R2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 12:28:47 -0500
Message-ID: <4B1400B3.60300@oracle.com>
Date: Mon, 30 Nov 2009 09:28:19 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: 2.6.32-rc8: amd64_edac slub error
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4B1400D0.0150:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Loading amd64_edac_mod on an amd64 system without the expected hardware support
causes memory usage error(s).

Is this already fixed/patched?  Do you need more info?
Thanks.



# modprobe  amd64_edac_mod
calling  amd64_edac_init+0x0/0x849 [amd64_edac_mod] @ 22156
EDAC amd64_edac:  Ver: 3.2.0 Nov 24 2009
EDAC amd64: ECC is enabled by BIOS.
=============================================================================
BUG kmalloc-16: Redzone overwritten
-----------------------------------------------------------------------------

INFO: 0xffff880139e25600-0xffff880139e25607. First byte 0x1f instead of 0xcc
INFO: Slab 0xffffea00044a9818 objects=102 used=38 fp=0xffff880139e255c8 flags=0x400000000000c3
INFO: Object 0xffff880139e255f0 @offset=1520 fp=0xffff880139e255c8

Bytes b4 0xffff880139e255e0:  18 56 e2 39 01 88 ff ff 5a 5a 5a 5a 5a 5a 5a 5a .V�9..����ZZZZZZZZ
  Object 0xffff880139e255f0:  1f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
 Redzone 0xffff880139e25600:  1f 00 00 00 00 00 00 00                         ........        
 Padding 0xffff880139e25610:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
Pid: 22158, comm: work_for_cpu Not tainted 2.6.32-rc8 #2
Call Trace:
 [<ffffffff81109383>] print_trailer+0x12a/0x133
 [<ffffffff81109836>] check_bytes_and_report+0xa9/0xd0
 [<ffffffffa008ba4c>] ? amd64_init_one_instance+0x220/0x33e [amd64_edac_mod]
 [<ffffffff811098bb>] check_object+0x5e/0x1b6
 [<ffffffff8110a889>] __slab_free+0x13a/0x25c
 [<ffffffff8110ac2b>] kfree+0xd6/0xe8
 [<ffffffffa008ba4c>] amd64_init_one_instance+0x220/0x33e [amd64_edac_mod]
 [<ffffffff81072167>] ? do_work_for_cpu+0x0/0x2b
 [<ffffffff812062e5>] local_pci_probe+0x17/0x1b
 [<ffffffff8107217f>] do_work_for_cpu+0x18/0x2b
 [<ffffffff81072167>] ? do_work_for_cpu+0x0/0x2b
 [<ffffffff810769fb>] kthread+0x6e/0x76
 [<ffffffff81012daa>] child_rip+0xa/0x20
 [<ffffffff8107698d>] ? kthread+0x0/0x76
 [<ffffffff81012da0>] ? child_rip+0x0/0x20
FIX kmalloc-16: Restoring 0xffff880139e25600-0xffff880139e25607=0xcc

EDAC amd64: NB MCE bank disabled, set MSR 0x0000017b[4] on node 0 to enable.
EDAC amd64: WARNING: ECC is disabled by BIOS. Module will NOT be loaded.
 Either Enable ECC in the BIOS, or set 'ecc_enable_override'.
 Also, use of the override can cause unknown side effects.
amd64_edac: probe of 0000:00:18.2 failed with error -22
EDAC amd64: ECC is enabled by BIOS.
=============================================================================
BUG kmalloc-16: Redzone overwritten
-----------------------------------------------------------------------------

INFO: 0xffff88027582e060-0xffff88027582e067. First byte 0x1f instead of 0xcc
INFO: Slab 0xffffea00089b4a10 objects=102 used=2 fp=0xffff88027582e028 flags=0xc00000000000c3
INFO: Object 0xffff88027582e050 @offset=80 fp=0xffff88027582e028

Bytes b4 0xffff88027582e040:  78 e0 82 75 02 88 ff ff 5a 5a 5a 5a 5a 5a 5a 5a x�.u..����ZZZZZZZZ
  Object 0xffff88027582e050:  1f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
 Redzone 0xffff88027582e060:  1f 00 00 00 00 00 00 00                  [root@ca-ostest293 ~]#        ........        
 Padding 0xffff88027582e070:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
Pid: 22161, comm: work_for_cpu Not tainted 2.6.32-rc8 #2
Call Trace:
 [<ffffffff81109383>] print_trailer+0x12a/0x133
 [<ffffffff81109836>] check_bytes_and_report+0xa9/0xd0
 [<ffffffffa008ba4c>] ? amd64_init_one_instance+0x220/0x33e [amd64_edac_mod]
 [<ffffffff811098bb>] check_object+0x5e/0x1b6
 [<ffffffff8110a889>] __slab_free+0x13a/0x25c
 [<ffffffff8110ac2b>] kfree+0xd6/0xe8
 [<ffffffffa008ba4c>] amd64_init_one_instance+0x220/0x33e [amd64_edac_mod]
 [<ffffffff81072167>] ? do_work_for_cpu+0x0/0x2b
 [<ffffffff812062e5>] local_pci_probe+0x17/0x1b
 [<ffffffff8107217f>] do_work_for_cpu+0x18/0x2b
 [<ffffffff81072167>] ? do_work_for_cpu+0x0/0x2b
 [<ffffffff810769fb>] kthread+0x6e/0x76
 [<ffffffff81012daa>] child_rip+0xa/0x20
 [<ffffffff8107698d>] ? kthread+0x0/0x76
 [<ffffffff81012da0>] ? child_rip+0x0/0x20
FIX kmalloc-16: Restoring 0xffff88027582e060-0xffff88027582e067=0xcc

EDAC amd64: NB MCE bank disabled, set MSR 0x0000017b[4] on node 1 to enable.
EDAC amd64: WARNING: ECC is disabled by BIOS. Module will NOT be loaded.
 Either Enable ECC in the BIOS, or set 'ecc_enable_override'.
 Also, use of the override can cause unknown side effects.
amd64_edac: probe of 0000:00:19.2 failed with error -22
initcall amd64_edac_init+0x0/0x849 [amd64_edac_mod] returned 0 after 1381423 usecs

-- 
~Randy
