Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbYCaBkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbYCaBkw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 21:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbYCaBkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 21:40:42 -0400
Received: from mail.gmx.net ([213.165.64.20]:56098 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751666AbYCaBkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 21:40:42 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1/qc6w+IhHqO/0ShAVj9U7wbSbrXLV1m0bY8qj6KM
	vXZTVyxVUcMWCj
Date: Mon, 31 Mar 2008 03:40:37 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Bob Tracy <rct@frus.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.25-rc7: warn_on_slowpath triggered
Message-ID: <20080331014037.GA24702@atjola.homenet>
References: <20080329222955.036CCDBA2@gherkin.frus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080329222955.036CCDBA2@gherkin.frus.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added Ingo and Thomas to Cc:]

On 2008.03.29 17:29:55 -0500, Bob Tracy wrote:
> System is a AMD K6-III/450.  This is actually a 2.6.25-rcX issue
> that I'm just getting around to reporting.  Sorry about that...

Not necessarily a regression, it's just that the WARN_ON_ONCE didn't
exist yet in 2.6.24.

> 
> ------------[ cut here ]------------
> WARNING: at arch/x86/pci/irq.c:263 pirq_via586_get+0x23/0x42()
> Modules linked in: snd_emu10k1(+) snd_rawmidi firmware_class snd_ac97_codec ac97_bus snd_pcm snd_seq_device snd_timer snd_page_alloc snd_util_mem snd_hwdep snd soundcore ipv6 usbmouse usbhid ff_memless uhci_hcd ehci_hcd usbcore binfmt_misc
> Pid: 1784, comm: modprobe Not tainted 2.6.25-rc7 #1
>  [<c0115b43>] warn_on_slowpath+0x40/0x4f
>  [<c012755b>] run_hrtimer_pending+0xac/0xc5
>  [<c011cc32>] run_timer_softirq+0x152/0x16b
>  [<c0119b8c>] __do_softirq+0x59/0x85
>  [<c027246b>] pci_conf1_read+0xac/0xc5
>  [<c027334f>] raw_pci_read+0x3f/0x47
>  [<c027246b>] pci_conf1_read+0xac/0xc5
>  [<c027334f>] raw_pci_read+0x3f/0x47
>  [<c0273421>] pci_read+0x1c/0x23
>  [<c01f5bce>] pci_bus_read_config_byte+0x37/0x6c
>  [<c01f5be8>] pci_bus_read_config_byte+0x51/0x6c
>  [<c0272cef>] pirq_via586_get+0x23/0x42
>  [<c0272ccc>] pirq_via586_get+0x0/0x42
>  [<c0272fa7>] pcibios_lookup_irq+0x1da/0x355
>  [<c0273152>] pirq_enable_irq+0x30/0x91
>  [<c0273403>] pcibios_enable_device+0x21/0x23
>  [<c01f798b>] do_pci_enable_device+0x1f/0x34
>  [<c01f79f8>] __pci_enable_device_flags+0x58/0x64
>  [<d8c51bb6>] snd_emu10k1_create+0x2f/0x5fb [snd_emu10k1]
>  [<d8b87f5b>] snd_card_new+0x1f6/0x24a [snd]
>  [<d8c5196e>] snd_card_emu10k1_probe+0xd2/0x2eb [snd_emu10k1]
>  [<c01f8d59>] pci_device_probe+0x36/0x57
>  [<c022f7d7>] driver_probe_device+0xb7/0x128
>  [<c022f8d5>] __driver_attach+0x0/0x75
>  [<c022f919>] __driver_attach+0x44/0x75
>  [<c022ede5>] bus_for_each_dev+0x38/0x5a
>  [<c022f670>] driver_attach+0x11/0x13
>  [<c022f8d5>] __driver_attach+0x0/0x75
>  [<c022f493>] bus_add_driver+0x8f/0x1ac
>  [<c022fae2>] driver_register+0x45/0x99
>  [<c01f8f46>] __pci_register_driver+0x2b/0x59
>  [<c01316c2>] sys_init_module+0x14cc/0x1624
>  [<c01584af>] do_sync_read+0xbe/0xfd
>  [<d8c00552>] snd_pcm_format_width+0x0/0x1c [snd_pcm]
>  [<c0158edb>] sys_read+0x3e/0x65
>  [<c0102a42>] syscall_call+0x7/0xb
>  =======================
> ---[ end trace 2f9d040b1fc63cd8 ]---
> 
