Return-Path: <linux-kernel-owner+w=401wt.eu-S1757454AbZEZVKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454AbZEZVKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 17:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757121AbZEZVKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 17:10:37 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:33520 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756893AbZEZVKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 17:10:32 -0400
Date: Tue, 26 May 2009 22:10:30 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Message-ID: <20090526211029.GA2011@sucs.org>
References: <20090312061047.GA13401@silver.sucs.org> <20090313095213.GA14250@silver.sucs.org> <20090320131437.GA30120@hash.localnet> <20090329142432.GA15578@sucs.org> <20090329151401.GA26510@hash.localnet> <20090331083041.GA19657@sucs.org> <20090513214416.GA4492@sucs.org> <20090515040904.GA32357@hash.localnet> <20090518100540.GB21150@sucs.org> <20090522093930.GA15375@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090522093930.GA15375@sucs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 22, 2009 at 10:39:31AM +0100, Sitsofe Wheeler wrote:
> On Mon, May 18, 2009 at 11:05:40AM +0100, Sitsofe Wheeler wrote:
> > On Fri, May 15, 2009 at 12:09:04AM -0400, Bob Copeland wrote:
> > > 
> > > This is too ugly to live, but I'd like to know if you can reproduce
> > > with this patch.  If it still happens, then I guess it's back to
> 
> The poison message has not reappeared but this morning there was a

Yet again, I spoke too soon. This evening the following was in dmesg:

