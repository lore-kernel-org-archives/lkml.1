Return-Path: <linux-kernel-owner+w=401wt.eu-S1758248AbZEZWU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248AbZEZWU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 18:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753417AbZEZWUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 18:20:49 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:38188 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339AbZEZWUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 18:20:48 -0400
Date: Tue, 26 May 2009 23:20:49 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, mingo@elte.hu
Subject: Re: EeePC 900 trackpad often not detected at boot in 2.6.30-rc4
Message-ID: <20090526222049.GB27961@sucs.org>
References: <20090511072135.GA4682@sucs.org> <20090520024658.GD17649@dtor-d630.eng.vmware.com> <20090520054739.GA31552@sucs.org> <200905200025.20280.dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905200025.20280.dmitry.torokhov@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 20, 2009 at 12:25:19AM -0700, Dmitry Torokhov wrote:
>
> On Tuesday 19 May 2009 22:47:39 Sitsofe Wheeler wrote:
>
> > This one could be tough to test unless there is a way of forcing the
> > awkward scheduling...
> 
> Umm.... you could try sticking
> 
> 	if (timeout == 0)
> 		printk(KERN_INFO "libps2: BINGO!\n");
> 
> 
> into the body of "if (psmouse->cmdcnt ...)" statement that was modified
> by the patch I sent and see if it gets activated. If your mouse still
> works with this message in the logs then the patch is working.

I only just saw your reply. After about 50 boots the following occurred:

