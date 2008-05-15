Return-Path: <linux-kernel-owner+w=401wt.eu-S1757558AbYEOS67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558AbYEOS67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbYEOS6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:58:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752253AbYEOS6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:58:50 -0400
Date: Thu, 15 May 2008 11:58:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
       Inaky Perez-Gonzalez <inaky@linux.intel.com>
Subject: Re: [BUG] Re: 2.6.26-rc2-mm1 - x86_32 oops on modprobe wusbcore
Message-Id: <20080515115816.dcde0952.akpm@linux-foundation.org>
In-Reply-To: <200805152021.25916.m.kozlowski@tuxland.pl>
References: <20080514010129.4f672378.akpm@linux-foundation.org>
	<200805152021.25916.m.kozlowski@tuxland.pl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008 20:21:25 +0200 Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> Hello,
> 
> 	To get this I simply modprobe wusbcore. modprobe itself ends with
> SIGSEGV. This comes from x86_32.

Thanks.  Let's add some cc's...

> UWB: workarounds enabled for bugs:445 514 543 548 010612024004
> BUG: unable to handle kernel NULL pointer dereference at 0000000c
> IP: [<c01e0e4c>] scatterwalk_start+0xc/0x1f
> *pde = 00000000 
> Oops: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
> last sysfs file: /sys/devices/pci0000:00/0000:00:01.0/0000:01:05.0/resource
> Modules linked in: cbc wusbcore(+) uwb radeon drm orinoco_cs orinoco hermes parport_pc parport floppy pcmcia firmware_class rtc psmouse pcspkr 8139too ide_cd_mod cdrom ehci_hcd uhci_hcd usbcore sony_laptop backlight snd_ali5451 snd_ac97_codec ac97_bus snd_pcm snd_timer snd snd_page_alloc yenta_socket rsrc_nonstatic ati_agp agpgart
> 
> Pid: 5423, comm: modprobe Not tainted (2.6.26-rc2-mm1 #1)
> EIP: 0060:[<c01e0e4c>] EFLAGS: 00010296 CPU: 0
> EIP is at scatterwalk_start+0xc/0x1f
> EAX: da471c78 EBX: da471c78 ECX: da471c78 EDX: 00000000
> ESI: da471dbb EDI: da4a5010 EBP: da471ba8 ESP: da471ba8
>  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Process modprobe (pid: 5423, ti=da471000 task=dceb0000 task.ti=da471000)
> Stack: da471bb4 c01e0ea9 00000000 da471bd4 c01e0f96 00000010 da471c78 da4a5010 
>        00000010 fffffffc 00000000 da471c04 c01e21ca 00000000 da471c68 da471dc8 
>        00000003 00000010 da471c84 da471c78 00000030 da4a5010 da4b8320 da471c34 
> Call Trace:
>  [<c01e0ea9>] ? scatterwalk_pagedone+0x4a/0x84
>  [<c01e0f96>] ? scatterwalk_copychunks+0x2f/0xbb
>  [<c01e21ca>] ? blkcipher_walk_next+0x311/0x38b
>  [<c01e1cdf>] ? blkcipher_walk_done+0xb2/0x28c
>  [<de86e308>] ? crypto_cbc_encrypt+0xc6/0x13b [cbc]
>  [<c01e3ac6>] ? aes_encrypt+0x0/0x114d
>  [<c02d1ba8>] ? _spin_unlock_irqrestore+0x3e/0x5f
>  [<c01f8e34>] ? sg_init_one+0xb/0x66
>  [<dedea2ba>] ? wusb_prf+0x2b0/0x3e2 [wusbcore]
>  [<c013ec7e>] ? trace_hardirqs_on+0xb/0xd
>  [<dedea445>] ? wusb_crypto_init+0x59/0x274 [wusbcore]
>  [<c02d1ba8>] ? _spin_unlock_irqrestore+0x3e/0x5f
>  [<de85f00b>] ? wusbcore_init+0xb/0x75 [wusbcore]
>  [<c0152e69>] ? ftrace_record_ip+0x104/0x21e
>  [<de85f010>] ? wusbcore_init+0x10/0x75 [wusbcore]
>  [<c0146115>] ? sys_init_module+0x11e/0x18e4
>  [<c0103001>] ? sysenter_past_esp+0x6a/0xa5
>  =======================
> Code: ff 89 d8 5b 5d c3 bb ef ff ff ff b8 80 1e 3a c0 e8 ed 46 f5 ff 89 d8 5b 5d c3 90 90 90 90 90 55 89 e5 e8 d4 2d f2 ff 89 c1 89 10 <8b> 42 0c 85 c0 74 08 8b 42 08 89 41 04 5d c3 0f 0b eb fe 55 89 
> EIP: [<c01e0e4c>] scatterwalk_start+0xc/0x1f SS:ESP 0068:da471ba8
> ---[ end trace 7ce75e8bc35923cb ]---
> 
> 	Mariusz
> 
