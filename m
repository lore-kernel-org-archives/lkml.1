Return-Path: <linux-kernel-owner+w=401wt.eu-S934433AbXGTTLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934433AbXGTTLl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 15:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758441AbXGTTLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 15:11:32 -0400
Received: from echo.digadd.de ([195.47.195.234]:43052 "EHLO mx2.digadd.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756182AbXGTTLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 15:11:30 -0400
Message-ID: <46A108D3.9030404@digadd.de>
Date: Fri, 20 Jul 2007 22:11:15 +0300
From: "Christian P. Schmidt" <charlie@digadd.de>
User-Agent: Thunderbird 2.0.0.4 (X11/20070716)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Problem after suspend to ram: NMI received for unknown reason b0.
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm almost happy with my new laptop - I got like 90% of the things
working the way I wanted, except the all-time dreaded suspend.

Suspend to disk, using the suspend2 patchset, fails because the
fingerprint reader on the USB bus apparently does not suspend. Well,
I'll go into that later on when I'm finished with the other problems
(like e1000 autonegotiation and the ATI driver messing up my xterms (and
only them).

The bigger problem is the embedded Atheros AR5418 and suspend to ram.

After the resume (between immediately and some time later) I see the
card suddenly stops working, and I see this in the log:

[ 1979.234594] Uhhuh. NMI received for unknown reason b0.
[ 1979.234604] You have some hardware problem, likely on the PCI bus.
[ 1979.234608] Dazed and confused, but trying to continue
[ 1980.211872] wifi0: rx FIFO overrun; resetting
[ 1981.258461] wifi0: rx FIFO overrun; resetting

And then this message continues once per second. Unloading the driver
before suspending seems to delay the NMI for some time, but not finally
preventing it. The card is remains in this somehow unusable state until
reboot, even if removing and reinserting the driver:

[ 2714.974822] ACPI: PCI interrupt for device 0000:03:00.0 disabled
[ 2714.975151] ath_pci: driver unloaded
[ 2716.572893] ath_pci: 0.9.4.5 ()
[ 2716.573574] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level,
low) -> IRQ 17
[ 2716.573726] PCI: Setting latency timer of device 0000:03:00.0 to 64
[ 2716.706774] ath_pci: switching rfkill capability off
[ 2716.706859] ath_pci: ath_pci: switching per-packet transmit power
control off
[ 2716.707332] wifi0: 11a rates: 6Mbps 9Mbps 12Mbps 18Mbps 24Mbps 36Mbps
48Mbps 54Mbps
[ 2716.707472] wifi0: 11b rates: 1Mbps 2Mbps 5.5Mbps 11Mbps
[ 2716.707565] wifi0: 11g rates: 1Mbps 2Mbps 5.5Mbps 11Mbps 6Mbps 9Mbps
12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
[ 2716.707734] wifi0: turboA rates: 6Mbps 9Mbps 12Mbps 18Mbps 24Mbps
36Mbps 48Mbps 54Mbps
[ 2716.707865] wifi0: turboG rates: 6Mbps 9Mbps 12Mbps 18Mbps 24Mbps
36Mbps 48Mbps 54Mbps
[ 2716.707995] wifi0: H/W encryption support: WEP AES AES_CCM TKIP
[ 2716.708087] wifi0: mac 12.10 phy 8.1 radio 12.0
[ 2716.708153] wifi0: Use hw queue 1 for WME_AC_BE traffic
[ 2716.708202] wifi0: Use hw queue 0 for WME_AC_BK traffic
[ 2716.708252] wifi0: Use hw queue 2 for WME_AC_VI traffic
[ 2716.708302] wifi0: Use hw queue 3 for WME_AC_VO traffic
[ 2716.708352] wifi0: Use hw queue 8 for CAB traffic
[ 2716.708399] wifi0: Use hw queue 9 for beacons
[ 2716.708754] wifi0: Atheros 5418: mem=0xedf00000, irq=17
[ 2722.595511] ath0: no IPv6 routers present
[ 2729.942696] wifi0: rx FIFO overrun; resetting

Judging from /proc/interrupts, no interrupts 17 are generated any more
(the one among others for the Atheros card). The audio subsystem that
shares the irq line works fine though, and generates interrupts.
A second Atheros card plugged via PCCard interface works perfectly
during this time.

Also, I'm not alone with this problem: See
http://ubuntuforums.org/showthread.php?p=3029533 for exactly this problem.

Some additional data:
full dmesg @ http://digadd.de/dmesg.txt
lspci -vv  @ http://digadd.de/lspci.txt
lshw       @ http://digadd.de/lshw.txt
.config    @ http://digadd.de/config.txt

Thanks for reading until here!
Christian