[    0.000000] Linux version 2.6.30-rc7-00066-ge2a1b9e-dirty (@verona) (gcc version 4.2.4) #145 Tue May 26 22:04:58 BST 2009
<snip>
[    1.092841] ath5k 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.092965] ath5k 0000:01:00.0: setting latency timer to 64
[    1.093153] ath5k 0000:01:00.0: registered as 'phy0'
[    1.167364] phy0: Selected rate control algorithm 'minstrel'
[    1.168857] ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
[    1.169390] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.169983] uhci_hcd: USB Universal Host Controller Interface driver
[    1.171389] Initializing USB Mass Storage driver...
[    1.171849] usbcore: registered new interface driver usb-storage
[    1.171940] USB Mass Storage support registered.
[    1.173127] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    1.174404] drivers/input/serio/i8042.c: 20 -> i8042 (command) [2]
[    1.174416] drivers/input/serio/i8042.c: 65 <- i8042 (return) [2]
[    1.174455] drivers/input/serio/i8042.c: 60 -> i8042 (command) [2]
[    1.175018] drivers/input/serio/i8042.c: 74 -> i8042 (parameter) [2]
[    1.176571] drivers/input/serio/i8042.c: d3 -> i8042 (command) [3]
[    1.176571] drivers/input/serio/i8042.c: 5a -> i8042 (parameter) [3]
[    1.176571] drivers/input/serio/i8042.c: 5a <- i8042 (return) [3]
[    1.180435] drivers/input/serio/i8042.c: a7 -> i8042 (command) [8]
[    1.181107] drivers/input/serio/i8042.c: 20 -> i8042 (command) [8]
[    1.181107] drivers/input/serio/i8042.c: 74 <- i8042 (return) [8]
[    1.182453] drivers/input/serio/i8042.c: a8 -> i8042 (command) [10]
[    1.183442] drivers/input/serio/i8042.c: 20 -> i8042 (command) [10]
[    1.183442] drivers/input/serio/i8042.c: 54 <- i8042 (return) [10]
[    1.186299] drivers/input/serio/i8042.c: 60 -> i8042 (command) [14]
[    1.187219] drivers/input/serio/i8042.c: 56 -> i8042 (parameter) [14]
[    1.189919] drivers/input/serio/i8042.c: d3 -> i8042 (command) [16]
[    1.189919] drivers/input/serio/i8042.c: a5 -> i8042 (parameter) [16]
[    1.195601] drivers/input/serio/i8042.c: 60 -> i8042 (command) [23]
[    1.196221] drivers/input/serio/i8042.c: 74 -> i8042 (parameter) [23]
[    1.199581] drivers/input/serio/i8042.c: d3 -> i8042 (command) [26]
[    1.199581] drivers/input/serio/i8042.c: f0 -> i8042 (parameter) [26]
[    1.199581] drivers/input/serio/i8042.c: f0 <- i8042 (return) [26]
[    1.204184] drivers/input/serio/i8042.c: d3 -> i8042 (command) [31]
[    1.204847] drivers/input/serio/i8042.c: 56 -> i8042 (parameter) [31]
[    1.204847] drivers/input/serio/i8042.c: 56 <- i8042 (return) [31]
[    1.207444] drivers/input/serio/i8042.c: d3 -> i8042 (command) [35]
[    1.208123] drivers/input/serio/i8042.c: a4 -> i8042 (parameter) [35]
[    1.208123] drivers/input/serio/i8042.c: a4 <- i8042 (return) [35]
[    1.209809] drivers/input/serio/i8042.c: Interrupt 12, without any data [37]
[    1.210081] drivers/input/serio/i8042.c: 60 -> i8042 (command) [37]
[    1.210761] drivers/input/serio/i8042.c: 56 -> i8042 (parameter) [37]
[    1.211965] drivers/input/serio/i8042.c: Interrupt 1, without any data [39]
[    1.211980] drivers/input/serio/i8042.c: Interrupt 1, without any data [39]
[    1.212924] drivers/input/serio/i8042.c: 60 -> i8042 (command) [39]
[    1.212924] drivers/input/serio/i8042.c: 47 -> i8042 (parameter) [39]
[    1.214724] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.214888] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.434751] mice: PS/2 mouse device common for all mice
[    1.438433] drivers/input/serio/i8042.c: f2 -> i8042 (kbd-data) [266]
[    1.439112] rtc_cmos 00:03: RTC can wake from S4
[    1.440192] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.440334] rtc0: alarms up to one month, 114 bytes nvram, hpet irqs
[    1.440818] Linux video capture interface: v2.00
[    1.441934] usbcore: registered new interface driver uvcvideo
[    1.442280] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [270]
[    1.442451] USB Video Class driver (v0.1.0)
[    1.443881] drivers/input/serio/i8042.c: ab <- i8042 (interrupt, 0, 1) [271]
[    1.444867] cpuidle: using governor ladder
[    1.445189] drivers/input/serio/i8042.c: 41 <- i8042 (interrupt, 0, 1) [273]
[    1.445282] drivers/input/serio/i8042.c: ed -> i8042 (kbd-data) [273]
[    1.448762] cpuidle: using governor menu
[    1.448938] eeepc: Eee PC Hotkey Driver
[    1.449681] eeepc: Hotkey init flags 0x41
[    1.449889] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [277]
[    1.452490] eeepc: Get control methods supported: 0x101701
[    1.452920] drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [280]
[    1.453306] input: Asus EeePC extra buttons as /devices/virtual/input/input4
[    1.456783] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [284]
[    1.457623] drivers/input/serio/i8042.c: f3 -> i8042 (kbd-data) [285]
[    1.462063] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [290]
[    1.463088] drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [291]
[    1.464925] Advanced Linux Sound Architecture Driver Version 1.0.20.
[    1.466806] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.467208] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [295]
[    1.467294] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    1.467390] drivers/input/serio/i8042.c: f4 -> i8042 (kbd-data) [295]
[    1.473224] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [301]
[    3.121835] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
[    3.122764] drivers/input/serio/i8042.c: d4 -> i8042 (command) [1950]
[    3.123016] drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [1950]
[    3.130982] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [1958]
[    3.132179] hda_codec: Unknown model for ALC662, trying auto-probe from BIOS...
[    3.132300] autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0)
[    3.132378]    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    3.132453]    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[    3.132526]    mono: mono_out=0x0
[    3.132597]    inputs: mic=0x18, fmic=0x19, line=0x0, fline=0x0, cd=0x0, aux=0x0
[    3.134892] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [1962]
[    3.136500] drivers/input/serio/i8042.c: d4 -> i8042 (command) [1964]
[    3.137015] drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [1964]
[    3.140289] ALSA device list:
[    3.140367]   #0: HDA Intel at 0xf7eb8000 irq 16
[    3.140591] TCP cubic registered
[    3.140666] NET: Registered protocol family 17
[    3.140846] Using IPI Shortcut mode
[    3.142878]   Magic number: 9:412:804
[    3.143418] rtc_cmos 00:03: setting system clock to 2009-05-26 21:47:18 UTC (1243374438)
[    3.149589] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [1977]
[    3.151638] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [1979]
[    5.550332] libps2: BINGO!
[    5.550425] drivers/input/serio/i8042.c: d4 -> i8042 (command) [4378]
[    5.551011] drivers/input/serio/i8042.c: f6 -> i8042 (parameter) [4378]
[    5.563688] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [4391]
[    5.563736] drivers/input/serio/i8042.c: d4 -> i8042 (command) [4391]
[    5.564673] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [4391]
[    5.572824] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [4400]
[    5.572863] drivers/input/serio/i8042.c: d4 -> i8042 (command) [4400]
[    5.573811] drivers/input/serio/i8042.c: 0a -> i8042 (parameter) [4400]
[    5.580823] ACPI: Battery Slot [BAT0] (battery present)

Another 50 boots later something similar happened:

