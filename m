Return-Path: <linux-kernel-owner+w=401wt.eu-S1758418AbYFPVt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418AbYFPVt2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 17:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754484AbYFPVtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 17:49:20 -0400
Received: from webmail.e-teleport.net ([213.190.83.68]:44253 "EHLO
	mail.imsnet.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380AbYFPVtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 17:49:20 -0400
X-Greylist: delayed 1405 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jun 2008 17:49:19 EDT
Message-ID: <4856DA62.7080803@e-teleport.net>
Date: Mon, 16 Jun 2008 23:25:54 +0200
From: =?ISO-8859-1?Q?S=E9guier_R=E9gis?= <rseguier@e-teleport.net>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, alan@redhat.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: via-velocity.c fix sleep-with-spinlock bug during
 MTU change
References: <20080531184615.350bac00@infradead.org> <20080603134019.df2f51d4.akpm@linux-foundation.org> <20080603215155.GA9712@electric-eye.fr.zoreil.com> <20080604215909.GA17446@electric-eye.fr.zoreil.com> <20080614212341.GA12976@electric-eye.fr.zoreil.com>
In-Reply-To: <20080614212341.GA12976@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu a écrit :
> Francois Romieu <romieu@fr.zoreil.com> :
> [...context available from http://lkml.org/lkml/2008/5/31/251 ...]
>
> Régis, I need your help.
>
> Can you give the patchkit below a try and check if the change of mtu
> works correctly ?
>
> http://userweb.kernel.org/~romieu/via-velocity/2.6.26-rc6/
>
> or:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/romieu/netdev-2.6.git velocity
>
>   
The mtu change doesn't work :

Jun 16 23:22:34 apollo kernel: ------------[ cut here ]------------
Jun 16 23:22:34 apollo kernel: WARNING: at arch/x86/kernel/pci-dma.c:482 
dma_free_coherent+0x3a/0x9c()
Jun 16 23:22:34 apollo kernel: Pid: 1527, comm: ip Tainted: G        W 
2.6.26-rc6EPIA_SN_VB7001 #3
Jun 16 23:22:34 apollo kernel:  [<c0115fe5>] warn_on_slowpath+0x3b/0x5f
Jun 16 23:22:34 apollo kernel:  [<c0133940>] 
get_page_from_freelist+0x24a/0x36f
Jun 16 23:22:34 apollo kernel:  [<c012d86b>] handle_IRQ_event+0x1a/0x3f
Jun 16 23:22:34 apollo kernel:  [<c0241193>] velocity_free_rd_ring+0xa5/0xb6
Jun 16 23:22:34 apollo kernel:  [<c0144752>] kfree+0x6a/0x72
Jun 16 23:22:34 apollo kernel:  [<c0241193>] velocity_free_rd_ring+0xa5/0xb6
Jun 16 23:22:34 apollo kernel:  [<c0105816>] dma_free_coherent+0x3a/0x9c
Jun 16 23:22:34 apollo kernel:  [<c02411eb>] 
velocity_free_dma_rings+0x47/0x4d
Jun 16 23:22:34 apollo kernel:  [<c024225b>] velocity_change_mtu+0xf6/0x157
Jun 16 23:22:34 apollo kernel:  [<c02856c4>] dev_set_mtu+0x2a/0x4f
Jun 16 23:22:34 apollo kernel:  [<c0286642>] dev_ioctl+0x4ab/0x530
Jun 16 23:22:34 apollo kernel:  [<c012e4cb>] handle_fasteoi_irq+0x74/0x77
Jun 16 23:22:34 apollo kernel:  [<c010479b>] do_IRQ+0x50/0x60
Jun 16 23:22:34 apollo kernel:  [<c027d785>] sock_ioctl+0x0/0x177
Jun 16 23:22:34 apollo kernel:  [<c01032eb>] common_interrupt+0x23/0x28
Jun 16 23:22:34 apollo kernel:  [<c027d785>] sock_ioctl+0x0/0x177
Jun 16 23:22:34 apollo kernel:  [<c0150b4a>] vfs_ioctl+0x16/0x48
Jun 16 23:22:34 apollo kernel:  [<c0150d5a>] do_vfs_ioctl+0x1de/0x1f1
Jun 16 23:22:34 apollo kernel:  [<c0150dae>] sys_ioctl+0x41/0x5b
Jun 16 23:22:34 apollo kernel:  [<c010291d>] sysenter_past_esp+0x6a/0x91
Jun 16 23:22:34 apollo kernel:  =======================
Jun 16 23:22:34 apollo kernel: ---[ end trace 17457a054a24b83c ]---


-- 
Régis
