Return-Path: <linux-kernel-owner+w=401wt.eu-S1752278AbZHaLvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbZHaLvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 07:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbZHaLvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 07:51:45 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:55965 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbZHaLvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 07:51:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=EttqYW6T6R8j/l4bgaQmlp+K2Oh3zRRm81U89c3hvNAcdejzD6hMK1EuRfBcqTyG0p
         DprLu2EuKoADoOJxkXE6Eb1BgQ/Zila/7fLI1t/SXsQTX7/sTsh1TkNph35zPX2A5/30
         PUuoDrjsC8cweE0Yyfj+Roz77m7GxbbM7hrJc=
MIME-Version: 1.0
Date: Mon, 31 Aug 2009 13:51:42 +0200
Message-ID: <c4e36d110908310451t7c238e09u5af112fa3321cc23@mail.gmail.com>
Subject: Regression in suspend to ram in 2.6.31-rc kernels
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I've noticed that my machine freezes while doing s2r and having
mounted filesystem from SD card.

My system: Lenovo T61, 4GB, C2D, kernel 2.6.31-rc8

Here is the trace of  suspend when SD card is inserted, follows resume
and again suspend and this time with mounted filesystem from SD card.

System locks with: PM: Removing info for mmc:mmc0:b368
Also btusb_bulk_complete: errors are interesting - I've noticed few
bugzillas in the google.
I could try bisect to find the patch - but it will take time....
So hopefully this trace will help.

Zdenek