[    0.000000] Linux version 2.6.30-rc7-00066-ge2a1b9e-dirty (@verona) (gcc version 4.2.4) #145 Tue May 26 22:04:58 BST 2009
<snip>
[    1.091914] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.092430] uhci_hcd: USB Universal Host Controller Interface driver
[    1.093503] Initializing USB Mass Storage driver...
[    1.093950] usbcore: registered new interface driver usb-storage
[    1.094068] USB Mass Storage support registered.
[    1.095197] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    1.096292] drivers/input/serio/i8042.c: 20 -> i8042 (command) [2]
[    1.096305] drivers/input/serio/i8042.c: 65 <- i8042 (return) [2]
[    1.096341] drivers/input/serio/i8042.c: 60 -> i8042 (command) [2]
[    1.097024] drivers/input/serio/i8042.c: 74 -> i8042 (parameter) [2]
[    1.098094] drivers/input/serio/i8042.c: d3 -> i8042 (command) [3]
[    1.098094] drivers/input/serio/i8042.c: 5a -> i8042 (parameter) [3]
[    1.098094] drivers/input/serio/i8042.c: 5a <- i8042 (return) [3]
[    1.100477] drivers/input/serio/i8042.c: a7 -> i8042 (command) [6]
[    1.101155] drivers/input/serio/i8042.c: 20 -> i8042 (command) [6]
[    1.101155] drivers/input/serio/i8042.c: 74 <- i8042 (return) [6]
[    1.102698] drivers/input/serio/i8042.c: a8 -> i8042 (command) [8]
[    1.103688] drivers/input/serio/i8042.c: 20 -> i8042 (command) [8]
[    1.103688] drivers/input/serio/i8042.c: 54 <- i8042 (return) [8]
[    1.104548] drivers/input/serio/i8042.c: 60 -> i8042 (command) [10]
[    1.105493] drivers/input/serio/i8042.c: 56 -> i8042 (parameter) [10]
[    1.106715] drivers/input/serio/i8042.c: d3 -> i8042 (command) [11]
[    1.106715] drivers/input/serio/i8042.c: a5 -> i8042 (parameter) [11]
[    1.110741] drivers/input/serio/i8042.c: 60 -> i8042 (command) [16]
[    1.111365] drivers/input/serio/i8042.c: 74 -> i8042 (parameter) [16]
[    1.114306] drivers/input/serio/i8042.c: d3 -> i8042 (command) [19]
[    1.114306] drivers/input/serio/i8042.c: f0 -> i8042 (parameter) [19]
[    1.114306] drivers/input/serio/i8042.c: f0 <- i8042 (return) [19]
[    1.118207] drivers/input/serio/i8042.c: d3 -> i8042 (command) [23]
[    1.118860] drivers/input/serio/i8042.c: 56 -> i8042 (parameter) [23]
[    1.118860] drivers/input/serio/i8042.c: 56 <- i8042 (return) [23]
[    1.123462] drivers/input/serio/i8042.c: d3 -> i8042 (command) [29]
[    1.124117] drivers/input/serio/i8042.c: a4 -> i8042 (parameter) [29]
[    1.124117] drivers/input/serio/i8042.c: a4 <- i8042 (return) [29]
[    1.126553] drivers/input/serio/i8042.c: Interrupt 12, without any data [32]
[    1.126826] drivers/input/serio/i8042.c: 60 -> i8042 (command) [32]
[    1.127505] drivers/input/serio/i8042.c: 56 -> i8042 (parameter) [32]
[    1.127932] drivers/input/serio/i8042.c: Interrupt 1, without any data [33]
[    1.127947] drivers/input/serio/i8042.c: Interrupt 1, without any data [33]
[    1.128889] drivers/input/serio/i8042.c: 60 -> i8042 (command) [33]
[    1.128889] drivers/input/serio/i8042.c: 47 -> i8042 (parameter) [33]
[    1.131672] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.131836] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.134201] mice: PS/2 mouse device common for all mice
[    1.138014] drivers/input/serio/i8042.c: f2 -> i8042 (kbd-data) [43]
[    1.138944] rtc_cmos 00:03: RTC can wake from S4
[    1.139897] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.140397] rtc0: alarms up to one month, 114 bytes nvram, hpet irqs
[    1.140887] Linux video capture interface: v2.00
[    1.142002] usbcore: registered new interface driver uvcvideo
[    1.142208] USB Video Class driver (v0.1.0)
[    1.144599] cpuidle: using governor ladder
[    1.147314] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [53]
[    1.148322] drivers/input/serio/i8042.c: ab <- i8042 (interrupt, 0, 1) [54]
[    1.149253] drivers/input/serio/i8042.c: 41 <- i8042 (interrupt, 0, 1) [55]
[    1.363545] drivers/input/serio/i8042.c: ed -> i8042 (kbd-data) [269]
[    1.365939] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [271]
[    1.366109] drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [272]
[    1.366307] cpuidle: using governor menu
[    1.366488] eeepc: Eee PC Hotkey Driver
[    1.367228] eeepc: Hotkey init flags 0x41
[    1.369746] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [275]
[    1.369796] eeepc: Get control methods supported: 0x101701
[    1.370248] drivers/input/serio/i8042.c: f3 -> i8042 (kbd-data) [276]
[    1.370567] input: Asus EeePC extra buttons as /devices/virtual/input/input4
[    1.373344] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [279]
[    1.374439] drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [280]
[    1.376778] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [282]
[    1.379691] drivers/input/serio/i8042.c: f4 -> i8042 (kbd-data) [285]
[    1.381622] Advanced Linux Sound Architecture Driver Version 1.0.20.
[    1.381722] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [287]
[    1.384285] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.384545] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    1.384902] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
[    1.386099] drivers/input/serio/i8042.c: d4 -> i8042 (command) [292]
[    1.386888] drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [292]
[    1.395793] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [301]
[    1.398353] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [304]
[    1.398768] drivers/input/serio/i8042.c: d4 -> i8042 (command) [304]
[    1.399339] drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [304]
[    1.410073] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [316]
[    1.411730] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [317]
[    3.061408] libps2: BINGO!
[    3.061496] drivers/input/serio/i8042.c: d4 -> i8042 (command) [1967]
[    3.062009] drivers/input/serio/i8042.c: f6 -> i8042 (parameter) [1967]
[    3.062413] hda_codec: Unknown model for ALC662, trying auto-probe from BIOS...
[    3.062528] autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0)
[    3.062606]    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    3.062681]    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[    3.062754]    mono: mono_out=0x0
[    3.062825]    inputs: mic=0x18, fmic=0x19, line=0x0, fline=0x0, cd=0x0, aux=0x0
[    3.066863] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [1972]
[    3.067169] drivers/input/serio/i8042.c: d4 -> i8042 (command) [1973]
[    3.068023] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [1973]
[    3.070563] ALSA device list:
[    3.070639]   #0: HDA Intel at 0xf7eb8000 irq 16
[    3.070859] TCP cubic registered
[    3.070936] NET: Registered protocol family 17
[    3.071203] Using IPI Shortcut mode
[    3.073280]   Magic number: 9:244:48
[    3.073469] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [1979]
[    3.073657] rtc_cmos 00:03: setting system clock to 2009-05-26 22:03:01 UTC (1243375381)
[    3.073895] drivers/input/serio/i8042.c: d4 -> i8042 (command) [1979]
[    3.074014] drivers/input/serio/i8042.c: 0a -> i8042 (parameter) [1979]
[    3.081552] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [1987]
[    3.081594] drivers/input/serio/i8042.c: d4 -> i8042 (command) [1987]
[    3.082539] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [1987]
[    3.089762] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [1995]
[    3.089798] drivers/input/serio/i8042.c: d4 -> i8042 (command) [1995]
[    3.090750] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [1995]
[    3.098657] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [2004]
[    3.098700] drivers/input/serio/i8042.c: d4 -> i8042 (command) [2004]
[    3.099644] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [2004]
[    3.107066] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [2013]
[    4.924196] drivers/input/serio/i8042.c: 1f <- i8042 (interrupt, 0, 1) [3830]
[    5.031672] drivers/input/serio/i8042.c: 23 <- i8042 (interrupt, 0, 1) [3937]
[    5.067286] drivers/input/serio/i8042.c: 9f <- i8042 (interrupt, 0, 1) [3973]
[    5.138368] drivers/input/serio/i8042.c: a3 <- i8042 (interrupt, 0, 1) [4044]
[    5.141485] drivers/input/serio/i8042.c: 39 <- i8042 (interrupt, 0, 1) [4047]
[    5.278109] drivers/input/serio/i8042.c: b9 <- i8042 (interrupt, 0, 1) [4184]
[    5.699163] drivers/input/serio/i8042.c: d4 -> i8042 (command) [4605]
[    5.700057] drivers/input/serio/i8042.c: 14 -> i8042 (parameter) [4605]
[    5.708687] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [4614]
[    5.708731] drivers/input/serio/i8042.c: d4 -> i8042 (command) [4614]
[    5.709673] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [4614]
[    5.716938] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [4622]
[    5.716977] drivers/input/serio/i8042.c: d4 -> i8042 (command) [4622]
[    5.717925] drivers/input/serio/i8042.c: 3c -> i8042 (parameter) [4622]
[    5.725244] ACPI: Battery Slot [BAT0] (battery present)

One reason for the delay could be that reading the battery information
causes the system to go out to lunch. If this happens while the ps2
mouse driver is waiting (thanks to fastboot)...


-- 
Sitsofe | http://sucs.org/~sits/
