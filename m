Return-Path: <linux-kernel-owner+w=401wt.eu-S1754467AbZEFEcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbZEFEcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 00:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbZEFEcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 00:32:35 -0400
Received: from [192.16.179.4] ([192.16.179.4]:43409 "EHLO sh.osrg.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbZEFEce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 00:32:34 -0400
Date: Wed, 6 May 2009 13:30:47 +0900
To: eric.valette@free.fr
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: DMA debug trace pointing to rtl8187
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <49FDB9F8.3080400@free.fr>
References: <49FDB9F8.3080400@free.fr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090506133131F.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 06 May 2009 13:30:47 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC'ed linux-usb,

The ehci_hcd driver uses buffers on the stack for DMA?

On Sun, 03 May 2009 17:36:24 +0200
Eric Valette <eric.valette@free.fr> wrote:

> ------------[ cut here ]------------
> 
> WARNING: at /usr/src/linux-2.6.22.9/lib/dma-debug.c:609

Hmm, the kernel version is wired. lib/dma-debug.c was added in
2.6.30-rc.


> check_for_stack+0x6b/0x8b()
> Hardware name: P5W DH Deluxe
> 
> ehci_hcd 0000:00:1d.7: DMA-API: device driver maps memory fromstack
> [addr=ffff88007fa79968]
> Modules linked in:
> 
> Pid: 297, comm: khubd Not tainted 2.6.30-rc4-git1 #32
> 
> Call Trace:
> 
>  [<ffffffff802331c2>] warn_slowpath+0xd3/0x107
> 
>  [<ffffffff803e4740>] ? soft_cursor+0x1a0/0x1b4
> 
>  [<ffffffff804f3c68>] ? ehci_qtd_alloc+0x18/0x5b
> 
>  [<ffffffff80229e89>] ? update_curr+0x4f/0xe2
> 
>  [<ffffffff8022a66b>] ? dequeue_task_fair+0x4a/0x1b3
> 
>  [<ffffffff8022f304>] ? finish_task_switch+0x51/0xac
> 
>  [<ffffffff8064e242>] ? thread_return+0x3e/0xaf
> 
>  [<ffffffff803c598f>] check_for_stack+0x6b/0x8b
> 
>  [<ffffffff803c6c4d>] debug_dma_map_page+0xfa/0x11f
> 
>  [<ffffffff804e4396>] usb_hcd_submit_urb+0x296/0x938
> 
>  [<ffffffff803b553c>] ? kobject_set_name_vargs+0x4f/0x58
> 
>  [<ffffffff8044ffa2>] ? dev_set_name+0x64/0x66
> 
>  [<ffffffff8064e242>] ? thread_return+0x3e/0xaf
> 
>  [<ffffffff804e4f32>] usb_submit_urb+0x20b/0x222
> 
>  [<ffffffff804e5f6f>] usb_start_wait_urb+0x4a/0xb7
> 
>  [<ffffffff804e61d3>] usb_control_msg+0xcf/0xf1
> 
>  [<ffffffff806419b0>] rtl8187_probe+0x1b5/0x7e8
> 
>  [<ffffffff804bc668>] ? rtl8187_eeprom_register_read+0x0/0x82
> 
>  [<ffffffff804bc478>] ? rtl8187_eeprom_register_write+0x0/0x95
> 
>  [<ffffffff804e7815>] ? usb_autopm_do_device+0xd1/0xdd
> 
>  [<ffffffff804e81a2>] usb_probe_interface+0x114/0x16d
> 
>  [<ffffffff80452e79>] driver_probe_device+0x9b/0x140
> 
>  [<ffffffff80452f99>] ? __device_attach+0x0/0x3c
> 
>  [<ffffffff80452fcc>] __device_attach+0x33/0x3c
> 
>  [<ffffffff804524ac>] bus_for_each_drv+0x51/0x87
> 
>  [<ffffffff80453057>] device_attach+0x5e/0x73
> 
>  [<ffffffff804522e1>] bus_attach_device+0x25/0x5b
> 
>  [<ffffffff8045104c>] device_add+0x47f/0x5d5
> 
>  [<ffffffff804e6e5a>] usb_set_configuration+0x4f4/0x55b
> 
>  [<ffffffff804ee876>] generic_probe+0x56/0xa0
> 
>  [<ffffffff804e70a7>] usb_probe_device+0x33/0x35
> 
>  [<ffffffff80452e79>] driver_probe_device+0x9b/0x140
> 
>  [<ffffffff80452f99>] ? __device_attach+0x0/0x3c
> 
>  [<ffffffff80452fcc>] __device_attach+0x33/0x3c
> 
>  [<ffffffff804524ac>] bus_for_each_drv+0x51/0x87
> 
>  [<ffffffff80453057>] device_attach+0x5e/0x73
> 
>  [<ffffffff804522e1>] bus_attach_device+0x25/0x5b
> 
>  [<ffffffff8045104c>] device_add+0x47f/0x5d5
> 
>  [<ffffffff804e1088>] usb_new_device+0x66/0xc6
> 
>  [<ffffffff804e25e6>] hub_thread+0xb56/0x10e0
> 
>  [<ffffffff80245e2e>] ? autoremove_wake_function+0x0/0x38
> 
>  [<ffffffff804e1a90>] ? hub_thread+0x0/0x10e0
> 
>  [<ffffffff804e1a90>] ? hub_thread+0x0/0x10e0
> 
>  [<ffffffff80245a9a>] kthread+0x56/0x83
> 
>  [<ffffffff8020beea>] child_rip+0xa/0x20
> 
>  [<ffffffff80245a44>] ? kthread+0x0/0x83
> 
>  [<ffffffff8020bee0>] ? child_rip+0x0/0x20
> 
> -- eric
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
