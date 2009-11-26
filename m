Return-Path: <linux-kernel-owner+w=401wt.eu-S1760176AbZKZQyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760176AbZKZQyD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 11:54:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759468AbZKZQyC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 11:54:02 -0500
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:46134 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755902AbZKZQyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 11:54:01 -0500
From: "Leyendecker, Robert" <Robert.Leyendecker@lsi.com>
To: Tim Blechmann <tim@klingt.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Date: Thu, 26 Nov 2009 11:53:55 -0500
Subject: RE: ext4: smp_processor_id() in preemptible
Thread-Topic: ext4: smp_processor_id() in preemptible
Thread-Index: AcpuKVl1Orcch/bkQvKX0HI96yXkrgAjkJnw
Message-ID: <8C8865ED624BB94F8FE50259E2B5C5B304593DAB98@palmail03.lsi.com>
References: <4AC9C4FD.7080606@klingt.org>
In-Reply-To: <4AC9C4FD.7080606@klingt.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id nAQGsL16031158

Tim,

I have similar crash, but probably different cause-vector, posted on this list, fedora bugzilla, rt-users but no response so far from anyone. Did you find any work around?  I tried looking at smp code for hints on problem it looks like in my case it could be trying to reschedule work on different CPU at time of crash. However, I admit that I could be way, way off on that cause. In my case, if I hammer my network interface with packets while another app is reading packets, my host locks up and clients are reporting dest unreachables. 

I don't think I have the problem in non-rt kernel. Have you tried booting without smp support?

http://lkml.org/lkml/headers/2009/11/23/548

-Bob



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Tim Blechmann
> Sent: Monday, October 05, 2009 5:06 AM
> To: linux-kernel@vger.kernel.org; linux-ext4@vger.kernel.org
> Subject: ext4: smp_processor_id() in preemptible
> 
> hi all,
> 
> using 2.6.31.1 with CONFIG_PREEMPT=y, i got the following call traces
> from ext4 related code, when doing some io-heavy tasks:
> 
> [30477.126201] INFO: task gconfd-2:2296 blocked for more than 120
> seconds.
> [30477.126205] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [30477.126208] gconfd-2      D ffff8800280436e8     0  2296      1
> 0x00000000
> [30477.126214] BUG: using smp_processor_id() in preemptible [00000000]
> code: khungtaskd/72 [30477.126221] caller is
> show_stack_log_lvl+0x32/0x170
> [30477.126224] Pid: 72, comm: khungtaskd Tainted: P           2.6.31.1
> #29
> [30477.126227] Call Trace:
> [30477.126234]  [<ffffffff81266881>] debug_smp_processor_id+0xd1/0xf0
> [30477.126238]  [<ffffffff81014b62>] show_stack_log_lvl+0x32/0x170
> [30477.126242]  [<ffffffff814f57c0>] ? printk+0x3c/0x44 [30477.126246]
> [<ffffffff81015e17>] show_stack+0x17/0x20 [30477.126251]
> [<ffffffff81045b52>] sched_show_task+0x92/0x100 [30477.126256]
> [<ffffffff810ab66d>] watchdog+0x1fd/0x240 [30477.126260]
> [<ffffffff810ab470>] ? watchdog+0x0/0x240 [30477.126264]
> [<ffffffff81071216>] kthread+0xa6/0xb0 [30477.126268]
> [<ffffffff8101303a>] child_rip+0xa/0x20 [30477.126272]
> [<ffffffff81071170>] ? kthread+0x0/0xb0 [30477.126275]
> [<ffffffff81013030>] ? child_rip+0x0/0x20 [30477.126278]
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
