Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbZAEUcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbZAEUcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 15:32:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbZAEUcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 15:32:24 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:34549 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbZAEUcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 15:32:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references
         :in-reply-to:content-type:content-transfer-encoding:from;
        b=HuKBljE1F3ZRtlQ/JR1bLFupPrS3CaOQVoGji8FtbAvrsyuCN6hD+IXRK8j5X71Hjk
         fGwuBTwhwrwpTwTx9twqeDYiNqlPUAkeYfp0Ia1vXlkxWvAFrqWrUylEOQi8FCDCG0df
         1FE/KVRKE2aHDoPCSynquaMx0EjbsSScnMHpU=
Message-ID: <49626E4D.3010705@gmail.com>
Date: Mon, 05 Jan 2009 20:32:13 +0000
User-Agent: Thunderbird 2.0.0.19 (X11/20090104)
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.28: warn_slowpath in orinoco receive path
References: <200901052005.12428.arvidjaar@mail.ru>
In-Reply-To: <200901052005.12428.arvidjaar@mail.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Dave <kilroyd@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov wrote:
> I would appreciate explanation which condition triggers this 
> warn_slowpath. Otherwise does it ring the bell for someone? Network was 
> dead after it till I reloaded modules (orinoco and hermes).
> 
> [89479.105038] WARNING: at /home/bor/src/linux-git/lib/list_debug.c:30 
> __list_add+0x8f/0xa0()
> [89479.105058] list_add corruption. prev->next should be next 
> (dddb3568), but was cbc28978. (prev=dddb3568).
<snip>
> [89479.106002] Pid: 15746, comm: X Not tainted 2.6.28-1avb #26
> [89479.106020] Call Trace:
> [89479.106062]  [<c011d3b0>] warn_slowpath+0x60/0x80
> [89479.106104]  [<c01073d0>] ? native_sched_clock+0x20/0x70
> [89479.106194]  [<c013d825>] ? lock_release_holdtime+0x35/0x200
> [89479.106218]  [<c018d9f0>] ? __slab_alloc+0x550/0x560
> [89479.106254]  [<c02f9c9d>] ? _spin_unlock+0x1d/0x20
> [89479.106270]  [<c018d9f0>] ? __slab_alloc+0x550/0x560
> [89479.106302]  [<c01ff2a7>] ? delay_tsc+0x17/0x24
> [89479.106319]  [<c01ff221>] ? __const_udelay+0x21/0x30
> [89479.106376]  [<dfa8b1e2>] ? hermes_bap_seek+0x112/0x1e0 [hermes]
> [89479.106396]  [<c013d7eb>] ? trace_hardirqs_off+0xb/0x10
> [89479.106418]  [<c018e307>] ? __kmalloc_track_caller+0xb7/0x110
> [89479.106448]  [<c028eefc>] ? dev_alloc_skb+0x1c/0x30
> [89479.106465]  [<c028eefc>] ? dev_alloc_skb+0x1c/0x30
> [89479.106482]  [<c020e13f>] __list_add+0x8f/0xa0
> [89479.106551]  [<dfd0fcae>] orinoco_interrupt+0xcae/0x16c0 [orinoco]
> [89479.106574]  [<c013b0e3>] ? tick_dev_program_event+0x33/0xb0
> [89479.106594]  [<c01073d0>] ? native_sched_clock+0x20/0x70
> [89479.106613]  [<c013d825>] ? lock_release_holdtime+0x35/0x200
> [89479.106662]  [<c013d7eb>] ? trace_hardirqs_off+0xb/0x10
> [89479.106892]  [<dfe7faa7>] ? usb_hcd_irq+0x97/0xa0 [usbcore]
> [89479.106926]  [<c015ba79>] handle_IRQ_event+0x29/0x60
> [89479.106947]  [<c015cf89>] handle_level_irq+0x69/0xe0
> [89479.106963]  [<c015cf20>] ? handle_level_irq+0x0/0xe0
> [89479.106977]  <IRQ>  [<c02ca933>] ? tcp_v4_rcv+0x633/0x6e0
> [89479.107025]  [<c0103f0c>] ? common_interrupt+0x28/0x30
> [89479.107057]  [<c02a0000>] ? sk_run_filter+0x320/0x7a0
> [89479.107078]  [<c020e041>] ? list_del+0x21/0x90
> [89479.107106]  [<dfd0d24e>] ? orinoco_rx_isr_tasklet+0x2ce/0x480 
> [orinoco]
> [89479.107131]  [<c01402e0>] ? __lock_acquire+0x160/0x1650
> [89479.107151]  [<c01073d0>] ? native_sched_clock+0x20/0x70
> [89479.107169]  [<c013d825>] ? lock_release_holdtime+0x35/0x200
> [89479.107200]  [<c012249a>] ? irq_enter+0xa/0x60
> [89479.107217]  [<c0104e52>] ? do_IRQ+0xd2/0x130
> [89479.107518]  [<c010342c>] ? restore_nocheck_notrace+0x0/0xe
> [89479.107542]  [<c0122830>] ? __do_softirq+0x0/0x110
> [89479.107561]  [<c013f7b4>] ? trace_hardirqs_on_caller+0x74/0x140
> [89479.107583]  [<c01ff678>] ? trace_hardirqs_on_thunk+0xc/0x10
> [89479.107602]  [<c0122087>] ? tasklet_action+0x27/0x90
> [89479.107620]  [<c013f7b4>] ? trace_hardirqs_on_caller+0x74/0x140
> [89479.107638]  [<c01220a3>] ? tasklet_action+0x43/0x90
> [89479.107655]  [<c012289f>] ? __do_softirq+0x6f/0x110
> [89479.107674]  [<c0122830>] ? __do_softirq+0x0/0x110
> [89479.107685]  <IRQ>  [<c015cf20>] ? handle_level_irq+0x0/0xe0
> [89479.107715]  [<c012246d>] ? irq_exit+0x5d/0x80
> [89479.107732]  [<c0104e52>] ? do_IRQ+0xd2/0x130
> [89479.107747]  [<c0103337>] ? sysenter_exit+0xf/0x16
> [89479.107765]  [<c013f83d>] ? trace_hardirqs_on_caller+0xfd/0x140
> [89479.107782]  [<c0103f0c>] ? common_interrupt+0x28/0x30
> [89479.107797] ---[ end trace a1fc0a52df4a729d ]---

Looks like the RX interrupt occurred at an inconvenient point during the
list_del call in the RX tasklet (orinoco_rx_isr_tasklet).

The call needs to be protected from the RX interrupt.

Quick patch included below - I'm not sure that the local_irq_* functions
are the ones we need, but it compiles and runs.

I don't suppose you're able to reproduce the error?


Dave.

---
diff --git a/drivers/net/wireless/orinoco/orinoco.c
b/drivers/net/wireless/orinoco/orinoco.c
index b33e13f..9a2d6be 100644
--- a/drivers/net/wireless/orinoco/orinoco.c
+++ b/drivers/net/wireless/orinoco/orinoco.c
@@ -1616,9 +1616,15 @@ static void orinoco_rx_isr_tasklet(unsigned long
data)

        /* extract desc and skb from queue */
        list_for_each_entry_safe(rx_data, temp, &priv->rx_list, list) {
+               unsigned long flags;
+
                desc = rx_data->desc;
                skb = rx_data->skb;
+
+               local_irq_save(flags);
                list_del(&rx_data->list);
+               local_irq_restore(flags);
+
                kfree(rx_data);

                orinoco_rx(dev, desc, skb);

