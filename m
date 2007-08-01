Return-Path: <linux-kernel-owner+w=401wt.eu-S1757366AbXHAE6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366AbXHAE6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 00:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752236AbXHAE6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 00:58:18 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60710 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751690AbXHAE6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 00:58:16 -0400
Date: Tue, 31 Jul 2007 21:56:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       bcm43xx-dev@lists.berlios.de, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, Gary Zambrano <zambrano@broadcom.com>,
       John Linville <linville@tuxdriver.com>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH FINAL] Merge the Sonics Silicon Backplane subsystem
Message-Id: <20070731215650.84c7a26b.akpm@linux-foundation.org>
In-Reply-To: <200707291324.58691.mb@bu3sch.de>
References: <200707291324.58691.mb@bu3sch.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jul 2007 13:24:54 +0200 Michael Buesch <mb@bu3sch.de> wrote:

> The Sonics Silicon Backplane is a mini-bus used on
> various Broadcom chips and embedded devices.

A few probs with mips allmodconfig:

drivers/ssb/driver_mipscore.c:121: warning: "struct ssb_serial_ports" declared inside parameter list
drivers/ssb/driver_mipscore.c:121: warning: its scope is only this definition or declaration, which is probably not what you want
drivers/ssb/driver_mipscore.c: In function `ssb_mips_serial_init':
drivers/ssb/driver_mipscore.c:166: warning: passing arg 1 of `ssb_extif_serial_init' from incompatible pointer type
drivers/ssb/driver_mipscore.c:166: warning: passing arg 2 of `ssb_extif_serial_init' from incompatible pointer type
drivers/ssb/driver_mipscore.c: At top level:
drivers/ssb/driver_mipscore.c:188: warning: 'ssb_cpu_clock' defined but not used
drivers/ssb/driver_pcicore.c: In function `ssb_fixup_pcibridge':
drivers/ssb/driver_pcicore.c:98: error: implicit declaration of function `pcibios_enable_device'
drivers/ssb/driver_pcicore.c: At top level:
drivers/ssb/driver_pcicore.c:278: warning: integer overflow in expression
drivers/ssb/driver_pcicore.c:278: warning: integer overflow in expression       

the latter is due to .end in

static struct resource ssb_pcicore_mem_resource = {
        .name   = "SSB PCIcore external memory",
        .start  = SSB_PCI_DMA,
        .end    = SSB_PCI_DMA + SSB_PCI_DMA_SZ - 1,
        .flags  = IORESOURCE_MEM,
};

It could be more Kconfig select borkage, of course..
