Return-Path: <linux-kernel-owner+w=401wt.eu-S1756435AbXL3NP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435AbXL3NP1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 08:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbXL3NPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 08:15:18 -0500
Received: from fmmailgate09.web.de ([217.72.192.184]:46681 "EHLO
	fmmailgate09.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbXL3NPQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 08:15:16 -0500
Date: Sun, 30 Dec 2007 14:15:13 +0100
Message-Id: <76599944@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Cc: hidave.darkstar@gmail.com, lcapitulino@mandriva.com.br,
       linux-mtd@lists.infradead.org, randy.dunlap@oracle.com
Subject: Re: [PATCH]: 2.6.24-rc5: mtd: PNC-2000 oops
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX19uIDv4KKaOHd98zoOT7UHzorplNXrJAdewKACFZF/CY2yBx
 Y6STuYXcGzYVxtQ7LTmE+ZdWCrvRBLB9JXAbohBDo1rscg+ibY=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

while doing some systematical driver load/unload testing i have also come across this one.

searched lkml and found/tried this patch - seems to work fine, at least driver now behaves as expected:
insmod: error inserting 'pnc2000.ko': -1 No such device or address

if it really _works_ is another story, but how can we know ? have searched the net a while for this hardware, but didn`t find _any_ reference that this hardware either exists or existed at all, so it looks that this hardware is very ancient or being used by japanese secret service, only !? :)

> The driver is broken for a long time. I ever ping the writer
> info@crossnet.co.jp (seems a company's email address), but got no
> response.

i have found email @crossnet from two people who seem to be involved in software development more or less. have sent them a mail and asked if they know anything about this or could re-establish a contact to the author.  

anyway, i vote for the patch being merged to avoid people investigate into this oops or complain here again.

if there is fear, that this breaks the driver even more, what about putting some message into the driver initialization ?

>>> PNC-2000 seems to be very ancient/rare hardware and the driver appears unmaintained 
>>> for a while. Due to missing testing capabilities, there`s no guarantee, that this driver still  
>>> works.  If you own such hardware or if the driver doesn`t work for you, please report to 
>>> linux-kernel@vger.kernel.org 

regards
roland





List:       linux-kernel
Subject:    [PATCH]: 2.6.24-rc5: mtd: PNC-2000 oops
From:       "Luiz Fernando N. Capitulino" <lcapitulino () mandriva ! com ! br>
Date:       2007-12-14 16:00:26
Message-ID: 20071214140026.621c9007 () mandriva ! com ! br
[Download message RAW]

Em Fri, 14 Dec 2007 10:06:20 +0800
"Dave Young" <hidave.darkstar@gmail.com> escreveu:

> On Dec 14, 2007 1:04 AM, Luiz Fernando N. Capitulino
> <lcapitulino@mandriva.com.br> wrote:
> > 
> > Hi there,
> > 
> > If I run:
> > 
> > # modprobe pnc2000
> > 
> > In a machine w/o mtd hardware, I get the following oops:
> > 
> > Photron PNC-2000 flash mapping: 400000 at bf000000
> > BUG: unable to handle kernel paging request at virtual address bf000000
> > printing eip: e0bfe05b *pde = 00000000
> > Oops: 0002 [#1]
> > Modules linked in: cfi_probe gen_probe pnc2000 mtd chipreg map_funcs nfsd lockd \
> > nfs_acl auth_rpcgss sunrpc exportfs af_packet snd_seq_dummy snd_seq_oss \
> > snd_seq_midi_event snd_seq snd_pcm_oss ipv6 snd_mixer_oss binfmt_misc loop \
> > dm_mirror dm_mod sata_via libata scsi_mod floppy cpufreq_ondemand \
> > cpufreq_conservative cpufreq_powersave freq_table firewire_ohci firewire_core \
> > crc_itu_t snd_via82xx gameport snd_ac97_codec ac97_bus snd_pcm snd_timer \
> > snd_page_alloc snd_mpu401_uart snd_rawmidi snd_seq_device i2c_viapro ehci_hcd snd \
> > uhci_hcd i2c_core soundcore 8139cp ide_cd cdrom ohci1394 usbcore ieee1394 via_agp \
> > 8139too mii agpgart shpchp pci_hotplug evdev ext3 jbd ide_disk ide_generic \
> > via82cxxx ide_core
> > 
> > Pid: 4067, comm: modprobe Not tainted (2.6.24-0.rc5.1mdv #1)
> > EIP: 0060:[<e0bfe05b>] EFLAGS: 00010286 CPU: 0
> > EIP is at simple_map_write+0x2a/0x34 [map_funcs]
> > EAX: 00000004 EBX: e0c3f5d0 ECX: bf000000 EDX: 00f000f0
> > ESI: e0c3f5d0 EDI: 00000002 EBP: dc913dbc ESP: dc913db8
> > DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> > Process modprobe (pid: 4067, ti=dc912000 task=df0409f0 task.ti=dc912000)
> > Stack: 00000004 dc913e18 e0cc1277 dc913e30 c012b89b 00000000 00000001 00000002
> > c04a2b7c 00000008 00000000 00000000 c043cde4 00000000 c0357ccb dc913e1c
> > dc913e1c 00000204 00000000 00000000 e0c00a54 e0cc119d 00000002 00000002
> > Call Trace:
> > [<c01054f2>] show_trace_log_lvl+0x1a/0x2f
> > [<c01055a2>] show_stack_log_lvl+0x9b/0xa3
> > [<c0105650>] show_registers+0xa6/0x177
> > [<c0105823>] die+0x102/0x1ee
> > [<c02cb4d2>] do_page_fault+0x561/0x63f
> > [<c02c9d1a>] error_code+0x6a/0x70
> > [<e0cc1277>] cfi_probe_chip+0xda/0x9c7 [cfi_probe]
> > [<e0c43123>] mtd_do_chip_probe+0x77/0x2d4 [gen_probe]
> > [<e0cc119b>] cfi_probe+0xd/0xf [cfi_probe]
> > [<e0c00142>] do_map_probe+0x3d/0x5a [chipreg]
> > [<e0c4103b>] init_pnc2000+0x3b/0x68 [pnc2000]
> > [<c0140d10>] sys_init_module+0x12c6/0x1394
> > [<c0103e42>] sysenter_past_esp+0x6b/0xc9
> > =======================
> > Code: c3 55 89 e5 53 89 c3 8b 40 18 83 f8 01 75 07 03 4b 10 88 11 eb 17 83 f8 02 \
> > 75 08 03 4b 10 66 89 11 eb 0a 83 f8 04 75 05 03 4b 10 <89> 11 f0 83 04 24 00 5b \
> > 5d c3 55 89 e5 57 89 d7 8b 55 08 56 89
> > EIP: [<e0bfe05b>] simple_map_write+0x2a/0x34 [map_funcs] SS:ESP 0068:dc913db8
> > 
> > --
> 
> This issue has been reported several times.

 Oh.

> The driver is broken for a long time. I ever ping the writer
> info@crossnet.co.jp (seems a company's email address), but got no
> response.
> 
> So how about kill (or disable ?) this driver until it is fixed?

 Well, looks like there's an ioremap() call missing there.

 The following patch does what every driver of that kind does. It
fixes the load OOPS for me but we need someone with the hardware
to test whether it works (or some mtd person to review it).

 If the patch is wrong I think we should disable the module, yes.

------

mtd: pnc2000: initializaion fix

pnc2000 should map bus memory before trying to access it, also
fix wrong struct map_info setup.

Signed-off-by: Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>

Index: linux-2.6.23/drivers/mtd/maps/pnc2000.c
===================================================================
--- linux-2.6.23.orig/drivers/mtd/maps/pnc2000.c
+++ linux-2.6.23/drivers/mtd/maps/pnc2000.c
@@ -30,8 +30,7 @@ static struct map_info pnc_map = {
 	.name = "PNC-2000",
 	.size = WINDOW_SIZE,
 	.bankwidth = 4,
-	.phys = 0xFFFFFFFF,
-	.virt = (void __iomem *)WINDOW_ADDR,
+	.phys = WINDOW_ADDR,
 };
 
 
@@ -64,16 +63,29 @@ static struct mtd_info *mymtd;
 
 static int __init init_pnc2000(void)
 {
+	int err;
+
 	printk(KERN_NOTICE "Photron PNC-2000 flash mapping: %x at %x\n", WINDOW_SIZE, \
WINDOW_ADDR);  
+	pnc_map.virt = ioremap(WINDOW_ADDR, WINDOW_SIZE);
+	if (!pnc_map.virt) {
+		printk("init_pnc2000(): failed to ioremap\n");
+		return -EIO;
+	}
+
 	simple_map_init(&pnc_map);
 
 	mymtd = do_map_probe("cfi_probe", &pnc_map);
 	if (mymtd) {
 		mymtd->owner = THIS_MODULE;
-		return add_mtd_partitions(mymtd, pnc_partitions, 3);
+		err = add_mtd_partitions(mymtd, pnc_partitions, 3);
+		if (err) {
+			printk("init_pnc2000(): add_mtd_partitions failed\n");
+			iounmap(pnc_map.virt);
+		}
 	}
 
+	iounmap(pnc_map.virt);
 	return -ENXIO;
 }
 
@@ -82,6 +94,7 @@ static void __exit cleanup_pnc2000(void)
 	if (mymtd) {
 		del_mtd_partitions(mymtd);
 		map_destroy(mymtd);
+		iounmap(pnc_map.virt);
 	}
 }
 



_______________________________________________________________________
Jetzt neu! Schützen Sie Ihren PC mit McAfee und WEB.DE. 30 Tage
kostenlos testen. http://www.pc-sicherheit.web.de/startseite/?mc=022220