[   48.518773] PM: Adding info for mmc:mmc0:b368
[   48.548729] mmcblk0: mmc0:b368 NCard 7.46 GiB
[   48.553560] PM: Adding info for No Bus:mmcblk0
[   48.558472]  mmcblk0: p1
[   48.564469] PM: Adding info for No Bus:mmcblk0p1
[   48.569513] PM: Adding info for No Bus:179:0
[   54.347771] usb 3-1: USB disconnect, address 2
[   54.348749] btusb_bulk_complete: hci0 urb ffff880138240948 failed
to resubmit (19)
[   54.359989] btusb_intr_complete: hci0 urb ffff880138240630 failed
to resubmit (19)
[   54.363287] btusb_bulk_complete: hci0 urb ffff880138240a50 failed
to resubmit (19)
[   54.375890] PM: Removing info for No Bus:ep_81
[   54.380563] PM: Removing info for No Bus:ep_82
[   54.385168] PM: Removing info for No Bus:ep_02
[   54.389853] PM: Removing info for usb:3-1:1.0
[   54.394592] btusb_send_frame: hci0 urb ffff880135f21318 submission failed
[   54.616119] PM: Adding info for No Bus:vcs63
[   54.616212] PM: Adding info for No Bus:vcsa63
[   54.643659] PM: Removing info for No Bus:rfkill0
[   54.648859] PM: Removing info for No Bus:hci0
[   54.653832] PM: Removing info for No Bus:ep_83
[   54.658478] PM: Removing info for No Bus:ep_03
[   54.663634] PM: Removing info for usb:3-1:1.1
[   54.669073] PM: Removing info for No Bus:ep_84
[   54.673712] PM: Removing info for No Bus:ep_04
[   54.674255] PM: Syncing filesystems ...
[   54.682217] PM: Removing info for usb:3-1:1.2
[   54.687086] done.
[   54.687189] PM: Removing info for usb:3-1:1.3
[   54.687398] PM: Removing info for No Bus:ep_00
[   54.687704] PM: Removing info for usb:3-1
[   54.688201] PM: Removing info for No Bus:usbdev3.2
[   54.708703] PM: Preparing system for mem sleep
[   54.714747] Freezing user space processes ... (elapsed 0.01 seconds) done.
[   54.738508] Freezing remaining freezable tasks ... (elapsed 0.06
seconds) done.
[   54.812909] PM: Entering mem sleep
[   54.816665] platform dock.0: preparing suspend
[   54.821181] platform dock.1: preparing suspend
[   54.825687] platform dock.2: preparing suspend
[   54.830210] agpgart-intel 0000:00:00.0: preparing suspend
[   54.835695] pci 0000:00:02.0: preparing suspend
[   54.840296] pci 0000:00:02.1: preparing suspend
[   54.844901] e1000e 0000:00:19.0: preparing suspend, may wakeup
[   54.850827] uhci_hcd 0000:00:1a.0: preparing suspend
[   54.855866] uhci_hcd 0000:00:1a.1: preparing suspend
[   54.860911] ehci_hcd 0000:00:1a.7: preparing suspend
[   54.865957] HDA Intel 0000:00:1b.0: preparing suspend
[   54.871089] pcieport-driver 0000:00:1c.0: preparing suspend
[   54.876746] pcieport-driver 0000:00:1c.1: preparing suspend
[   54.882396] pcieport-driver 0000:00:1c.2: preparing suspend
[   54.888048] pcieport-driver 0000:00:1c.3: preparing suspend
[   54.893695] pcieport-driver 0000:00:1c.4: preparing suspend
[   54.899340] uhci_hcd 0000:00:1d.0: preparing suspend
[   54.904383] uhci_hcd 0000:00:1d.1: preparing suspend
[   54.909503] uhci_hcd 0000:00:1d.2: preparing suspend
[   54.914545] ehci_hcd 0000:00:1d.7: preparing suspend
[   54.919583] pci 0000:00:1e.0: preparing suspend
[   54.924193] pci 0000:00:1f.0: preparing suspend
[   54.928795] ata_piix 0000:00:1f.1: preparing suspend
[   54.933842] ahci 0000:00:1f.2: preparing suspend
[   54.938533] i801_smbus 0000:00:1f.3: preparing suspend
[   54.943751] iwl3945 0000:03:00.0: preparing suspend
[   54.948717] pci 0000:15:00.0: preparing suspend
[   54.953329] sdhci-pci 0000:15:00.2: preparing suspend
[   54.958451] pci 0000:15:00.3: preparing suspend
[   54.963063] pci 0000:15:00.4: preparing suspend
[   54.967669] pci 0000:15:00.5: preparing suspend
[   54.972361] platform vesafb.0: preparing suspend
[   54.977217] serial8250 serial8250: preparing suspend
[   54.982358] i8042 i8042: preparing suspend
[   54.986545] platform hdaps: preparing suspend
[   54.991032] usb usb1: preparing type suspend, may wakeup
[   54.996430] usb usb2: preparing type suspend, may wakeup
[   55.001841] usb usb3: preparing type suspend, may wakeup
[   55.007243] usb usb4: preparing type suspend, may wakeup
[   55.012647] usb usb5: preparing type suspend, may wakeup
[   55.018044] usb usb6: preparing type suspend, may wakeup
[   55.023552] usb usb7: preparing type suspend, may wakeup
[   55.028949] usb 1-4: preparing type suspend, may wakeup
[   55.034262] usb 3-2: preparing type suspend, may wakeup
[   55.039573] usb 1-4.4: preparing type suspend, may wakeup
[   55.045076] iTCO_wdt iTCO_wdt: preparing suspend
[   55.049806] platform regulatory.0: preparing suspend
[   55.054870] thinkpad_acpi thinkpad_acpi: preparing suspend
[   55.060432] thinkpad_hwmon thinkpad_hwmon: preparing suspend
[   55.066312] mmcblk mmc0:b368: legacy suspend
[   55.070728] leds iwl-phy0::TX: legacy class suspend
[   55.075682] leds iwl-phy0::RX: legacy class suspend
[   55.080639] leds iwl-phy0::assoc: legacy class suspend
[   55.085849] leds iwl-phy0::radio: legacy class suspend
[   55.091087] backlight acpi_video0: legacy class suspend
[   55.096384] drm card0: legacy class suspend
[   55.113694] pci 0000:00:02.0: power state changed by ACPI to D3
[   55.119766] rfkill rfkill2: legacy class suspend
[   55.124504] ieee80211 phy0: legacy class suspend
[   55.142622] PM: Removing info for No Bus:iwl-phy0::assoc
[   55.148410] PM: Removing info for No Bus:iwl-phy0::RX
[   55.153723] PM: Removing info for No Bus:iwl-phy0::TX
[   55.159036] PM: Removing info for No Bus:iwl-phy0::radio
[   55.168882] leds tpacpi::thinkvantage: legacy class suspend
[   55.174579] leds tpacpi::standby: legacy class suspend
[   55.179842] leds tpacpi::power: legacy class suspend
[   55.184932] leds tpacpi::thinklight: legacy class suspend
[   55.190451] rfkill rfkill1: legacy class suspend
[   55.195192] psmouse serio2: legacy suspend
[   55.417071] thinkpad_hwmon thinkpad_hwmon: suspend
[   55.421984] thinkpad_acpi thinkpad_acpi: suspend
[   55.427617] leds mmc0::: legacy class suspend
[   55.432093] platform regulatory.0: suspend
[   55.436364] iTCO_wdt iTCO_wdt: suspend
[   55.440254] usb 1-4.4: type suspend, may wakeup
[   55.456971] usb 3-2: type suspend, may wakeup
[   55.473573] usb 1-4: type suspend, may wakeup
[   55.490111] usb usb7: type suspend, may wakeup
[   55.494682] usb usb6: type suspend, may wakeup
[   55.499257] usb usb5: type suspend, may wakeup
[   55.503833] usb usb4: type suspend, may wakeup
[   55.508400] usb usb3: type suspend, may wakeup
[   55.513087] usb usb2: type suspend, may wakeup
[   55.517652] usb usb1: type suspend, may wakeup
[   55.522280] sr 3:0:0:0: legacy suspend
[   55.526191] scsi target3:0:0: legacy suspend
[   55.530587] sd 0:0:0:0: legacy suspend
[   55.534474] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   55.540193] sd 0:0:0:0: [sda] Stopping disk
[   57.578287] scsi target0:0:0: legacy suspend
[   57.582691] platform hdaps: suspend
[   57.586294] psmouse serio1: legacy suspend
[   57.995366] atkbd serio0: legacy suspend
[   58.603402] i8042 i8042: suspend
[   58.606943] scsi host4: legacy suspend
[   58.610811] scsi host3: legacy suspend
[   58.614682] scsi host2: legacy suspend
[   58.618549] scsi host1: legacy suspend
[   58.622418] scsi host0: legacy suspend
[   58.626359] serial8250 serial8250: suspend
[   58.630763] platform vesafb.0: suspend
[   58.634685] pnp 00:0a: legacy suspend
[   58.638463] i8042 aux 00:09: legacy suspend
[   58.642793] i8042 kbd 00:08: legacy suspend
[   58.647110] rtc_cmos 00:07: legacy suspend, may wakeup
[   58.652420] pnp 00:06: legacy suspend
[   58.656199] pnp 00:05: legacy suspend
[   58.659977] pnp 00:04: legacy suspend
[   58.663750] pnp 00:03: legacy suspend
[   58.667531] system 00:02: legacy suspend
[   58.671582] pnp 00:01: legacy suspend
[   58.675364] system 00:00: legacy suspend
[   58.679424] pci 0000:15:00.5: suspend
[   58.683203] pci 0000:15:00.4: suspend
[   58.686983] pci 0000:15:00.3: suspend
[   58.690765] sdhci-pci 0000:15:00.2: suspend
[   58.695455] mmc0: card b368 removed
[   58.699058] PM: Removing info for mmc:mmc0:b368
[   58.704358] PM: Removing info for No Bus:mmcblk0p1
[   58.709743] PM: Removing info for No Bus:179:0
[   58.714660] PM: Removing info for No Bus:mmcblk0
[   58.721890] ACPI handle has no context!
[   58.725852] sdhci-pci 0000:15:00.2: PME# disabled
[   58.730711] sdhci-pci 0000:15:00.2: PCI INT C disabled
[   58.735978] ACPI handle has no context!
[   58.750081] pci 0000:15:00.0: suspend
[   58.753881] iwl3945 0000:03:00.0: suspend
[   58.770107] i801_smbus 0000:00:1f.3: suspend
[   58.774636] ahci 0000:00:1f.2: suspend
[   58.816766] ata_piix 0000:00:1f.1: suspend
[   58.821149] ata5: port disabled. ignoring.
[   58.825528] ata_piix 0000:00:1f.1: PCI INT C disabled
[   58.830746] pci 0000:00:1f.0: suspend
[   58.834535] pci 0000:00:1e.0: suspend
[   58.838333] ehci_hcd 0000:00:1d.7: suspend
[   58.842639] ehci_hcd 0000:00:1d.7: PCI INT D disabled
[   58.847883] uhci_hcd 0000:00:1d.2: suspend
[   58.852194] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[   58.857428] uhci_hcd 0000:00:1d.1: suspend
[   58.861670] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[   58.866863] uhci_hcd 0000:00:1d.0: suspend
[   58.871137] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[   58.876361] pcieport-driver 0000:00:1c.4: suspend
[   58.881241] pcieport-driver 0000:00:1c.3: suspend
[   58.886084] pcieport-driver 0000:00:1c.2: suspend
[   58.890958] pcieport-driver 0000:00:1c.1: suspend
[   58.895833] pcieport-driver 0000:00:1c.0: suspend
[   58.900695] HDA Intel 0000:00:1b.0: suspend
[   58.917161] HDA Intel 0000:00:1b.0: PCI INT B disabled
[   58.933436] ehci_hcd 0000:00:1a.7: suspend
[   58.937710] ehci_hcd 0000:00:1a.7: PCI INT C disabled
[   58.942930] uhci_hcd 0000:00:1a.1: suspend
[   58.947199] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[   58.952419] uhci_hcd 0000:00:1a.0: suspend
[   58.956696] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[   58.961906] e1000e 0000:00:19.0: suspend, may wakeup
[   58.969801] e1000e 0000:00:19.0: PCI INT A disabled
[   58.974851] e1000e 0000:00:19.0: PME# enabled
[   58.979405] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[   58.996757] pci 0000:00:02.1: suspend
[   59.000586] pci 0000:00:02.0: suspend
[   59.004424] agpgart-intel 0000:00:00.0: suspend
[   59.009140] platform dock.2: suspend
[   59.012871] platform dock.1: suspend
[   59.016594] platform dock.0: suspend
[   59.020326] thermal LNXTHERM:02: legacy suspend
[   59.025023] thermal LNXTHERM:01: legacy suspend
[   59.029728] acpi LNXTHERM:00: legacy suspend
[   59.034140] acpi IBM0079:00: legacy suspend
[   59.038477] acpi PNP0C14:00: legacy suspend
[   59.042822] acpi device:2a: legacy suspend
[   59.047077] acpi device:29: legacy suspend
[   59.051345] acpi device:28: legacy suspend
[   59.055584] acpi device:27: legacy suspend
[   59.059855] acpi device:26: legacy suspend
[   59.064080] acpi device:25: legacy suspend
[   59.068333] acpi device:24: legacy suspend
[   59.072599] acpi device:23: legacy suspend
[   59.076837] acpi device:22: legacy suspend
[   59.081101] acpi device:21: legacy suspend
[   59.085369] acpi device:20: legacy suspend
[   59.089630] acpi device:1f: legacy suspend
[   59.093878] acpi device:1e: legacy suspend
[   59.098129] acpi device:1d: legacy suspend
[   59.102377] acpi device:1c: legacy suspend
[   59.107508] acpi device:1b: legacy suspend
[   59.111789] acpi device:1a: legacy suspend
[   59.116063] acpi device:19: legacy suspend
[   59.120320] acpi device:18: legacy suspend
[   59.124571] acpi device:17: legacy suspend
[   59.128815] acpi device:16: legacy suspend
[   59.133065] acpi device:15: legacy suspend
[   59.137313] acpi device:14: legacy suspend
[   59.141573] acpi device:13: legacy suspend
[   59.145839] acpi device:12: legacy suspend
[   59.150108] acpi device:11: legacy suspend
[   59.154368] acpi device:10: legacy suspend
[   59.158617] acpi device:0f: legacy suspend
[   59.162849] acpi device:0e: legacy suspend
[   59.167095] acpi device:0d: legacy suspend
[   59.171352] acpi device:0c: legacy suspend
[   59.175614] acpi device:0b: legacy suspend
[   59.180218] acpi device:0a: legacy suspend
[   59.184503] acpi device:09: legacy suspend
[   59.188754] acpi device:08: legacy suspend
[   59.192993] acpi device:07: legacy suspend
[   59.197246] acpi device:06: legacy suspend
[   59.201501] acpi device:05: legacy suspend
[   59.205774] acpi device:04: legacy suspend
[   59.210045] acpi device:03: legacy suspend
[   59.214311] video device:02: legacy suspend
[   59.218655] thinkpad_hotkey IBM0068:00: legacy suspend
[   59.223985] ac ACPI0003:00: legacy suspend
[   59.228236] battery PNP0C0A:00: legacy suspend
[   59.232845] power LNXPOWER:00: legacy suspend
[   59.237383] ec PNP0C09:00: legacy suspend
[   59.241594] acpi ATM1200:00: legacy suspend
[   59.245941] acpi IBM0057:00: legacy suspend
[   59.250298] acpi PNP0303:00: legacy suspend
[   59.254674] acpi PNP0B00:00: legacy suspend
[   59.259005] acpi PNP0C04:00: legacy suspend
[   59.263327] acpi PNP0800:00: legacy suspend
[   59.267665] acpi PNP0200:00: legacy suspend
[   59.271994] acpi PNP0103:00: legacy suspend
[   59.276356] acpi PNP0100:00: legacy suspend
[   59.280704] acpi PNP0000:00: legacy suspend
[   59.285043] acpi PNP0C02:00: legacy suspend
[   59.289367] acpi device:01: legacy suspend
[   59.293628] pci_root PNP0A08:00: legacy suspend
[   59.298332] button PNP0C0E:00: legacy suspend
[   59.302860] button PNP0C0D:00: legacy suspend
[   59.307351] acpi PNP0C01:00: legacy suspend
[   59.311697] pci_link PNP0C0F:07: legacy suspend
[   59.316391] pci_link PNP0C0F:06: legacy suspend
[   59.321074] pci_link PNP0C0F:05: legacy suspend
[   59.325773] pci_link PNP0C0F:04: legacy suspend
[   59.330477] pci_link PNP0C0F:03: legacy suspend
[   59.335175] pci_link PNP0C0F:02: legacy suspend
[   59.340146] pci_link PNP0C0F:01: legacy suspend
[   59.344843] pci_link PNP0C0F:00: legacy suspend
[   59.349529] acpi device:00: legacy suspend
[   59.353773] processor LNXCPU:01: legacy suspend
[   59.358435] processor LNXCPU:00: legacy suspend
[   59.363122] button LNXPWRBN:00: legacy suspend
[   59.367738] acpi LNXSYSTM:00: legacy suspend
[   59.372341] thinkpad_hwmon thinkpad_hwmon: LATE suspend
[   59.377725] thinkpad_acpi thinkpad_acpi: LATE suspend
[   59.382919] platform regulatory.0: LATE suspend
[   59.387612] iTCO_wdt iTCO_wdt: LATE suspend
[   59.391962] platform hdaps: LATE suspend
[   59.396066] i8042 i8042: LATE suspend
[   59.399933] serial8250 serial8250: LATE suspend
[   59.404631] platform vesafb.0: LATE suspend
[   59.408993] pci 0000:15:00.5: LATE suspend
[   59.413441] pci 0000:15:00.4: LATE suspend
[   59.417840] pci 0000:15:00.3: LATE suspend
[   59.422231] sdhci-pci 0000:15:00.2: LATE suspend
[   59.427021] pci 0000:15:00.0: LATE suspend
[   59.431406] iwl3945 0000:03:00.0: LATE suspend
[   59.436012] i801_smbus 0000:00:1f.3: LATE suspend
[   59.440898] ahci 0000:00:1f.2: LATE suspend
[   59.445237] ata_piix 0000:00:1f.1: LATE suspend
[   59.449947] pci 0000:00:1f.0: LATE suspend
[   59.454348] pci 0000:00:1e.0: LATE suspend
[   59.458725] ehci_hcd 0000:00:1d.7: LATE suspend
[   59.463640] ehci_hcd 0000:00:1d.7: PME# disabled
[   59.566817] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
[   59.573377] uhci_hcd 0000:00:1d.2: LATE suspend
[   59.656865] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D3
[   59.663421] uhci_hcd 0000:00:1d.1: LATE suspend
[   59.668202] uhci_hcd 0000:00:1d.0: LATE suspend
[   59.750198] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D3
[   59.756727] pcieport-driver 0000:00:1c.4: LATE suspend
[   59.762186] pcieport-driver 0000:00:1c.3: LATE suspend
[   59.767640] pcieport-driver 0000:00:1c.2: LATE suspend
[   59.773130] pcieport-driver 0000:00:1c.1: LATE suspend
[   59.778625] pcieport-driver 0000:00:1c.0: LATE suspend
[   59.784077] HDA Intel 0000:00:1b.0: LATE suspend
[   59.788832] ehci_hcd 0000:00:1a.7: LATE suspend
[   59.793711] ehci_hcd 0000:00:1a.7: PME# disabled
[   59.890198] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D3
[   59.896738] uhci_hcd 0000:00:1a.1: LATE suspend
[   59.980198] uhci_hcd 0000:00:1a.1: power state changed by ACPI to D3
[   59.986707] uhci_hcd 0000:00:1a.0: LATE suspend
[   59.991487] e1000e 0000:00:19.0: LATE suspend, may wakeup
[   59.997046] pci 0000:00:02.1: LATE suspend
[   60.001327] pci 0000:00:02.0: LATE suspend
[   60.005605] agpgart-intel 0000:00:00.0: LATE suspend
[   60.010766] platform dock.2: LATE suspend
[   60.014914] platform dock.1: LATE suspend
[   60.019094] platform dock.0: LATE suspend
[   60.143490] ACPI: Preparing to enter system sleep state S3
[   60.640815] Disabling non-boot CPUs ...
[   60.648297] kvm: disabling virtualization on CPU1
[   60.648558] CPU 1 is now offline
[   60.656776] lockdep: fixing up alternatives.
[   60.661179] SMP alternatives: switching to UP code
[   60.673821] CPU0 attaching NULL sched-domain.
[   60.678563] CPU1 attaching NULL sched-domain.
[   60.683171] CPU0 attaching NULL sched-domain.
[   60.688863] CPU1 is down
[   60.691691] Extended CMOS year: 2000
[   60.691691] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[   60.691691] Back to C!
[   60.691691] CPU0: Thermal monitoring handled by SMI
[   60.691691] Extended CMOS year: 2000
[   60.695683] Enabling non-boot CPUs ...
[   60.703883] lockdep: fixing up alternatives.
[   60.708336] SMP alternatives: switching to SMP code
[   60.719176] Booting processor 1 APIC 0x1 ip 0x6000
[   60.672915] Initializing CPU#1
[   60.672915] Calibrating delay using timer specific routine..
4390.91 BogoMIPS (lpj=7315059)
[   60.672915] CPU: L1 I cache: 32K, L1 D cache: 32K
[   60.672915] CPU: L2 cache: 4096K
[   60.672915] CPU: Physical Processor ID: 0
[   60.672915] CPU: Processor Core ID: 1
[   60.672915] mce: CPU supports 6 MCE banks
[   60.672915] CPU1: Thermal monitoring handled by SMI
[   60.672915] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[   60.821634] CPU1:
[   60.823364] Switched to high resolution mode on CPU 1
[   60.873115] Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0a
[   60.879992] kvm: enabling virtualization on CPU1
[   60.884812] CPU0 attaching NULL sched-domain.
[   60.896740] CPU0 attaching sched-domain:
[   60.900824]  domain 0: span 0-1 level CPU
[   60.905093]   groups: 0 1
[   60.908127] CPU1 attaching sched-domain:
[   60.912199]  domain 0: span 0-1 level CPU
[   60.916449]   groups: 1 0
[   60.923587] CPU1 is up
[   60.926052] ACPI: Waking up from system sleep state S3
[   61.973640] platform dock.0: EARLY resume
[   61.977819] platform dock.1: EARLY resume
[   61.981973] platform dock.2: EARLY resume
[   61.986132] agpgart-intel 0000:00:00.0: EARLY resume
[   61.991316] pci 0000:00:02.0: EARLY resume
[   61.995574] pci 0000:00:02.0: restoring config space at offset 0x1
(was 0x900007, writing 0x900403)
[   62.004872] pci 0000:00:02.1: EARLY resume
[   62.009158] pci 0000:00:02.1: restoring config space at offset 0x1
(was 0x900000, writing 0x900007)
[   62.018380] e1000e 0000:00:19.0: EARLY resume
[   62.023044] uhci_hcd 0000:00:1a.0: EARLY resume
[   62.027813] uhci_hcd 0000:00:1a.0: restoring config space at offset
0x1 (was 0x2800005, writing 0x2800001)
[   62.037680] uhci_hcd 0000:00:1a.1: EARLY resume
[   62.180146] uhci_hcd 0000:00:1a.1: power state changed by ACPI to D0
[   62.186768] uhci_hcd 0000:00:1a.1: restoring config space at offset
0x1 (was 0x2800005, writing 0x2800001)
[   62.196703] ehci_hcd 0000:00:1a.7: EARLY resume
[   62.201481] ehci_hcd 0000:00:1a.7: restoring config space at offset
0x1 (was 0x2900106, writing 0x2900102)
[   62.211398] ehci_hcd 0000:00:1a.7: PME# disabled
[   62.216171] HDA Intel 0000:00:1b.0: EARLY resume
[   62.221063] HDA Intel 0000:00:1b.0: restoring config space at
offset 0x1 (was 0x100106, writing 0x100102)
[   62.230849] pcieport-driver 0000:00:1c.0: EARLY resume
[   62.236221] pcieport-driver 0000:00:1c.0: restoring config space at
offset 0x7 (was 0x20002020, writing 0x2020)
[   62.246562] pcieport-driver 0000:00:1c.0: restoring config space at
offset 0x1 (was 0x100107, writing 0x100507)
[   62.256993] pcieport-driver 0000:00:1c.1: EARLY resume
[   62.262374] pcieport-driver 0000:00:1c.1: restoring config space at
offset 0x7 (was 0x3030, writing 0x20003030)
[   62.273320] pcieport-driver 0000:00:1c.1: restoring config space at
offset 0x1 (was 0x100107, writing 0x100507)
[   62.283707] pcieport-driver 0000:00:1c.2: EARLY resume
[   62.289102] pcieport-driver 0000:00:1c.2: restoring config space at
offset 0x7 (was 0x20004040, writing 0x4040)
[   62.299437] pcieport-driver 0000:00:1c.2: restoring config space at
offset 0x1 (was 0x100107, writing 0x100507)
[   62.310189] pcieport-driver 0000:00:1c.3: EARLY resume
[   62.315573] pcieport-driver 0000:00:1c.3: restoring config space at
offset 0x7 (was 0x20005050, writing 0x5050)
[   62.325920] pcieport-driver 0000:00:1c.3: restoring config space at
offset 0x1 (was 0x100107, writing 0x100507)
[   62.336345] pcieport-driver 0000:00:1c.4: EARLY resume
[   62.341723] pcieport-driver 0000:00:1c.4: restoring config space at
offset 0x7 (was 0x20006060, writing 0x6060)
[   62.352054] pcieport-driver 0000:00:1c.4: restoring config space at
offset 0x1 (was 0x100107, writing 0x100507)
[   62.362441] uhci_hcd 0000:00:1d.0: EARLY resume
[   62.393526] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[   62.400134] uhci_hcd 0000:00:1d.0: restoring config space at offset
0x1 (was 0x2800005, writing 0x2800001)
[   62.410042] uhci_hcd 0000:00:1d.1: EARLY resume
[   62.414831] uhci_hcd 0000:00:1d.1: restoring config space at offset
0x1 (was 0x2800005, writing 0x2800001)
[   62.424687] uhci_hcd 0000:00:1d.2: EARLY resume
[   62.453526] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
[   62.460124] uhci_hcd 0000:00:1d.2: restoring config space at offset
0x1 (was 0x2800005, writing 0x2800001)
[   62.469978] ehci_hcd 0000:00:1d.7: EARLY resume
[   62.474778] ehci_hcd 0000:00:1d.7: restoring config space at offset
0x1 (was 0x2900106, writing 0x2900102)
[   62.484688] ehci_hcd 0000:00:1d.7: PME# disabled
[   62.489471] pci 0000:00:1e.0: EARLY resume
[   62.493821] pci 0000:00:1e.0: restoring config space at offset 0x1
(was 0x100005, writing 0x100007)
[   62.503060] pci 0000:00:1f.0: EARLY resume
[   62.507420] ata_piix 0000:00:1f.1: EARLY resume
[   62.512189] ata_piix 0000:00:1f.1: restoring config space at offset
0x1 (was 0x2800005, writing 0x2880005)
[   62.522012] ahci 0000:00:1f.2: EARLY resume
[   62.526491] ahci 0000:00:1f.2: restoring config space at offset 0x1
(was 0x2b00007, writing 0x2b00407)
[   62.536115] i801_smbus 0000:00:1f.3: EARLY resume
[   62.541061] iwl3945 0000:03:00.0: EARLY resume
[   62.545861] iwl3945 0000:03:00.0: restoring config space at offset
0x1 (was 0x100106, writing 0x100506)
[   62.555601] pci 0000:15:00.0: EARLY resume
[   62.559960] sdhci-pci 0000:15:00.2: EARLY resume
[   62.576810] sdhci-pci 0000:15:00.2: restoring config space at
offset 0x3 (was 0x800000, writing 0x804000)
[   62.586623] sdhci-pci 0000:15:00.2: restoring config space at
offset 0x1 (was 0x2100000, writing 0x2100006)
[   62.596580] pci 0000:15:00.3: EARLY resume
[   62.600953] pci 0000:15:00.4: EARLY resume
[   62.605342] pci 0000:15:00.5: EARLY resume
[   62.609714] platform vesafb.0: EARLY resume
[   62.614017] serial8250 serial8250: EARLY resume
[   62.618720] i8042 i8042: EARLY resume
[   62.622526] platform hdaps: EARLY resume
[   62.626611] iTCO_wdt iTCO_wdt: EARLY resume
[   62.630957] platform regulatory.0: EARLY resume
[   62.635667] thinkpad_acpi thinkpad_acpi: EARLY resume
[   62.640895] thinkpad_hwmon thinkpad_hwmon: EARLY resume
[   62.646397] acpi LNXSYSTM:00: legacy resume
[   62.650790] button LNXPWRBN:00: legacy resume
[   62.655315] processor LNXCPU:00: legacy resume
[   62.659918] processor LNXCPU:01: legacy resume
[   62.664531] acpi device:00: legacy resume
[   62.668719] pci_link PNP0C0F:00: legacy resume
[   62.673301] pci_link PNP0C0F:01: legacy resume
[   62.678222] pci_link PNP0C0F:02: legacy resume
[   62.682813] pci_link PNP0C0F:03: legacy resume
[   62.687433] pci_link PNP0C0F:04: legacy resume
[   62.692028] pci_link PNP0C0F:05: legacy resume
[   62.696612] pci_link PNP0C0F:06: legacy resume
[   62.701226] pci_link PNP0C0F:07: legacy resume
[   62.705843] acpi PNP0C01:00: legacy resume
[   62.710084] button PNP0C0D:00: legacy resume
[   62.740310] button PNP0C0E:00: legacy resume
[   62.744748] pci_root PNP0A08:00: legacy resume
[   62.749355] acpi device:01: legacy resume
[   62.753500] acpi PNP0C02:00: legacy resume
[   62.757733] acpi PNP0000:00: legacy resume
[   62.761987] acpi PNP0100:00: legacy resume
[   62.766240] acpi PNP0103:00: legacy resume
[   62.770497] acpi PNP0200:00: legacy resume
[   62.774754] acpi PNP0800:00: legacy resume
[   62.779027] acpi PNP0C04:00: legacy resume
[   62.783288] acpi PNP0B00:00: legacy resume
[   62.787535] acpi PNP0303:00: legacy resume
[   62.791801] acpi IBM0057:00: legacy resume
[   62.796049] acpi ATM1200:00: legacy resume
[   62.800305] ec PNP0C09:00: legacy resume
[   62.804372] power LNXPOWER:00: legacy resume
[   62.809609] battery PNP0C0A:00: legacy resume
[   62.861016] ac ACPI0003:00: legacy resume
[   62.866037] thinkpad_hotkey IBM0068:00: legacy resume
[   62.871273] video device:02: legacy resume
[   62.881358] acpi device:03: legacy resume
[   62.885540] acpi device:04: legacy resume
[   62.889732] acpi device:05: legacy resume
[   62.893897] acpi device:06: legacy resume
[   62.898068] acpi device:07: legacy resume
[   62.902230] acpi device:08: legacy resume
[   62.906392] acpi device:09: legacy resume
[   62.910557] acpi device:0a: legacy resume
[   62.914723] acpi device:0b: legacy resume
[   62.918892] acpi device:0c: legacy resume
[   62.923049] acpi device:0d: legacy resume
[   62.927219] acpi device:0e: legacy resume
[   62.931374] acpi device:0f: legacy resume
[   62.935540] acpi device:10: legacy resume
[   62.939718] acpi device:11: legacy resume
[   62.943864] acpi device:12: legacy resume
[   62.948028] acpi device:13: legacy resume
[   62.952184] acpi device:14: legacy resume
[   62.956338] acpi device:15: legacy resume
[   62.960485] acpi device:16: legacy resume
[   62.964629] acpi device:17: legacy resume
[   62.968788] acpi device:18: legacy resume
[   62.972954] acpi device:19: legacy resume
[   62.977131] acpi device:1a: legacy resume
[   62.981256] acpi device:1b: legacy resume
[   62.985428] acpi device:1c: legacy resume
[   62.989570] acpi device:1d: legacy resume
[   62.993740] acpi device:1e: legacy resume
[   62.997919] acpi device:1f: legacy resume
[   63.002081] acpi device:20: legacy resume
[   63.006244] acpi device:21: legacy resume
[   63.010437] acpi device:22: legacy resume
[   63.014574] acpi device:23: legacy resume
[   63.018735] acpi device:24: legacy resume
[   63.022902] acpi device:25: legacy resume
[   63.027054] acpi device:26: legacy resume
[   63.031217] acpi device:27: legacy resume
[   63.035389] acpi device:28: legacy resume
[   63.039528] acpi device:29: legacy resume
[   63.043706] acpi device:2a: legacy resume
[   63.047853] acpi PNP0C14:00: legacy resume
[   63.052110] acpi IBM0079:00: legacy resume
[   63.056354] acpi LNXTHERM:00: legacy resume
[   63.060675] thermal LNXTHERM:01: legacy resume
[   63.067758] thermal LNXTHERM:02: legacy resume
[   63.073703] platform dock.0: resume
[   63.077314] platform dock.1: resume
[   63.080971] platform dock.2: resume
[   63.084616] agpgart-intel 0000:00:00.0: resume
[   63.092075] pci 0000:00:02.0: resume
[   63.095850] pci 0000:00:02.0: PME# disabled
[   63.100194] pci 0000:00:02.1: resume
[   63.103935] pci 0000:00:02.1: PME# disabled
[   63.108270] e1000e 0000:00:19.0: resume
[   63.112301] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   63.119459] e1000e 0000:00:19.0: setting latency timer to 64
[   63.125316] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[   63.131829] e1000e 0000:00:19.0: PME# disabled
[   63.136414] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[   63.142929] e1000e 0000:00:19.0: PME# disabled
[   63.147628] e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
[   63.455553] uhci_hcd 0000:00:1a.0: resume
[   63.459736] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   63.467050] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[   63.473078] usb usb3: root hub lost power or was reset
[   63.478539] uhci_hcd 0000:00:1a.1: resume
[   63.482729] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[   63.490050] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[   63.496062] usb usb4: root hub lost power or was reset
[   63.501376] ehci_hcd 0000:00:1a.7: resume
[   63.505533] ehci_hcd 0000:00:1a.7: PME# disabled
[   63.510325] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[   63.517674] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[   63.523803] HDA Intel 0000:00:1b.0: resume
[   63.528059] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level,
low) -> IRQ 17
[   63.535435] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   63.960513] pcieport-driver 0000:00:1c.0: resume
[   63.965365] pcieport-driver 0000:00:1c.1: resume
[   63.970151] pcieport-driver 0000:00:1c.2: resume
[   63.974940] pcieport-driver 0000:00:1c.3: resume
[   63.980334] pcieport-driver 0000:00:1c.4: resume
[   63.985141] uhci_hcd 0000:00:1d.0: resume
[   63.989304] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   63.996602] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   64.002644] usb usb5: root hub lost power or was reset
[   64.007960] uhci_hcd 0000:00:1d.1: resume
[   64.012144] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   64.019452] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   64.025481] usb usb6: root hub lost power or was reset
[   64.030779] uhci_hcd 0000:00:1d.2: resume
[   64.034943] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   64.042592] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   64.048617] usb usb7: root hub lost power or was reset
[   64.053953] ehci_hcd 0000:00:1d.7: resume
[   64.058132] ehci_hcd 0000:00:1d.7: PME# disabled
[   64.062922] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[   64.070572] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   64.076591] pci 0000:00:1e.0: resume
[   64.080338] pci 0000:00:1e.0: setting latency timer to 64
[   64.085908] pci 0000:00:1f.0: resume
[   64.089652] ata_piix 0000:00:1f.1: resume
[   64.093850] ata_piix 0000:00:1f.1: PCI INT C -> GSI 16 (level, low) -> IRQ 16
[   64.101153] ata_piix 0000:00:1f.1: setting latency timer to 64
[   64.108756] ata5: port disabled. ignoring.
[   64.114208] ahci 0000:00:1f.2: resume
[   64.118034] ahci 0000:00:1f.2: setting latency timer to 64
[   64.123712] i801_smbus 0000:00:1f.3: resume
[   64.128027] iwl3945 0000:03:00.0: resume
[   64.132163] pci 0000:15:00.0: resume
[   64.135890] pci 0000:15:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   64.142764] sdhci-pci 0000:15:00.2: resume
[   64.147000] sdhci-pci 0000:15:00.2: PCI INT C -> GSI 18 (level,
low) -> IRQ 18
[   64.154424] sdhci-pci 0000:15:00.2: Will use DMA mode even though
HW doesn't fully claim to support it.
[   64.165083] pci 0000:15:00.3: resume
[   64.168812] pci 0000:15:00.3: PME# disabled
[   64.173139] pci 0000:15:00.4: resume
[   64.176845] pci 0000:15:00.4: PME# disabled
[   64.181179] pci 0000:15:00.5: resume
[   64.184890] pci 0000:15:00.5: PME# disabled
[   64.189241] system 00:00: legacy resume
[   64.193213] pnp 00:01: legacy resume
[   64.196984] system 00:02: legacy resume
[   64.201089] pnp 00:03: legacy resume
[   64.204920] pnp 00:04: legacy resume
[   64.208737] pnp 00:05: legacy resume
[   64.212562] pnp 00:06: legacy resume
[   64.216382] rtc_cmos 00:07: legacy resume
[   64.220679] i8042 kbd 00:08: legacy resume
[   64.225053] i8042 aux 00:09: legacy resume
[   64.229461] pnp 00:0a: legacy resume
[   64.233378] platform vesafb.0: resume
[   64.237424] serial8250 serial8250: resume
[   64.241783] scsi host0: legacy resume
[   64.245728] scsi host1: legacy resume
[   64.249664] scsi host2: legacy resume
[   64.253556] scsi host3: legacy resume
[   64.257512] scsi host4: legacy resume
[   64.261444] i8042 i8042: resume
[   64.267243] atkbd serio0: legacy resume
[   64.271395] psmouse serio1: legacy resume
[   64.275703] platform hdaps: resume
[   64.277631] ata4.00: ACPI cmd ef/03:42:00:00:00:a0 filtered out
[   64.277634] ata4.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
[   64.278635] ata4.00: ACPI cmd e3/00:10:00:00:00:a0 succeeded
[   64.279447] ata4.00: ACPI cmd e3/00:03:00:00:00:a0 succeeded
[   64.297087] ata4.00: configured for UDMA/33
[   64.308163] scsi target0:0:0: legacy resume
[   64.312623] sd 0:0:0:0: legacy resume
[   64.316561] sd 0:0:0:0: [sda] Starting disk
[   64.444275] ata3: SATA link down (SStatus 0 SControl 300)
[   64.450071] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   64.459259] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[   64.465282] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[   64.471746] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[   64.477800] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[   64.489003] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[   64.495043] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[   64.501577] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[   64.507638] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[   64.515654] ata1.00: configured for UDMA/100
[   64.526502] ata1.00: configured for UDMA/100
[   64.531147] ata1: EH complete
[   64.543961] scsi target3:0:0: legacy resume
[   64.548405] sr 3:0:0:0: legacy resume
[   64.552285] usb usb1: type resume
[   64.558091] mmc0: new high speed SDHC card at address b368
[   64.564027] PM: Adding info for mmc:mmc0:b368
[   64.568686] mmc mmc0:b368: parent mmc0 should not be sleeping
[   64.575244] mmcblk0: mmc0:b368 NCard 7.46 GiB
[   64.580122] PM: Adding info for No Bus:mmcblk0
[   64.585021]  mmcblk0: p1
[   64.591007] PM: Adding info for No Bus:mmcblk0p1
[   64.596195] PM: Adding info for No Bus:179:0
[   64.800253] usb usb2: type resume
[   64.830257] usb usb3: type resume
[   65.076788] usb usb4: type resume
[   65.080303] usb usb5: type resume
[   65.083810] usb usb6: type resume
[   65.087298] usb usb7: type resume
[   65.090776] usb 1-4: type resume
[   65.138368] usb 3-2: type resume
[   65.246805] usb 3-2: reset full speed USB device using uhci_hcd and address 3
[   65.397913] usb 1-4.4: type resume
[   65.444675] iTCO_wdt iTCO_wdt: resume
[   65.448555] platform regulatory.0: resume
[   65.452685] leds mmc0::: legacy class resume
[   65.457137] thinkpad_acpi thinkpad_acpi: resume
[   65.465463] thinkpad_acpi: ACPI backlight control delay disabled
[   65.473502] thinkpad_hwmon thinkpad_hwmon: resume
[   65.478394] psmouse serio2: legacy resume
[   65.482634] rfkill rfkill1: legacy class resume
[   65.487403] leds tpacpi::thinklight: legacy class resume
[   65.493012] leds tpacpi::power: legacy class resume
[   65.498238] leds tpacpi::standby: legacy class resume
[   65.503574] leds tpacpi::thinkvantage: legacy class resume
[   65.509399] ieee80211 phy0: legacy class resume
[   65.609020] PM: Adding info for No Bus:iwl-phy0::radio
[   65.614309] Registered led device: iwl-phy0::radio
[   65.619333] PM: Adding info for No Bus:iwl-phy0::assoc
[   65.624596] Registered led device: iwl-phy0::assoc
[   65.629520] PM: Adding info for No Bus:iwl-phy0::RX
[   65.634518] Registered led device: iwl-phy0::RX
[   65.639169] PM: Adding info for No Bus:iwl-phy0::TX
[   65.644171] Registered led device: iwl-phy0::TX
[   65.664304] rfkill rfkill2: legacy class resume
[   65.669073] drm card0: legacy class resume
[   65.673261] pci 0000:00:02.0: setting latency timer to 64
[   65.680336] backlight acpi_video0: legacy class resume
[   65.685703] thinkpad_hwmon thinkpad_hwmon: completing resume
[   65.691441] thinkpad_acpi thinkpad_acpi: completing resume
[   65.697018] platform regulatory.0: completing resume
[   65.702091] iTCO_wdt iTCO_wdt: completing resume
[   65.706813] usb 1-4.4: completing type resume
[   65.711272] usb 3-2: completing type resume
[   65.715548] usb 1-4: completing type resume
[   65.720097] usb usb7: completing type resume
[   65.724458] usb usb6: completing type resume
[   65.728811] usb usb5: completing type resume
[   65.733168] usb usb4: completing type resume
[   65.737528] usb usb3: completing type resume
[   65.742565] usb usb2: completing type resume
[   65.746929] usb usb1: completing type resume
[   65.751327] platform hdaps: completing resume
[   65.755767] i8042 i8042: completing resume
[   65.760045] serial8250 serial8250: completing resume
[   65.765248] platform vesafb.0: completing resume
[   65.770029] pci 0000:15:00.5: completing resume
[   65.774634] pci 0000:15:00.4: completing resume
[   65.779239] pci 0000:15:00.3: completing resume
[   65.783848] sdhci-pci 0000:15:00.2: completing resume
[   65.788977] pci 0000:15:00.0: completing resume
[   65.793592] iwl3945 0000:03:00.0: completing resume
[   65.798548] i801_smbus 0000:00:1f.3: completing resume
[   65.803762] ahci 0000:00:1f.2: completing resume
[   65.808456] ata_piix 0000:00:1f.1: completing resume
[   65.813498] pci 0000:00:1f.0: completing resume
[   65.818106] pci 0000:00:1e.0: completing resume
[   65.822715] ehci_hcd 0000:00:1d.7: completing resume
[   65.827755] uhci_hcd 0000:00:1d.2: completing resume
[   65.832800] uhci_hcd 0000:00:1d.1: completing resume
[   65.837839] uhci_hcd 0000:00:1d.0: completing resume
[   65.842881] pcieport-driver 0000:00:1c.4: completing resume
[   65.848544] pcieport-driver 0000:00:1c.3: completing resume
[   65.854186] pcieport-driver 0000:00:1c.2: completing resume
[   65.859834] pcieport-driver 0000:00:1c.1: completing resume
[   65.865484] pcieport-driver 0000:00:1c.0: completing resume
[   65.871131] HDA Intel 0000:00:1b.0: completing resume
[   65.876258] ehci_hcd 0000:00:1a.7: completing resume
[   65.881300] uhci_hcd 0000:00:1a.1: completing resume
[   65.886349] uhci_hcd 0000:00:1a.0: completing resume
[   65.891389] e1000e 0000:00:19.0: completing resume
[   65.896258] pci 0000:00:02.1: completing resume
[   65.900865] pci 0000:00:02.0: completing resume
[   65.905473] agpgart-intel 0000:00:00.0: completing resume
[   65.910954] platform dock.2: completing resume
[   65.915469] platform dock.1: completing resume
[   65.919990] platform dock.0: completing resume
[   65.924729] PM: Finishing wakeup.
[   65.928718] Restarting tasks ... done.
[   65.987300] PM: Removing info for No Bus:iwl-phy0::assoc
[   65.992930] PM: Removing info for No Bus:iwl-phy0::RX
[   65.999983] PM: Removing info for No Bus:iwl-phy0::TX
[   66.005410] PM: Removing info for No Bus:iwl-phy0::radio
[   66.096621] PM: Removing info for No Bus:vcs63
[   66.096844] PM: Removing info for No Bus:vcsa63
[   66.792522] e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
[   66.851174] e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
[   66.857259] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   66.947981] PM: Adding info for No Bus:iwl-phy0::radio
[   66.954868] Registered led device: iwl-phy0::radio
[   66.959913] PM: Adding info for No Bus:iwl-phy0::assoc
[   66.965984] Registered led device: iwl-phy0::assoc
[   66.971499] PM: Adding info for No Bus:iwl-phy0::RX
[   66.977686] Registered led device: iwl-phy0::RX
[   66.982552] PM: Adding info for No Bus:iwl-phy0::TX
[   66.988401] Registered led device: iwl-phy0::TX
[   67.011146] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   67.323525] usb 3-1: new full speed USB device using uhci_hcd and address 4
[   67.491109] usb 3-1: New USB device found, idVendor=0a5c, idProduct=2110
[   67.498019] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   67.505308] usb 3-1: Product: BCM2045B
[   67.509242] usb 3-1: Manufacturer: Broadcom Corp
[   67.514086] PM: Adding info for usb:3-1
[   67.518809] usb 3-1: configuration #1 chosen from 1 choice
[   67.527931] PM: Adding info for usb:3-1:1.0
[   67.533086] PM: Adding info for No Bus:hci0
[   67.537789] PM: Adding info for No Bus:rfkill3
[   67.543933] PM: Adding info for No Bus:ep_81
[   67.549100] PM: Adding info for No Bus:ep_82
[   67.553654] PM: Adding info for No Bus:ep_02
[   67.558370] PM: Adding info for usb:3-1:1.1
[   67.562897] PM: Adding info for No Bus:ep_83
[   67.567480] PM: Adding info for No Bus:ep_03
[   67.572063] PM: Adding info for usb:3-1:1.2
[   67.577056] PM: Adding info for No Bus:ep_84
[   67.581743] PM: Adding info for No Bus:ep_04
[   67.586311] PM: Adding info for usb:3-1:1.3
[   67.591036] PM: Adding info for No Bus:usbdev3.4
[   67.596201] PM: Adding info for No Bus:ep_00
[   69.671721] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow
Control: None
[   69.680512] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   79.773396] eth0: no IPv6 routers present
[   83.231905] SysRq : Emergency Sync
[   83.241326] Emergency Sync complete
[   84.347695] usb 3-1: USB disconnect, address 4
[   84.347898] btusb_bulk_complete: hci0 urb ffff88013967e108 failed
to resubmit (19)
[   84.348907] btusb_intr_complete: hci0 urb ffff88013967e210 failed
to resubmit (19)
[   84.348926] btusb_bulk_complete: hci0 urb ffff88013967e738 failed
to resubmit (19)
[   84.375644] PM: Removing info for No Bus:ep_81
[   84.380319] PM: Removing info for No Bus:ep_82
[   84.384974] PM: Removing info for No Bus:ep_02
[   84.389640] PM: Removing info for usb:3-1:1.0
[   84.394381] btusb_send_frame: hci0 urb ffff8801330df948 submission failed
[   84.438357] PM: Adding info for No Bus:vcs63
[   84.438450] PM: Adding info for No Bus:vcsa63
[   84.476874] PM: Syncing filesystems ... done.
[   84.488352] PM: Preparing system for mem sleep
[   84.492989] Freezing user space processes ...
[   84.644220] PM: Removing info for No Bus:rfkill3
[   84.649374] PM: Removing info for No Bus:hci0
[   84.654137] PM: Removing info for No Bus:ep_83
[   84.658730] PM: Removing info for No Bus:ep_03
[   84.663320] PM: Removing info for usb:3-1:1.1
[   84.667941] PM: Removing info for No Bus:ep_84
[   84.672513] PM: Removing info for No Bus:ep_04
[   84.677093] PM: Removing info for usb:3-1:1.2
[   84.681698] PM: Removing info for usb:3-1:1.3
[   84.683383] (elapsed 0.18 seconds) done.
[   84.683385] Freezing remaining freezable tasks ...
[   84.695052] PM: Removing info for No Bus:ep_00
[   84.699924] PM: Removing info for usb:3-1
[   84.704376] PM: Removing info for No Bus:usbdev3.4
[   84.827551] (elapsed 0.14 seconds) done.
[   84.831701] PM: Entering mem sleep
[   84.835394] platform dock.0: preparing suspend
[   84.839911] platform dock.1: preparing suspend
[   84.844424] platform dock.2: preparing suspend
[   84.848941] agpgart-intel 0000:00:00.0: preparing suspend
[   84.854427] pci 0000:00:02.0: preparing suspend
[   84.859025] pci 0000:00:02.1: preparing suspend
[   84.863637] e1000e 0000:00:19.0: preparing suspend, may wakeup
[   84.869544] uhci_hcd 0000:00:1a.0: preparing suspend
[   84.874637] uhci_hcd 0000:00:1a.1: preparing suspend
[   84.879679] ehci_hcd 0000:00:1a.7: preparing suspend
[   84.884718] HDA Intel 0000:00:1b.0: preparing suspend
[   84.889844] pcieport-driver 0000:00:1c.0: preparing suspend
[   84.895494] pcieport-driver 0000:00:1c.1: preparing suspend
[   84.901139] pcieport-driver 0000:00:1c.2: preparing suspend
[   84.906788] pcieport-driver 0000:00:1c.3: preparing suspend
[   84.912436] pcieport-driver 0000:00:1c.4: preparing suspend
[   84.918083] uhci_hcd 0000:00:1d.0: preparing suspend
[   84.923123] uhci_hcd 0000:00:1d.1: preparing suspend
[   84.928165] uhci_hcd 0000:00:1d.2: preparing suspend
[   84.933227] ehci_hcd 0000:00:1d.7: preparing suspend
[   84.938267] pci 0000:00:1e.0: preparing suspend
[   84.942872] pci 0000:00:1f.0: preparing suspend
[   84.947482] ata_piix 0000:00:1f.1: preparing suspend
[   84.952523] ahci 0000:00:1f.2: preparing suspend
[   84.957218] i801_smbus 0000:00:1f.3: preparing suspend
[   84.962435] iwl3945 0000:03:00.0: preparing suspend
[   84.967403] pci 0000:15:00.0: preparing suspend
[   84.972012] sdhci-pci 0000:15:00.2: preparing suspend
[   84.977236] pci 0000:15:00.3: preparing suspend
[   84.981844] pci 0000:15:00.4: preparing suspend
[   84.986452] pci 0000:15:00.5: preparing suspend
[   84.991148] platform vesafb.0: preparing suspend
[   84.996001] serial8250 serial8250: preparing suspend
[   85.001156] i8042 i8042: preparing suspend
[   85.005333] platform hdaps: preparing suspend
[   85.009821] usb usb1: preparing type suspend, may wakeup
[   85.015221] usb usb2: preparing type suspend, may wakeup
[   85.020615] usb usb3: preparing type suspend, may wakeup
[   85.026012] usb usb4: preparing type suspend, may wakeup
[   85.031429] usb usb5: preparing type suspend, may wakeup
[   85.036823] usb usb6: preparing type suspend, may wakeup
[   85.042219] usb usb7: preparing type suspend, may wakeup
[   85.047615] usb 1-4: preparing type suspend, may wakeup
[   85.052923] usb 3-2: preparing type suspend, may wakeup
[   85.058237] usb 1-4.4: preparing type suspend, may wakeup
[   85.063738] iTCO_wdt iTCO_wdt: preparing suspend
[   85.068470] platform regulatory.0: preparing suspend
[   85.073531] thinkpad_acpi thinkpad_acpi: preparing suspend
[   85.079148] thinkpad_hwmon thinkpad_hwmon: preparing suspend
[   85.085020] leds iwl-phy0::TX: legacy class suspend
[   85.089977] leds iwl-phy0::RX: legacy class suspend
[   85.094930] leds iwl-phy0::assoc: legacy class suspend
[   85.100143] leds iwl-phy0::radio: legacy class suspend
[   85.105365] mmcblk mmc0:b368: legacy suspend
[   85.109758] backlight acpi_video0: legacy class suspend
[   85.115057] drm card0: legacy class suspend
[   85.130315] pci 0000:00:02.0: power state changed by ACPI to D3
[   85.136392] rfkill rfkill2: legacy class suspend
[   85.141127] ieee80211 phy0: legacy class suspend
[   85.161178] PM: Removing info for No Bus:iwl-phy0::assoc
[   85.166773] PM: Removing info for No Bus:iwl-phy0::RX
[   85.172064] PM: Removing info for No Bus:iwl-phy0::TX
[   85.177356] PM: Removing info for No Bus:iwl-phy0::radio
[   85.186994] leds tpacpi::thinkvantage: legacy class suspend
[   85.192695] leds tpacpi::standby: legacy class suspend
[   85.197956] leds tpacpi::power: legacy class suspend
[   85.203047] leds tpacpi::thinklight: legacy class suspend
[   85.208565] rfkill rfkill1: legacy class suspend
[   85.213299] psmouse serio2: legacy suspend
[   85.434146] thinkpad_hwmon thinkpad_hwmon: suspend
[   85.439058] thinkpad_acpi thinkpad_acpi: suspend
[   85.444644] leds mmc0::: legacy class suspend
[   85.449124] platform regulatory.0: suspend
[   85.453395] iTCO_wdt iTCO_wdt: suspend
[   85.457279] usb 1-4.4: type suspend, may wakeup
[   85.473449] usb 3-2: type suspend, may wakeup
[   85.493439] usb 1-4: type suspend, may wakeup
[   85.510106] usb usb7: type suspend, may wakeup
[   85.514674] usb usb6: type suspend, may wakeup
[   85.519248] usb usb5: type suspend, may wakeup
[   85.523822] usb usb4: type suspend, may wakeup
[   85.528392] usb usb3: type suspend, may wakeup
[   85.532990] usb usb2: type suspend, may wakeup
[   85.537556] usb usb1: type suspend, may wakeup
[   85.542183] sr 3:0:0:0: legacy suspend
[   85.546057] scsi target3:0:0: legacy suspend
[   85.550452] sd 0:0:0:0: legacy suspend
[   85.554317] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   85.559971] sd 0:0:0:0: [sda] Stopping disk
[   87.603694] scsi target0:0:0: legacy suspend
[   87.608106] platform hdaps: suspend
[   87.611717] psmouse serio1: legacy suspend
[   88.018767] atkbd serio0: legacy suspend
[   88.626739] i8042 i8042: suspend
[   88.630210] scsi host4: legacy suspend
[   88.634078] scsi host3: legacy suspend
[   88.637950] scsi host2: legacy suspend
[   88.641820] scsi host1: legacy suspend
[   88.645691] scsi host0: legacy suspend
[   88.649635] serial8250 serial8250: suspend
[   88.654002] platform vesafb.0: suspend
[   88.657919] pnp 00:0a: legacy suspend
[   88.661696] i8042 aux 00:09: legacy suspend
[   88.666024] i8042 kbd 00:08: legacy suspend
[   88.670342] rtc_cmos 00:07: legacy suspend, may wakeup
[   88.675624] pnp 00:06: legacy suspend
[   88.679408] pnp 00:05: legacy suspend
[   88.683190] pnp 00:04: legacy suspend
[   88.686968] pnp 00:03: legacy suspend
[   88.690744] system 00:02: legacy suspend
[   88.694801] pnp 00:01: legacy suspend
[   88.698585] system 00:00: legacy suspend
[   88.702650] pci 0000:15:00.5: suspend
[   88.706431] pci 0000:15:00.4: suspend
[   88.710216] pci 0000:15:00.3: suspend
[   88.713993] sdhci-pci 0000:15:00.2: suspend
[   88.718337] mmc0: card b368 removed
[   88.721944] PM: Removing info for mmc:mmc0:b368
