Return-Path: <linux-kernel-owner+w=401wt.eu-S1756647AbYIRSeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbYIRSeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 14:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755778AbYIRSeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 14:34:07 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:24350 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720AbYIRSeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 14:34:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=uHpwbAChHppZ6j66UNm4rVqB8NaS57FnwkMl6zmqowvNK1K9D3DOEYe7IQhzS+/u+/
         2bUFGVWk4otY7jJbnVS2qo9a5tydu3ftQOo5EKbDA5QRh0Zk51HZ/U9Ql1K2tSi3GnoU
         6h6xb8QrmpkSsi6gCsBSEVM07yHtD6cMOLnLA=
Message-ID: <43e72e890809181134ybbec8fdxcb2a466aa17fe390@mail.gmail.com>
Date: Thu, 18 Sep 2008 11:34:03 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Steven Noonan" <steven@uplinklabs.net>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27 (rc5, rc6, probably others)
Cc: LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
In-Reply-To: <f488382f0809181123n55a4979eg1996bbc30fa47d54@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f488382f0809181123n55a4979eg1996bbc30fa47d54@mail.gmail.com>
X-Google-Sender-Auth: 036b6dd3421c9794
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2008 at 11:23 AM, Steven Noonan <steven@uplinklabs.net> wrote:
> The only thing I can think of is that I've
> got 'irqpoll' on the command line. I have it because I had to reload
> the ath9k driver at one point, and this was the result (caused ath9k
> to become a useless driver until I rebooted, which re-enabled IRQ 17):
>
> [53997.493777] ath9k: driver unloaded
> [54001.098532] ath9k: 0.1
> [54001.098833] ath9k 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [54001.099013] ath9k 0000:03:00.0: setting latency timer to 64
> [54001.233825] phy1: Selected rate control algorithm 'ath9k_rate_control'
> [54001.236980] phy1: Atheros 5416: mem=0xffffc20000060000, irq=17
> [54002.136218] irq 17: nobody cared (try booting with the "irqpoll" option)
> [54002.136229] Pid: 0, comm: swapper Tainted: P 2.6.27-rc6-00036-ga551b98 #2
> [54002.136234]
> [54002.136235] Call Trace:
> [54002.136241] <IRQ> [<ffffffff80265231>] __report_bad_irq+0x3d/0x81
> [54002.136258] [<ffffffff80265477>] note_interrupt+0x202/0x267
> [54002.136265] [<ffffffff80265bfc>] handle_fasteoi_irq+0xba/0xe4
> [54002.136273] [<ffffffff8020e7ff>] do_IRQ+0x115/0x191
> [54002.136279] [<ffffffff8020bc01>] ret_from_intr+0x0/0xa
> [54002.136283] <EOI> [<ffffffff802541bb>] ?
> tick_nohz_stop_sched_tick+0x2c5/0x2d4
> [54002.136296] [<ffffffff8020a69f>] ? cpu_idle+0x2d/0xed
> [54002.136304] [<ffffffff8060d741>] ? rest_init+0x75/0x77
> [54002.136309]
> [54002.136312] handlers:
> [54002.136315] [<ffffffffa0209016>] (ath_isr+0x0/0x160 [ath9k])
> [54002.136340] Disabling IRQ #17

irqpoll is a monster of evil and that should make your system crawl to
its knees. I would advise instead we work with you fixing the the
missed interrupts issue upon rmmod.

  Luis
