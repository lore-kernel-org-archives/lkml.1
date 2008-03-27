Return-Path: <linux-kernel-owner+w=401wt.eu-S1760003AbYC0QPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760003AbYC0QPJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 12:15:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756313AbYC0QO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 12:14:57 -0400
Received: from ns.suse.de ([195.135.220.2]:44178 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371AbYC0QOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 12:14:55 -0400
Date: Thu, 27 Mar 2008 09:07:00 -0700
From: Greg KH <gregkh@suse.de>
To: Mark Lord <lkml@rtr.ca>, jkosina@suse.cz
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
       Pavel Machek <pavel@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.25-rc7:  Ugh.
Message-ID: <20080327160700.GB828@suse.de>
References: <47EBBD57.30902@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47EBBD57.30902@rtr.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 11:29:27AM -0400, Mark Lord wrote:
> It is with great reluctance when I attempt moving my main "desktop"
> over to a new kernel version -- because the USB subsystem seems to
> break every single time.

That's not good, why not tell the linux-usb developers this?  (added to
the cc:)

> So today I tried 2.6.25-rc7 on it for the first time.
> Not good.
>
> It boots, but just a simple suspend/resume (RAM) was enough to kill it.
> It comes back on resume, with an X desktop again,
> but with no USB functionality -- no mouse.
>
> The keyboard still works, so I dropped to a console and tried:
>
>   rmmod usbhid
>   insmod usbhid
>
> And the console hung at 100% CPU on the insmod.

Haven't heard of this one before sorry.  Jiri, have you?