[    0.000000] Linux version 2.6.30-rc6-00026-g0f6f49a-dirty (@milan) (gcc version 4.2.4) #141 Sun May 17 16:30:00 BST 2009
<snip>
[11297.190882] PM: Finishing wakeup.
[11297.190887] Restarting tasks ... done.
[11306.158509] atl2 0000:03:00.0: irq 27 for MSI/MSI-X
[11320.692729] wlan0: authenticate with AP 00:1e:4a:07:5a:e0
[11320.892095] wlan0: authenticate with AP 00:1e:4a:07:5a:e0
[11320.894748] wlan0: authenticated
[11320.894757] wlan0: associate with AP 00:1e:4a:07:5a:e0
[11320.897842] wlan0: RX AssocResp from 00:1e:4a:07:5a:e0 (capab=0x431 status=0 aid=214)
[11320.897851] wlan0: associated
[11320.942976] cfg80211: Calling CRDA for country: GB
[11366.078522] [drm:i915_get_vblank_counter] *ERROR* trying to get vblank count for disabled pipe 0
[11367.837863] wlan0: deauthenticating by local choice (reason=3)
[11371.345954] PM: Syncing filesystems ... done.
[11371.372369] PM: Preparing system for mem sleep
[11371.372413] Freezing user space processes ... (elapsed 0.00 seconds) done.
[11371.377617] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[11371.377776] PM: Entering mem sleep
[11371.377852] Suspending console(s) (use no_console_suspend to debug)
[11371.391145] sd 1:0:1:0: [sdb] Stopping disk
[11371.391386] sd 1:0:0:0: [sda] Stopping disk
[11371.901859] pci 0000:00:02.0: PCI INT A disabled
[11371.912911] ath5k 0000:01:00.0: PCI INT A disabled
[11371.923268] ACPI handle has no context!
[11371.923281] atl2 0000:03:00.0: PME# disabled
[11371.923295] atl2 0000:03:00.0: PCI INT A disabled
[11371.923308] ACPI handle has no context!
[11371.934316] ata_piix 0000:00:1f.2: PCI INT B disabled
[11371.945082] ehci_hcd 0000:00:1d.7: PCI INT A disabled
[11371.945176] ehci_hcd 0000:00:1d.7: PME# disabled
[11371.956083] uhci_hcd 0000:00:1d.3: PCI INT D disabled
[11371.956161] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[11371.956236] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[11371.956311] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[11371.967154] HDA Intel 0000:00:1b.0: PCI INT A disabled
[11371.978483] PM: suspend devices took 0.601 seconds
[11371.980429] ACPI: Preparing to enter system sleep state S3
[11372.019286] Intel machine check architecture supported.
[11372.019286] Intel machine check reporting enabled on CPU#0.
[11372.019286] Back to C!
[11372.019286] Force enabled HPET at resume
[11372.019286] ACPI: Waking up from system sleep state S3
[11372.097613] pci 0000:00:02.0: restoring config space at offset 0x1 (was 0x900007, writing 0x900003)
[11372.097774] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100006, writing 0x100002)
[11372.097879] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100104, writing 0x100504)
[11372.098348] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100106, writing 0x100506)
[11372.098498] pcieport-driver 0000:00:1c.2: restoring config space at offset 0x1 (was 0x100106, writing 0x100506)
[11372.098630] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[11372.098696] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[11372.098761] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[11372.098826] uhci_hcd 0000:00:1d.3: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[11372.098908] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900006, writing 0x2900002)
[11372.098956] pci 0000:00:1e.0: restoring config space at offset 0xf (was 0x60000, writing 0x600ff)
[11372.099691] ath5k 0000:01:00.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
[11372.099746] ath5k 0000:01:00.0: restoring config space at offset 0x4 (was 0x4, writing 0xfbef0004)
[11372.099761] ath5k 0000:01:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x4)
[11372.099780] ath5k 0000:01:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
[11379.933540] pci 0000:00:02.0: PME# disabled
[11379.933559] pci 0000:00:02.1: PME# disabled
[11379.933672] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[11379.933687] HDA Intel 0000:00:1b.0: setting latency timer to 64
[11379.987627] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[11379.987652] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[11379.987691] usb usb2: root hub lost power or was reset
[11379.987796] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[11379.987810] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[11379.987841] usb usb3: root hub lost power or was reset
[11379.987919] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[11379.987933] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[11379.987963] usb usb4: root hub lost power or was reset
[11379.988370] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[11379.988385] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[11379.988415] usb usb5: root hub lost power or was reset
[11379.988523] ehci_hcd 0000:00:1d.7: PME# disabled
[11379.988534] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[11379.988549] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[11379.988564] ehci_hcd 0000:00:1d.7: PME# disabled
[11379.988610] pci 0000:00:1e.0: setting latency timer to 64
[11379.988704] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[11379.988715] ata_piix 0000:00:1f.2: setting latency timer to 64
[11380.023822] ACPI Error (dsopcode-0505): Attempt to CreateField of length zero [20090320]
[11380.023855] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.RATA] (Node f7039b40), AE_AML_OPERAND_VALUE
[11380.023977] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN1.DRV0._GTF] (Node f7039700), AE_AML_OPERAND_VALUE
[11380.024432] ata2.00: _GTF evaluation failed (AE 0x3004)
[11380.025644] atl2 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[11380.025657] atl2 0000:03:00.0: setting latency timer to 64
[11380.025673] atl2 0000:03:00.0: PME# disabled
[11380.025684] atl2 0000:03:00.0: PME# disabled
[11380.027223] ath5k 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[11380.027840] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[11380.027854] pci 0000:00:02.0: setting latency timer to 64
[11380.601301] ata2.01: ACPI cmd ef/03:44:00:00:00:b0 filtered out
[11380.601310] ata2.01: ACPI cmd ef/03:0c:00:00:00:b0 filtered out
[11380.607318] ata2.00: configured for UDMA/66
[11380.610458] ata2.01: configured for UDMA/66
[11381.837983] sd 1:0:0:0: [sda] Starting disk
[11381.839276] sd 1:0:1:0: [sdb] Starting disk
[11381.942226] usb 1-5: reset high speed USB device using ehci_hcd and address 2
[11382.059426] PM: resume devices took 9.960 seconds
[11382.059430] ------------[ cut here ]------------
[11382.059444] WARNING: at kernel/power/main.c:176 suspend_test_finish+0x88/0x90()
[11382.059449] Hardware name: 900
[11382.059453] Component: resume devices
[11382.059462] Pid: 5562, comm: pm-suspend Tainted: G        W  2.6.30-rc6-00026-g0f6f49a-dirty #141
[11382.059468] Call Trace:
[11382.059477]  [<c0152de8>] ? suspend_test_finish+0x88/0x90
[11382.059485]  [<c0152de8>] ? suspend_test_finish+0x88/0x90
[11382.059496]  [<c01286bc>] warn_slowpath_common+0x7c/0xa0
[11382.059503]  [<c0152de8>] ? suspend_test_finish+0x88/0x90
[11382.059512]  [<c012872b>] warn_slowpath_fmt+0x2b/0x30
[11382.059520]  [<c0152de8>] suspend_test_finish+0x88/0x90
[11382.059528]  [<c0152e9f>] suspend_devices_and_enter+0x8f/0x1b0
[11382.059536]  [<c0153151>] enter_state+0x121/0x180
[11382.059543]  [<c015324f>] state_store+0x9f/0xe0
[11382.059550]  [<c01531b0>] ? state_store+0x0/0xe0
[11382.059560]  [<c023c934>] kobj_attr_store+0x24/0x30
[11382.059570]  [<c01d67ee>] sysfs_write_file+0xbe/0x110
[11382.059579]  [<c0195b4a>] vfs_write+0x9a/0x120
[11382.059587]  [<c01d6730>] ? sysfs_write_file+0x0/0x110
[11382.059594]  [<c0195c92>] sys_write+0x42/0x70
[11382.059602]  [<c0102e18>] sysenter_do_call+0x12/0x36
[11382.059608] ---[ end trace 0bba3f59e299cf86 ]---
[11382.059706] PM: Finishing wakeup.
[11382.059710] Restarting tasks ... done.
[11389.349481] atl2 0000:03:00.0: irq 27 for MSI/MSI-X
[11403.488569] wlan0: authenticate with AP 00:01:38:d6:0b:4f
[11403.490743] wlan0: authenticated
[11403.490751] wlan0: associate with AP 00:01:38:d6:0b:4f
[11403.493884] wlan0: RX AssocResp from 00:01:38:d6:0b:4f (capab=0x431 status=0 aid=6)
[11403.493892] wlan0: associated
[13209.741573] ath5k phy0: noise floor calibration timeout (2417MHz)
[14978.093981] =============================================================================
[14978.093994] BUG kmalloc-4096: Poison overwritten
[14978.093999] -----------------------------------------------------------------------------
[14978.094003] 
[14978.094009] INFO: 0xd6495110-0xd6495187. First byte 0x80 instead of 0x6b
[14978.094026] INFO: Allocated in dev_alloc_skb+0x21/0x40 age=2048 cpu=0 pid=0
[14978.094037] INFO: Freed in skb_release_data+0x5e/0x90 age=69 cpu=0 pid=0
[14978.094045] INFO: Slab 0xc12c9200 objects=7 used=2 fp=0xd64950f0 flags=0x400040c3
[14978.094052] INFO: Object 0xd64950f0 @offset=20720 fp=0xd6493090
[14978.094054] 
[14978.094059] Bytes b4 0xd64950e0:  0c 11 00 00 3b f7 df 00 5a 5a 5a 5a 5a 5a 5a 5a ....;÷ß.ZZZZZZZZ
[14978.094094]   Object 0xd64950f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094126]   Object 0xd6495100:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094159]   Object 0xd6495110:  80 00 00 00 ff ff ff ff ff ff 00 01 38 d6 0b 4f ....ÿÿÿÿÿÿ..8Ö.O
[14978.094192]   Object 0xd6495120:  00 01 38 d6 0b 4f 60 85 e0 01 19 b1 08 00 00 00 ..8Ö.O`.à..±....
[14978.094224]   Object 0xd6495130:  64 00 31 04 00 04 57 69 66 69 01 08 82 84 8b 96 d.1...Wifi......
[14978.094257]   Object 0xd6495140:  8c 12 98 24 03 01 01 07 0a 47 42 20 01 0d 14 01 ...$.....GB.....
[14978.094289]   Object 0xd6495150:  0d 14 00 2a 01 00 32 04 b0 48 60 6c 30 18 01 00 ...*..2.°H`l0...
[14978.094322]   Object 0xd6495160:  00 0f ac 02 02 00 00 0f ac 02 00 0f ac 04 01 00 ..¬.....¬...¬...
[14978.094354]   Object 0xd6495170:  00 0f ac 02 05 00 dd 05 00 10 91 04 00 05 04 00 ..¬...Ý.........
[14978.094386]   Object 0xd6495180:  01 00 00 8b 11 d1 77 77 6b 6b 6b 6b 6b 6b 6b 6b .....Ñwwkkkkkkkk
[14978.094419]   Object 0xd6495190:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094451]   Object 0xd64951a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094484]   Object 0xd64951b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094517]   Object 0xd64951c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094549]   Object 0xd64951d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094582]   Object 0xd64951e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094614]   Object 0xd64951f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094647]   Object 0xd6495200:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094679]   Object 0xd6495210:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094712]   Object 0xd6495220:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094744]   Object 0xd6495230:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094777]   Object 0xd6495240:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094809]   Object 0xd6495250:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094842]   Object 0xd6495260:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094874]   Object 0xd6495270:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094907]   Object 0xd6495280:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495290:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64952a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64952b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64952c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64952d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64952e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64952f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495300:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495310:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495320:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495330:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495340:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495350:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495360:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495370:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495380:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495390:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64953a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64953b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64953c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64953d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64953e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64953f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495400:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495410:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495420:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495430:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495440:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495450:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495460:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495470:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495480:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495490:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64954a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64954b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64954c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64954d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64954e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64954f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495500:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495510:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495520:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495530:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495540:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495550:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495560:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495570:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495580:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495590:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64955a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64955b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64955c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64955d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64955e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64955f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495600:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495610:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495620:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495630:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495640:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495650:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495660:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495670:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495680:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495690:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64956a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64956b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64956c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64956d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64956e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64956f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495700:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495710:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495720:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495730:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495740:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495750:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495760:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495770:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495780:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495790:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64957a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64957b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64957c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64957d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64957e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64957f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495800:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495810:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495820:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495830:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495840:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495850:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495860:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495870:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495880:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495890:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64958a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64958b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64958c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64958d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64958e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64958f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495900:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495910:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495920:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495930:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495940:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495950:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495960:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495970:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495980:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495990:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64959a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64959b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64959c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64959d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64959e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64959f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495a00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495a10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495a20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495a30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495a40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495a50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495a60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495a70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495a80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495a90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495aa0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495ab0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495ac0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495ad0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495ae0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495af0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495b00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495b10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495b20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495b30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495b40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495b50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495b60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495b70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495b80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495b90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495ba0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495bb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495bc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495bd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495be0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495bf0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495c00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495c10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495c20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495c30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495c40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495c50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495c60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495c70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495c80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495c90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495ca0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495cb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495cc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495cd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495ce0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495cf0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495d00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495d10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495d20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495d30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495d40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495d50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495d60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495d70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495d80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495d90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495da0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495db0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495dc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495dd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495de0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495df0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495e00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495e10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495e20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495e30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495e40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495e50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495e60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495e70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495e80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495e90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495ea0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495eb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495ec0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495ed0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495ee0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495ef0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495f00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495f10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495f20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495f30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495f40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495f50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495f60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495f70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495f80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495f90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495fa0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495fb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495fc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495fd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495fe0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6495ff0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6496000:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6496010:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6496020:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6496030:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6496040:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6496050:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6496060:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6496070:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6496080:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd6496090:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64960a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64960b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64960c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64960d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[14978.094929]   Object 0xd64960e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk¥
[14978.094929]  Redzone 0xd64960f0:  bb bb bb bb                                     »»»»            
[14978.094929]  Padding 0xd6496118:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
[14978.094929] Pid: 0, comm: swapper Tainted: G        W  2.6.30-rc6-00026-g0f6f49a-dirty #141
[14978.094929] Call Trace:
[14978.094929]  [<c018edc4>] print_trailer+0xb4/0xf0
[14978.094929]  [<c018eea7>] check_bytes_and_report+0xa7/0xd0
[14978.094929]  [<c018ff6e>] check_object+0x1ae/0x1f0
[14978.094929]  [<c0190bff>] __slab_alloc+0x46f/0x510
[14978.094929]  [<c0190e69>] ? kmem_cache_alloc+0xc9/0x150
[14978.094929]  [<c0191cd9>] __kmalloc_track_caller+0x1c9/0x1e0
[14978.094929]  [<c03aa391>] ? dev_alloc_skb+0x21/0x40
[14978.094929]  [<c03a9d0e>] ? __alloc_skb+0x2e/0x120
[14978.094929]  [<c03aa391>] ? dev_alloc_skb+0x21/0x40
[14978.094929]  [<c03a9d34>] __alloc_skb+0x54/0x120
[14978.094929]  [<c03aa391>] dev_alloc_skb+0x21/0x40
[14978.094929]  [<c0328b78>] ath5k_rx_skb_alloc+0x28/0x1b0
[14978.094929]  [<c043575e>] ? _spin_lock+0x3e/0x50
[14978.094929]  [<c0328f34>] ath5k_tasklet_rx+0x134/0x710
[14978.094929]  [<c014dc89>] ? __lock_acquire+0x339/0x5e0
[14978.094929]  [<c012d624>] tasklet_action+0x44/0x90
[14978.094929]  [<c012d105>] __do_softirq+0x75/0x1a0
[14978.094929]  [<c0435672>] ? _spin_unlock+0x22/0x30
[14978.094929]  [<c012d285>] do_softirq+0x55/0x60
[14978.094929]  [<c012d56c>] irq_exit+0x6c/0x80
[14978.094929]  [<c0104dc7>] do_IRQ+0x47/0x90
[14978.094929]  [<c0142feb>] ? getnstimeofday+0x5b/0x120
[14978.094929]  [<c01034ae>] common_interrupt+0x2e/0x34
[14978.094929]  [<c014007b>] ? hrtimer_nanosleep+0x1b/0x110
[14978.094929]  [<c028fff1>] ? acpi_idle_enter_bm+0x1d4/0x1fd
[14978.094929]  [<c03757cc>] cpuidle_idle_call+0x6c/0xc0
[14978.094929]  [<c05b2500>] ? unknown_bootoption+0x0/0x210
[14978.094929]  [<c0101d61>] cpu_idle+0x41/0x60
[14978.094929]  [<c0429bf5>] rest_init+0x55/0x60
[14978.094929]  [<c05b2b4a>] start_kernel+0x26a/0x300
[14978.094929]  [<c05b2500>] ? unknown_bootoption+0x0/0x210
[14978.094929]  [<c05b2395>] ? reserve_ebda_region+0x55/0x70
[14978.094929]  [<c05b2302>] i386_start_kernel+0x52/0x90
[14978.094929] FIX kmalloc-4096: Restoring 0xd6495110-0xd6495187=0x6b
[14978.094929] 
[14978.094929] FIX kmalloc-4096: Marking all objects used
[16525.355132] pidgin[7026]: segfault at e ip b778379b sp a542c220 error 4 in libc-2.7.so[b7718000+149000]

I'm pretty certain this kernel had your previous patch (although the
directory that held the kernel has since been cleaned away on the server
on which it was compiled).

-- 
Sitsofe | http://sucs.org/~sits/
