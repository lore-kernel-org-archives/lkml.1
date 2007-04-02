Return-Path: <linux-kernel-owner+w=401wt.eu-S933826AbXDBGE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933826AbXDBGE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 02:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933641AbXDBGEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 02:04:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33218 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933753AbXDBGEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 02:04:15 -0400
Date: Mon, 2 Apr 2007 08:04:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] enhance initcall_debug, measure latency
Message-ID: <20070402060408.GA6505@elte.hu>
References: <20070401181614.GA25648@elte.hu> <20070401182801.GA25956@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070401182801.GA25956@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> some boot time analysis using this facility:

using a non-allyesconfig kernel gives the results below. The entries 
that seem to take a bit too long (considering what they do):

initcall 0xc069bac5 ran for 519 msecs: init_nic+0x0/0x2c()
initcall 0xc0699610 ran for 344 msecs: isapnp_init+0x0/0x435()
initcall 0xc069af66 ran for 245 msecs: serial8250_init+0x0/0x112()
initcall 0xc06981e8 ran for 183 msecs: acpi_pci_link_init+0x0/0x43()
initcall 0xc06a07b0 ran for 175 msecs: pci_acpi_init+0x0/0x9b()
initcall 0xc06980ef ran for 110 msecs: acpi_pci_root_init+0x0/0x25()
initcall 0xc069fa24 ran for 69 msecs: pcibios_assign_resources+0x0/0x92()
initcall 0xc0246fd6 ran for 64 msecs: pci_init+0x0/0x2c()
initcall 0xc0695fc2 ran for 62 msecs: pcie_portdrv_init+0x0/0x46()
initcall 0xc0698656 ran for 54 msecs: pnp_system_init+0x0/0xf()
initcall 0xc06a27ac ran for 43 msecs: inet_init+0x0/0x390()
initcall 0xc069f88e ran for 28 msecs: init_acpi_pm_clocksource+0x0/0x173()

these amount to almost 50% of the ~4 seconds total bootup initcall time!

	Ingo

initcall 0xc069c43b ran for 1147 msecs: ide_init+0x0/0x8a()
initcall 0xc069bac5 ran for 519 msecs: init_nic+0x0/0x2c()
initcall 0xc069cbe0 ran for 497 msecs: ide_generic_init+0x0/0x11()
initcall 0xc0699610 ran for 344 msecs: isapnp_init+0x0/0x435()
initcall 0xc069af66 ran for 245 msecs: serial8250_init+0x0/0x112()
initcall 0xc06981e8 ran for 183 msecs: acpi_pci_link_init+0x0/0x43()
initcall 0xc06a07b0 ran for 175 msecs: pci_acpi_init+0x0/0x9b()
initcall 0xc06980ef ran for 110 msecs: acpi_pci_root_init+0x0/0x25()
initcall 0xc068b878 ran for 97 msecs: check_nmi_watchdog+0x0/0x1d1()
initcall 0xc069cbf1 ran for 75 msecs: idedisk_init+0x0/0xf()
initcall 0xc069fa24 ran for 69 msecs: pcibios_assign_resources+0x0/0x92()
initcall 0xc0246fd6 ran for 64 msecs: pci_init+0x0/0x2c()
initcall 0xc0695fc2 ran for 62 msecs: pcie_portdrv_init+0x0/0x46()
initcall 0xc0698656 ran for 54 msecs: pnp_system_init+0x0/0xf()
initcall 0xc06a27ac ran for 43 msecs: inet_init+0x0/0x390()
initcall 0xc069f88e ran for 28 msecs: init_acpi_pm_clocksource+0x0/0x173()
initcall 0xc069bb07 ran for 23 msecs: rtl8139_init_module+0x0/0x16()
initcall 0xc069eeae ran for 18 msecs: psmouse_init+0x0/0x64()
initcall 0xc0111a26 ran for 18 msecs: powernowk8_init+0x0/0x78()
initcall 0xc069e932 ran for 17 msecs: i8042_init+0x0/0x321()
initcall 0xc069baf1 ran for 16 msecs: cp_init+0x0/0x16()
initcall 0xc06979b8 ran for 16 msecs: acpi_init+0x0/0x1ff()
initcall 0xc0697bfc ran for 15 msecs: acpi_scan_init+0x0/0xfc()
initcall 0xc06a3154 ran for 12 msecs: netlbl_init+0x0/0x71()
initcall 0xc069e512 ran for 11 msecs: usb_init+0x0/0x103()
initcall 0xc06986cd ran for 11 msecs: pnpacpi_init+0x0/0x69()