> Back to 2.6.24.3 again, for now -- I've got work to do.
>
> The specs of this machine have been posted with great regularity
> in the past, every new kernel revision it seems.   So here we go again:
>
> Dell Inspiron 9400 notebook, Intel Core2Duo T7400, 2GB SDRAM.
>
> Suspend/Resume have worked perfectly (after kernel fixes, mostly USB)
> for all kernels in the past since 2.6.20 or so.
>
> Here's the /var/log/messages from the suspend/resume.
> That's it for now.  I've got work to do, and I'm tired of
> seeing this break with each new revision.
>
>
> logger: /usr/local/bin/suspend.sh kernel: [  107.491762] PM: Syncing 
> filesystems ... done.
> kernel: [  107.492274] Freezing user space processes ... (elapsed 0.00 
> seconds) done.
> kernel: [  107.493016] Freezing remaining freezable tasks ... (elapsed 0.00 
> seconds) done.
> kernel: [  107.499129] ACPI: Preparing to enter system sleep state S3
> kernel: [  107.499656] Suspending console(s)
> kernel: [  107.524879] b44: eth0: powering down PHY
> kernel: [  108.011326] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> kernel: [  108.011473] sd 0:0:0:0: [sda] Stopping disk
> kernel: [  110.058446] pciehp_suspend ENTRY
> last message repeated 2 times
> kernel: [  110.058446] ricoh-mmc: Suspending.
> kernel: [  110.058446] ricoh-mmc: Controller is now re-enabled.
> kernel: [  110.058446] ACPI handle has no context!
> kernel: [  110.058446] ACPI: PCI interrupt for device 0000:03:01.1 disabled
> kernel: [  110.058446] ACPI handle has no context!
> kernel: [  110.089544] ACPI: PCI interrupt for device 0000:03:00.0 disabled
> kernel: [  110.089554] ACPI handle has no context!
> kernel: [  110.102988] ACPI: PCI interrupt for device 0000:00:1f.2 disabled
> kernel: [  110.116231] ACPI: PCI interrupt for device 0000:00:1d.7 disabled
> kernel: [  110.129385] ACPI: PCI interrupt for device 0000:00:1d.3 disabled
> kernel: [  110.129433] ACPI: PCI interrupt for device 0000:00:1d.2 disabled
> kernel: [  110.129480] ACPI: PCI interrupt for device 0000:00:1d.1 disabled
> kernel: [  110.129526] ACPI: PCI interrupt for device 0000:00:1d.0 disabled
> kernel: [  110.129533] pciehp_suspend ENTRY
> kernel: [  110.129601] pciehp_suspend ENTRY
> kernel: [  110.129668] pciehp_suspend ENTRY
> kernel: [  110.142697] ACPI: PCI interrupt for device 0000:00:1b.0 disabled
> kernel: [  110.155936] Disabling non-boot CPUs ...
> kernel: [  110.159155] CPU 1 is now offline
> kernel: [  110.159159] SMP alternatives: switching to UP code
> kernel: [  110.161085] CPU1 is down
> kernel: [  110.161085] Back to C!
> kernel: [  110.161498] Enabling non-boot CPUs ...
> kernel: [  110.161854] SMP alternatives: switching to SMP code
> kernel: [  110.162467] Booting processor 1/1 ip 4000
> kernel: [  110.162471] CPU 1 irqstacks, hard=c037f000 soft=c037d000
> kernel: [  111.314889] Initializing CPU#1
> kernel: [  111.314889] Calibrating delay using timer specific routine.. 
> 4321.52 BogoMIPS (lpj=7199246)
> kernel: [  111.314889] CPU: L1 I cache: 32K, L1 D cache: 32K
> kernel: [  111.314889] CPU: L2 cache: 4096K
> kernel: [  111.314889] CPU: Physical Processor ID: 0
> kernel: [  111.314889] CPU: Processor Core ID: 1
> kernel: [  110.256366] CPU1: Intel(R) Core(TM)2 CPU         T7400  @ 
> 2.16GHz stepping 06
> kernel: [  111.314889] CPU1 is up
> kernel: [  111.314896] Switched to high resolution mode on CPU 1
> kernel: [  111.349610] PM: Writing back config space on device 0000:00:01.0 
> at offset a (was f, writing 0)
> kernel: [  111.349618] PM: Writing back config space on device 0000:00:01.0 
> at offset 3 (was 10000, writing 10010)
> kernel: [  111.349629] PCI: Setting latency timer of device 0000:00:01.0 to 
> 64
> kernel: [  111.360769] PM: Writing back config space on device 0000:00:1b.0 
> at offset f (was 100, writing 10b)
> kernel: [  111.360795] PM: Writing back config space on device 0000:00:1b.0 
> at offset 4 (was ffa7c004, writing efffc004)
> kernel: [  111.360804] PM: Writing back config space on device 0000:00:1b.0 
> at offset 3 (was 0, writing 10)
> kernel: [  111.360814] PM: Writing back config space on device 0000:00:1b.0 
> at offset 1 (was 100000, writing 100102)
> kernel: [  111.360845] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 21 
> (level, low) -> IRQ 21
> kernel: [  111.360856] PCI: Setting latency timer of device 0000:00:1b.0 to 
> 64
> kernel: [  111.360892] PM: Writing back config space on device 0000:00:1c.0 
> at offset f (was 100, writing 20100)
> kernel: [  111.360910] PM: Writing back config space on device 0000:00:1c.0 
> at offset 9 (was 10001, writing 1fff1)
> kernel: [  111.360917] PM: Writing back config space on device 0000:00:1c.0 
> at offset 8 (was 0, writing fff0)
> kernel: [  111.360925] PM: Writing back config space on device 0000:00:1c.0 
> at offset 7 (was 0, writing 200000f0)
> kernel: [  111.360932] PM: Writing back config space on device 0000:00:1c.0 
> at offset 6 (was 0, writing b0b00)
> kernel: [  111.360944] PM: Writing back config space on device 0000:00:1c.0 
> at offset 3 (was 810000, writing 810010)
> kernel: [  111.360954] PM: Writing back config space on device 0000:00:1c.0 
> at offset 1 (was 100000, writing 100007)
> kernel: [  111.360982] PCI: Setting latency timer of device 0000:00:1c.0 to 
> 64
> kernel: [  111.360989] pciehp_resume ENTRY
> kernel: [  111.361035] PM: Writing back config space on device 0000:00:1c.1 
> at offset f (was 200, writing 20200)
> kernel: [  111.361047] PM: Writing back config space on device 0000:00:1c.1 
> at offset 9 (was 10001, writing 1fff1)
> kernel: [  111.361052] PM: Writing back config space on device 0000:00:1c.1 
> at offset 8 (was 0, writing efc0efc0)
> kernel: [  111.361056] PM: Writing back config space on device 0000:00:1c.1 
> at offset 7 (was 20000000, writing 200000f0)
> kernel: [  111.361061] PM: Writing back config space on device 0000:00:1c.1 
> at offset 6 (was 0, writing c0c00)
> kernel: [  111.361068] PM: Writing back config space on device 0000:00:1c.1 
> at offset 3 (was 810000, writing 810010)
> kernel: [  111.361075] PM: Writing back config space on device 0000:00:1c.1 
> at offset 1 (was 100000, writing 100107)
> kernel: [  111.361095] PCI: Setting latency timer of device 0000:00:1c.1 to 
> 64
> kernel: [  111.361099] pciehp_resume ENTRY
> kernel: [  112.362047] pciehp: Device 0000:0c:00.0 already exists at c:0, 
> cannot hot-add
> kernel: [  112.362052] pciehp: Cannot add device 0xc:0
> kernel: [  112.362085] PM: Writing back config space on device 0000:00:1c.3 
> at offset f (was 400, writing 20400)
> kernel: [  112.362102] PM: Writing back config space on device 0000:00:1c.3 
> at offset 9 (was 10001, writing e011e001)
> kernel: [  112.362110] PM: Writing back config space on device 0000:00:1c.3 
> at offset 8 (was 0, writing efb0efa0)
> kernel: [  112.362117] PM: Writing back config space on device 0000:00:1c.3 
> at offset 7 (was 0, writing d0d0)
> kernel: [  112.362125] PM: Writing back config space on device 0000:00:1c.3 
> at offset 6 (was 0, writing e0d00)
> kernel: [  112.362136] PM: Writing back config space on device 0000:00:1c.3 
> at offset 3 (was 810000, writing 810010)
> kernel: [  112.362146] PM: Writing back config space on device 0000:00:1c.3 
> at offset 1 (was 100000, writing 100007)
> kernel: [  112.362174] PCI: Setting latency timer of device 0000:00:1c.3 to 
> 64
> kernel: [  112.362181] pciehp_resume ENTRY
> kernel: [  112.362213] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 
> (level, low) -> IRQ 20
> kernel: [  112.362222] PCI: Setting latency timer of device 0000:00:1d.0 to 
> 64
> kernel: [  112.362287] usb usb1: root hub lost power or was reset
> kernel: [  112.362311] PCI: Enabling device 0000:00:1d.1 (0000 -> 0001)
> kernel: [  112.362316] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 21 
> (level, low) -> IRQ 21
> kernel: [  112.362326] PCI: Setting latency timer of device 0000:00:1d.1 to 
> 64
> kernel: [  112.362335] PM: Writing back config space on device 0000:00:1d.1 
> at offset f (was 200, writing 20b)
> kernel: [  112.362353] PM: Writing back config space on device 0000:00:1d.1 
> at offset 8 (was 1, writing bf61)
> kernel: [  112.362399] usb usb2: root hub lost power or was reset
> kernel: [  112.362421] PCI: Enabling device 0000:00:1d.2 (0000 -> 0001)
> kernel: [  112.362426] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 22 
> (level, low) -> IRQ 22
> kernel: [  112.362436] PCI: Setting latency timer of device 0000:00:1d.2 to 
> 64
> kernel: [  112.362445] PM: Writing back config space on device 0000:00:1d.2 
> at offset f (was 300, writing 309)
> kernel: [  112.362464] PM: Writing back config space on device 0000:00:1d.2 
> at offset 8 (was 1, writing bf41)
> kernel: [  112.362509] usb usb3: root hub lost power or was reset
> kernel: [  112.362532] PCI: Enabling device 0000:00:1d.3 (0000 -> 0001)
> kernel: [  112.362537] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 23 
> (level, low) -> IRQ 23
> kernel: [  112.362547] PCI: Setting latency timer of device 0000:00:1d.3 to 
> 64
> kernel: [  112.362556] PM: Writing back config space on device 0000:00:1d.3 
> at offset f (was 400, writing 407)
> kernel: [  112.362574] PM: Writing back config space on device 0000:00:1d.3 
> at offset 8 (was 1, writing bf21)
> kernel: [  112.362619] usb usb4: root hub lost power or was reset
> kernel: [  112.375278] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 
> (level, low) -> IRQ 20
> kernel: [  112.375286] PCI: Setting latency timer of device 0000:00:1d.7 to 
> 64
> kernel: [  112.375379] PM: Writing back config space on device 0000:00:1e.0 
> at offset 9 (was 100f1, writing 1fff1)
> kernel: [  112.375390] PM: Writing back config space on device 0000:00:1e.0 
> at offset 8 (was 90, writing ef90ef90)
> kernel: [  112.375400] PM: Writing back config space on device 0000:00:1e.0 
> at offset 7 (was 2280e0f0, writing 228000f0)
> kernel: [  112.375418] PM: Writing back config space on device 0000:00:1e.0 
> at offset 1 (was 100007, writing 100107)
> kernel: [  112.375446] PCI: Setting latency timer of device 0000:00:1e.0 to 
> 64
> kernel: [  112.375495] PM: Writing back config space on device 0000:00:1f.0 
> at offset 1 (was 2100007, writing 2100107)
> kernel: [  112.388552] PM: Writing back config space on device 0000:00:1f.2 
> at offset f (was 200, writing 205)
> kernel: [  112.388602] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 17 
> (level, low) -> IRQ 17
> kernel: [  112.388610] PCI: Setting latency timer of device 0000:00:1f.2 to 
> 64
> kernel: [  112.388636] PM: Writing back config space on device 0000:00:1f.3 
> at offset f (was 200, writing 205)
> kernel: [  111.330331] ata2.00: _GTF evaluation failed (AE 0x1001)
> kernel: [  111.330331] ata2.01: _GTF evaluation failed (AE 0x1001)
> kernel: [  112.388678] PM: Writing back config space on device 0000:00:1f.3 
> at offset 1 (was 2800001, writing 2800101)
> kernel: [  112.388751] PM: Writing back config space on device 0000:01:00.0 
> at offset f (was 1ff, writing 104)
> kernel: [  112.388838] PM: Writing back config space on device 0000:01:00.0 
> at offset 3 (was 0, writing 10)
> kernel: [  111.330331] ata1.01: _GTF evaluation failed (AE 0x1001)
> kernel: [  112.417656] PCI: Enabling device 0000:03:00.0 (0000 -> 0002)
> kernel: [  112.417662] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 
> (level, low) -> IRQ 17
> kernel: [  112.417677] PM: Writing back config space on device 0000:03:00.0 
> at offset f (was 100, writing 105)
> kernel: [  112.417702] PM: Writing back config space on device 0000:03:00.0 
> at offset 4 (was 0, writing ef9fe000)
> kernel: [  112.417710] PM: Writing back config space on device 0000:03:00.0 
> at offset 3 (was 0, writing 4000)
> kernel: [  112.417720] PM: Writing back config space on device 0000:03:00.0 
> at offset 1 (was 100002, writing 100106)
> kernel: [  112.431706] PM: Writing back config space on device 0000:03:01.0 
> at offset f (was 4020100, writing 4020103)
> kernel: [  112.431734] PM: Writing back config space on device 0000:03:01.0 
> at offset 4 (was 0, writing ef9fd800)
> kernel: [  112.431742] PM: Writing back config space on device 0000:03:01.0 
> at offset 3 (was 800000, writing 804000)
> kernel: [  112.431751] PM: Writing back config space on device 0000:03:01.0 
> at offset 1 (was 2100000, writing 2100106)
> kernel: [  112.517139] PM: Writing back config space on device 0000:03:01.1 
> at offset f (was 200, writing 209)
> kernel: [  112.517168] PM: Writing back config space on device 0000:03:01.1 
> at offset 4 (was 0, writing ef9fd400)
> kernel: [  112.517176] PM: Writing back config space on device 0000:03:01.1 
> at offset 3 (was 800000, writing 804000)
> kernel: [  112.517186] PM: Writing back config space on device 0000:03:01.1 
> at offset 1 (was 2100000, writing 2100106)
> kernel: [  112.517211] ACPI: PCI Interrupt 0000:03:01.1[B] -> GSI 18 
> (level, low) -> IRQ 18
> kernel: [  112.517234] ricoh-mmc: Resuming.
> kernel: [  112.517245] ricoh-mmc: Controller is now disabled.
> kernel: [  112.517259] PM: Writing back config space on device 0000:03:01.3 
> at offset f (was 200, writing 209)
> kernel: [  112.517286] PM: Writing back config space on device 0000:03:01.3 
> at offset 4 (was 0, writing ef9fd700)
> kernel: [  112.517298] PM: Writing back config space on device 0000:03:01.3 
> at offset 1 (was 2100000, writing 2100102)
> kernel: [  112.517382] pciehp_resume ENTRY
> kernel: [  112.517410] pciehp_resume ENTRY
> kernel: [  111.839425] ata2.00: configured for UDMA/33
> kernel: [  113.520191] pciehp: Device 0000:0c:00.0 already exists at c:0, 
> cannot hot-add
> kernel: [  113.520197] pciehp: Cannot add device 0xc:0
> kernel: [  113.520214] pciehp_resume ENTRY
> kernel: [  113.520461] sd 0:0:0:0: [sda] Starting disk
> kernel: [  113.727280] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
> kernel: [  113.746993] ata1.00: configured for UDMA/133
> kernel: [  113.770650] sd 0:0:0:0: [sda] 312581808 512-byte hardware 
> sectors (160042 MB)
> kernel: [  113.770650] sd 0:0:0:0: [sda] Write Protect is off
> kernel: [  113.770650] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> kernel: [  113.770650] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
> enabled, doesn't support DPO or FUA
> kernel: [  114.901667] Restarting tasks ... <6>usb 5-1: USB disconnect, 
> address 2
> kernel: [  114.933424] done.
> kernel: [  115.128131] usb 5-1: new high speed USB device using ehci_hcd 
> and address 5

This looks like your usb device should be up and working.

Do you have CONFIG_USB_SUSPEND enabled in your .config?

> ## Note: these are "normal" and harmless on this machine,
> ## and the reason for them has never been tracked down:
> kernel: [  115.198514] Uhhuh. NMI received for unknown reason 90 on CPU 0.
> kernel: [  115.198519] You have some hardware problem, likely on the PCI 
> bus.
> kernel: [  115.198521] Dazed and confused, but trying to continue


Not very nice "harmless" messages :(

>
> kernel: [  117.690742] b44: eth0: Link is up at 100 Mbps, full duplex.
> kernel: [  117.690750] b44: eth0: Flow control is off for TX and off for 
> RX.
> login[3020]: (pam_unix) session opened for user root by (uid=0)
> login[4507]: ROOT LOGIN  on 'tty1'
> root: reloading usbhid module
> kernel: [  225.955054] usbcore: deregistering interface driver usbhid
> kernel: [  225.966118] usbcore: deregistering interface driver hiddev
> root: session hung on insmod
> kernel: [  248.875843] SysRq : Emergency Sync
> kernel: [  248.876629] Emergency Sync complete
> kernel: [  249.535815] SysRq : Emergency Remount R/O
