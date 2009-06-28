Return-Path: <linux-kernel-owner+w=401wt.eu-S1753158AbZF1LF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbZF1LF0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 07:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbZF1LFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 07:05:17 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:33038 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbZF1LFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 07:05:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ejnbbtXVIL74b+2mXlbn9stpUaZpfw8/x/lvIG+tg0FLLgkqxmx4OF0OwC6MWyXI6g
         ioZstBX/1vd+YXxeebd+tRmavybFYw21FIORs07CCK1kVJbBxk+IuaW2V2GDERReqEVM
         ZLJwz/CdYvPlNSTQq4YXjaupTrBA+WHDYQEPM=
MIME-Version: 1.0
Date: Sun, 28 Jun 2009 12:05:17 +0100
Message-ID: <6278d2220906280405y731f7f2l65472ec5f62dbc83@mail.gmail.com>
Subject: [2.6.30-rc1] lockdep false positive in DMA debug API...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 2.6.30-rc1, I'm seeing the lockdep validator spinning it's wheels
[1] (also already seen [2]) on the DMA debug interface, with the
hashed locks.

A false positive needing annotation, or some changes to the locking are needed?

Daniel

--- [1]

atl1 0000:02:00.0: irq 28 for MSI/MSI-X

atl1 0000:02:00.0: eth0 link is up 1000 Mbps full duplex

# ifconfig eth0 mtu 9000
BUG: MAX_STACK_TRACE_ENTRIES too low!

turning off the locking correctness validator.

Pid: 2383, comm: ifconfig Not tainted 2.6.31-rc1-268c #2

Call Trace:

 [<ffffffff8101ad9f>] ? save_stack_trace+0x2f/0x50

 [<ffffffff8109c27e>] save_trace+0xbe/0xd0

 [<ffffffff8109c2e8>] add_lock_to_list+0x58/0xf0

 [<ffffffff8132d631>] ? add_dma_entry+0x41/0x80

 [<ffffffff810a0678>] __lock_acquire+0xe88/0x1250

 [<ffffffff810a0b5e>] lock_acquire+0x11e/0x170

 [<ffffffff8132d631>] ? add_dma_entry+0x41/0x80

 [<ffffffff81691230>] _spin_lock_irqsave+0x60/0xa0

 [<ffffffff8132d631>] ? add_dma_entry+0x41/0x80

 [<ffffffff8132d631>] add_dma_entry+0x41/0x80

 [<ffffffff8132ed37>] debug_dma_map_page+0x177/0x1b0

 [<ffffffff814b43e5>] atl1_alloc_rx_buffers+0x265/0x330

 [<ffffffff814b52c5>] atl1_up+0x85/0x900

 [<ffffffff814b5ce0>] atl1_change_mtu+0x80/0xd0

 [<ffffffff81599182>] dev_set_mtu+0x52/0x90

 [<ffffffff8159b1d2>] dev_ifsioc+0x272/0x2f0

 [<ffffffff8159b5b3>] dev_ioctl+0x363/0x610

 [<ffffffff81695182>] ? sub_preempt_count+0x142/0x150

 [<ffffffff8158379d>] sock_ioctl+0x9d/0x2b0

 [<ffffffff8116ddd6>] vfs_ioctl+0x36/0xb0

 [<ffffffff8116df7a>] do_vfs_ioctl+0x8a/0x5f0

 [<ffffffff8115ed7c>] ? fget_light+0x5c/0x150

 [<ffffffff8116e52f>] sys_ioctl+0x4f/0xa0

 [<ffffffff8100c4f2>] system_call_fastpath+0x16/0x1b

atl1 0000:02:00.0: irq 28 for MSI/MSI-X

atl1 0000:02:00.0: eth0 link is up 1000 Mbps full duplex

--- [2] http://lkml.org/lkml/2009/6/22/54
-- 
Daniel J Blueman
