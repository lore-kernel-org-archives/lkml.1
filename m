Return-Path: <linux-kernel-owner+w=401wt.eu-S1752141AbZAKTh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbZAKTh6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 14:37:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbZAKTg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 14:36:28 -0500
Received: from ns2.suse.de ([195.135.220.15]:39324 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbZAKTgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 14:36:25 -0500
Message-Id: <57de16e612d63138bd2c618449af9d8312466e25.1231695451.git.kkeil@suse.de>
In-Reply-To: <cover.1231695451.git.kkeil@suse.de>
References: <cover.1231695451.git.kkeil@suse.de>
Subject: [PATCH 1/7] BUGFIX: used NULL pointer at ioctl(sk,IMGETDEVINFO,&devinfo) when devinfo.id not registered
From: Karsten Keil <kkeil@suse.de>
Date: Sun, 11 Jan 2009 16:24:13 +0100
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Karsten Keil <kkeil@suse.de>,
       Martin Bachem <m.bachem@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Bachem <m.bachem@gmx.de>
Date: Sun, 26 Oct 2008 13:30:09 +0100

daxtar example # modprobe hfcsusb
daxtar example # modprobe mISDN_l1loop
daxtar example # ./misdnportinfo
Found 3 devices
        id:             0
        Dprotocols:     00000006
        Bprotocols:     0000000e
        protocol:       0
        nrbchan:        2
        name:           HFC-S_USB.1
        id:             1
        Dprotocols:     00000006
        Bprotocols:     0000000e
        protocol:       0
        nrbchan:        2
        name:           mISDN_l1loop.1
        id:             2
        Dprotocols:     00000006
        Bprotocols:     0000000e
        protocol:       0
        nrbchan:        2
        name:           mISDN_l1loop.2
daxtar example # rmmod hfcsusb
daxtar example # ./misdnportinfo
Found 2 devices
*Segmentation* *fault*

dmesg:

[ 9914.939718] BUG: unable to handle kernel NULL pointer dereference at 000000d4
[ 9914.939721] IP: [<f8f9f2dd>] :mISDN_core:get_mdevice+0x19/0x22
[ 9914.939729] *pde = 00000000
[ 9914.939732] Oops: 0000 [#14] PREEMPT SMP
[ 9914.939734] Modules linked in: mISDN_l1loop mISDN_core vmnet vmblock vmci vmmon coretemp w83627ehf hwmon_vid rfcomm l2cap blue
tooth usbhid snd_usb_audio snd_usb_lib snd_rawmidi snd_hwdep fuse nvidia(P) uhci_hcd i2c_i801 ehci_hcd snd_hda_intel atl1 usbcore i2c_core parport_seria
l [last unloaded: hfcsusb]
[ 9914.939751] Pid: 29618, comm: misdnportinfo Tainted: P      D   (2.6.27.3 #5)
[ 9914.939753] EIP: 0060:[<f8f9f2dd>] EFLAGS: 00210246 CPU: 0
[ 9914.939758] EIP is at get_mdevice+0x19/0x22 [mISDN_core]
[ 9914.939760] EAX: 00000000 EBX: f8fa791c ECX: f6afaa58 EDX: f7960cf4
[ 9914.939762] ESI: 80044944 EDI: bfc2e62c EBP: bfc2e62c ESP: f5adbef4
[ 9914.939763]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[ 9914.939765] Process misdnportinfo (pid: 29618, ti=f5ada000 task=f6bec430 task.ti=f5ada000)
[ 9914.939767] Stack: f8f9f4e0 00000000 f8f9f867 bfc2e62c 0000000a c02461e8 00200246 c042dde8
[ 9914.939771]        00000003 c042dde4 00000000 00000001 00200082 c0114775 00000000 00000000
[ 9914.939775]        00000003 f7088010 00200282 f8fa791c 80044944 bfc2e62c bfc2e62c c02f6615
[ 9914.939780] Call Trace:
[ 9914.939782]  [<f8f9f4e0>] _get_mdevice+0x0/0x18 [mISDN_core]
[ 9914.939789]  [<f8f9f867>] base_sock_ioctl+0x7a/0x129 [mISDN_core]
[ 9914.939789]  [<c02461e8>] opost+0x171/0x182
[ 9914.939789]  [<c0114775>] __wake_up+0x29/0x39
[ 9914.939789]  [<c02f6615>] sock_ioctl+0x1b5/0x1d9
[ 9914.939789]  [<c02f6460>] sock_ioctl+0x0/0x1d9
[ 9914.939789]  [<c016794c>] vfs_ioctl+0x1c/0x5d
[ 9914.939789]  [<c0167bcb>] do_vfs_ioctl+0x23e/0x24e
[ 9914.939789]  [<c0167c07>] sys_ioctl+0x2c/0x45
[ 9914.939789]  [<c0102cbd>] sysenter_do_call+0x12/0x21
[ 9914.939789]  [<c0350000>] pci_fixup_i450gx+0x4e/0x56
[ 9914.939789]  =======================
[ 9914.939789] Code: 00 68 02 f0 f9 f8 e8 ae b4 2c c7 8b 44 24 04 5a 59 c3 83 ec 04 31 d2 89 04 24 89 e1 b8 ac df fa f8 68 e0 f4
f9 f8 e8 4a b5 2c c7 <8b> 80 d4 00 00 00 5a 59 c3 53 89 cb 8d 90 9c 00 00 00 89 c8 e8
[ 9914.939789] EIP: [<f8f9f2dd>] get_mdevice+0x19/0x22 [mISDN_core] SS:ESP 0068:f5adbef4
[ 9914.939858] ---[ end trace 50e18a715b019424 ]---

Signed-off-by: Martin Bachem <m.bachem@gmx.de>
Signed-off-by: Karsten Keil <kkeil@suse.de>
---
 include/linux/mISDNif.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/linux/mISDNif.h b/include/linux/mISDNif.h
index 557477a..5da3d95 100644
--- a/include/linux/mISDNif.h
+++ b/include/linux/mISDNif.h
@@ -559,7 +559,10 @@ extern void	mISDN_unregister_clock(struct mISDNclock *);
 
 static inline struct mISDNdevice *dev_to_mISDN(struct device *dev)
 {
-	return dev_get_drvdata(dev);
+	if (dev)
+		return dev_get_drvdata(dev);
+	else
+		return NULL;
 }
 
 extern void	set_channel_address(struct mISDNchannel *, u_int, u_int);
-- 
1.5.6.4

