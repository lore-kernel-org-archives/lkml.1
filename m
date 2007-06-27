Return-Path: <linux-kernel-owner+w=401wt.eu-S1763485AbXF0VuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763485AbXF0VuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 17:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758260AbXF0VuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 17:50:10 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4997 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091AbXF0VuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 17:50:08 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: akpm@linux-foundation.org, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] mtd: add module license to mtdbdi
Date: Wed, 27 Jun 2007 23:50:04 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       David Howells <dhowells@redhat.com>
References: <200706271030.l5RAUgKE015163@imap1.linux-foundation.org>
In-Reply-To: <200706271030.l5RAUgKE015163@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200706272350.04975.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	This seems to be a known issue [1] about Photron PNC-2000 module called
pnc2000. To reproduce this just 'modprobe pnc2000'. The patch attached at least
makes the kernel to be not tainted when mtdbdi gets loaded.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/mtd/mtdbdi.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.22-rc6-bo-a/drivers/mtd/mtdbdi.c	2007-06-27 22:05:34.000000000 +0200
+++ linux-2.6.22-rc6-bo-b/drivers/mtd/mtdbdi.c	2007-06-27 23:20:57.000000000 +0200
@@ -46,3 +46,5 @@ struct backing_dev_info mtd_bdi_rw_mappa
 			   BDI_CAP_WRITE_MAP),
 };
 EXPORT_SYMBOL_GPL(mtd_bdi_rw_mappable);
+
+MODULE_LICENSE("GPL v2");



Regards,

	Mariusz

[1] http://groups.google.pl/group/linux.kernel/browse_frm/thread/77d9f9273ab14382

a.txt - unpatched
b.txt - patched

--- a.txt       2007-06-27 23:32:48.000000000 +0200
+++ b.txt       2007-06-27 23:33:33.000000000 +0200
@@ -1,4 +1,3 @@
-mtdbdi: module license 'unspecified' taints kernel.
 Photron PNC-2000 flash mapping: 400000 at bf000000
 BUG: unable to handle kernel paging request at virtual address bf000000
  printing eip:
@@ -6,27 +5,29 @@ ded752ff
 *pde = 00000000
 Oops: 0002 [#1]
 PREEMPT
-Modules linked in: cfi_probe gen_probe pnc2000 mtdpart mtdcore mtdbdi(P) chipreg eeprom i2c_ali1535 rtc_cmos rtc_core rtc_lib i2c_ali15x3 8139too 8250_pci 8250 serial_core yenta_socket rsrc_nonstatic
+Modules linked in: cfi_probe gen_probe pnc2000 mtdpart mtdcore mtdbdi chipreg eeprom i2c_ali1535 rtc_cmos rtc_core rtc_lib 8139too i2c_ali1
+5x3 yenta_socket rsrc_nonstatic 8250_pci 8250 serial_core
 CPU:    0
-EIP:    0060:[<ded752ff>]    Tainted: P        VLI
+EIP:    0060:[<ded752ff>]    Not tainted VLI
 EFLAGS: 00010286   (2.6.22-rc6-mm1 #2)
 EIP is at cfi_probe_chip+0xac/0xe61 [cfi_probe]
 eax: bf000000   ebx: 00000004   ecx: 00000010   edx: 00f000f0
-esi: ded564e0   edi: 00000002   ebp: c3511e14   esp: c3511db0
+esi: ded574e0   edi: 00000002   ebp: c354de14   esp: c354ddb0
 ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
-Process modprobe (pid: 6075, ti=c3510000 task=c1b70ac0 task.ti=c3510000)
-Stack: 00000000 00000000 c3511e2c c0126d84 00000000 c3511dd0 00000000 00000000
-       00000000 00000001 dead4ead ffffffff ffffffff c043cc58 00000000 00000046
-       c3511df0 c3511df0 00000000 00000001 dead4ead ffffffff ded75253 00000002
+Process modprobe (pid: 6235, ti=c354c000 task=c263c030 task.ti=c354c000)
+Stack: 00000000 00000000 c354de2c c0126d84 00000000 c354ddd0 00000000 00000000
+       00000000 00000001 dead4ead ffffffff ffffffff c06aee70 00000000 c04f3d98
+       c354ddf0 c354ddf0 00000000 00000001 dead4ead ffffffff ded75253 00000002
 Call Trace:
- [<ded54131>] mtd_do_chip_probe+0x83/0x32a [gen_probe]
+ [<ded55131>] mtd_do_chip_probe+0x83/0x32a [gen_probe]
  [<ded75251>] cfi_probe+0xd/0xf [cfi_probe]
- [<de872185>] do_map_probe+0x1c/0x61 [chipreg]
- [<ded5c049>] init_pnc2000+0x49/0x76 [pnc2000]
+ [<ded51185>] do_map_probe+0x1c/0x61 [chipreg]
+ [<ded5d049>] init_pnc2000+0x49/0x76 [pnc2000]
  [<c0137c50>] sys_init_module+0x11b/0x160b
  [<c010401e>] sysenter_past_esp+0x5f/0x85
  [<ffffe410>] 0xffffe410
  =======================
 INFO: lockdep is turned off.
-Code: f0 8d 0c fd 00 00 00 00 89 c2 d3 e2 09 c2 83 fb 01 0f 84 af 0d 00 00 83 fb 02 0f 84 95 0d 00 00 83 fb 04 75 08 8b 45 b8 03 46 0c <89> 10 0f ae f0 89 f6 8b 5e 14 8b 55 08 8b 4a 08 89 d8 99 f7 f9
-EIP: [<ded752ff>] cfi_probe_chip+0xac/0xe61 [cfi_probe] SS:ESP 0068:c3511db0
+Code: f0 8d 0c fd 00 00 00 00 89 c2 d3 e2 09 c2 83 fb 01 0f 84 af 0d 00 00 83 fb 02 0f 84 95 0d 00 00 83 fb 04 75 08 8b 45 b8 03 46 0c <89>
+ 10 0f ae f0 89 f6 8b 5e 14 8b 55 08 8b 4a 08 89 d8 99 f7 f9
+EIP: [<ded752ff>] cfi_probe_chip+0xac/0xe61 [cfi_probe] SS:ESP 0068:c354ddb0


