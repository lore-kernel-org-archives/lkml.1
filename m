Return-Path: <linux-kernel-owner+w=401wt.eu-S1757925AbYFTQs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925AbYFTQs4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 12:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754572AbYFTQss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 12:48:48 -0400
Received: from www17.your-server.de ([213.133.104.17]:39219 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840AbYFTQsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 12:48:46 -0400
Subject: Re: kernel BUG at kernel/workqueue.c:169 (was: linux-next: Tree
	for June 16)
From: Thomas Meyer <thomas@m3y3r.de>
To: rpjday@crashcourse.ca, rusty@rustcorp.com.au
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1213651727.3275.3.camel@dhcppc4>
References: <20080616190103.c3271e3e.sfr@canb.auug.org.au>
	 <1213651727.3275.3.camel@dhcppc4>
Content-Type: text/plain
Date: Fri, 20 Jun 2008 20:48:37 +0200
Message-Id: <1213987718.3134.7.camel@dhcppc4>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 16.06.2008, 23:28 +0200 schrieb Thomas Meyer:

> My internet is gone :-(
> 
> [   24.176830] kernel BUG at kernel/workqueue.c:169!
> [   24.176830] invalid opcode: 0000 [#1] SMP 
> [   24.176830] last sysfs file: /sys/devices/pci0000:00/0000:00:05.0/host2/target2:0:0/2:0:0:0/rev
> [   24.176830] Modules linked in: rndis_wlan(+) cfi_probe snd_pcm gen_probe rndis_host ck804xrom(+) cdc_ether mtd snd_timer usbnet snd_page_alloc chipreg k8temp(+) snd_hwdep i2c_nforce2(+) hwmon button snd forcedeth(+) mii map_funcs i2c_core serio_raw soundcore pcspkr sg sr_mod cdrom sata_nv pata_amd ata_generic pata_acpi libata sd_mod scsi_mod sha256_generic aes_i586 dm_crypt dm_snapshot dm_zero dm_mirror dm_log dm_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: scsi_wait_scan]
> [   24.176830] 
> [   24.176830] Pid: 1006, comm: modprobe Not tainted (2.6.26-rc6-next-20080616 #74)
> [   24.176830] EIP: 0060:[<c04342e4>] EFLAGS: 00010213 CPU: 0
> [   24.176830] EIP is at queue_work+0x1b/0x48
> [   24.176830] EAX: f786606c EBX: 00000000 ECX: 00000000 EDX: f7866068
> [   24.176830] ESI: f7866800 EDI: f897a98c EBP: f6490c88 ESP: f6490c84
> [   24.176830]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [   24.176830] Process modprobe (pid: 1006, ti=f6490000 task=f6458c70 task.ti=f6490000)
> [   24.176830] Stack: f6e93cb8 f6490c90 f99a00b1 f6490cc0 f897a343 f7865c80 f7865d50 00000000 
> [   24.176830]        00000000 80000002 00000001 00000000 00000003 ffffffea f7865c80 f6490d00 
> [   24.176830]        f897a625 00000001 00000002 f6e93c00 f7865c80 f7865800 f7866800 c04f6d22 
> [   24.176830] Call Trace:
> [   24.176830]  [<f99a00b1>] ? rndis_wext_link_change+0x29/0x2b [rndis_wlan]
> [   24.176830]  [<f897a343>] ? rndis_command+0x1af/0x23c [rndis_host]
> [   24.176830]  [<f897a625>] ? generic_rndis_bind+0x109/0x3a6 [rndis_host]
> [   24.176830]  [<c04f6d22>] ? idr_get_empty_slot+0x12a/0x1d9
> [   24.176830]  [<f99a1f9f>] ? rndis_wext_bind+0x74/0x289 [rndis_wlan]
> [   24.176830]  [<c05be14e>] ? alloc_netdev_mq+0xb8/0xc3
> [   24.176830]  [<c05cbc0d>] ? ether_setup+0x0/0x78
> [   24.176830]  [<f89685b3>] ? usbnet_probe+0x21d/0x4dd [usbnet]
> [   24.176830]  [<c062ddfb>] ? mutex_lock+0x1d/0x2d
> [   24.176830]  [<c0581ab5>] ? usb_autopm_do_device+0xb1/0xb9
> [   24.176830]  [<c0582081>] ? usb_probe_interface+0xbc/0xef
> [   24.176830]  [<c056bc6d>] ? driver_probe_device+0xa0/0x136
> [   24.176830]  [<c056bd3d>] ? __driver_attach+0x3a/0x59
> [   24.176830]  [<c056b6a5>] ? bus_for_each_dev+0x3b/0x63
> [   24.176830]  [<c056bb12>] ? driver_attach+0x14/0x16
> [   24.176830]  [<c056bd03>] ? __driver_attach+0x0/0x59
> [   24.176830]  [<c056b0da>] ? bus_add_driver+0x9d/0x1ba
> [   24.176830]  [<c056bec7>] ? driver_register+0x81/0xe1
> [   24.176830]  [<c0582266>] ? usb_register_driver+0x66/0xc0
> [   24.176830]  [<f891d017>] ? rndis_wlan_init+0x17/0x19 [rndis_wlan]
> [   24.176830]  [<c04451bb>] ? sys_init_module+0x177e/0x1930
> [   24.176830]  [<c0403895>] ? sysenter_past_esp+0x6a/0x91
> [   24.176830]  =======================
> [   24.176830] Code: 76 c0 8b 00 f7 d0 8b 04 88 e8 a7 ff ff ff c9 c3 55 89 e5 53 89 c3 f0 0f ba 2a 00 19 c0 31 c9 85 c0 75 30 8d 42 04 39 42 04 74 04 <0f> 0b eb fe 64 8b 0d 04 00 7b c0 83 7b 10 00 74 06 8b 0d f4 b4 
> [   24.176830] EIP: [<c04342e4>] queue_work+0x1b/0x48 SS:ESP 0068:f6490c84
> [   24.185309] ---[ end trace 6a99273b07870aed ]---
> 

I tried to bisect this one, but without a consistent result. So I looked
at the last changes on the file drivers/net/wireless/rndis_wlan*

Strangley reverting commmit 5720508d9ad9a82927875252b7a19ba2b45f11f8
(rndis_wlan: Use kernel-supplied ARRAY_SIZE() macro) brought back my usb
wlan device!

This is strange, the commit looks good.

Another thing i tried is to change <linux/kernel.h>:

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 9453483..fcd7b73 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -40,7 +40,7 @@ extern const char linux_proc_banner[];
 #define PTR_ALIGN(p, a)                ((typeof(p))ALIGN((unsigned long)(p), (a)))
 #define IS_ALIGNED(x, a)               (((x) & ((typeof(x))(a) - 1)) == 0)
 
-#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
+#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
 
 #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
 #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))

Recompling rndis_wlan with above change, makes my usb wlan stick work
again.

Maybe I'm totally wrong here, but i assume that the must_be_array thing
is broken. but OTOH ARRAY_SIZE is used in a lot of places in the kernel.
So I'm not sure what's going on here.

gcc version is:
$ gcc --version
gcc (GCC) 4.3.0 20080428 (Red Hat 4.3.0-8)

Feedback msot welcome!

greets
thomas



