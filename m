Return-Path: <linux-kernel-owner+w=401wt.eu-S1753398AbYHLUyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbYHLUyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 16:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbYHLUyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 16:54:33 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:14237 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbYHLUyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 16:54:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tF+mbV5joA+ROlpuFXdoLPxBASQdO2TPhr9+rBCEd7UnXWNj0eUFaDHHE+c6SFEATQ
         sHnbldNzDyZeqS05oLGYG/V4dK2WggwWHkz2b2cKasK6P/GIr8tD3YcAutafD2sZs1fK
         oFoRc0V166RZoar0slWW4bOs+bQSMbK375+Rs=
Message-ID: <19f34abd0808121354n5374b51n88f3c131567c4989@mail.gmail.com>
Date: Tue, 12 Aug 2008 22:54:31 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: Re: latest -git: kernel hangs when pulling the plug on 8139too
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <19f34abd0808121346w60f37ac0mf8e4ed20549af0e1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0808110949n5d7d363es66325b87a8fb0fd1@mail.gmail.com>
	 <20080811192739.GB5791@martell.zuzino.mipt.ru>
	 <19f34abd0808121020l4a0552a0v3d48b181d980d600@mail.gmail.com>
	 <19f34abd0808121202p6a59917ey561ac48012fb92ca@mail.gmail.com>
	 <19f34abd0808121346w60f37ac0mf8e4ed20549af0e1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, I spoke a bit too soon.

On Tue, Aug 12, 2008 at 10:46 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>  [<c0119b05>] nmi_watchdog_tick+0x1d5/0x1e0
>  [<c0106217>] do_nmi+0x97/0x2d0
>  [<c0591f03>] nmi_stack_correct+0x26/0x2b
>  [<c028007b>] ? as_remove_queued_request+0x9b/0xb0
>  [<c028a218>] ? delay_tsc+0x98/0xb8
>  [<c028a0b9>] __delay+0x9/0x10
>  [<c0299579>] _raw_spin_lock+0xb9/0x140
>  [<c015623b>] ? trace_hardirqs_off+0xb/0x10
>  [<c05916b6>] _spin_lock_irqsave+0x76/0x90
>  [<c035b255>] ? rtl8139_start_xmit+0x65/0x130
>  [<c035b255>] rtl8139_start_xmit+0x65/0x130

Acquires &tp->lock.

>  [<c04c5e28>] netpoll_send_skb+0x158/0x1a0
>  [<c04c62fb>] netpoll_send_udp+0x1db/0x1f0
>  [<c037c70c>] write_msg+0x8c/0xc0
>  [<c0135883>] __call_console_drivers+0x53/0x60
>  [<c01358db>] _call_console_drivers+0x4b/0x90
>  [<c0135a25>] release_console_sem+0xc5/0x1f0
>  [<c0135f0b>] vprintk+0x1ab/0x3e0
>  [<c0591acc>] ? _spin_unlock_irqrestore+0x6c/0x70
>  [<c01460e1>] ? __queue_work+0x31/0x40
>  [<c01461e5>] ? queue_work+0x45/0x50
>  [<c014629f>] ? queue_delayed_work+0xf/0x30
>  [<c0591aa3>] ? _spin_unlock_irqrestore+0x43/0x70
>  [<c01462d1>] ? schedule_delayed_work+0x11/0x20
>  [<c013615b>] printk+0x1b/0x20
>  [<c0349736>] mii_check_media+0x196/0x1e0
>  [<c059127b>] ? _spin_lock+0x5b/0x70
>  [<c03597f4>] rtl_check_media+0x24/0x30
>  [<c035a0ea>] rtl8139_interrupt+0x42a/0x4a0

Acquires &tp->lock.

>  [<c01716d8>] handle_IRQ_event+0x28/0x70
>  [<c0172d9b>] handle_fasteoi_irq+0x6b/0xe0
>  [<c0107128>] do_IRQ+0x48/0xa0
>  [<c028a604>] ? trace_hardirqs_off_thunk+0xc/0x18
>  [<c0104a5c>] common_interrupt+0x28/0x30
>  [<c015007b>] ? update_wall_time+0x36b/0x7d0
>  [<c010ae8c>] ? mwait_idle+0x3c/0x50
>  [<c010285c>] cpu_idle+0x6c/0x120
>  [<c056bb32>] rest_init+0x62/0x70
>  =======================
> <4>---[ end trace 33bf576b6277932f ]---
>
> ...this seems to contain at least a little bit of useful information.
>
> Looks to me like it's quite simply a recursive printk. I don't
> understand why the printk code doesn't catch this, though.

Nope. It tries to take a lock that is already held. Instead: How can
it be solved?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
