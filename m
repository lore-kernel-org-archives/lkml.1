Return-Path: <linux-kernel-owner+w=401wt.eu-S1755012AbZDULLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbZDULLW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 07:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbZDULLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 07:11:14 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:41032 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbZDULLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 07:11:13 -0400
Date: Tue, 21 Apr 2009 08:10:17 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: linux-kernel@vger.kernel.org
Subject: [2.6.30-rc2] usb reset during big file transfer and ext3 error
Message-ID: <20090421111015.GA30260@ime.usp.br>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi there.

I have an amd64 system running Debian's sid distribution and I installed
Linux 2.6.30-rc2 on it, as a way to get improvements for the i915
subsystem.

Unfortunately, when I was transferring the contents of 2 DVDs from the
main IDE HD to a USB external HD, I got errors from the USB host, the
writes on the external HD become failures and the ext3 filesystem there
enters into error mode, going read-only.

I eventually lose the access to the device (i.e., the /dev/sd??? device
isn't there anymore) and I then have to re-run fsck on the given
filesystem.

This has already happened 2 or 3 times already and I observed that it
only occurs when there is high traffic---if I am, say, compiling the
kernel on that external HD, I don't see any problems.

Attached is part of the dmesg log that shows the problem. I put the
whole dmesg at <http://rb.doesntexist.org/linux/>.

As always, if any further information is needed, please let me know.


Thanks, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org

--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="dmesg-usb-reset-and-ext3-error.txt"

[ 2549.248657] [drm] Initialized drm 1.1.0 20060810
[ 2549.274952] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[ 2549.274966] pci 0000:00:02.0: setting latency timer to 64
[ 2549.284965] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[ 2637.993156] [drm:i915_get_vblank_counter] *ERROR* trying to get vblank count for disabled pipe 1
[ 2638.160324] [drm:i915_get_vblank_counter] *ERROR* trying to get vblank count for disabled pipe 1
[ 4433.904183] kjournald starting.  Commit interval 5 seconds
[ 4433.905842] EXT3 FS on sda1, internal journal
[ 4433.905857] EXT3-fs: mounted filesystem with writeback data mode.
[53869.272136] RPC: Registered udp transport module.
[53869.272143] RPC: Registered tcp transport module.
[53869.335615] Slow work thread pool: Starting up
[53869.335792] Slow work thread pool: Ready
[53869.335876] FS-Cache: Loaded
[53869.427746] FS-Cache: Netfs 'nfs' registered for caching
[79423.834543] TCP(fetchmail:17649): Application bug, race in MSG_PEEK.
[86492.830164] hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0004
[86492.830186] ehci_hcd 0000:00:1d.7: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
[86492.830201] hub 1-0:1.0: port 2, status 0501, change 0001, 480 Mb/s
[86492.935048] hub 1-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x501
[86492.987231] ehci_hcd 0000:00:1d.7: port 2 full speed --> companion
[86492.987240] ehci_hcd 0000:00:1d.7: GetStatus port 2 status 003801 POWER OWNER sig=j CONNECT
[86492.987272] hub 1-0:1.0: port 2 not reset yet, waiting 50ms
[86492.987283] usb usb2: usb resume
[86492.987286] usb usb2: wakeup_rh
[86493.019783] hub 2-0:1.0: hub_resume
[86493.019813] uhci_hcd 0000:00:1d.0: port 2 portsc 0093,00
[86493.019819] hub 2-0:1.0: port 2: status 0101 change 0001
[86493.039050] ehci_hcd 0000:00:1d.7: GetStatus port 2 status 003002 POWER OWNER sig=se0 CSC
[86493.039095] hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0004
[86493.121258] hub 2-0:1.0: state 7 ports 2 chg 0004 evt 0000
[86493.121286] hub 2-0:1.0: port 2, status 0101, change 0000, 12 Mb/s
[86493.224022] usb 2-2: new full speed USB device using uhci_hcd and address 2
[86493.346010] usb 2-2: ep0 maxpacket = 8
[86493.392973] usb 2-2: default language 0x0409
[86493.414991] usb 2-2: New USB device found, idVendor=03f0, idProduct=4811
[86493.415000] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[86493.415018] usb 2-2: Product: PSC 1600 series
[86493.415022] usb 2-2: Manufacturer: HP
[86493.415025] usb 2-2: SerialNumber: BR64SDP097L0
[86493.415208] usb 2-2: uevent
[86493.415244] usb 2-2: usb_probe_device
[86493.415250] usb 2-2: configuration #1 chosen from 1 choice
[86493.418188] usb 2-2: adding 2-2:1.0 (config #1, interface 0)
[86493.418274] usb 2-2:1.0: uevent
[86493.418704] usb 2-2: adding 2-2:1.1 (config #1, interface 1)
[86493.418773] usb 2-2:1.1: uevent
[86493.419127] usb 2-2: adding 2-2:1.2 (config #1, interface 2)
[86493.419177] usb 2-2:1.2: uevent
[86493.419493] usb 2-2: adding 2-2:1.3 (config #1, interface 3)
[86493.419542] usb 2-2:1.3: uevent
[86493.419576] usb-storage 2-2:1.3: usb_probe_interface
[86493.419584] usb-storage 2-2:1.3: usb_probe_interface - got id
[86493.432978] scsi1 : SCSI emulation for USB Mass Storage devices
[86493.433973] drivers/usb/core/inode.c: creating file '002'
[86493.434475] usb-storage: device found at 2
[86493.434479] usb-storage: waiting for device to settle before scanning
[86493.600758] usblp 2-2:1.1: usb_probe_interface
[86493.600764] usblp 2-2:1.1: usb_probe_interface - got id
[86493.604982] drivers/usb/core/file.c: looking for a minor, starting at 0
[86493.605216] usblp0: USB Bidirectional printer dev 2 if 1 alt 0 proto 2 vid 0x03F0 pid 0x4811
[86493.605278] usbcore: registered new interface driver usblp
[86498.436129] usb-storage: device scan complete
[86498.439106] scsi 1:0:0:0: Direct-Access     HP       PSC 1610         1.00 PQ: 0 ANSI: 2
[86498.468856] sd 1:0:0:0: [sdb] Attached SCSI removable disk
[86498.549340] usb 2-2:1.3: uevent
[86498.549701] usb 2-2: uevent
[86512.705044] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0004
[86512.705062] uhci_hcd 0000:00:1d.0: port 2 portsc 008a,00
[86512.705080] hub 2-0:1.0: port 2, status 0100, change 0003, 12 Mb/s
[86512.705086] usb 2-2: USB disconnect, address 2
[86512.705091] usb 2-2: unregistering device
[86512.705095] usb 2-2: usb_disable_device nuking all URBs
[86512.705111] usb 2-2: unregistering interface 2-2:1.0
[86512.705502] usb 2-2:1.0: uevent
[86512.705534] usb 2-2: unregistering interface 2-2:1.1
[86512.705824] drivers/usb/core/file.c: removing 0 minor
[86512.705944] usblp0: removed
[86512.705971] usb 2-2:1.1: uevent
[86512.705996] usb 2-2: unregistering interface 2-2:1.2
[86512.706317] usb 2-2:1.2: uevent
[86512.706342] usb 2-2: unregistering interface 2-2:1.3
[86512.712318] usb 2-2:1.3: uevent
[86512.712734] usb 2-2: uevent
[86512.817029] hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x100
[86513.955019] usb usb2: suspend_rh (auto-stop)
[86515.705093] hub 2-0:1.0: hub_suspend
[86515.705108] usb usb2: bus auto-suspend
[86515.705112] usb usb2: suspend_rh
[103051.265045] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096 retry 1
[103051.265156] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096 retry 2
[103051.265281] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096 retry 3
[103051.265406] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096 retry 4
[103051.265531] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096 retry 5
[103051.265656] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096 retry 6
[103051.265781] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096 retry 7
[103051.265906] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096 retry 8
[103051.266032] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096 retry 9
[103051.266157] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096 retry 10
[103051.266281] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096 retry 11
[103051.266406] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096 retry 12
[103051.266530] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096 retry 13
[103051.266655] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096 retry 14
[103051.266781] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096 retry 15
[103051.266906] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096 retry 16
[103051.267032] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096 retry 17
[103051.267155] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096 retry 18
[103051.267281] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096 retry 19
[103051.267406] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096 retry 20
[103051.267530] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096 retry 21
[103051.267655] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096 retry 22
[103051.267782] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096 retry 23
[103051.267906] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096 retry 24
[103051.268031] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096 retry 25
[103051.268155] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096 retry 26
[103051.268280] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096 retry 27
[103051.268406] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096 retry 28
[103051.268537] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096 retry 29
[103051.268659] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096 retry 30
[103051.268780] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096 retry 31
[103051.268905] ehci_hcd 0000:00:1d.7: devpath 6.1 ep2out 3strikes
[103051.280918] hub 1-6:1.0: logical disconnect on port 1
[103051.281235] sd 0:0:0:0: [sda] Unhandled error code
[103051.281241] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.281247] end_request: I/O error, dev sda, sector 255674535
[103051.281254] Buffer I/O error on device sda1, logical block 31959309
[103051.281257] lost page write due to I/O error on sda1
[103051.281269] Buffer I/O error on device sda1, logical block 31959310
[103051.281273] lost page write due to I/O error on sda1
[103051.281279] Buffer I/O error on device sda1, logical block 31959311
[103051.281282] lost page write due to I/O error on sda1
[103051.281294] Buffer I/O error on device sda1, logical block 31959312
[103051.281297] lost page write due to I/O error on sda1
[103051.281303] Buffer I/O error on device sda1, logical block 31959313
[103051.281306] lost page write due to I/O error on sda1
[103051.281311] Buffer I/O error on device sda1, logical block 31959314
[103051.281315] lost page write due to I/O error on sda1
[103051.281320] Buffer I/O error on device sda1, logical block 31959315
[103051.281323] lost page write due to I/O error on sda1
[103051.281329] Buffer I/O error on device sda1, logical block 31959316
[103051.281332] lost page write due to I/O error on sda1
[103051.281337] Buffer I/O error on device sda1, logical block 31959317
[103051.281341] lost page write due to I/O error on sda1
[103051.281346] Buffer I/O error on device sda1, logical block 31959318
[103051.281349] lost page write due to I/O error on sda1
[103051.281474] sd 0:0:0:0: [sda] Unhandled error code
[103051.281478] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.281483] end_request: I/O error, dev sda, sector 255674775
[103051.281624] sd 0:0:0:0: [sda] Unhandled error code
[103051.281627] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.281633] end_request: I/O error, dev sda, sector 255675015
[103051.281778] sd 0:0:0:0: [sda] Unhandled error code
[103051.281781] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.281786] end_request: I/O error, dev sda, sector 255675255
[103051.281928] sd 0:0:0:0: [sda] Unhandled error code
[103051.281931] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.281936] end_request: I/O error, dev sda, sector 255675495
[103051.282076] sd 0:0:0:0: [sda] Unhandled error code
[103051.282079] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.282084] end_request: I/O error, dev sda, sector 255675735
[103051.282215] sd 0:0:0:0: [sda] Unhandled error code
[103051.282218] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.282223] end_request: I/O error, dev sda, sector 255675975
[103051.282340] sd 0:0:0:0: [sda] Unhandled error code
[103051.282343] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.282348] end_request: I/O error, dev sda, sector 255676215
[103051.282467] sd 0:0:0:0: [sda] Unhandled error code
[103051.282470] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.282476] end_request: I/O error, dev sda, sector 255676455
[103051.282613] sd 0:0:0:0: [sda] Unhandled error code
[103051.282617] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.282622] end_request: I/O error, dev sda, sector 255676695
[103051.282764] sd 0:0:0:0: [sda] Unhandled error code
[103051.282767] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.282772] end_request: I/O error, dev sda, sector 255676935
[103051.282900] sd 0:0:0:0: [sda] Unhandled error code
[103051.282903] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.282908] end_request: I/O error, dev sda, sector 255677175
[103051.283076] sd 0:0:0:0: [sda] Unhandled error code
[103051.283080] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.283085] end_request: I/O error, dev sda, sector 255677415
[103051.283218] sd 0:0:0:0: [sda] Unhandled error code
[103051.283222] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.283227] end_request: I/O error, dev sda, sector 255677655
[103051.283368] sd 0:0:0:0: [sda] Unhandled error code
[103051.283371] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.283376] end_request: I/O error, dev sda, sector 255677895
[103051.283501] sd 0:0:0:0: [sda] Unhandled error code
[103051.283504] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.283509] end_request: I/O error, dev sda, sector 255678135
[103051.283640] sd 0:0:0:0: [sda] Unhandled error code
[103051.283643] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.283648] end_request: I/O error, dev sda, sector 255678375
[103051.283728] sd 0:0:0:0: [sda] Unhandled error code
[103051.283731] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.283736] end_request: I/O error, dev sda, sector 255678415
[103051.283863] sd 0:0:0:0: [sda] Unhandled error code
[103051.283866] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.283871] end_request: I/O error, dev sda, sector 255678655
[103051.283992] sd 0:0:0:0: [sda] Unhandled error code
[103051.283996] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.284006] end_request: I/O error, dev sda, sector 255678895
[103051.284134] sd 0:0:0:0: [sda] Unhandled error code
[103051.284138] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.284143] end_request: I/O error, dev sda, sector 255679135
[103051.284273] sd 0:0:0:0: [sda] Unhandled error code
[103051.284276] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.284281] end_request: I/O error, dev sda, sector 255679375
[103051.284409] sd 0:0:0:0: [sda] Unhandled error code
[103051.284413] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.284418] end_request: I/O error, dev sda, sector 255679615
[103051.284568] sd 0:0:0:0: [sda] Unhandled error code
[103051.284572] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.284577] end_request: I/O error, dev sda, sector 255679855
[103051.284717] sd 0:0:0:0: [sda] Unhandled error code
[103051.284721] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.284726] end_request: I/O error, dev sda, sector 255680095
[103051.284866] sd 0:0:0:0: [sda] Unhandled error code
[103051.284870] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.284875] end_request: I/O error, dev sda, sector 255680335
[103051.285007] sd 0:0:0:0: [sda] Unhandled error code
[103051.285010] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.285015] end_request: I/O error, dev sda, sector 255680575
[103051.285157] sd 0:0:0:0: [sda] Unhandled error code
[103051.285160] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.285165] end_request: I/O error, dev sda, sector 255680815
[103051.285294] sd 0:0:0:0: [sda] Unhandled error code
[103051.285298] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.285303] end_request: I/O error, dev sda, sector 255681055
[103051.285425] sd 0:0:0:0: [sda] Unhandled error code
[103051.285429] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.285434] end_request: I/O error, dev sda, sector 255681295
[103051.285552] sd 0:0:0:0: [sda] Unhandled error code
[103051.285556] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.285561] end_request: I/O error, dev sda, sector 255681535
[103051.285687] sd 0:0:0:0: [sda] Unhandled error code
[103051.285691] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.285696] end_request: I/O error, dev sda, sector 255681775
[103051.285833] sd 0:0:0:0: [sda] Unhandled error code
[103051.285837] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.285842] end_request: I/O error, dev sda, sector 255682015
[103051.285983] sd 0:0:0:0: [sda] Unhandled error code
[103051.285987] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.285992] end_request: I/O error, dev sda, sector 255682255
[103051.286125] sd 0:0:0:0: [sda] Unhandled error code
[103051.286128] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.286133] end_request: I/O error, dev sda, sector 255682495
[103051.286265] sd 0:0:0:0: [sda] Unhandled error code
[103051.286268] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.286273] end_request: I/O error, dev sda, sector 255682735
[103051.286391] sd 0:0:0:0: [sda] Unhandled error code
[103051.286394] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.286399] end_request: I/O error, dev sda, sector 255682975
[103051.286538] sd 0:0:0:0: [sda] Unhandled error code
[103051.286541] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.286546] end_request: I/O error, dev sda, sector 255683215
[103051.286684] sd 0:0:0:0: [sda] Unhandled error code
[103051.286688] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.286693] end_request: I/O error, dev sda, sector 255683455
[103051.286822] sd 0:0:0:0: [sda] Unhandled error code
[103051.286825] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.286830] end_request: I/O error, dev sda, sector 255683695
[103051.286948] sd 0:0:0:0: [sda] Unhandled error code
[103051.286951] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.286956] end_request: I/O error, dev sda, sector 255683935
[103051.287092] sd 0:0:0:0: [sda] Unhandled error code
[103051.287095] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.287100] end_request: I/O error, dev sda, sector 255684175
[103051.287225] sd 0:0:0:0: [sda] Unhandled error code
[103051.287228] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.287233] end_request: I/O error, dev sda, sector 255684415
[103051.287382] sd 0:0:0:0: [sda] Unhandled error code
[103051.287386] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.287391] end_request: I/O error, dev sda, sector 255684655
[103051.287540] sd 0:0:0:0: [sda] Unhandled error code
[103051.287543] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.287548] end_request: I/O error, dev sda, sector 255684895
[103051.287687] sd 0:0:0:0: [sda] Unhandled error code
[103051.287691] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.287696] end_request: I/O error, dev sda, sector 255685135
[103051.287834] sd 0:0:0:0: [sda] Unhandled error code
[103051.287838] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.287843] end_request: I/O error, dev sda, sector 255685375
[103051.288022] sd 0:0:0:0: [sda] Unhandled error code
[103051.288025] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.288030] end_request: I/O error, dev sda, sector 255685615
[103051.288160] sd 0:0:0:0: [sda] Unhandled error code
[103051.288163] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.288168] end_request: I/O error, dev sda, sector 255685855
[103051.288306] sd 0:0:0:0: [sda] Unhandled error code
[103051.288309] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.288314] end_request: I/O error, dev sda, sector 255686095
[103051.288438] sd 0:0:0:0: [sda] Unhandled error code
[103051.288441] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.288446] end_request: I/O error, dev sda, sector 255686335
[103051.288571] sd 0:0:0:0: [sda] Unhandled error code
[103051.288575] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.288580] end_request: I/O error, dev sda, sector 255686575
[103051.288648] sd 0:0:0:0: [sda] Unhandled error code
[103051.288651] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.288656] end_request: I/O error, dev sda, sector 255686615
[103051.288785] sd 0:0:0:0: [sda] Unhandled error code
[103051.288789] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.288794] end_request: I/O error, dev sda, sector 255686855
[103051.288921] sd 0:0:0:0: [sda] Unhandled error code
[103051.288924] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.288930] end_request: I/O error, dev sda, sector 255687095
[103051.289067] sd 0:0:0:0: [sda] Unhandled error code
[103051.289070] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.289075] end_request: I/O error, dev sda, sector 255687335
[103051.289216] sd 0:0:0:0: [sda] Unhandled error code
[103051.289220] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.289225] end_request: I/O error, dev sda, sector 255687575
[103051.289407] sd 0:0:0:0: [sda] Unhandled error code
[103051.289410] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.289415] end_request: I/O error, dev sda, sector 255687815
[103051.289545] sd 0:0:0:0: [sda] Unhandled error code
[103051.289548] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.289553] end_request: I/O error, dev sda, sector 255688055
[103051.289682] sd 0:0:0:0: [sda] Unhandled error code
[103051.289686] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.289691] end_request: I/O error, dev sda, sector 255688295
[103051.289842] sd 0:0:0:0: [sda] Unhandled error code
[103051.289845] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.289850] end_request: I/O error, dev sda, sector 255688535
[103051.289980] sd 0:0:0:0: [sda] Unhandled error code
[103051.289983] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.289988] end_request: I/O error, dev sda, sector 255688775
[103051.290111] sd 0:0:0:0: [sda] Unhandled error code
[103051.290114] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.290119] end_request: I/O error, dev sda, sector 255689015
[103051.290256] sd 0:0:0:0: [sda] Unhandled error code
[103051.290260] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.290265] end_request: I/O error, dev sda, sector 255689255
[103051.290402] sd 0:0:0:0: [sda] Unhandled error code
[103051.290406] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.290411] end_request: I/O error, dev sda, sector 255689495
[103051.290553] sd 0:0:0:0: [sda] Unhandled error code
[103051.290556] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.290561] end_request: I/O error, dev sda, sector 255689735
[103051.290700] sd 0:0:0:0: [sda] Unhandled error code
[103051.290703] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.290708] end_request: I/O error, dev sda, sector 255689975
[103051.290844] sd 0:0:0:0: [sda] Unhandled error code
[103051.290847] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.290852] end_request: I/O error, dev sda, sector 255690215
[103051.290974] sd 0:0:0:0: [sda] Unhandled error code
[103051.290978] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.290983] end_request: I/O error, dev sda, sector 255690455
[103051.291125] sd 0:0:0:0: [sda] Unhandled error code
[103051.291128] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.291133] end_request: I/O error, dev sda, sector 255690695
[103051.291267] sd 0:0:0:0: [sda] Unhandled error code
[103051.291270] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.291275] end_request: I/O error, dev sda, sector 255690935
[103051.291420] sd 0:0:0:0: [sda] Unhandled error code
[103051.291424] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.291429] end_request: I/O error, dev sda, sector 255691175
[103051.291560] sd 0:0:0:0: [sda] Unhandled error code
[103051.291564] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.291569] end_request: I/O error, dev sda, sector 255691415
[103051.291698] sd 0:0:0:0: [sda] Unhandled error code
[103051.291701] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.291706] end_request: I/O error, dev sda, sector 255691655
[103051.291849] sd 0:0:0:0: [sda] Unhandled error code
[103051.291852] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.291857] end_request: I/O error, dev sda, sector 255691895
[103051.292008] sd 0:0:0:0: [sda] Unhandled error code
[103051.292011] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.292017] end_request: I/O error, dev sda, sector 255692135
[103051.292227] sd 0:0:0:0: [sda] Unhandled error code
[103051.292230] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.292235] end_request: I/O error, dev sda, sector 255692375
[103051.292396] sd 0:0:0:0: [sda] Unhandled error code
[103051.292399] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.292404] end_request: I/O error, dev sda, sector 255692615
[103051.292508] hub 1-6:1.0: state 7 ports 4 chg 0002 evt 0000
[103051.292643] sd 0:0:0:0: [sda] Unhandled error code
[103051.292647] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.292652] end_request: I/O error, dev sda, sector 255692855
[103051.292828] sd 0:0:0:0: [sda] Unhandled error code
[103051.292831] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.292836] end_request: I/O error, dev sda, sector 255693095
[103051.292977] sd 0:0:0:0: [sda] Unhandled error code
[103051.292980] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.292985] end_request: I/O error, dev sda, sector 255693335
[103051.293133] sd 0:0:0:0: [sda] Unhandled error code
[103051.293136] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.293141] end_request: I/O error, dev sda, sector 255693575
[103051.293272] sd 0:0:0:0: [sda] Unhandled error code
[103051.293275] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.293280] end_request: I/O error, dev sda, sector 255693815
[103051.293416] sd 0:0:0:0: [sda] Unhandled error code
[103051.293420] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.293425] end_request: I/O error, dev sda, sector 255694055
[103051.293487] sd 0:0:0:0: [sda] Unhandled error code
[103051.293491] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.293496] end_request: I/O error, dev sda, sector 258511
[103051.293549] sd 0:0:0:0: [sda] Unhandled error code
[103051.293553] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.293558] end_request: I/O error, dev sda, sector 258535
[103051.293622] sd 0:0:0:0: [sda] Unhandled error code
[103051.293626] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.293631] end_request: I/O error, dev sda, sector 255328319
[103051.293685] sd 0:0:0:0: [sda] Unhandled error code
[103051.293688] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.293693] end_request: I/O error, dev sda, sector 255574439
[103051.293745] sd 0:0:0:0: [sda] Unhandled error code
[103051.293748] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.293753] end_request: I/O error, dev sda, sector 255582639
[103051.293805] sd 0:0:0:0: [sda] Unhandled error code
[103051.293809] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.293814] end_request: I/O error, dev sda, sector 255596407
[103051.293894] sd 0:0:0:0: [sda] Unhandled error code
[103051.293898] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.293903] end_request: I/O error, dev sda, sector 255604607
[103051.293955] sd 0:0:0:0: [sda] Unhandled error code
[103051.293959] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.293964] end_request: I/O error, dev sda, sector 255612807
[103051.294023] sd 0:0:0:0: [sda] Unhandled error code
[103051.294026] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.294031] end_request: I/O error, dev sda, sector 255621007
[103051.294078] sd 0:0:0:0: [sda] Unhandled error code
[103051.294081] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.294086] end_request: I/O error, dev sda, sector 255629207
[103051.294186] Aborting journal on device sda1.
[103051.294261] sd 0:0:0:0: [sda] Unhandled error code
[103051.294265] sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
[103051.294271] end_request: I/O error, dev sda, sector 12423
[103051.295042] hub 1-6:1.0: port 1, status 0100, change 0001, 12 Mb/s
[103051.295412] usb 1-6.1: USB disconnect, address 3
[103051.295416] usb 1-6.1: unregistering device
[103051.295420] usb 1-6.1: usb_disable_device nuking all URBs
[103051.295431] usb 1-6.1: unregistering interface 1-6.1:1.0
[103051.299398] __journal_remove_journal_head: freeing b_committed_data
[103051.300502] usb 1-6.1:1.0: uevent
[103051.300743] usb 1-6.1: uevent
[103051.313245] ext3_abort called.
[103051.313255] EXT3-fs error (device sda1): ext3_journal_start_sb: Detected aborted journal
[103051.313261] Remounting filesystem read-only
[103051.379354] EXT3-fs error (device sda1): ext3_find_entry: reading directory #6979648 offset 0
[103051.379906] EXT3-fs error (device sda1): ext3_find_entry: reading directory #6979648 offset 0
[103051.380099] EXT3-fs error (device sda1): ext3_find_entry: reading directory #6979648 offset 0
[103051.380237] EXT3-fs error (device sda1): ext3_find_entry: reading directory #6979648 offset 0
[103051.396411] EXT3-fs error (device sda1): ext3_find_entry: reading directory #6979636 offset 0
[103051.406406] hub 1-6:1.0: debounce: port 1: total 100ms stable 100ms status 0x100
[103053.704026] hub 1-6:1.0: hub_suspend
[103053.704041] usb 1-6: unlink qh256-0001/ffff88007c53f140 start 255 [1/0 us]
[103053.704360] usb 1-6: usb auto-suspend
[103056.704303] hub 1-0:1.0: hub_suspend
[103056.704319] usb usb1: bus auto-suspend
[103056.704324] ehci_hcd 0000:00:1d.7: suspend root hub
[103083.606368] ext3_abort called.
[103083.606377] EXT3-fs error (device sda1): ext3_put_super: Couldn't clean up the journal

--/04w6evG8XlLl3ft--
