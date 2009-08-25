Return-Path: <linux-kernel-owner+w=401wt.eu-S1755664AbZHYSLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbZHYSLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 14:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755625AbZHYSLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 14:11:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46952 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755645AbZHYSLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 14:11:39 -0400
Date: Tue, 25 Aug 2009 11:11:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: mailing54 <mailing54@plzk.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>, Eric Anholt <eric@anholt.net>
Subject: Re: Linux 2.6.31-rc7
In-Reply-To: <4A941E8B.8080902@plzk.org>
Message-ID: <alpine.LFD.2.01.0908251057260.3218@localhost.localdomain>
References: <alpine.LFD.2.01.0908211810390.3158@localhost.localdomain> <4A941E8B.8080902@plzk.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 25 Aug 2009, mailing54 wrote:
> 
> Unlike rc6, this rc (rc7) does not boot correctly on my Macbook 2.1. I am
> using amd64 kernel-debs provided by Ubuntu on
> http://kernel.ubuntu.com/~kernel-ppa/mainline/.
> 
> During boot with rc7, I can unlock my encrypted volumes just fine. After that,
> boot continues till suddenly screen goes black. I can not tell if the whole
> thing hangs or just the screen dies, but I can tell that the only way to get
> out of that limbo seems to be the power button. Again, everything seems to
> work flawless with rc6 Ubuntu deb.

Are you using the same config? It sounds very much like your -rc7 problems 
are due to the Intel KMS (kernel mode setting) driver, which I know has 
had problems on at least Mac Mini's. And I wonder if the -rc6 kernel deb 
used different config options and didn't enable KMS, for example. Because 
I don't think anything actually changed in the KMS code itself between rc6 
and rc7.

That said, there were some generic EDID changes that could possibly affect 
KMS, but looking at the dmesg, I don't think you had KMS enabled in -rc6, 
and maybe you do in -rc7. I have no idea what configs those debian builds 
use.

			Linus

---
> Assuming that dmesg output of rc6 and rc7 should look kinda similar, I tried
> to narrow the problem down to the following part in the output of rc6:
> 
> 
> [   21.193733] cfg80211: Regulatory domain changed to country: AT
> [   21.193737]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> [   21.193740]     (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
> [   21.193742]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
> [   21.193745]     (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
> [   21.193747]     (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
> [   21.707177] lp: driver loaded but no devices found
> [   21.913101] Adding 2097144k swap on /dev/mapper/vgencrypted-swap. Priority:-1 extents:1 across:2097144k
> [   22.485747] EXT3 FS on dm-1, internal journal
> [   23.482830] kjournald starting.  Commit interval 5 seconds
> [   23.483105] EXT3 FS on sda4, internal journal
> [   23.483109] EXT3-fs: mounted filesystem with writeback data mode.
> [   23.628917] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
> [   23.630731] SGI XFS Quota Management subsystem
> [   23.688751] XFS mounting filesystem dm-3
> [   24.004942] Ending clean XFS mount for filesystem: dm-3
> [   24.844066] HDA Intel 0000:00:1b.0: PCI INT A disabled
> [   24.853007] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ22
> [   24.853046] HDA Intel 0000:00:1b.0: setting latency timer to 64
> [   24.920161] hda_codec: STAC922x, Apple subsys_id=106b2200
> [   25.902474] ppdev: user-space parallel port driver
> [   30.269237] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [   30.543459] usb 5-1: usbfs: USBDEVFS_CONTROL failed cmd hid2hci rqt 64 rq 0 len 0 ret -84
> [   30.555027] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [   30.555030] Bluetooth: BNEP filters: protocol multicast
> [   30.591724] Bridge firewalling registered
> [   30.816130] usb 5-1: USB disconnect, address 2
> [   31.116057] usb 5-1: new full speed USB device using uhci_hcd and address 3
> [   31.309153] usb 5-1: configuration #1 chosen from 1 choice
> [   31.337641] Bluetooth: Generic Bluetooth USB driver ver 0.5
> [   31.338153] usbcore: registered new interface driver btusb
> [   33.876059] [drm] Initialized drm 1.1.0 20060810
> [   33.898991] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [   33.898997] pci 0000:00:02.0: setting latency timer to 64
> [   33.908179] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
> [   34.129469] render error detected, EIR: 0x00000010
> [   34.129475] page table error
> [   34.129477]   PGTBL_ER: 0x00000102
> [   34.129480] [drm:i915_handle_error] *ERROR* EIR stuck: 0x00000010, masking
> [   34.129487] render error detected, EIR: 0x00000010
> [   34.129489] page table error
> [   34.129490]   PGTBL_ER: 0x00000102
> [   34.408721] sky2 eth0: enabling interface
> [   34.409131] ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   36.660303] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> 
> 
> 
> (complete dmesg attached)
> 
> I think the problem must be somewhere in here because when booting rc7 (in
> rescue mode), the last thing I can see before all goes black is the frequency
> table shown in the first lines of the quoted section. (Also, there are
> scary-looking errors near the end ;) )
> 
> 
> /proc/version/
> Linux version 2.6.31-020631rc6-generic (root@zinc) (gcc version 4.2.3 (Ubuntu
> 4.2.3-2ubuntu7)) #020631rc6 SMP Fri Aug 14 09:04:48 UTC 2009
> 
> 
> Please let me know what further info is needed.
> 
> Regards,
> 
> Tobias
> 
