Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197AbYGZPjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbYGZPjX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 11:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbYGZPjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 11:39:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41296 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279AbYGZPjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 11:39:10 -0400
Date: Sat, 26 Jul 2008 17:38:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] x86: usb debug port early console v4
Message-ID: <20080726153850.GA15794@elte.hu>
References: <200807231252.20371.yhlu.kernel@gmail.com> <200807231400.53957.yhlu.kernel@gmail.com> <200807231739.39620.yhlu.kernel@gmail.com> <200807241729.41132.yhlu.kernel@gmail.com> <20080726134828.GF4401@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080726134828.GF4401@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.3
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > based on work from Eric, and add some timeout so don't dead loop when 
> > debug device is not installed
> > 
> > v2: fix checkpatch warning
> > v3: move ehci struct def to linux/usrb/ehci_def.h from host/ehci.h
> >     also add CONFIG_EARLY_PRINTK_DBGP to disable it by default
> > v4: address comments from Ingo, seperate ehci reg def moving to another patch
> >     also add auto detect port that connect to debug device for Nvidia southbridge
> > 
> > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> applied to tip/x86/early-printk - thanks Yinghai.

small build fix below.

	Ingo

------------>
>From 9749986a878e91182ff027ff0010ab8e3211031a Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 26 Jul 2008 17:28:11 +0200
Subject: [PATCH] x86: usb debug port early console, fix

fix:

 arch/x86/kernel/built-in.o: In function `nvidia_set_debug_port':
 early_printk.c:(.text+0xf8b1): undefined reference to `read_pci_config'
 early_printk.c:(.text+0xf8dc): undefined reference to `write_pci_config'
 arch/x86/kernel/built-in.o: In function `setup_early_printk':
 early_printk.c:(.init.text+0x5487): undefined reference to `early_pci_allowed'
 early_printk.c:(.init.text+0x54cb): undefined reference to `read_pci_config'
 early_printk.c:(.init.text+0x54ec): undefined reference to `read_pci_config_16'
 [...]

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig.debug |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 93422d2..2a3dfbd 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -46,7 +46,7 @@ config EARLY_PRINTK
 config EARLY_PRINTK_DBGP
 	bool "Early printk via EHCI debug port"
 	default n
-	depends on EARLY_PRINTK
+	depends on EARLY_PRINTK && PCI
 	help
 	  Write kernel log output directly into the EHCI debug port.
 
