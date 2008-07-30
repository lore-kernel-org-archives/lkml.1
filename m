Return-Path: <linux-kernel-owner+w=401wt.eu-S1761640AbYG3J6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761640AbYG3J6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759795AbYG3J6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:58:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755515AbYG3J6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:58:22 -0400
Date: Wed, 30 Jul 2008 02:57:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pete Clements <clem@clem.clem-digital.net>
Cc: linux-kernel@vger.kernel.org (linux-kernel),
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: 2.6.26-rc1 oops on boot -- cs423x?
Message-Id: <20080730025759.822df4dc.akpm@linux-foundation.org>
In-Reply-To: <200807291851.m6TIpvN7004222@clem.clem-digital.net>
References: <200807291851.m6TIpvN7004222@clem.clem-digital.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008 14:51:57 -0400 (EDT) Pete Clements <clem@clem.clem-digital.net> wrote:

>  Missed most of the 26-git series, git6 first one tried and oops 
> showed in that one as well as those tried after. oops below.
> 
> -- 
> Pete Clements 
> 
>  pnp: the driver 'cs4236_isapnp' has been registered
>  cs4236_isapnp 01:01.00: driver attached
>  cs4236_isapnp 01:01.02: driver attached
>  cs4236_isapnp 01:01.00: pnp_assign_resources, try dependent set 0
>  cs4236_isapnp 01:01.00:   add dma 1 flags 0x40000028
>  cs4236_isapnp 01:01.00:   add dma 3 flags 0x40000028
>  cs4236_isapnp 01:01.00:   add irq 5 flags 0x40000001
>  cs4236_isapnp 01:01.00:   add io  0x534-0x537 flags 0x40000001
>  cs4236_isapnp 01:01.00:   add io  0x388-0x38b flags 0x40000001
>  cs4236_isapnp 01:01.00:   add io  0x220-0x22f flags 0x40000001
>  cs4236_isapnp 01:01.00: pnp_assign_resources succeeded: current resources:
>  cs4236_isapnp 01:01.00:   dma 1 flags 0x40000828
>  cs4236_isapnp 01:01.00:   dma 1 flags 0x40000828  dma 3 flags 0x40000828
>  cs4236_isapnp 01:01.00:   dma 1 flags 0x40000828  dma 3 flags 0x40000828  irq 5 flags 0x40000401
>  cs4236_isapnp 01:01.00:   dma 1 flags 0x40000828  dma 3 flags 0x40000828  irq 5 flags 0x40000401  io  0x534-0x537 flags 0x40000101
>  cs4236_isapnp 01:01.00:   dma 1 flags 0x40000828  dma 3 flags 0x40000828  irq 5 flags 0x40000401  io  0x534-0x537 flags 0x40000101  io  0x388-0x38b fla
>  ------------[ cut here ]------------
>  WARNING: at lib/vsprintf.c:609 vsnprintf+0x6c7/0x6d0()
>  Modules linked in: snd_cs4236(+) snd_opl3_lib snd_seq_dummy snd_hwdep snd_cs4236_lib snd_mpu401_uart snd_seq_oss(+) snd_seq_midi snd_seq_midi_event snd_seq snd_rawmidi snd_seq_device snd_cs4231_lib snd_pcm_oss snd_mixer_oss snd_pcm snd_timer uhci_hcd snd i2c_piix4 usbcore soundcore sg snd_page_alloc 3c59x i2c_core mii
>  Pid: 1885, comm: modprobe Not tainted 2.6.27-rc1 #1
>   [<c011f621>] warn_on_slowpath+0x61/0xa0
>   [<c011a017>] __dequeue_entity+0x57/0xd0
>   [<c011684d>] update_curr+0x4d/0x70
>   [<c011a18d>] pick_next_task_fair+0x8d/0x100
>   [<c01e17b7>] string+0x27/0xc0
>   [<c01e1c09>] vsnprintf+0x3b9/0x6d0
>   [<c01e1177>] number+0x2a7/0x2b0
>   [<c01e17b7>] string+0x27/0xc0
>   [<c01e1f17>] vsnprintf+0x6c7/0x6d0
>   [<c01dc4c0>] idr_get_new_above_int+0x10/0x80
>   [<c0136601>] up+0x11/0x40
>   [<c011fe6e>] release_console_sem+0x19e/0x1d0
>   [<c01dc8d3>] idr_remove+0x173/0x1d0
>   [<c01a442d>] xlate_proc_name+0x3d/0xc0
>   [<c01e1fab>] snprintf+0x1b/0x20
>   [<c01fca09>] dbg_pnp_show_resources+0x129/0x220
>   [<c01fbc2e>] pnp_assign_resources+0x18e/0x850
>   [<c017f16d>] iput+0x1d/0x50
>   [<c01ac33a>] sysfs_addrm_finish+0x3a/0x1f0
>   [<c02e18ee>] klist_node_init+0x2e/0x50
>   [<c01fc347>] pnp_auto_config_dev+0x57/0xb0
>   [<c01f9dfe>] pnp_request_card_device+0xbe/0xf0
>   [<c01fc3bf>] pnp_activate_dev+0x1f/0x50
>   [<f88ce50c>] snd_cs423x_pnpc_detect+0x11f/0x3b4 [snd_cs4236]
>   [<c01f9c0a>] card_probe+0xea/0x170
>   [<c01f9d2e>] pnp_register_card_driver+0x9e/0xb0
>   [<f8839027>] alsa_card_cs423x_init+0x27/0x49 [snd_cs4236]
>   [<c0140d46>] sys_init_module+0x136/0x1920
>   [<c0124f50>] __request_region+0x0/0xd0
>   [<c0103026>] syscall_call+0x7/0xb
>   =======================

I would say that dbg_pnp_show_resources() is passing a negative `size'
into snprintf().


