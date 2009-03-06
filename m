Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbZCFT3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbZCFT3b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 14:29:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755397AbZCFT3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 14:29:17 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:50199 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776AbZCFT3Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 14:29:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ADuo4i2/o84FmD2lVdsfGHqT7fcUgcSahsEhn/dwyesNyoMGYNbM7JBRfN4OGlKJfu
         0wt/Y0/gLK++/6OwlMgaRc2CBZl17LoU0AWyPK3Qn+XhV68u0rYtOLWV7BeEsfoTUs9h
         mkOgv26KRjtUbnXwp9mZLL8X543MQKEx/PUBI=
MIME-Version: 1.0
In-Reply-To: <9e246b4d0903061127q7c82103dq88c5184765f3c17a@mail.gmail.com>
References: <9e246b4d0903061127q7c82103dq88c5184765f3c17a@mail.gmail.com>
Date: Fri, 6 Mar 2009 14:29:13 -0500
Message-ID: <9e246b4d0903061129g7b66dc3bm8013b75be671ca33@mail.gmail.com>
Subject: r8169 MAC problem
From: Tim Durack <tdurack@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Francois Romieu <romieu@fr.zoreil.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like the r8169 MAC bug is still lurking:

CFG-1:~# uname -a
Linux CFG-1 2.6.29-rc7-686 #1 SMP Fri Mar 6 01:07:38 UTC 2009 i686 GNU/Linux

CFG-1:~# modprobe -r r8169
[  198.684076] r8169 0000:00:0c.0: PCI INT A disabled
[  198.944075] r8169 0000:00:0b.0: PCI INT A disabled
[  199.204080] r8169 0000:00:09.0: PCI INT A disabled

CFG-1:~# modprobe -i r8169
[  202.183521] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[  202.189230] r8169 0000:00:09.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  202.197440] r8169 0000:00:09.0: no PCI Express capability
[  202.203116] r8169 0000:00:09.0: MAC address found in EEPROM:
00:30:18:ab:f0:34
[  202.212721] eth0: RTL8169sc/8110sc at 0xf90b0000,
00:00:00:00:f0:34, XID 18000000 IRQ 18
[  202.221555] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[  202.227202] r8169 0000:00:0b.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[  202.234202] r8169 0000:00:0b.0: no PCI Express capability
[  202.239859] r8169 0000:00:0b.0: MAC address found in EEPROM:
00:30:18:ab:f0:35
[  202.249413] eth1: RTL8169sc/8110sc at 0xf8012000,
00:00:00:00:f0:35, XID 18000000 IRQ 19
[  202.258267] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[  202.263911] r8169 0000:00:0c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  202.270890] r8169 0000:00:0c.0: no PCI Express capability
[  202.276551] r8169 0000:00:0c.0: MAC address found in EEPROM:
00:30:18:ab:f0:36
[  202.286256] eth2: RTL8169sc/8110sc at 0xf8016000,
00:30:18:ab:f0:36, XID 18000000 IRQ 16

This obviously doesn't work very well. Full power-cycle back into
2.6.26 fixes the problem:

CFG-1:~# uname -a
Linux CFG-1 2.6.26-1-686 #1 SMP Sun Feb 8 02:27:05 UTC 2009 i686 GNU/Linux

CFG-1:~# modprobe -r r8169
[   83.220122] ACPI: PCI interrupt for device 0000:00:0c.0 disabled
[   83.252673] ACPI: PCI interrupt for device 0000:00:0b.0 disabled
[   83.285249] ACPI: PCI interrupt for device 0000:00:09.0 disabled

CFG-1:~# modprobe -i r8169
[   87.454505] r8169 Gigabit Ethernet driver 2.2LK-NAPI loaded
[   87.461284] ACPI: PCI Interrupt 0000:00:09.0[A] ->  a future
releasGSI 18 (level, low) -> IRQ 18
[   87.476007] eth0: RTL8169sc/8110sc at 0xf8832000,
00:30:18:ab:f0:34, XID 18000000 IRQ 18
[   87.484682] r8169 Gigabit Ethernet driver 2.2LK-NAPI loaded
[   87.489660] ACPI: PCI Interrupt 0000:00:0b.0[A] -> GSI 19 (level,
low) -> IRQ 19
[   87.500006] eth1: RTL8169sc/8110sc at 0xf8834000,
00:30:18:ab:f0:35, XID 18000000 IRQ 19
[   87.508675] r8169 Gigabit Ethernet driver 2.2LK-NAPI loaded
[   87.513633] ACPI: PCI Interrupt 0000:00:0c.0[A] -> GSI 16 (level,
low) -> IRQ 16
[   87.524006] eth2: RTL8169sc/8110sc at 0xf8f88000,
00:30:18:ab:f0:36, XID 18000000 IRQ 16

Based on googling around, I'm going to guess this might be related:

Ivan Vecera (1): r8169: read MAC address from EEPROM on init (2nd attempt)

Any ideas?

Tim:>
